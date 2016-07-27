---
layout: article
title: Message Queues
---

{% include section_title.html title="Message Queues" %}

Keno Antigen makes use of Message Queues for several purposes.

  * To farm off slow or expensive computation to background processes
  * To communicate changes to the front end Web Socket servers which can be passed on to clients.

Message Queues in Keno Antigen are implemented as Beanstalk Queues.

  https://github.com/kr/beanstalkd/blob/master/doc/protocol.txt

Each Message Queue (or **pipe** in beanstalk nomenclature) is  given a unique name,
for example **bg_building** is the background (bg) queue responsible for completion of building
upgrades and building work. **fg_websocket** is a foreground (fg) message queue which is
received by the WebSocket server and those messages may in turn be sent to connected clients.

Each message includes header information which allows it to be routed to an appropriate
handler with content that is specific to a task, for example the building_id of a building
to be upgraded.

When a message is put onto a queue, it can be put on to be processed either immediately, or 
at a later time. This can be useful to, for example, schedule a building upgrade to be 
completed at a specific time. The message will not be taken off the queue until the specified time.

{% include section_title.html title="Background Tasks" %}

A background application **bg_worker.pl** can run as a daemon process, waiting for
messages on one or more message queues. When a message is received it is routed to
an appropriate handler subroutine in the **KA::MessageQueue::** namespace. For example
the **KA::MessageQueue::Building** module will handle any background tasks for buildings
such as finishing building upgrades.

There can be many background queues, e.g. **bg_fleet** (process ship builds, ship arrivals)
and **bg_captcha** (create a new captcha image) but each will be processed by the generic
**bg_worker.pl** script. Each instance of the script can be configured to listen
for only certain queues and multiple instances can be configured to listen to the same
queue. In this way the tasks can be partitioned and additional servers/workers can be
instantiated to cope with increased load. In a development environment usually one worker
will suffice to listen to all queues.

{% include section_title.html title="Foreground tasks" %}

Foreground tasks are intended to communicate information from the backend (perhaps the
result of an expensive computation) to the frontend and onto one or more clients.

The receiver in this case is the WebSocket server, it listens asynchronously for both
new web-socket requests from clients, and for new messages on the **fg_websocket** 
message queue.

Messages on the queue will generally hold information about the client/user that the
message is intended for so that the web-socket code can then pass on the information
to the client(s) associated with that user ID.

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

However, let us assume that there is a miss and the data can't be found in the cache.

In this case the Web-Socket will put a message on the **bg_starmap** message queue
with details of the request and the requesting empire ID and then continue
processing other Web-Socket requests.

The background process which is listening on this queue immediately takes it off the
queue and processes it, carrying out the database query, creating the data and
putting the data onto the cache. It can then send a message on the **fg_websocket**
message queue telling the Web Socket code that the data has been updated. The Web
Socket code now takes the data out of the freshly updated cache and sends in on to
the requesting client.

In this way a cache hit results in a very fast response to the client. Where there
is a cache miss, the computation is carried out by one or more background processes
which again do not affect performance (since they can even be on different servers).






