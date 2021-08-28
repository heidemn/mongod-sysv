#!/bin/bash
set -e

purge=0
purge_data=0
yes=
while [[ "$1" =~ ^- ]]; do
    if [ "$1" = "--purge" ]; then
        purge=1
    elif [ "$1" = "--purge-data" ]; then
        purge_data=1
    elif [ "$1" = "--yes" ] || [ "$1" = "-y" ]; then
        yes="-y"
    else
        echo "ERROR: Unknown option: $1"
        exit 1
    fi
    shift
done
mongodb_version="${1:-5.0}"
if [ "$mongodb_version" != 4.0 ] && [ "$mongodb_version" != 5.0 ]; then
    echo "ERROR: Unknown mongodb_version: $mongodb_version"
    exit 1
fi

echo
echo "*** Installing MongoDB $mongodb_version ***"
echo

set -x

sudo curl -o /etc/init.d/mongod https://raw.githubusercontent.com/heidemn/mongod-sysv/master/mongod
sudo chmod +x /etc/init.d/mongod
sudo service mongod status || true

if [ "$purge" = 1 ]; then
    sudo apt-get purge $yes "mongodb*"
fi
if [ "$purge_data" = 1 ]; then
    sudo rm -rf /var/lib/mongodb/
fi

sudo apt-get update
sudo apt-get $yes install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-${mongodb_version}.asc | sudo apt-key add -

source /etc/os-release
if [ "$mongodb_version" = 4.0 ]; then
    # "focal" is N/A according to MongoDB 4.0 docs.
    UBUNTU_CODENAME=bionic
fi
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu ${UBUNTU_CODENAME}/mongodb-org/${mongodb_version} multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-${mongodb_version}.list

sudo apt-get update


if [ "$mongodb_version" = 4.0 ]; then
    # Used earlier: 4.0.21
    sudo apt-get install $yes mongodb-org=4.0.26 mongodb-org-server=4.0.26 mongodb-org-shell=4.0.26 mongodb-org-mongos=4.0.26 mongodb-org-tools=4.0.26
else
    sudo apt-get install $yes mongodb-org=5.0.2 mongodb-org-database=5.0.2 mongodb-org-server=5.0.2 mongodb-org-shell=5.0.2 mongodb-org-mongos=5.0.2 mongodb-org-tools=5.0.2
fi

sudo mkdir -p /var/lib/mongodb/
sudo chown mongodb:mongodb /var/lib/mongodb/

sudo service mongod status || true
sudo service mongod start

mongo --eval 'db.adminCommand( { listDatabases: 1 } )'

sudo service mongod stop
sudo service mongod status || true
