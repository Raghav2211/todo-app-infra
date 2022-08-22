#!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

fmt() {
  find . \( -path '*/.terraform/*' \) -prune -false -o -type f -name '*.tf' | while read f
    do
      echo $f
      terraform fmt $f

    done
}

plan() {
  local chdir=$1
  local plan_file=$2
  terraform -chdir=$chdir plan -out $plan_file  
}

apply() {
  local chdir=$1
  local plan_file=$2
  terraform -chdir=$chdir apply $plan_file  
}

module_apply() {
  local account=$1
  local region=$2
  local chdir
  local plan_file
  if [[ $region == "global" ]]; then
    component=$3
    chdir=$account/global/$component
    plan_file=$account-global-${component////-}.plan
  else
    environment=$3
    component=$4
    chdir=$account/$region/$environment/$component
    plan_file=$account-$region-$environment-${component////-}.plan   
  fi
  echo "\n🔧 Running command[apply] for account[$account] region[$region] environment[$environment] component[$component]"
  apply $chdir $plan_file
}

v2_buila_all() {
  local account=$1
  local region=$2
  local environment=$3
  module_config=$(jq '."'"$account"'"' todo-v2-tf-modules-config.json)
  global_modules=$(jq -r '.global[]' <<<  $module_config) 
  region_modules=$(jq -r '."'"$region"'"[]' <<<  $module_config) 
  for global_module in $global_modules; do
    tf lab global $global_module init -reconfigure
    tf lab global $global_module validate
    tf lab global $global_module plan
  done
  for region_module in $region_modules; do
    if [ $( jq 'has("'"${region_module}"'")' <<< $module_config ) == "true" ]; then 
      submodules=$( jq -r '."'"$region_module"'"[] | paths(scalars) as $p | [ ( [ $p[] | tostring ] | join("/") ) , (getpath($p)) ] | join("/")' <<< $module_config)
      for submodule in $submodules; do
        component=$region_module/${submodule///[[:digit:]]/}
        echo "Applying for region :- ${region}"
        tf $account $region $environment $component init -reconfigure
        tf $account $region $environment $component validate
        tf $account $region $environment $component plan
      done
    fi
  done
}


tf() {
  local account=$1
  local region=$2
  if [[ $region == "global" ]]; then
    local component=$3
    local cmd=$4
    echo "\n🔧 Running command[$cmd] for account[$account] component[$component]"
    if [[ $cmd == "plan" ]]; then
      terraform -chdir=$account/global/$component $cmd -out $account-global-${component////-}.plan
    elif [[ $cmd == "apply" ]]; then
      terraform -chdir=$account/global/$component $cmd $account-global-${component////-}.plan
    else
      terraform -chdir=$account/global/$component $cmd
    fi
  else
    local environment=$3
    local component=$4
    local cmd=$5
    echo "\n🔧 Running command[$cmd] for for account[$account] region[$region] environment[$environment] component[$component]"
    if [[ $cmd == "plan" ]]; then
      plan $account/$region/$environment/$component $account-$region-$environment-${component////-}.plan
    elif [[ $cmd == "apply" ]]; then
      apply $account/$region/$environment/$component $account-$region-$environment-${component////-}.plan
    else
      terraform -chdir=$account/$region/$environment/$component $cmd
    fi
  fi
}

help() {
    echo "Usage:    ${me} [OPTIONS] COMMAND"
    echo ""
    echo "Author:"
    echo "   TODO APP INFRA Contributors - <$(git config --get remote.origin.url)>"
    echo ""
    echo "Options:"
    echo " --debug, -D                                                            Enable debug mode"
    echo " help, -h                                                               show help"
    echo ""
    echo "Commands:"
    echo " v2-build-all <account> <aws-region> <environment>                      Build(init/validate/plan) all modules for todoV2"
}


if [ $# -lt 1 ]; then
    help
fi


while test -n "$1"; do
   case "$1" in
       -h|help)
          help
          shift
          ;;
       fmt)
         fmt
         shift
         ;;
       apply)
        if [[ $# -gt 4 ]]; then
          echo "Too many args";
          help
          exit 1;
         elif [[ $# -lt 3 ]]; then
          echo "Less args";
          help
          exit 1;	   
        fi    
         module_apply $2 $3 $4 $5
         exit $?
         ;;  
       v2-build-all)
         if [[ $# -gt 4 ]]; then
          echo "Too many args";
          help
          exit 1;
         elif [[ $# -lt 4 ]]; then
          echo "Less args";
          help
          exit 1;	   
         fi   
         v2_buila_all $2 $3 $4
         exit $?
         ;;
       *)
          echo "Unrecognized option : ${1}"
          help
          exit 1;
   esac
done



