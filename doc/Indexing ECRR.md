## Indexing Earthcube Resource Registry

workflow:

* google form write to google drive
* rclone syncs ecrr_sumbitted to s3 store.
* on schedule, glcon is excuted
* ntriples are uploaded to

  * graph.geocodes.earthcube.org
  * graph.geodex.org
  * fuskeki at: http://132.249.238.169:8080/fuseki/ecrr/

Note: only ecrr_sumbitted will syncronized. If the examples need to up updates, they need to be manually run, for now.

 **Details**: 
* The registry is created with a google form, which puts files into a google drive:

rclone is used to pull data from google drive to and s3 store.
(TDB: write go module to pull from google drive)

```bash
#/bin/bash
echo "start" > ~/ecrrdata/ecrr_geocodes_lastrun

echo "rclone google drive"
rclone  --s3-upload-cutoff 0 sync --include *.json --delete-excluded ecrrGoogleDrive:/ minio_geocodes:/ecrr/summoned/ecrr/
echo "rclone form google drive"
rclone  --s3-upload-cutoff 0 sync --include *.json --delete-excluded ecrrFormGoogleDrive:/ minio_geocodes:/ecrr/summoned/ecrr_form/
 
echo "gleaner"
cd glcon 
./glcon gleaner batch --cfg ecrr  2> log
cd  ~/ecrrdata
rclone --ignore-checksum copy minio_geocodes:/ecrr/results/rr1/ecrr_examples_graph.nq .
rclone --ignore-checksum copy minio_geocodes:/ecrr/results/rr1/ecrr_graph.nq .

#curl -X PUT --header "Content-Type:application/n-quads" --upload-file "ecrr_examples_graph.nq"  http://localhost:8080/fuseki/ecrr/data
#curl -X PUT --header "Content-Type:application/n-quads" --upload-file "ecrr_graph.nq"  http://localhost:8080/fuseki/ecrr/data

echo "upload triples"
cat ecrr_graph.nq ecrr_examples_graph.nq > goodTriples.nq
curl -X PUT --header "Content-Type:application/n-quads" --upload-file "goodTriples.nq"  http://132.249.238.169:8080/fuseki/ecrr/data
# push to graphdb
curl -X POST -H "Content-Type:text/x-nquads" --upload-file "goodTriples.nq" "https://graph.geodex.org/blazegraph/namespace/ecrr/sparql"
curl -X POST -H "Content-Type:text/x-nquads" --upload-file "goodTriples.nq" "https://graph.geocodes.earthcube.org/blazegraph/namespace/ecrr/sparql"
```

## crontab

crontab -e

```shell
00 * * * * /home/centos/ecrr2earthcube.sh >ecrr_cron.log 2>&1
```

### Updating

The script will create and upload the form repo.

`cd glcon; ./glcon gleaner batch --cfgName ecrr`

If the examples, or the tools are updated, then they need to be manually summoned.

`cd glcon; ./glcon gleaner batch --cfgName ecrr --summon --source ecrr_examples `

`cd glcon; ./glcon gleaner batch --cfgName ecrr --summon --source geocodes_examples`

### Gleaner/glcon notes

Sources found at; https://docs.google.com/spreadsheets/d/1G7Wylo9dLlq3tmXe8E8lZDFNKFDuoIEeEZd3epS0ggQ/edit#gid=567896613


```csv
hack,SourceType,Active,CredentialsFile,Name,ProperName,URL,Headless,Domain,PID,Logo,base_url,base_uri,count,cdf_membership,summary
51,googledrive,TRUE,configs/credentials/gleaner-331805-030e15e1d9c4.json,ecrr_submitted,Earthcube Resource Registry,https://drive.google.com/drive/u/0/folders/1TacUQqjpBbGsPQ8JPps47lBXMQsNBRnd,FALSE,http://www.earthcube.org/resourceregistry/,,https://www.earthcube.org/sites/default/files/doc-repository/logo_earthcube_full_horizontal.png,http://earthcube.org/resource_registry,,274,,"The EarthCube Resource Registry (ECRR) is intended to provide immediate access to a list of EC capabilities to understand what EC is, and what it isn‚Äôt. To support this goal, the ECRR project has developed several persistent resources available for wider EarthCube use"
52,sitemap,TRUE,,ecrr_examples,Earthcube Resource Registry Examples,https://raw.githubusercontent.com/earthcube/ecrro/master/Examples/sitemap.xml,FALSE,http://www.earthcube.org/resourceregistry/examples,,https://www.earthcube.org/sites/default/files/doc-repository/logo_earthcube_full_horizontal.png,http://earthcube.org/resource_registry,,274,,"The EarthCube Resource Registry (ECRR) is intended to provide immediate access to a list of EC capabilities to understand what EC is, and what it isn‚Äôt. To support this goal, the ECRR project has developed several persistent resources available for wider EarthCube use"
54,sitemap,TRUE,,geocodes_examples,GeoCodes Tools Examples, https://raw.githubusercontent.com/earthcube/GeoCODES-Metadata/main/sitemap.xml,FALSE,https://raw.githubusercontent.com/earthcube/GeoCODES-Metadata/,,,,,,,
```

### rclone notes

_Note: rclone my no longer be needed with the googledrive capable gleaner, and github actions creating sitemaps of folders_

rclone is used to sync files from the google drive to the s3.

rclone config
add the following:

```text
[ecrrGoogleDrive]
type = drive
scope = drive.readonly
root_folder_id = 1cUdfoIPMTG4LFXzIIKh0GUhYt-1jwyek
token = {"access_token":"",
"token_type":"Bearer","refresh_token":"","expiry":"2021-11-09T19:29:11.724918065Z"}

[ecrrFormGoogleDrive]
type = drive
scope = drive.readonly
root_folder_id = 1TacUQqjpBbGsPQ8JPps47lBXMQsNBRnd
token = {"access_token":"",
"token_type":"Bearer","refresh_token":"",
"expiry":"2021-11-09T19:29:12.396834233Z"}

[minio_geocodes]
type = s3
provider = Minio
env_auth = false
access_key_id = {{KEY}}
secret_access_key = {{SECRET}}
endpoint = oss.geocodes.earthcube.org
acl = public-read

```

## original host

ssh -i ~/{{cinergikey}} centos@132.249.238.169

installed apache fuseki and rclone

configured rclone to read google drive
[ecrrGoogleDrive]
type = drive
scope = drive.readonly
root_folder_id = 1cUdfoIPMTG4LFXzIIKh0GUhYt-1jwyek
token = {"access_token":"{{TOKEN}}","token_type":"Bearer",
"refresh_token":
"{{KEY}}",
"expiry":"2019-10-30T11:56:41.757335-07:00"}

[sdscS3]
type = s3
provider = Ceph
env_auth = false
access_key_id =
secret_access_key =
endpoint = object.cloud.sdsc.edu

rclone  --s3-upload-cutoff 0 sync ecrrGoogleDrive:/ sdscS3:/gleaner-summoned/ecrr/

gleaner

Needed script to copy goodtriples.
