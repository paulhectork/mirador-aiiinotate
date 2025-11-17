#!/usr/bin/env bash

set -e;

# ----------------------------------------
# definitions

# path to current script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# basic / dev config
ENV_CONFIG="$SCRIPT_DIR/../.env"
# docker specific config, created by `env_to_docker`
ENV_DOCKER="$SCRIPT_DIR/.env"
# utils scripts
UTILS="$SCRIPT_DIR/../scripts/utils.sh";

usage() {
    cat <<EOF

USAGE:
    $0 {build|start|stop} env
ARGUMENTS:
    - {build|start|stop}: action on docker container
    - env: relative or absolute path to your env file

EOF
}

# mac+linux compatible file replacements
sed_repl () {
    sed_expr="$1"
    file="$2"
    if [ "$OS" = "Linux" ];
    then sed -i -e "$sed_expr" "$file";
    else sed -i "" -e "$sed_expr" "$file";
    fi
}

# copy config/.env file to docker/.env and adapt the file to work with docker.
env_to_docker() {
    # check the env file is found
    if [ ! -f "$ENV_CONFIG" ];
    then
        echo ".env file not found at at '$ENV_CONFIG'. exiting...";
        return 1;  # will exit when used with `set -e`
    fi;

    # NOTE that the MongoDB host in Docker MUST BE the name of the Mongo docker service (defined in docker-compose)
    cp "$ENV_CONFIG" "$ENV_DOCKER";
    sed_repl s~^MONGODB_HOST=.*$~MONGODB_HOST=mongo~ "$ENV_DOCKER";
    sed_repl s~^AIIINOTATE_HOST=.*~AIIINOTATE_HOST=0.0.0.0~ "$ENV_DOCKER"
}

build_containers () {
    sudo docker compose --env-file "$ENV_DOCKER" build --no-cache;
}

start_containers() {
    sudo docker compose --env-file "$ENV_DOCKER" up -d;
}

stop_containers() {
    sudo docker compose --env-file "$ENV_DOCKER" stop;
}

# ----------------------------------------
# run

source "$UTILS";
env_to_docker;
cd "$SCRIPT_DIR";
pwd
case "$1" in
    start)
        start_containers
        ;;
    stop)
        stop_containers
        ;;
    build)
        stop_containers
        build_containers
        start_containers
        ;;
    *)
        usage;
        exit 1
        ;;
esac;

