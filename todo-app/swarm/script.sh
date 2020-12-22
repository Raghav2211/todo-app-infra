#!/bin/bash

usage() { echo "Usage: $0 [-s <45|90>] [-p <string>]" 1>&2; exit 1; }
echo "start"
# start the case-ing
while test -n "$1"; do
   case "$1" in
      --debug|-p)
         echo "debug"
         shift
         ;;
       create)
         echo "create : $#"
         if [[ $# -gt 1 ]]; then
          echo "Too many args ";
          exit 1;  
         fi 
         shift
         ;;
       delete)
         echo "delete"
         shift
         ;;
       *) 
        echo "Unknown"
        exit 1;  
   esac
done
