FROM ubuntu:latest

MAINTAINER Morgan Commons morgan.commons@aspect.com

#Add values to prevent error: 'Could not resolve archive.ubuntu.com'
COPY 91.189.88.46 archive.ubuntu.com /etc/hosts
COPY 91.189.88.46 security.ubuntu.com /etc/hosts
# Install latest updates
RUN apt-get update
RUN apt-get upgrade -y

# Install mysql client and server
RUN apt-get -y install mysql-client mysql-server curl

# Enable remote access (default is localhost only, we change this
# otherwise our database would not be reachable from outside the container)
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Install database
ADD ./database.sql /var/db/database.sql

# Set Standard settings
ENV user root
ENV password aspect2015
ENV url file:/var/db/database.sql
ENV right WRITE

# Install starting script
ADD ./start-database.sh /usr/local/bin/start-database.sh
RUN chmod +x /usr/local/bin/start-database.sh

EXPOSE 3306

CMD ["/usr/local/bin/start-database.sh"]
