#!/bin/bash

# based on code by
# - Alexander Kaalimetschek at https://unix.stackexchange.com/a/415155/310780
# - Tom at https://github.com/l3laze/sind

# Recursively searches directories and constructs menu options for selection
# which then execute the selected items corresponding bash scripts.

function select_option
{
  for f in "$PWD"/meta-config/*; do
    echo "tis $f"
  done
}
