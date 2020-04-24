# Running the Geodex / GeoCODES services

## Prerequisites
* Assumes Ubuntu LTS
* go, go-dep
* docker, docker-compose

```
sudo apt-get update -y
sudo apt-get install -y golang docker.io go-dep
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
sudo usermod -a -G docker ubuntu
docker swarm init
```

Modify `.bash_profile` and change `PATH`:
```
export PATH=$PATH:$(go env GOPATH)/bin
```

Logout and login again for group and PATH changes to take effect.


## Checkout source

To run without building, you only need the `gleaner` and this `geodex` repository. Images for the other services have been built and pushed.

```
mkdir -p ~/go/src/earthcube.org/Project418/
cd go/src/earthcube.org/Project418
git clone https://github.com/earthcube/gleaner -b eco
git clone https://github.com/earthcube/services -b eco
git clone https://github.com/earthcube/webui -b eco
git clone https://github.com/earthcube/webUI2 -b eco
git clone https://github.com/craig-willis/geodex
```


## Building components
This shows how to build individual components and images.

```
cd gleaner
make gleaner
docker build -t geocodes/gleaner -f build/Dockerfile .
```

```
cd services
dep ensure
make services
docker build -t geocodes/p418services -f build/Dockerfile .
```

```
cd webui
dep ensure
make webui
docker build -t geocodes/p418webui -f build/Dockerfile .
```

```
cd webUI2
docker build -t geocodes/p418webui2 .
```


## Running Gleaner

For more information about running Gleaner, see also the ECO [README](https://github.com/earthcube/gleaner/blob/eco/docs/starterpack/README.md).

Start the Gleaner backend:
```
cd gleaner/docs/starterpack/
. demo-exp.env
docker-compose -f gleaner-compose-ECAM.yml  up
```
Index IEDA using spatial, text, graph millers (`configs/eco.yaml`)
```
cd gleaner
./runGleaner.sh -setup
./runGleaner.sh
```

For development purposes, create /etc/hosts entry for `geodex.local.earthcube.org`:
```
127.0.0.1  geodex.local.earthcube.org
``` 

To run the web services in this repo:
```
cd geodex
docker-compose up
```

If running on a VM, forward pors 80 and 443:
```
ssh -L 443:localhost:443 -L 80:localhost:80  you@vm
```

Test the following URLs:
* https://geodex.local.earthcube.org/ Geodex main landing page
* https://geodex.local.earthcube.org/geocodes/ Geocodes text/spatial search
* https://geodex.local.earthcube.org/geocodes/textSearch.html Text search for IEDA only. Search for "coral" ([api call](http://geodex.local.earthcube.org/api/v1/textindex/search?q=coral&s=0&i=ieda&n=10))
* https://geodex.local.earthcube.org/geocodes/spatialSearch.html Search for [-125.40664,44.4617] ([api call](* http://geodex.local.earthcube.org/api/v1/spatial/search/object?geowithin={%22type%22:%22FeatureCollection%22,%22features%22:[{%22type%22:%22Feature%22,%22geometry%22:{%22type%22:%22Point%22,%22coordinates%22:[-125.40664,44.4617]},%22properties%22:{}}]}))

## Things to note:

* `gleaner` fork is based on old commit for parity with current geodex.org. A minor change was required to spatial framing to support arrays of spatialCoverage, but this breaks individual cases. IEDA test case happens to use arrays.
* `gleaner` (`eco` branch) includes changes to the starterpack and configuration along with IEDA test configuration.
* `webui` fork (`eco` branch) includes changes to add `host` flag to change API server host, changes to Go dependencies to enable building, and changes to the Docker configuration to enable `GEODEX_HOST` env var.
* `webUI2` fork (`eco` branch) includes changes to the Docker configuration to enable `GEODEX_HOST` env var.
* `services` fork (`eco` branch) adds flag to change host and Docker configuration to enable `GEODEX_HOST` env var.

## TODO/questions
* Move these forks to `earthcube` org?
* This would probably all work with latest version of Gleaner, since framing is broken anyway.
* Preliminary docker-compose needs revision. There is already some of this in the latest `gleaner`, but it was useful to work through it end to end.
* Traefik needs TLS configuration (do we want to use Lets Encrypt?), do we have a dev domain that we can easily manage or will SDSC provide valid certs? (e.g., local.earthcube.org -> 127.0.0.1)
* Need to figure out Jena/SparQL end-to-end
* There are things that aren't clear in the repos -- use of Blazegraph and Blast in `webui`.  
* `webui` search isn't working because Blast is missing from config
* `entrypoint` sed approach to host/domain change is lazy
* Index maintenance can be separate from running instance -- this largely seems to be what has been done in the past.  Build the index on one machine, copy it to another.
* IEDA bounding boxes look backwards? Also, IEDA is successfully indexed on geodex.org, so maybe the array problem isn't a problem?
* bleve index is created on /bleve. For now, I just mount that into the services container, but this should be configurable.
