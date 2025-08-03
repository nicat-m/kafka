#!/bin/bash

INPUT="terraform.tfvars"
OUTPUT="terraform.tfvars.example"

# Clear new file
> $OUTPUT

while IFS= read -r line; do
  if [[ "$line" =~ ^[[:space:]]*([a-zA-Z0-9_]+)[[:space:]]*=[[:space:]]*.+$ ]]; then
    var_name="${BASH_REMATCH[1]}"
    echo "$var_name = \"\"" >> $OUTPUT
  else
    echo "$line" >> $OUTPUT
  fi
done < "$INPUT"

echo "Created $OUTPUT with empty values."
