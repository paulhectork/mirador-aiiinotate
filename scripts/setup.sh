#!/usr/bin/env bash

#TODO : install mongodb

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );

source "$SCRIPT_DIR/utils.sh";

cd "$ROOT_DIR";

validate_envfile;

npm i;

start_mongod;

aiiinotate --env "$ENV_FILE" -- migrate apply;
