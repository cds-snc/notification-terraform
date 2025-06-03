#!/bin/bash

kubectl rollout restart deployment/notify-admin -n notification-canada-ca
kubectl rollout status deployment notify-admin -n notification-canada-ca

kubectl rollout restart deployment/notify-api -n notification-canada-ca
kubectl rollout status deployment notify-api -n notification-canada-ca

CELERIES=$(kubectl get deployments -n notification-canada-ca | awk '{print $1}' | grep celery )
for celery in $CELERIES; do
  echo $celery
  kubectl rollout restart deployment/$celery -n notification-canada-ca
  kubectl rollout status deployment $celery -n notification-canada-ca
done
