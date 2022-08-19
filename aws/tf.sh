#!/bin/bash

account=$1
region=$2
if [[ $region == "global" ]]; then
  component=$3
  cmd=$4
else
  environment=$3
  component=$4
  cmd=$5
fi

if [[ $region == "global" ]]; then
  echo "\n🔧 $cmd for $account-global-$component"

  if [[ $cmd == "plan" ]]; then
    terraform -chdir=$account/global/$component plan -out $account-global-${component////-}.plan
  elif [[ $cmd == "apply" ]]; then
    terraform -chdir=$account/global/$component apply $account-global-${component////-}.plan
  else
    terraform -chdir=$account/global/$component $cmd
  fi

else
  echo "\n🔧 $cmd for $account-$region-$environment-$component"

  if [[ $cmd == "plan" ]]; then
    terraform -chdir=$account/$region/$environment/$component plan -out $account-$region-$environment-${component////-}.plan
  elif [[ $cmd == "apply" ]]; then
      terraform -chdir=$account/$region/$environment/$component apply $account-$region-$environment-${component////-}.plan
  else
    terraform -chdir=$account/$region/$environment/$component $cmd
  fi

fi
