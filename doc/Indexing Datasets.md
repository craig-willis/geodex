Gleaner

Details:

Machine:

Container

Repository listing:
https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/edit#gid=1340502269
should be downloaded into configs/geocodes as:  'CDFSources -- sources.csv'

Other servies:
* graph.geocodes.earthcube.org
* oss.geocodes.earthcube.org

## Running Gleaner
If we you update the spreadsheet, download the csv,
cd glcon
./glcon config generate --cfgName gecodes --sourcemaps 'CDFSources -- sources.csv'

### to check a recently added entry, use source
./glcon gleaner batch --cfgName gecodes  --source {{new repo name}}
./glcon nabu prefix --source  {{new repo name}}
./glcon nabu prune --source  {{new repo name}}

### to run all
./glcon gleaner batch --cfgName gecodes
./glcon nabu prefix 
./glcon nabu prune 



TODO:
wget from google sheets for the csv


