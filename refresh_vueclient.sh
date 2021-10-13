docker pull nsfearthcube/ec_facets_client:latest
docker-compose up -d --force-recreate vue-client
docker pull nsfearthcube/ec_facets_api_nodejs:latest
docker-compose up -d --force-recreate vue-services
