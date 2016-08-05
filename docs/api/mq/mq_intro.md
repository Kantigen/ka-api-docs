---
layout: article
title: Message Queues
---

{% include section_title.html title="Message Queues" %}

Keno Antigen makes use of Message Queues for several purposes.

  * To farm off slow or expensive computation to background processes
  * To communicate changes to the front end Web Socket servers which can be passed on to clients.
  * To provide a publish/subscribe mechanism.

Message Queues in Keno Antigen are implemented as Beanstalk Queues.

  [Beanstalk Protocol](https://github.com/kr/beanstalkd/blob/master/doc/protocol.txt)

Each Message Queue (or **pipe** in beanstalk nomenclature) is  given a unique name,
for example **bg_building** is the background (bg) queue responsible for completion of building
upgrades and building work.

For each pipe there can be one or more producers (that put messages onto the pipe) and
there should be at least one worker (to take messages off the pipe). It is not possible for
a single message to be received by more than one worker (but see the comments below about
Publish/Subscribe) and multiple copies of the worker may be spawned if there is more work than
one server is able to deal with.

Beanstalk does not make any requirements on the content of a message, so long as it is
a string, so a simple JSON encoded structure is implemented in the application.

Generally, messages are processed in the order that they are put onto the queue, however
this can be modified in a couple of ways.

* The priority of the message can be changed, the lower the number, the higher the priority.
higher priority messages are taken off the queue first.
* A delay can be put on the message, the message will not be taken off the queue until
the time has elapsed.

Although message priority is not heavily used in KA the Delay is very useful for 
scheduled events such as building upgrade completion or ship arrival.


{% include section_title.html title="Background Tasks" %}

A background process, or **worker** can run as a daemon process, waiting for messages on
one or more message queues. When a message is taken off the queue it can be processed by
the daemon which will then be ready to process the next message.

Multiple instances of the worker can be created on multiple servers to handle the 
expected workload. Some workers can be configured to read specific pipes and specialize
in certain types of message. There may be good reason to dedicate certain workers to
certain message types, e.g. building upgrades.

In a development environment it is usual to only have one worker that handles all tasks.


{% include section_title.html title="Web Socket server" %}

The Web Socket Server is able to listen asynchronously for both new web-socket requests
from clients, and simultaniously for new messages on a Message Queue.

In this way, if an event happens on the server (for example a building completes 
construction or a ship arrives at a planet) then this can be communicated to the Web
Socket Server which can then pass the information onto the appropriate Clients.


{% include section_title.html title="Publish Subscribe" %}

Beanstalk Queues are point-to-point, that is there is one source and one target and
as such it is not possible to broadcast to multiple targets. However by having 
multiple pipes it is possible to have a fanout exchange which will receive messages
on one pipe and send the received message to multiple output pipes. This is how
we have implemented a Publish/Subscribe system in KA.

An example of such a process is that when a building completes construction, the
back-end code can publish a message identifying the building, the planet, and the 
empire affected by the change. Each of the Web Socket servers (or indeed any other 
process) can subscribe to this message queue. Web Sockets can then pass this information
on to the appropriate client. Other processes may use the same message to (for example)
recalculate the new statistics of the planet.

If no-one is subscribed to a particular channel, then the messages are just deleted.


{% include section_title.html title="Typical Use Case" %}

The request for a chunk of the starmap is a typical example.

The client makes a Web-Socket request to the server for one or more chunks of the
starmap data. This request is received by the Server and basic validation is 
carried out.

A request for a chunk of the starmap is computationally expensive, it requires joins
on several tables in the database so we don't want to do this in the Web-Socket
handler since it will degrade performance.

For this reason, we can cache the starmap data since it will only change relatively
infrequently and immediately return the data if it can be found in the cache.

However, let us assume that there is a cache-miss and the data is not immediately available.

In this case the Web-Socket will put a message on the **bg_starmap** message queue
with details of the request and the requesting empire ID and then continue
processing other Web-Socket requests.

The background process which is listening on this queue takes it off the
queue and processes it, carrying out the database query, creating the data and
putting the data onto the cache. It can then send a message on the **fg_websocket**
message queue telling the Web Socket code that the data has been updated. The Web
Socket code now takes the data out of the freshly updated cache and sends in on to
the requesting client.

In this way a cache hit results in a very fast response to the client. Where there
is a cache miss, the computation is carried out by one or more background processes
which again do not affect performance (since they can even be on different servers).


{% include section_title.html title="Message Format" %}

A general message format is defined thus.

{% highlight JSON %}
{
  "route"           : "/building/upgraded",
  "content"         : {
    "building_id"     : 6550,
  }
}
{% endhighlight %}

The **route** allows the routing of different messages on a message queue to
a specific handler. For example route **/building/finishUpgrade** could route the
message to **KA::MessageQueue::Building** method **bg_finishUpgrade**

the **content** is message specific, in this case it contains the primary key
to the building being upgraded.

This particular message would be received by the background daemon responsible
for completing building upgrades at the time when they are scheduled to complete.


{% include section_title.html title="Message Queues and Pub/Sub Channels" %}

This is a list of the various message queues and the Pub/Sub Channels currently
implemented in KA.

* **bg_building** - Background process to manage building upgrades and work
* **bg_fleet** - Background process to manage fleet arrival and build completion
* **bg_captcha** - Background process to generate a new captcha
* **bg_starmap** - Background process to generate a starmap chunk
* **bg_pubsub** - Background process to manage publish and subscription requests

* **fg_websocket** - Web Socket process to receive background messages (Deprecated)

* **ps_building** - Pub/Sub channel for notifications of building upgrades and work completion


