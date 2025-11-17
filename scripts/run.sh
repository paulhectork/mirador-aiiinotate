#!/usr/bin/env bash

# build and serve the mirador-mae-aiiinotate ingration.\
# $2 defines 2 modes to run the app: "dev" and prod.
# - in prod, this script just runs mirador.
# - in dev, this script runs mongo, aiiinotate and mirador.
# why ? in prod, we use a docker-compose where mongo and aiiinotate run in their own containers.

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );
cd "$ROOT_DIR"

# $MODE defines if we run the app in dev or in prod.
# only allowed value is "dev" (use no value for a prod build)
MODE="$1"
if [ ! -z "$MODE" ] && [ ! "$MODE" = "dev" ]
then echo -e "\nincorrect argument for $0: '$1' \nUSAGE: bash $0 [dev]\n"; exit 1;
fi;

source "$SCRIPT_DIR/utils.sh"
check_envfile;
source "$ENV_FILE";

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
    # serve it
    http-server "$ROOT_DIR"/dist -p "$MIRADOR_PORT";
}

maybe_start_aiiinotate
build_mirador
start_mirador
maybe_stop_aiiinotate
