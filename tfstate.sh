#!/bin/sh

# exit if any of the intermediate steps fail
set -e

# validate required software
aws --version > /dev/null 2>&1 || { jq -n '{"result":"aws is missing"}'; exit 1; }
jq --version > /dev/null 2>&1 || { jq -n '{"result":"jq is missing"}'; exit 1; }

# define unique id per execution (avoid collisions)
UNIQUE_ID=$(uuidgen)

# save tfstate as json and upload to s3
echo $3 > tfstate.${UNIQUE_ID}.txt
jq -rc . tfstate.${UNIQUE_ID}.txt > tfstate.${UNIQUE_ID}.json
aws s3 cp --quiet tfstate.${UNIQUE_ID}.json s3://${1}/${2}

# clean up and allow s3 to sync up (sleep 1 second)
rm tfstate.${UNIQUE_ID}.txt tfstate.${UNIQUE_ID}.json
sleep 1

# return successful execution
jq -n '{"result":"ok"}'
