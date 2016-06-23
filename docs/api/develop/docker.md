---
layout: article
title: Docker setup
---

{% include section_title.html title="Docker Introduction" %}

Docker documentation can be found at:-

  https://docs.docker.com

Docker works with 'containers' which you can think of as lightweight
virtual machines. They can be built once, and deployed in many places.

Different components have been configured to run in docker
containers, for example client-code, server-code, mysql, etc. These 
components work together to make the game, each one can be deployed
separately on many different environments, Linux, Windows OS-X.

Containers can be downloaded automatically from docker-hub, some of these
are specially built for Keno Antigen and can be found at https://hub.docker.com/u/kenoantigen

Other containers are more generic, such as Redis, Beanstalk of MySQL and 
these will be downloaded from their respective repositories.

By downloading prebuilt docker containers this precludes the necessity of
building and installing the software, that is all done for you. 

By comparison, building all the components from scratch might typically
take up to 16 hours (assuming no issues) but by using Docker this takes 
just the download time (say 40 minutes depending upon your broadband speed)
and a few minutes to run them up. Once they are downloaded the images
remain on your system and don't need to be downloaded again.


{% include section_title.html title="Components" %}

Components are split across a number of gihub repositories. Each repository
has one or more docker scripts to spin up the docker containers.

  * **git@github.com:Kantigen/ka-web.git** The Javascript Client
    * **ka-web** Docker container for the Javascript Client

  * **git@github.com:Kantigen/ka-api-docs.git** The documentation (this!)
    * **ka-api-docs** Docker container for docs

  * **git@github.com:Kantigen/ka-server.git** The Perl Server Code
    * **ka-network** The Docker network component
    * **ka-captcha-data** A persistent data store holding Captcha images
    * **ka-mysql-data** A persistent data store for MySQL
    * **ka-redis** Redis store Server
    * **ka-beanstalkd** The beanstalk Job Queue
    * **ka-memcache**d Memcache Cache Server
    * **ka-mysql-server** MySQL Server
    * **ka-server** The main Perl Server code
    * **ka-websocket** The Perl WebSocket API code
    * **ka-nginx** Web Server for various components

The Perl Server components should be run in the above order (there are some
dependencies between them).

