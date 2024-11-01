#!/usr/bin/env bash

set -o allexport
source .env
set +o allexport

C_OFF='\033[0m'
C_RED_B='\033[1;31m'
C_WHITE_B='\033[1;37m'

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LOGS_DIR="$script_dir/update_logs"
