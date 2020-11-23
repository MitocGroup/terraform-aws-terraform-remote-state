#!/bin/sh

# exit if any of the intermediate steps fail
set -e

# validate required software
aws --version > /dev/null 2>&1 || { jq -n '{"message":"aws is missing"}'; exit 1; }
jq --version > /dev/null 2>&1 || { jq -n '{"message":"jq is missing"}'; exit 1; }

# define unique id per execution (avoid collisions)
UNIQUE_ID=$(uuidgen)

# validate inline parameters
if [ -z "${1}" ]; then jq -n '{"message":"template tfstate is missing"}'; exit 1; fi
if [ -z "${2}" ]; then jq -n '{"message":"s3 bucket is missing"}'; exit 1; fi
if [ -z "${3}" ]; then jq -n '{"message":"s3 key is missing"}'; exit 1; fi
if [ -z "${4}" ]; then jq -n '{"message":"aws region is missing"}'; exit 1; fi

# assume aws role if exists
if [ ! -z "${5}" ]; then
  ASSUME_ROLE="$(aws sts assume-role --role-arn ${5} --role-session-name awscli-${UNIQUE_ID} | jq '.Credentials')"
  ACCESS_KEY="$(echo ${ASSUME_ROLE} | jq '.AccessKeyId')"
  SECRET_KEY="$(echo ${ASSUME_ROLE} | jq '.SecretAccessKey')"
  SESSION_TOKEN="$(echo ${ASSUME_ROLE} | jq '.SessionToken')"

  mkdir -p ~/.aws
  if [ -f ~/.aws/config ]; then mv -f ~/.aws/config ~/.aws/config-${UNIQUE_ID}.bkp; fi
  touch ~/.aws/config
  echo "[default]" > ~/.aws/config
  echo "aws_access_key_id=${ACCESS_KEY//\"/}" >> ~/.aws/config
  echo "aws_secret_access_key=${SECRET_KEY//\"/}" >> ~/.aws/config
  echo "aws_session_token=${SESSION_TOKEN//\"/}" >> ~/.aws/config
fi

# save tfstate as json and upload to s3
echo ${1} > tfstate.${UNIQUE_ID}.txt
jq -rc . tfstate.${UNIQUE_ID}.txt > tfstate.${UNIQUE_ID}.json
aws s3 cp --quiet --region ${4} tfstate.${UNIQUE_ID}.json s3://${2}/${3}

# clean up and allow s3 to sync up (sleep 1 second)
rm tfstate.${UNIQUE_ID}.txt tfstate.${UNIQUE_ID}.json
sleep 1

# return successful execution
jq -n '{"message":"success"}'
