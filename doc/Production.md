## Notes on Production

Notes are found at:

* [Indexing Earthcube Resoruce Registry](./Indexing%20ECRR.md)
* [Indexing Datasets](./Indexing%20Datasets.md)

Production Folder on Google Drive
* [google drive eco/ecotech/production](https://drive.google.com/drive/folders/1vhNgUEX3SGUKv4tJStVPjQRbJm4nbWuK?usp=sharing)


Server listing is found at:
[google drive eco/ecotech/production/Geocodes resources to monitor](https://docs.google.com/spreadsheets/d/1ouXQtQpj-r03MtJ7ax06MwDQhaOgtHGle0w1ERmG6_Y/edit#gid=1417756058
)

Sources used for gleaner: https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/edit#gid=1340502269

====
Outline:

* Pull this repository
* put configuration of servers in the .env.beta (see env.example)
* run:
  * ./restart_all.sh
If a container is updated:
  * ./refresh_all.sh

TODO:
* split docker compose files into smaller chunks.
* pull ecrr scripts into a directory
* kubernetes.



