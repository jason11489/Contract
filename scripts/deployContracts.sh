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
echo -e "DEFAULT_ENDPOINT=${ENDPOINT}" > $ENV_FILE
echo -e "CONTRACT_ADDRESS=${DEPLOYED_ADDRESS}" >> $ENV_FILE
echo -e "EC_TYPE=EC_ALT_BN128" >> $ENV_FILE

# run registerAuditor.js
echo "Registering auditor on ${DEPLOYED_ADDRESS}..."
STATUS=`node --experimental-specifier-resolution=node solc/scripts/registerAuditor.js ${ENDPOINT} ${DEPLOYED_ADDRESS}`

if [[ "$?" -ne 0 ]]
then
    echo "Error while registering auditor."
    echo "Terminating..."
    exit 4
fi

echo "Auditor successfully registered to: ${DEPLOYED_ADDRESS}"

# run deployToken.js for ERC20
echo "Deploying ${ERC20_PRESET} on ${ENDPOINT}..."
ERC20_ADDRESS=$(node --experimental-specifier-resolution=node solc/scripts/deployToken.js ${ENDPOINT} "${ERC20_PRESET}" "${ERC20_NAME}" "${ERC20_SYM}")

if [[ "$?" -ne 0 ]]
then
    echo "Error while deploying ${ERC20_PRESET}."
    echo "Terminating..."
    exit 5
fi

echo "${ERC20_PRESET} successfully deployed at: ${ERC20_ADDRESS}"
echo -e "ERC20_ADDRESS=${ERC20_ADDRESS}" >> $ENV_FILE

# run mint.js for ERC20
echo "Minting ${ERC20_MINT_AMOUNT} ${ERC20_NAME} tokens to accounts..."
STATUS=$(node --experimental-specifier-resolution=node solc/scripts/mint.js ${ENDPOINT} "${ERC20_ADDRESS}" "${ERC20_MINT_AMOUNT}")

if [[ "$?" -ne 0 ]]
then
    echo "Error while minting ${ERC20_NAME}."
    echo "Terminating..."
    exit 5
fi

# run approve.js for ERC20
echo "Approving ${ERC20_APPROVE_AMOUNT} ${ERC20_NAME} tokens on accounts..."
STATUS=$(node --experimental-specifier-resolution=node solc/scripts/approve.js ${ENDPOINT} "${ERC20_ADDRESS}" "${DEPLOYED_ADDRESS}" "${ERC20_APPROVE_AMOUNT}")

if [[ "$?" -ne 0 ]]
then
    echo "Error while approving ${ERC20_NAME}."
    echo "Terminating..."
    exit 5
fi

# run registerToken.js for ERC20
echo "Registering ${ERC20_NAME} tokens on ${DEPLOYED_ADDRESS}..."
STATUS=$(node --experimental-specifier-resolution=node solc/scripts/registerToken.js ${ENDPOINT} "${DEPLOYED_ADDRESS}" "${ERC20_ADDRESS}")

if [[ "$?" -ne 0 ]]
then
    echo "Error while registering ${ERC20_NAME}."
    echo "Terminating..."
    exit 5
fi

## run deployToken.js for ERC721
#echo "Deploying ${ERC721_PRESET} on ${ENDPOINT}..."
#ERC721_ADDRESS=$(node --harmony-top-level-await --experimental-specifier-resolution=node solc/scripts/deployToken.js ${ENDPOINT} "${ERC721_PRESET}" "${ERC721_NAME_1}" "${ERC721_SYM_1}" "${ERC721_BASE_URI_1}")
#
#if [[ "$?" -ne 0 ]]
#then
#    echo "Error while deploying ${ERC721_PRESET}."
#    echo "Terminating..."
#    exit 5
#fi
#echo "${ERC721_PRESET} successfully deployed at: ${ERC721_ADDRESS}"
#echo -e "ERC721_ADDRESS_1=${ERC721_ADDRESS}" >> $ENV_FILE
#
## run approve.js for ERC721
#echo "Approving all ${ERC721_NAME_1} tokens on accounts..."
#STATUS=$(node --harmony-top-level-await --experimental-specifier-resolution=node solc/scripts/approve.js ${ENDPOINT} "${ERC721_ADDRESS}" "${DEPLOYED_ADDRESS}")
#
#if [[ "$?" -ne 0 ]]
#then
#    echo "Error while approving ${ERC721_NAME_1}."
#    echo "Terminating..."
#    exit 5
#fi


