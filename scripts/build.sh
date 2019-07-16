#!/bin/sh

# apollo config db info
apollo_config_db_url=jdbc:mysql://localhost:3306/miop_apollo_config?characterEncoding=utf8
apollo_config_db_username=root
apollo_config_db_password=root

# apollo portal db info
apollo_portal_db_url=jdbc:mysql://localhost:3306/miop_apollo_portal?characterEncoding=utf8
apollo_portal_db_username=root
apollo_portal_db_password=root

# meta server url, different environments should have different meta server addresses
sit_meta=http://fill-in-sit-meta-server:8080
uat_meta=http://fill-in-uat-meta-server:8080
ver_meta=http://fill-in-ver-meta-server:8080
prod_meta=http://fill-in-prod-meta-server:8080

META_SERVERS_OPTS="-Dsit_meta=$sit_meta -Duat_meta=$uat_meta -Dver_meta=$ver_meta -Dprod_meta=$prod_meta"

# =============== Please do not modify the following content =============== #
# go to script directory
cd "${0%/*}"

cd ..

# package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=$apollo_config_db_url -Dspring_datasource_username=$apollo_config_db_username -Dspring_datasource_password=$apollo_config_db_password

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=$apollo_portal_db_url -Dspring_datasource_username=$apollo_portal_db_username -Dspring_datasource_password=$apollo_portal_db_password $META_SERVERS_OPTS

echo "==== building portal finished ===="
