#!/usr/bin/env bash

get_os() {
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)     os=Linux;;
        Darwin*)    os=Mac;;
        CYGWIN*)    os=Cygwin;;
        MINGW*)     os=MinGw;;
        MSYS_NT*)   os=Git;;
        *)          os="UNKNOWN:${unameOut}"
    esac
    echo "${os}"
}
export OS;
OS=$(get_os);

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
