# mongod-sysv

SysV init script for MongoDB.

Useful when Systemd is not available, e.g. in WSL2.  
Allows to conveniently start and stop MongoDB in the background, using the default config file `/etc/mongod.conf`. 

## Prerequisites

Only tested with MongoDB 4.0 on Ubuntu 20.04, running in WSL2.

## Installation

You can use any filename for the service, if you don't like `mongod`.

```
sudo curl -o /etc/init.d/mongod https://raw.githubusercontent.com/heidemn/mongod-sysv/master/mongod
sudo chmod +x /etc/init.d/mongod
```

### Full installation of MongoDB

Based on: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/

Before running it, adapt [the script](install-mongodb.sh) as needed (e.g. MongoDB version).  
Tested on Ubuntu 20.04 in WSL2.

```
./install-mongodb.sh
```


## Usage

The script provides the usual service commands:

- `sudo service mongod status`
- `sudo service mongod start`
- `sudo service mongod stop`
- `sudo service mongod restart`

Example:

```
$ sudo service mongod status
Checking status of mongod...
mongod is not running (3).

$ sudo service mongod start
Starting mongod...
Waiting for localhost:27017............. OK.

$ sudo service mongod status
Checking status of mongod...
mongod is running.

$ sudo service mongod restart
Stopping mongod...
OK.
Starting mongod...
Waiting for localhost:27017............. OK.

$ sudo service mongod stop
Stopping mongod...
OK.
```
