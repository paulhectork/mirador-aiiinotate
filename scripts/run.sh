#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );

source "$SCRIPT_DIR/utils.sh"

cd "$ROOT_DIR"

check_envfile;

source "$ENV_FILE";

aiiinotate --env "$ENV_FILE" -- serve prod &

# build the mirador app
rm -rf "$ROOT_DIR"/dist "$ROOT_DIR"/.parcel-cache && parcel build "$ROOT_DIR"/src/index.html;
# serve it
http-server "$ROOT_DIR"/dist -p "$MIRADOR_PORT";

# once the above command returns, kill aiiinotate (MainThread = nodejs parent thread).
kill $(pgrep MainThread);
