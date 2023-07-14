#!/bin/bash

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKDIR="${__dir}/.."

source ${__dir}/testNetConfig.sh

PID=$(lsof -i:${PORT} | grep ${PORT} | tr -s ' ' | cut -d ' ' -f2)

if [[ -n $PID ]]
then
    echo "Port is already in use: ${PORT}"
    echo "Check if you are already running the network."
    while true; do
	    read -p "Do you wish to kill process and re-run? [y/n]" yn
	    case $yn in
	        [Yy]* ) kill $PID && break;;
	        [Nn]* ) echo "Terminating..." && exit 1;;
	        * ) echo "Please answer y or n.";;
	    esac
	done
fi

echo "Starting ganache..."
CMD="npx ganache --hardfork ${HARDFORK} --port ${PORT} --gasLimit ${GAS_LIMIT} --gasPrice ${GAS_PRICE} --defaultBalanceEther ${DEFAULT_BALANCE} --host ${HOST} --account_keys_path ${KEYS_PATH}" \

${CMD}
if [[ "$?" -ne 0 ]]
then
    echo "Error while starting ganache."
    echo "Terminating..."
    exit 2
fi
