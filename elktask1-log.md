# Install Elasticsearch
sudo yum install -y http://mirror.linuxtrainingacademy.com/elasticsearch/elasticsearch-7.9.2-x86_64.rpm

# Install Java
sudo yum install -y java-1.8.0-openjdk

# Configure Elasticsearch
vi /etc/elasticsearch/elasticsearch.yml
# Set cluster and node names
# cluster.name: syslog
# node.name: syslog

# Start and enable Elasticsearch service
sudo systemctl start elasticsearch.service
sudo systemctl enable elasticsearch.service

# Verify Elasticsearch installation
curl http://localhost:9200

# Install Logstash
sudo yum install -y http://mirror.linuxtrainingacademy.com/logstash/logstash-7.9.2.rpm

# Configure Logstash
vi /etc/logstash/conf.d/syslog.conf
# Add Logstash configuration for syslog input, grok filters, geoip, and Elasticsearch output

# Start and enable Logstash service
sudo systemctl start logstash
sudo systemctl enable logstash
sudo systemctl status logstash
cat /var/log/logstash/logstash-plain.log

# Configure rsyslog to forward logs to Logstash
sudo vi /etc/rsyslog.d/logstash.conf
# Add forwarding configuration: *.* @192.168.33.10:5141

# Restart rsyslog
sudo systemctl restart rsyslog

# Install Kibana
sudo yum install -y http://mirror.linuxtrainingacademy.com/kibana/kibana-7.9.2-x86_64.rpm

# Configure Kibana
vi /etc/kibana/kibana.yml
# Set Kibana server host: server.host: "192.168.33.10"

# Start and enable Kibana service
sudo systemctl start kibana
sudo systemctl enable kibana

# Access Kibana on port 5601 and configure index patterns

# Create Logstash index pattern in Kibana

# Explore Kibana features, e.g., discover, visualize, and dashboard

# Additional steps for remote server:
# - Add new server IP to Logstash configuration in /etc/rsyslog.d/logstash.conf

# Analyze syslog data from the Internet server
curl -fsSL http://mirror.linuxtrainingacademy.com/elasticsearch/es-sample.sh | sudo bash

# Verify Elasticsearch indices
curl http://localhost:9200/_cat/indices?v

# Explore failed SSH attempts on Kibana Maps
# - Open Kibana, click on the menu icon, and go to "Maps"

# Create Kibana dashboard with visualizations

# Search for specific log entries in Kibana Discover

# Additional configuration for forwarding logs to another server
sudo vi /etc/rsyslog.d/logstash.conf
# Add forwarding configuration for the new server: *.* @192.168.56.25:5141




# Add forwarding configuration for the new server
sudo vi /etc/rsyslog.d/logstash.conf
# Add the following line: *.* @192.168.56.25:5141

# Restart rsyslog
sudo systemctl restart rsyslog

# New Server:
# Add Logstash configuration on the new server in /etc/rsyslog.d/logstash.conf
# *.* @192.168.33.10:5141

# Restart rsyslog on the new server
sudo systemctl restart rsyslog

# Come back to syslog server

# Collect syslog data from the Internet server for one day
curl -fsSL http://mirror.linuxtrainingacademy.com/elasticsearch/es-sample.sh | sudo bash

# Verify Elasticsearch indices
curl http://localhost:9200/_cat/indices?v

# Explore failed SSH attempts on Kibana Maps
# - Open Kibana, click on the menu icon, and go to "Maps"

# Create Kibana dashboard with visualizations
# - Use Kibana interface to create visualizations and a dashboard based on your requirements

# Additional Steps:
# - Customize the script for mapping failed SSH attempts based on the structure of your log data
# - Create visualizations in Kibana that represent the geographical location of failed SSH attempts
# - Add these visualizations to a dashboard for a comprehensive view

# Note: The specific details for creating a dashboard and mapping SSH attempts will depend on your log data structure and Kibana visualization capabilities.
