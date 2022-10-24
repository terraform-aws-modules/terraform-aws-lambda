#!/bin/sh
set -e

echo in entrypoint
echo I can read $MY_ENV_VAR and my volume:
ls -la /entrypoint

echo "running command $@"
"$@"

echo finished running entrypoint
