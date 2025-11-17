#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );
ROOT_DIR="$SCRIPT_DIR/..";

start_mongod() {
    if ! systemctl is-active --quiet mongod;
    then sudo systemctl start mongod;
    fi;
}

# assert that an env file exists
validate_envfile() {
    env_file=$1;
    if [ ! -f "$env_file" ];
    then
        echo ".env file not found. exiting... (at '$env_file')";
        exit 1;
    fi;
}
