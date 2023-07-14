#!/bin/bash

HARDFORK="istanbul"
GAS_LIMIT="0x3FFFFFFFFFFFF"
GAS_PRICE="0"
DEFAULT_BALANCE="9000000"
HOST="0.0.0.0"
PORT=${1-"8545"}
SCRIPT_PATH=$( cd "$(dirname "$0")" ; pwd )
KEYS_PATH="${SCRIPT_PATH}/../solc/keys.json"
