docker pull nsfearthcube/ec_facets_client:latest
docker pull nsfearthcube/ec_facets_client:feat-binder
docker pull nsfearthcube/ec_facets_api_nodejs:latest
docker-compose --env-file env.beta  -f geocodes-dev-compose.yaml -f geocodes-compose.yaml -f docker-compose.yaml up -d
