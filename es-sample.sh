#!/bin/bash

# Run as root
[[ "$EUID" -eq 0 ]] || {
  echo 'Please run with sudo or as root.'
  exit 1
}

# Are we on CentOS 7 or 8?  This changes the backup file name
ESBACKUP_FILE_NAME="esbackups.tgz"
grep "^VERSION=" /etc/os-release| grep 8  >/dev/null 2>&1

[[ ${?} -eq 0 ]] && {
  #CENTOS_VER="8"
  ESBACKUP_FILE_NAME="esbackups-v8.tgz"
}

# Idiot checking.
# Is ES even up?
curl -s http://localhost:9200/ -o /dev/null
[[ ${?} -ne 0 ]] && {
  echo 'Could not connect to ElasticSearch.  Please ensure ElasticSearch is running.'
  exit 1
}

STATUS=$(curl -s http://localhost:9200/_cluster/health?pretty | grep status | cut -f4 -d\")
[[ "${STATUS}" = "red" ]] && {
  echo 'Preexisting error detected with ElasticSearch.'
  echo 'Please ensure ElasticSearch is running and that indices are in a yellow or green state before running this script again.'
  exit 1
}

# Make sure there is at least one index that is either yellow or green.
curl -s http://localhost:9200/_cat/indices | egrep 'yellow|green' >/dev/null
[[ ${?} -ne 0 ]] && {
  echo 'Preexisting error detected with ElasticSearch.'
  echo 'Please ensure ElasticSearch is running and that indices are in a yellow or green state before running this script again.'
  exit 1
}

echo 'Downloading sample Elasticsearch data.'
echo 'This make take several minutes to complete.'
echo 'Please wait...'

# Try to download the file
for i in {0..4}
do
  curl --retry 2 -s -C - http://mirror.linuxtrainingacademy.com/elasticsearch/sample-data/${ESBACKUP_FILE_NAME} -o /var/tmp/${ESBACKUP_FILE_NAME}
  [ $? -eq 0 ] && break
done
echo 'Finsihed downloading sample Elasticsearch data.'


echo 'Extracting sample Elasticsearch data.'
cd /
tar zxf /var/tmp/${ESBACKUP_FILE_NAME} >/dev/null 2>&1
# Make sure it matches the ES user on THIS host.
chown -R elasticsearch:elasticsearch /esbackups >/dev/null 2>&1
echo 'Finished Extracting sample Elasticsearch data.'


# Add some sneaky config, but only do it once.
cp -p /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.$(date +%F.$$) >/dev/null 2>&1
grep ^path.repo: /etc/elasticsearch/elasticsearch.yml >/dev/null 2>&1
[ $? -eq 0 ] || echo 'path.repo: ["/esbackups"]' >> /etc/elasticsearch/elasticsearch.yml

# Remove any leading whitespace from elasticsearch.yml because indentation in YAML matters.
sed -i 's/^ *//' /etc/elasticsearch/elasticsearch.yml

# Restart ES
echo 'Restarting Elasticsearch...'
systemctl restart elasticsearch >/dev/null 2>&1

# Wait for ES to start
for i in {0..100}
do
  sleep 3
  STATUS=$(curl -s http://localhost:9200/_cluster/health?pretty | grep status | cut -f4 -d\")
  [ "$STATUS" = "yellow" ] && break
  [ "$STATUS" = "green" ] && break
done

echo 'Importing data into Elasticsearch.'
echo 'This make take several minutes to complete.'
echo 'Please wait...'

# If there is an existing index, delete it.
curl -XDELETE http://localhost:9200/logstash-2016.04.15 >/dev/null 2>&1
curl -XDELETE http://localhost:9200/logstash-2017.04.15 >/dev/null 2>&1
curl -XDELETE http://localhost:9200/logstash-2018.04.15 >/dev/null 2>&1
curl -XDELETE http://localhost:9200/logstash-2019.04.15 >/dev/null 2>&1
curl -XDELETE http://localhost:9200/logstash-2020.04.15 >/dev/null 2>&1

# Create snapshot configuration
#curl -s -XPUT 'http://localhost:9200/_snapshot/my_backup?pretty' -d '
curl -s -XPUT -H "Content-Type: application/json" 'http://localhost:9200/_snapshot/my_backup?pretty' -d '
{
    "type": "fs",
    "settings": {
        "location": "/esbackups",
        "compress": true
    }
}' >/dev/null 2>&1


# Restore snapshot
curl -s -XPOST http://localhost:9200/_snapshot/my_backup/snapshot_1/_restore  >/dev/null 2>&1

# Wait for the restoration
RESTORED=false
for i in {0..100}
do
  sleep 2
  STATE=$(curl -s http://localhost:9200/_snapshot/my_backup/snapshot_1?pretty | grep state | cut -f4 -d\" | grep -v ^$)
  [ "$STATE" = "SUCCESS" ] && {
    RESTORED=true
    break
  }
done

# Wait for indices to turn from red to yellow/green.
REDS=1
for i in {0..100}
do
  sleep 2
  REDS=$(curl -s http://localhost:9200/_cat/indices | grep red | wc -l)
  [ "$REDS" -eq 0 ] && break
done

# Delete any old indices from me being to lazy to exclude them from the snapshot.
#curl -XDELETE http://localhost:9200/logstash-2016.04.15 >/dev/null 2>&1

# Check to see if it worked.
if [ $RESTORED = true ]
then
  echo 'Finished Importing data into Elasticsearch.'
else
  echo 'Import failed.'
  exit 1
fi

# Later gators.
echo 'Done.  Bye!'



#####
# /usr/local/bin/elasticdump --concurrency 20 --quiet --output=http://127.0.0.1:9200/logstash-2020.04.15 --input=logs.json.2020
#####
