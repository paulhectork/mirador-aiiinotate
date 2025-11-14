#!/usr/bin/env bash

# build and serve the mirador-mae-aiiinotate ingration.
# 2 modes are allowed: prod and dev, defined by $2.
# if $2 == "dev", then we will run `aiiinotate` in a background process and exit it when quitting the app
# don't use "dev" in prod.

# allowed values; "dev" or nothing.
MODE="$1"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );

cd "$ROOT_DIR"

source "$SCRIPT_DIR/utils.sh"
check_envfile;
source "$ENV_FILE";

# start aiiinotate in dev
if [ "$MODE" = "dev" ];
then aiiinotate --env "$ENV_FILE" -- serve prod &
fi;

# build the mirador app
rm -rf "$ROOT_DIR"/dist "$ROOT_DIR"/.parcel-cache && parcel build "$ROOT_DIR"/src/index.html;
# serve it
http-server "$ROOT_DIR"/dist -p "$MIRADOR_PORT";

# in dev, kill aiiinotate when http-server exists (MainThread = nodejs parent thread).
if [ "$MODE" = "dev" ];
then kill $(pgrep MainThread);
fi;