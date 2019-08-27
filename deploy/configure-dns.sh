#!/bin/bash
set -e

export KR_SITE_NAME=keeprunning.io
LC_CTYPE=C && find ./dns-resources/  -type f -exec sed -i '' "s/KR_SITE_NAME/${KR_SITE_NAME}/g" {} \;

# to replace back
# LC_CTYPE=C && find ./dns-resources/ -type f -exec sed -i '' "s/${KR_SITE_NAME}/KR_SITE_NAME/g" {} \;

gcloud compute addresses create kr-ip --global
export EXTERNAL_IP_ADDRESS=$(gcloud compute addresses describe kr-ip --global | grep address: | awk '{print $2'})


gcloud dns managed-zones create kr-zone --dns-name="${KR_SITE_NAME}" --description="Test KR zone" --visibility=public
gcloud dns record-sets transaction start --zone="kr-zone"
gcloud dns record-sets transaction add $EXTERNAL_IP_ADDRESS \
  --name="${KR_SITE_NAME}." \
  --ttl="30" \
  --type="A" \
  --zone="kr-zone"

# NOTE: I could not add it as part of the same transaction
# gcloud dns record-sets transaction add "${KR_SITE_NAME}." \
#  --name="www.${KR_SITE_NAME}." \
#  --zone="kr-zone" \
#  --type="CNAME" \
#  --ttl="30"

gcloud dns record-sets transaction execute --zone="kr-zone"

kubectl apply -f dns-resources/