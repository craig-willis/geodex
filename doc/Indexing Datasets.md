# Indexing using glcon Gleaner Console

Details:
You can run glcon with the configuration.

Machine: 
dev.geocodes.earthcube.org

Container

Repository listing:
[csv file from google sheets:]( https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=sources)
[google sheet](https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/edit#gid=1340502269)
No longer needs to be downloaed, but it should occassionally be commited into configs/geocodes as:  'CDFSources -- sources.csv'

Other services:
* graph.geocodes.earthcube.org
* oss.geocodes.earthcube.org

## grab latest glcon


## Intialize Configurations

`./glcon config init`  
 config will be named local

`./glcon config init --cfgName geocodes`

## Edit
in configs
```yaml
minio:
  address: oss.geocodes.earthcube.org
  port: 80
  accessKey: worldsbestaccesskey
  secretKey: worldsbestsecretkey
  ssl: false
  bucket: gleaner2 # can be overridden with MINIO_BUCKET
sparql:
  endpoint: http://graph.geocodes.earthcube.org/blazegraph/namespace/earthcube/sparql
s3:
  bucket: gleaner2 # sync with above... can be overridden with MINIO_BUCKET... get's zapped if it's not here.
  domain: us-east-1

#headless field in gleaner.summoner
headless: http://127.0.0.1:9222
sourcesSource:
#  type: csv
#  location: sources.csv
  type: csv
  location: https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/gviz/tq?tqx=out:csv&sheet=sources
  ```
## Running Gleaner
If we you update the spreadsheet, download the csv,
`cd glcon`

`./glcon config generate`
or
`./glcon config generate --cfgName geocodes` 

### to check a recently added entry, use source
`./glcon gleaner batch --cfgName geocodes  --source {{new repo name}}`
`./glcon nabu prefix --source  {{new repo name}} --cfgName geocodes`
`./glcon nabu prune --source  {{new repo name}} --cfgName geocodes`

### to run all
`./glcon gleaner batch --cfgName geocodes`
`./glcon nabu prefix  --cfgName geocodes`
`./glcon nabu prune --cfgName geocodes`






