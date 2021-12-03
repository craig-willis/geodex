# Running the Geodex / GeoCODES services
* [Production Notes](./doc/Production.md)

A set of git workflows builds executables and containers for:
* Data processing tools
  * gleaner
  * nabu
* Web Services
  * geocodes
  * geocodes api

This is the project for the configuration of the docker stack for the geocodes production

## Prerequisites
* Assumes Ubuntu LTS
* Docker
* optional, since binaries are built
  * Go (`apt-get install golang`)
  * Go dep

## DNS Suggested
NEED A LIST OF THE DNS NAMES HERE

## Checkout source
```
mkdir geodex
cd geodex
git clone https://github.com/earthcube/geodex 
```

## Add Binaries
get latest from https://github.com/gleanerio/gleaner/releases
```shell
mkdir glcon
cd glcon
wget {release}-linux-amd64.tar.gz
tar -xf {release}-linux-amd64.tar.gz
```


## Docker Stack

A set of shell scripts is used to start the stack.
prior to this you need to create and edit the env for the
```shell
cp env.example env.beta
nano env.beta
```

```shell
./refresh_all.sh
```


