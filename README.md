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
* For external connections such as `ttnctl`, add the following to your `/etc/hosts` file
  ```
  127.0.0.1 discovery.local.thethings.network router.local.thethings.network handler.local.thethings.network 
  ```
* Once the script successfully runs, you can now bring up the services using
  ```
  $ docker-compose up -d
  ```
* Sometimes, the handler cannot start streams with the broker. In this case, restart the handler a couple of times until the connection is successful
* Since there's no console in this deployment, all the interaction is done via the [CLI(ttnctl)](https://www.thethingsnetwork.org/docs/network/cli/quick-start.html).
* In order for the CLI to communicate with the stack components, you need to manually trust the discovery CA. For macOS, follow [this guide](https://tosbourn.com/getting-os-x-to-trust-self-signed-ssl-certificates/).


### Clean

* Use the `clean.sh` script to remove the generated files.
    ```
    $ROOT=<> ./clean.sh
    ```
