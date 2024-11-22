#! /bin/bash

# Quick and dirty script to insert terraform-docs config for all modules between markers (#BEGIN_AUTOGEN and #END_AUTOGEN) in .pre-commit-config.yaml

DIRECTORIES=$(find . -type f -name '*.tf' | sed -r 's|/[^/]+$||' |sort |uniq)

OUTPUT=""

for dir in $DIRECTORIES
do
  OUTPUT+="\n      - id: terraform-docs-go\n"
  OUTPUT+="        name: \"terraform-docs-go - ${dir}\"\n"
  OUTPUT+="        args: [\"markdown\",\"table\",\"--output-file\",\"README.md\",\"${dir}\"]"
done

head="#BEGIN_AUTOGEN"
tail="#END_AUTOGEN"

sed -i '' -E "s|$head[^$tail]*|$head$OUTPUT|g" .pre-commit-config.yaml
