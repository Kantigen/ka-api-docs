---
lastmod: 2016-10-09
date: 2016-10-09
linktitle: start 
menu:
  main:
    parent: getting started
title: Start
weight: 10
---

{{< section_title  "Architecture" >}}

There are two main components, the Server code written predominantly in Perl
and the client code written in Javascript (using ReactJS). In addition users
can use the same API that the client and server use to run their own code.
(One option we are looking at is allowing users to run their code on the
KA servers, in docker containers) 

The Client code is a single-page-app which communicates through a Web-Socket
API to the server. 

Since the API is open-source then this offers the opportunity for third-party
clients to be written which can be used to drive a users empire.

{{< section_title  "Web Sockets" >}}

Web Sockets offer significant advantages over HTTP requests, such as AJAX calls 
using HTTP.

  * The overhead for each request is much smaller. An AJAX call could easily 
have 1200 bytes of header for a simple 8 bytes of data. The same data for a 
Web Socket header is 8 bytes. This makes Web Sockets faster.
  * It is asynchronous and full-duplex. As well as the client being able to
push data or request data from the server at any time, the server can also push
data to the client when it changes. As a consequence the client does not have
to resort to frequent polling or similar techniques.
  * By only supporting Web Sockets the server code can be further simplified
making it much faster and cheaper. We can then scale out horizontally,
providing more power at a cheaper cost.

The downside is that client code needs to be asynchronous, but this is a common
technique for Javascript and we can provide libraries for other languages 
such as Perl.


{{< section_title  "Message Format" >}}

Messages both to, and from, the Server are in JSON encoded strings. For
example the following represents a client Login request.

```json
{
  "route"       : "/user/login",
  "msgId"       : "123",
  "clientCode"  : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content" : {
    "username"      : "james_bond",
    "password"      : "top5ecr3t"
  }
}
```
This message is from the Client to the Server.

### route

This is the address, or route, to the server code that will handle the 
request.

### msgId

This is a unique identifier (usually a number) that ties together the Client
request with the asynchronous reply by the Server. It can most easily be
implemented by an incrementing number in the client. For example, if there
are multiple requests to the same route the client can match the multiple
server responses by the **msgId**.

If the msgId is not supplied to the server it will not include a msgId in it's response.

If it is a server initiated message (for example a 'welcome' message) then
no **msgId** will be included.

### clientCode

A Client Code is used to identify a client to the server. A Client Code is initially 
provided by the server and once given it should continue to be used by that
particular client, even if you log out and back in again. This enables the 
server to retain your settings.

Each browser (Internet Explorer, Chrome, Safari etc.) should have it's own unique
Client Code. Different computers should have their own Client Code and any script
that you may write should have it's own Client Code. You should not share your 
code otherwise you may get data corruption.

A session is associated with a Client Code and it may 'time-out' (after a few 
hours) but even so, you should still keep the same Client Code for subsequent 
sessions.

In most of the following API calls the **clientCode** argument is mandatory.
If you do not supply the code the call will be rejected.

### content

This is the main body of the message which will vary depending upon the route
and will be described in detail for each API call. **route**, **msgId**
and **clientCode** will be assumed to be present unless stated otherwise.


{{< section_title  "Making a Connection" >}}

Here is an example connection to a Web Socket (in Perl)

```php
use AnyEvent::WebSocket::Client;
my $client = AnyEvent::WebSocket::Client->new;
my $connection;
$client->connect("ws://spacebotwar.com/ws")->cb(sub {
   ...
```

And an example in Javascript

{% highlight javascript %}
var ws = new WebSocket("ws://spacebotwar.com/ws");
ws.onopen = function() {
  alert("Connection is open")
}

{% endhighlight %}

On making a successful connection the server will send a Welcome message as follows.




{% include section_header.html method="SERVER" url="/welcome" title="Welcome" %}

When a client makes a Web Socket connection, the server will send a message indicating the
current status. It may also send an update whenever the server status changes.

{% highlight JSON %}
{
  "route"       : "/welcome",
  "status"      : 0,
  "message"     : "OK",
  "content" : {
    "alert"           : "Server will go off-line shortly",
    "offlineSeconds"  : "3060"
  }
}
{% endhighlight %}

### status

The status of the connection, where **0** represents success.

### message

A human readable message.

<h3>content</h3>

Optional additional information, TODO (example is indicative)

**Note** there will be no **msgId** since this is a Server initiated message.



{% include section_header.html method="SERVER" url="/{various}" title="Standard Server Response" %}

Although all responses from the Web Socket server are asynchronous, frequently enough
the server will respond with a simple acknowledgement that the last client request
was acted upon.

For example, a Login Request from the Client using the route **/login** will result in
the Server sending a message to the client with the same route (**/login**).

Rather than repeat the server response throughout the API documentation, it will be
described here and referred to as a **Standard Response**

{% highlight JSON %}
{
  "route"       : "/{some_route}",
  "msgId"       : "123",
  "status"      : 0,
  "message"     : "OK",
  "content"     : {
    "example"       : "Some value"
  }
}
{% endhighlight %}

### status

The status of the **server** where **0** represents success, any other value represents failure.

### message

A human readable message.

### msgId

Where provided in the Client request, the same **msgId** will be returned in the Server response.
If not provided, this field will not be supplied.


<h3>content</h3>

Optional additional information. This will be described in the relevant section of the API
documentation.


