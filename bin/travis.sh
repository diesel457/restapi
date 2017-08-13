#!/bin/bash

# Stop pre-started RDBMS, move their data back to disk (save RAM)
# sync for some settle time
sudo /etc/init.d/mysql stop || /bin/true
sudo service mysql stop || /bin/true
sudo service mysqld stop || /bin/true
sudo /etc/init.d/postgresql stop || /bin/true
/bin/sync

for d in mysql postgresql ; do
  sudo rm -rf /var/lib/$d
done