# run deployToken.js for ERC721
echo "Deploying ${ERC721_PRESET} on ${ENDPOINT}..."
ERC721_ADDRESS=$(node --experimental-specifier-resolution=node solc/scripts/deployToken.js ${ENDPOINT} "${ERC721_PRESET}" "${ERC721_NAME_0}" "${ERC721_SYM_0}" "${ERC721_BASE_URI_0}")

if [[ "$?" -ne 0 ]]
then
    echo "Error while deploying ${ERC721_PRESET}."
    echo "Terminating..."
    exit 5
fi

echo "${ERC721_PRESET} successfully deployed at: ${ERC721_ADDRESS}"
echo -e "ERC721_ADDRESS_0=${ERC721_ADDRESS}" >> $ENV_FILE


# run mint.js for ERC721
echo "Minting ${ERC721_NAME_0} token to accounts..."
STATUS=$(node --experimental-specifier-resolution=node solc/scripts/mint.js ${ENDPOINT} "${ERC721_ADDRESS}")

if [[ "$?" -ne 0 ]]
then
    echo "Error while minting ${ERC721_NAME_0}."
    echo "Terminating..."
    exit 5
fi

# run approve.js for ERC721
echo "Approving all ${ERC721_NAME_0} tokens on accounts..."
STATUS=$(node --experimental-specifier-resolution=node solc/scripts/approve.js ${ENDPOINT} "${ERC721_ADDRESS}" "${DEPLOYED_ADDRESS}")

if [[ "$?" -ne 0 ]]
then
    echo "Error while approving ${ERC721_NAME_0}."
    echo "Terminating..."
    exit 5
fi

# run deployToken.js for ERC1155
echo "Deploying ${ERC1155_PRESET} on ${ENDPOINT}..."
ERC1155_ADDRESS=$(node --experimental-specifier-resolution=node solc/scripts/deployToken.js ${ENDPOINT} "${ERC1155_PRESET}" "${ERC1155_NAME_0}" "${ERC1155_SYM_0}" "${ERC1155_BASE_URI_0}")

if [[ "$?" -ne 0 ]]
then
    echo "Error while deploying ${ERC1155_PRESET}."
    echo "Terminating..."
    exit 5
fi

echo "${ERC1155_PRESET} successfully deployed at: ${ERC1155_ADDRESS}"
echo -e "ERC1155_ADDRESS_0=${ERC1155_ADDRESS}" >> $ENV_FILE

# run mint.js for ERC1155
echo "Minting ${ERC1155_NAME_0} token to accounts..."
STATUS=$(node --experimental-specifier-resolution=node solc/scripts/mint.js ${ENDPOINT} "${ERC1155_ADDRESS}" "${ERC1155_MINT_ID}" "${ERC1155_MINT_AMOUNT}" )

if [[ "$?" -ne 0 ]]
then
    echo "Error while minting ${ERC1155_NAME_0}."
    echo "Terminating..."
    exit 5
fi

echo "Configuring done."



# run deployTest.js

echo "Deploying contract on ${ENDPOINT}..."
DEPLOYED_ADDRESS=$(node --experimental-specifier-resolution=node solc/scripts/deployDataTradeContract.js ${ENDPOINT})

if [[ "$?" -ne 0 ]]
then
    echo "Error while deploying contracts."
    echo "Terminating..."
    exit 3
fi

echo "Test Contract successfully deployed at: ${DEPLOYED_ADDRESS}"
