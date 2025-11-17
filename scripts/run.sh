#!/usr/bin/env bash

# build and serve the mirador-mae-aiiinotate ingration.\
# $2 defines 2 modes to run the app: "dev" and "prod".
# - in prod, this script just runs mirador.
# - in dev, this script runs mongo, aiiinotate and mirador.
# why ? in prod, we use a docker-compose where mongo and aiiinotate run in their own containers.

set -e

# ----------------------------------------
# definitions

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );
ROOT_DIR="$SCRIPT_DIR/.."
source "$SCRIPT_DIR/utils.sh"

usage() {
    cat <<EOF
USAGE:
    bash $0 {dev|prod} env
ARGUMENTS:
    - {dev|prod}: type of build to use. 'dev' for local, 'prod' for docker deploy
    - env: relative or absolute path to your env file
EOF
}

# start mongodb and aiiinotate in dev
maybe_start_aiiinotate() {
    if [ "$MODE" = "dev" ];
    then
        start_mongod;
        aiiinotate --env "$ENV_FILE" -- serve prod &
    fi;
}

# in dev, kill aiiinotate when http-server exists (MainThread = nodejs parent thread).
maybe_stop_aiiinotate() {
    if [ "$MODE" = "dev" ];
    then kill $(pgrep MainThread);
    fi;
}

# build the mirador app
build_mirador() {
    rm -rf "$ROOT_DIR"/dist "$ROOT_DIR"/.parcel-cache && parcel build "$ROOT_DIR"/src/index.html;
}

# serve the mirador app
start_mirador() {
    http-server "$ROOT_DIR"/dist -p "$MIRADOR_PORT";
}

# ----------------------------------------
# run

# $MODE defines if we run the app in dev or in prod.
# only allowed value is "dev" (use no value for a prod build)
MODE="$1"
if [ ! "$MODE" = "dev" ] && [ ! "$MODE" = "prod" ];
then usage; exit 1;
fi;

# get the env file, see that it exists and return it as an absolute path
ENV_FILE="$2";
if [ -z "$ENV_FILE" ];
then usage && exit 1;
fi;
ENV_FILE=$(realpath "$ENV_FILE");
validate_envfile "$ENV_FILE";

source "$ENV_FILE";

cd "$ROOT_DIR"
maybe_start_aiiinotate
build_mirador
start_mirador
maybe_stop_aiiinotate
