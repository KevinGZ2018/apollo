@echo off

rem apollo config db info
set apollo_config_db_url="jdbc:mysql://localhost:3306/miop_apollo_config?characterEncoding=utf8"
set apollo_config_db_username="root"
set apollo_config_db_password="root"

rem apollo portal db info
set apollo_portal_db_url="jdbc:mysql://localhost:3306/miop_apollo_portal?characterEncoding=utf8"
set apollo_portal_db_username="root"
set apollo_portal_db_password="root"

rem meta server url, different environments should have different meta server addresses
set sit_meta="http://localhost:8080"
set uat_meta="http://anotherIp:8080"
set ver_meta="http://someIp:8080"
set prod_meta="http://yetAnotherIp:8080"

set META_SERVERS_OPTS=-Dsit_meta=%sit_meta% -Duat_meta=%uat_meta% -Dver_meta=%ver_meta% -Dprod_meta=%prod_meta%

rem =============== Please do not modify the following content =============== 
rem go to script directory
cd "%~dp0"

cd ..

rem package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

call mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=%apollo_config_db_url% -Dspring_datasource_username=%apollo_config_db_username% -Dspring_datasource_password=%apollo_config_db_password%

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

call mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=%apollo_portal_db_url% -Dspring_datasource_username=%apollo_portal_db_username% -Dspring_datasource_password=%apollo_portal_db_password% %META_SERVERS_OPTS%

echo "==== building portal finished ===="

pause
