# #!/bin/bash

services=('config-server' 'edge-service' 'todo')

for str in "${services[@]}"; do
  n=0
  while [ "$(kubectl get pods -l=app.kubernetes.io/name=$str -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; do
     sleep 5
      n=$((n+1))
      if [ "$n" -eq 5 ]; then
            exit 1;
      fi
     echo "Waiting for $str to be ready."
  done
  echo "$str is ready"
done