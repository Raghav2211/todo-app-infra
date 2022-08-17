# #!/bin/bash
n=0
while [ "$(kubectl get pods -l=app.kubernetes.io/name='config-server' -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; do
   sleep 5
    n=$((n+1))
    if [ "$n" -eq 5 ]; then
          exit 1;
    fi
   echo "Waiting for config-server to be ready."
done
echo "config-server is ready"

n=0
while [ "$(kubectl get pods -l=app.kubernetes.io/name='edge-service' -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; do
   sleep 5
    n=$((n+1))
    if [ "$n" -eq 5 ]; then
          exit 1;
    fi
   echo "Waiting for edge-service to be ready."
done
echo "edge-service is ready"

n=0
while [ "$(kubectl get pods -l=app.kubernetes.io/name='todo' -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true" ]; do
   sleep 5
    n=$((n+1))
    if [ "$n" -eq 5 ]; then
          exit 1;
    fi
   echo "Waiting for todo-app to be ready."
done
echo "todo-app is ready"