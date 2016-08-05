---
layout: article
title: Publish/Subscribe Queues
---

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

Any update which needs to be communicated asynchronously to a user has the following 
problem.

There may be one or more web-socket connections made by the same user (for example
in different browsers) all of which need to be informed of events related to their
account, e.g. chat messages or updates to their planets.

To achieve this, a background task responsible for sending these messages can
publish them to a pub/sub queue and each Web Socket can subscribe to it. The same
message will then go to each Web Socket connection which can then forward it to
any open connections to that user.

