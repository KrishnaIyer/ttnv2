#! /bin/bash
set -e

function init(){
  rm -rf $1/keys $1/config
  mkdir -p $1/keys $1/config
  rm -rf $1/docker-compose.yml
  cp ./templates/bridge.env $1/config/bridge.env
  sed -i "" "s/NETWORKID/$2/g" $1/config/bridge.env
  cp ./templates/docker-compose.yml $1/docker-compose.yml
  sed -i "" "s/NETWORKSERVERDOMAIN/$3/g" $1/docker-compose.yml
}


function initkeys() {
  mkdir -p $ROOT/keys/$1
  touch $ROOT/keys/$1/server.key
  touch $ROOT/keys/$1/server.pub
  touch $ROOT/keys/$1/server.cert
}

function initconfig() {
  cp ./templates/$1.yml $ROOT/config/$1.yml
  sed -i "" "s/NETWORKID/$2/g" $ROOT/config/$1.yml
  sed -i "" "s/NETWORKSERVERDOMAIN/$3/g" $ROOT/config/$1.yml
}

# Script starts here.

if [[ -z "$NETWORK_ID" ]]
then
  echo "Error: Please input NETWORK_ID"
  exit 1
fi

if [[ -z "$NETWORK_SERVER_DOMAIN" ]]
then
    NETWORK_SERVER_DOMAIN="local.thethings.network"
fi

if [[ -z "$ROOT" ]]
then
  ROOT="."
fi

# Preparation
init $ROOT $NETWORK_ID $NETWORK_SERVER_DOMAIN

# Generating Certificates
echo "Generating routing certificates..."
for component in discovery router networkserver broker handler
do
  initkeys $component
  initconfig $component $NETWORK_ID $NETWORK_SERVER_DOMAIN
  docker-compose run --rm $component $component gen-keypair
done

# router networkserver broker handler
for component in discovery router networkserver broker handler
do
  docker-compose run --rm $component $component gen-cert localhost $component $component.$NETWORK_SERVER_DOMAIN
done

# Generating routing tokens
echo "Generating routing tokens..."
nstoken=$(docker-compose run --rm networkserver networkserver authorize $NETWORK_ID-broker | tail -n2 | head -n1)
sed -i "" "s/NSTOKEN/$nstoken/g" $ROOT/config/broker.yml

for component in router broker handler
do
  token=$(docker-compose run --rm discovery discovery authorize $component $NETWORK_ID-$component | tail -n2 | head -n1)
  sed -i "" "s/TOKEN/$token/g" $ROOT/config/$component.yml
done

# Bridge Settings
cp ./templates/bridge.env $ROOT/config/bridge.env
sed -i "" "s/NETWORKID/$NETWORK_ID/g" $ROOT/config/bridge.env

## Clean up
echo "Cleaning up.."
docker-compose down
