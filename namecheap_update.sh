#!/usr/bin/env bash

set -o allexport
source shared.sh
set +o allexport

[ -d "$LOGS_DIR" ] || mkdir -p "$LOGS_DIR"

update_timestamp="$(date +%Y-%m-%dT%H_%M_%S)"

base_domain="$1"
if [[ -z "$base_domain" ]]; then
  echo -e "${C_RED_B}\n  ERROR: Required argument base_domain not provided!${C_OFF}"
  echo -e "${C_WHITE_B}\n  Usage: $0 <base_domain> <update_host1> <update_host2> ...${C_OFF}"
  exit 1
fi
shift 1
if [[ -z "$1" ]]; then
  echo -e "${C_RED_B}\n  ERROR: No update hosts provided!${C_OFF}"
  echo -e "${C_WHITE_B}\n  Usage: $0 <base_domain> <update_host1> <update_host2> ...${C_OFF}"
  exit 1
fi
if ! command -v 'curl' >/dev/null; then
  echo -e "${C_RED_B}\n  ERROR: required curl command not found!${C_OFF}"
  exit 1
fi
if ! command -v 'jq' >/dev/null; then
  echo -e "${C_RED_B}\n  ERROR: required jq command not found!${C_OFF}"
  exit 1
fi

jtm_bin="$script_dir/jtm/jtm-macos-64.v2.09"
if [[ "$OSTYPE" == linux* ]]; then
  jtm_bin="$script_dir/jtm/jtm-linux-64.v2.09"
fi

for update_host in $@; do
  echo -e "\n  Updating subdomain${C_OFF} ${C_WHITE_B}$update_host${C_OFF} of ${C_WHITE_B}$base_domain${C_OFF} - ${C_WHITE_B}$update_host.$base_domain${C_OFF}"
  log_file="$LOGS_DIR/${update_host}.${base_domain}_${update_timestamp}.json"
  response="$(
    curl -s "https://dynamicdns.park-your-domain.com/update?host=${update_host}&domain=${base_domain}&password=${DYN_PW}" | \
    $jtm_bin | jq
  )"
  echo "$response" | jq '.[1]["interface-response"]' | xz -zc > "${log_file}.xz"
done

bash log_cleaner.sh
