#!/bin/bash
set -ex

sudo curl -o /etc/init.d/mongod https://raw.githubusercontent.com/heidemn/mongod-sysv/master/mongod
sudo chmod +x /etc/init.d/mongod
sudo service mongod status


sudo apt-get update
sudo apt-get -y install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update

# Used earlier: 4.0.21
sudo apt-get install -y mongodb-org=5.0.2 mongodb-org-database=5.0.2 mongodb-org-server=5.0.2 mongodb-org-shell=5.0.2 mongodb-org-mongos=5.0.2 mongodb-org-tools=5.0.2

# Optional: Delete prexisting data.
#sudo rm -r /var/lib/mongodb/
#sudo mkdir /var/lib/mongodb/
#sudo chown mongodb:mongodb /var/lib/mongodb/

sudo service mongod status
sudo service mongod start

mongo --eval 'db.adminCommand( { listDatabases: 1 } )'

sudo service mongod stop
sudo service mongod status
