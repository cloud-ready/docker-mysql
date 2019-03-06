# docker-mysql

mysql using uid 1000

Dockerfile [cloud-ready/docker-mysql on Github](https://github.com/cloud-ready/docker-mysql)

[cloudready/mysql on Docker Hub](https://hub.docker.com/r/cloudready/mysql/)


Connect to mysql on Mac OSX

Find out if there is a mysql client on your Mac, run `brew list | grep mysql-client` in terminal.

If no mysql installed run
```
brew install mysql-client

# The following command should not be executed repeatedly.
echo 'export PATH="/usr/local/opt/mysql-client/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```
in terminal.

Connect to mysql by mysql-client
```
mysql -h 127.0.0.1 -P 3306 -u root -proot_pass
```

Run SQL script file by mysql-client
```
mysql -h 127.0.0.1 -P 3306 -u root -proot_pass < path/to/your.sql
```

Send multi-line queries by mysql-client
```
mysql -h 127.0.0.1 -P 3306 -u root -proot_pass << "EOF"

SHOW DATABASES;
EOF
```
