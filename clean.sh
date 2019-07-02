#! /bin/bash
set -e

if [[ -z "$ROOT" ]]
then
  ROOT="."
fi

rm -rf $ROOT/config $ROOT/keys
rm -rf $ROOT/docker-compose.yml
