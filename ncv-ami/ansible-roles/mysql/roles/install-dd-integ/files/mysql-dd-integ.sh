#!/bin/bash

pass=$1

#sudo mysql -e "CREATE USER 'datadog'@'localhost' IDENTIFIED BY $pass ;"
sudo mysql -e "GRANT REPLICATION CLIENT ON *.* TO 'datadog'@'localhost' WITH MAX_USER_CONNECTIONS 5;"

sudo mysql -e "GRANT PROCESS ON *.* TO 'datadog'@'localhost';"
sudo mysql -e "GRANT SELECT ON performance_schema.* TO 'datadog'@'localhost';"
mysql -u datadog --password=$pass -e "show status" | \
grep Uptime && echo -e "MySQL user - OK" || echo -e "Cannot connect to MySQL"

mysql -u datadog --password=$pass -e "show slave status" && \
echo -e "MySQL grant - OK" || echo -e "Missing REPLICATION CLIENT grant"


mysql -u datadog --password=$pass -e "SELECT * FROM performance_schema.threads" && \
echo -e "MySQL SELECT grant - OK" || echo -e "Missing SELECT grant"
mysql -u datadog --password=$pass -e "SELECT * FROM INFORMATION_SCHEMA.PROCESSLIST" && \
echo -e "MySQL PROCESS grant - OK" || echo -e "Missing PROCESS grant"
