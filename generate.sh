#!/usr/bin/env bash

cd "$(dirname "$0")"

target_filename=.github/workflows/semantic.yml
template_filename=workflow_template.yml
script_filename=semantic_script.sh
pattern_filename=semantic_pattern.txt

cat /dev/null > $target_filename

while IFS='' read -r line; do
  case $line in
  __PATTERN__)
    read -r semantic_pattern < $pattern_filename
    echo "    $semantic_pattern" >> $target_filename
    ;;
  __SCRIPT__)
    while IFS='' read -r script_line; do
      echo "        $script_line" >> $target_filename
    done < $script_filename
    ;;
  *)
    echo "$line" >> $target_filename
    ;;
  esac
done < $template_filename
