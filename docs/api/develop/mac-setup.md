---
layout: article
title: Setup Mac Development Environment
---

{% include section_title.html title="Install docker" %}

There are documents elsewhere on how to install Docker but
when installing on OS X just check the following point.

On OS X Docker runs in a Virtual Box, the default base memory is 1024 MB but
it might be too little, in which case you need to set higher, say 8196 as
follows. (Note this will blow-away your current docker containers if you have
any!)


{% highlight bash %}
$ docker-machine rm default
$ docker-machine create --driver virtualbox --virtualbox-memory 8096 default
$ eval "$(docker-machine env default)"
{% endhighlight %}


{% include section_title.html title="Clone from GIT" %}

Assuming that you are going to checkout the code into ~keno

{% highlight bash %}

$ cd ~keno
$ git clone git@github.com:Kantigen/ka-web.git
$ git clone git@github.com:Kantigen/ka-server.git
$ git clone git@github.com:Kantigen/ka-api-docs.git

{% endhighlight %}

You may not want to download all of these, you can just download
the **ka-web** if you want to just work on the client and most
people will not want to make changes to **ka-api-docs**

Assuming you want to install both the client and server on a Mac
you can do so as follows.

### CLIENT

{% highlight bash %}
$ cd ~keno/ka-web
$ 
{% endhighlight %}

There are two main components, the Server code written predominantly in Perl
and the client code written in Javascript (using ReactJS). In addition user
code can be run on the servers in Docker containers. This allows user code
to be written in a variety of languages (Javascript, Perl, Ruby, Python)
but in a secure manner.

The Client code is a single-page-app which communicates through a Web-Socket
API to the server. The user code running in docker containers also
communicates via web-sockets.

Since the API is open-source then this offers the opportunity for third-party
clients to be written which can be used to drive a users empire.




