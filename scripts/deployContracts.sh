#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="${__dir}/.."

source ${__dir}/testNetConfig.sh


if [ -z "$1" ]
then
    echo "Endpoint not assigned."
    echo "Working on local testnet..."
    LOCALHOST=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' -m 1`
    ENDPOINT="http://${LOCALHOST}:${PORT}"
else
    echo "Endpoint: $1"
    ENDPOINT=$1
fi

# run deploy.js
echo "Deploying contract on ${ENDPOINT}..."
DEPLOYED_ADDRESS=$(node --experimental-specifier-resolution=node solc/scripts/deployContract.js ${ENDPOINT})

if [[ "$?" -ne 0 ]]
then
    echo "Error while deploying contracts."
    echo "Terminating..."
    exit 3
fi

echo "Contract successfully deployed at: ${DEPLOYED_ADDRESS}"


# write .env
ENV_FILE="${WORKDIR}/.env"
echo "DEFAULT_ENDPOINT=${ENDPOINT}" > $ENV_FILE
echo "CONTRACT_ADDRESS=${DEPLOYED_ADDRESS}" >> $ENV_FILE
echo "EC_TYPE=EC_ALT_BN128" >> $ENV_FILE
