#!/usr/bin/env bash

set -e;

# ----------------------------------------
# definitions

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );
ROOT_DIR="$SCRIPT_DIR/..";
source "$SCRIPT_DIR/utils.sh";

usage() {
    cat <<EOF
USAGE: bash $0 env
ARGUMENTS:
    - env: relative or absolute path to your env file
EOF
}

# ----------------------------------------
# run

# get the env file, see that it exists and return it as an absolute path
ENV_FILE="$1";
if [ -z "$ENV_FILE" ];
then usage && exit 1;
fi;
ENV_FILE=$(realpath "$ENV_FILE");
validate_envfile "$ENV_FILE";

cd "$ROOT_DIR";
npm i;
start_mongod;
"$ROOT_DIR"/node_modules/.bin/aiiinotate --env "$ENV_FILE" -- migrate apply;
