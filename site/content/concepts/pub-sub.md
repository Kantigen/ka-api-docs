---
layout: article
title: Publish Subscribe
---

{% include section_title.html title="The Problem" %}

Lacuna Expanse had a fundamental problem, any updates that happened on the
server (for example buildings being completed, ships arriving) did not appear
on the browser client until another action was made, e.g. clicking on a link.

This was the nature of the AJAX calls, the server had no way to communicate
changes to the client until the client made another request.

Another issue is that some changes (for example attacks against fellow alliance
members) might be relevent to multiple players so each one would need to 
request, or receive updates, independently.


{% include section_title.html title="Publish/Subscribe" %}

The Publish/Subscribe model works like this. The sender does not program messages
to be sent to specific receivers, called subscribers, but instead messages are
published without knowledge of which subscribers, if any, there may be.

Similarly subscribers express interest in one or more types of message without
knowledge if which publishers, if any, there are.

This provides greater scalability and removes close binding between client and
server.

For example, a Publisher might create a queue for a topic 'ship-arrival' so
that each time a ship arrives a short message is created to say which planet
it was sent from, where it was received, and a few more details such as payload
and attack status, sending and receiving empire id.

A subscriber would join the queue and filter the messages either for sending or
receiving empire id. Then whenever a ship arrived the subscriber would get an
instant update of the event.

The subscriber in this case might be the Web-Socket handler which knows the
empire ID of all connected clients. On receiving a relevent message on the queue
the Web-Socket handler would send it directly to the appropriate client(s).

Since we are already using Redis, and Redis has a pub-sub option then this
looks like the way to go.

