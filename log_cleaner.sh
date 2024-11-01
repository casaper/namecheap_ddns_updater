#!/usr/bin/env bash

# script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# logs_dir="$script_dir/update_logs"
# [ -d "$logs_dir" ] || mkdir -p "$logs_dir"

set -o allexport
source shared.sh
set +o allexport

[ -d "$LOGS_DIR" ] || mkdir -p "$LOGS_DIR"

keep_count="${1:-50}"
log_files="$(find "$LOGS_DIR" -name '*.xz' | sort -h)"
file_count="$(wc -l <<<"$log_files" | tr -d '[:blank:]')"

if ((file_count <= keep_count)); then
  exit 0
fi

remove_count=$((file_count - keep_count))

rm_files=$(head -n $remove_count <<<"$log_files")

# echo "  keep_count:   $keep_count"
# echo "  file_count:   $file_count"
# echo "  remove_count: $remove_count"

echo -e "\n  Removing exessive log files:"
while read -r rm_file; do
  echo "  - ${rm_file//$LOGS_DIR\//}"
  rm "$rm_file"
done <<<"$rm_files"
echo -e "\n Kept log files:"
while read -r kept_file; do
  echo "  - ${kept_file//$LOGS_DIR\//}"
done < <(ls -1 "$LOGS_DIR/"*.xz)
