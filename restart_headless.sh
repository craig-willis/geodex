echo Restart headless only

docker-compose --env-file env.beta  -f geocodes-dev-compose.yaml -f geocodes-compose.yaml -f docker-compose.yaml restart headless

