# TTN V2 deployment

This repository contains the necessary configuration to install a TTN V2 private routing environment.
This is based on [this](https://www.thethingsnetwork.org/article/deploying-a-private-routing-environment-with-docker-compose) blog post.

## Usage

* Clone this repository.
* Run the install script:
    ```
    $NETWORK_ID=<> $ROOT=<> $NETWORK_SERVER_DOMAIN=<> ./install.sh
    ```
* Note that the `NETWORK_ID` env is mandatory
### Clean

* Use the `clean.sh` script to remove the generated files.
    ```
    $ROOT=<> ./clean.sh
    ```
