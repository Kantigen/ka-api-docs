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


{% include section_header.html title="Building Finish Upgrade" method="MESSAGE" url="/building/finishUpgrade" %}

To indicate that a building upgrade has reached the scheduled time. This would normally be put onto the 
**bg_building** queue when the user starts an upgrade with a delay equal to the build time. When the
scheduled time is reached a background process will take it off the queue and process it.

{% highlight JSON %}
{
  "route"           : "/building/finishUpgrade",
  "content"         : {
    "building_id"     : 6550,
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Building->bg_finishUpgrade**

The **building_id** is the primary key for the building that is scheduled to complete it's upgrade.


{% include section_header.html title="Building Finish Work" method="MESSAGE" url="/building/finishWork" %}

To indicate that a building has completed it's work. This would be put onto the **bg_building** queue
when the work starts. When the scheduled time is reached a background process will take it off the
queue and process it.

{% highlight JSON %}
{
  "route"           : "/building/finishUpgrade",
  "content"         : {
    "building_id"     : 6550,
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Building->bg_finishWork**

The **building_id** is the primary key for the building that is scheduled to complete it's work.


{% include section_header.html title="Captcha Generate" method="MESSAGE" url="/captcha/generate" %}

Whenever the latest captcha is used a job is put onto the **bg_captcha** queue to indicate that a 
new one needs to be prepared.

{% highlight JSON %}
{
  "route"           : "/captcha/generate",
  "content"         : {
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Captcha->bg_generate**

There is no content required, the message itself is sufficient to generate a new captcha.


{% include section_header.html title="Fleet Arrives" method="MESSAGE" url="/fleet/arrives" %}

After a delay (to correspond with the flight time of a fleet) the job will be taken off the
**bg_fleet** queue.

{% highlight JSON %}
{
  "route"           : "/fleet/arrive",
  "content"         : {
    "fleet_id"        : 1234
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Fleet->bg_arrives**

The **fleet_id** is the primary key for the fleet.


{% include section_header.html title="Fleet Finish Construction" method="MESSAGE" url="/fleet/finishConstruction" %}

After a delay (to correspond with the build time of a fleet) the job will be taken off the
**bg_fleet** queue.

{% highlight JSON %}
{
  "route"           : "/fleet/finishConstruction",
  "content"         : {
    "fleet_id"        : 1234
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Fleet->bg_finishConstruction**

The **fleet_id** is the primary key for the fleet.


{% include section_header.html title="Starmap Get Map Chunk" method="MESSAGE" url="/starmap/getMapChunk" %}

When a Client requests a chunk of the starmap from the Web Socket Server, and it is not cached, then
the Web Socket will generate a message requesting that a background process calculates it.

{% highlight JSON %}
{
  "route"           : "/starmap/getMapChunk",
  "user_id"         : 3,
  "content"         : {
    "sector"          : 0,
    "left"            : -50,
    "bottom"          : 250
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Starmap->bg_getMapChunk**

A chunk is always 50 x 50 units in size.

The **sector** is the starmap sector (currently only sector 0 is defined)

The **left** is the x co-ordinate of the left of the 50 x 50 starmap churk, this must be on a 50 unit boundary.

The **bottom** is the y co-ordinate of the bottom of the 50 x 50 star map chunk, this must be on a 50 unit boundary.

the **user_id** identifies the requesting User. When the Starmap chunk has been generated and put in
the cache a message is published to all Web Socket Servers which will send the chunk on to any client
connection made by that user.



{% include section_header.html title="Pub/Sub Publish a message" method="MESSAGE" url="/pubsub/publish" %}

To publish a message that can be consumed by several other processes a **PubSub** module has been created
**KA::PubSub** with three methods **publish**, **subscribe** and **unsubscribe**

These methods communicate with a Pub Sub Fan Exchange to create and destroy Message Queue Pipes as 
needed by the consumers.

The **publish** method creates a message.

{% highlight JSON %}
{
  "route"       : "/pubsub/publish",
  "content"     : {
    "channel"     : "ps_building",
    "message"       : {
      "route"         : "/building/upgraded",
      "user_id"       : 123,
      "content"         : {
        "body_id"         : 5544,
        "empire_id"       : 3,
        "building_id"     : 6545
      }    
    }
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Pubsub->bg_publish**

This looks a little more complicated because one queue message is within the 'envelope' of
another message. However it can be broken down thus.

**route** (the outer one) is the route to the background process that handles Pub/Sub publishing
at **/pubsub/publish**

**content** (the outer one) is the envelope of the message.

within which, **channel** is the pub-sub channel to publish to ('ps_building') and the **message**
to publish to that channel.

The contents of the **message** will vary according to the data being published, but this one
shows a pub-sub message indicating that a building has just been upgraded.


{% include section_header.html title="Subscribe to a Pub/Sub Channel" method="MESSAGE" url="/pubsub/subscribe" %}

Any process that wants to subscribe to a Pub Sub channel first sends a message to the Pub Sub Fan Exchange.

{% highlight JSON %}
{
  "route"       : "/pubsub/subscribe",
  "content"     : {
    "pipe"        : "ps_building_1"
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Pubsub->bg_subscribe**

The **pipe** is the name of the fan-out message queue and since each fan-out requires a
separate message queue it is given a unique name by appending a number **ps_building_1**.

The creation of the number is managed by the method **KA::PubSub->subscribe** so you
would not create this manually. 

Thereafter any messages published to channel **ps_building** will be fanned out to
**ps_building_1**, **ps_building_2** etc.


{% include section_header.html title="Unsubscribe from a Pub/Sub Channel" method="MESSAGE" url="/pubsub/unsubscribe" %}

To stop subscribing to a channel send a message to the Pub Sub Fan Exchange.

{% highlight JSON %}
{
  "route"       : "/pubsub/unsubscribe",
  "content"     : {
    "pipe"        : "ps_building_1"
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Pubsub->bg_unsubscribe**

This will tell the Pub Sub Fan Exchange to stop publishing to that pipe and the process
should stop listening to that pipe.


{% include section_header.html title="Pub/Sub Building Upgraded" method="MESSAGE" url="/building/upgraded" %}

This would be published by the background process,  **KA::MessageQueue::Building->bg_finishUpgrade** when
a building has completed an upgrade.

It would be consumed by each of the Web Socket processes.

{% highlight JSON %}
{
  "route"       : "/building/upgraded",
  "user_id"     : 3,
  "content"     : {
    "building_id"   : 4573,
    "body_id"       : 6543,
    "empire_id"     : 3
  }
}
{% endhighlight %}

Processed by **KA::WebSocket::Building->mq_upgraded**

**user_id** is the primary key for the logged in user. This will be used by the Web Socket to
direct the message to any client connection of the owner of the building (if connected).

**building_id** and **body_id** are the primary keys for the building and body respectively.

**empire_id** is usually the same as the **user_id**






