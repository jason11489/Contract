#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="${__dir}/.."

# Start ganache
echo "Starting ganache..."
CMD="${__dir}/runTestNet.sh" \

${CMD} > /dev/null 2>&1 & disown
if [[ "$?" -ne 0 ]]
then
    echo "Error while starting ganache."
    echo "Terminating..."
    exit 2
fi

sleep 3

# Deploy contracts
echo "Deploying contracts..."
${__dir}/deployContracts.sh

if [[ "$?" -ne 0 ]]
then
    echo "Error while deploying contracts."
    echo "Terminating..."
    exit 2
fi
