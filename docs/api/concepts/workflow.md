---
layout: article
title: Workflow
---


{% include section_title.html title="Workflow" %}

Developers wanting to contribute to Keno Angigen need to understand the
routes that various messages flow through the system, be these websocket
calls or message queues. A few examples should help to make it clearer.


{% include section_title.html title="User Registration Process" %}

In this example, the web client initiates a web-socket request. The 
server carries out some (fast) validation and processing in the
request but a time-expensive operation (sending an email) is passed
down to a background process to be carried out at leasure.

A user registers to play Keno Antigen via the web client sending a 
[CLIENT User Registration](/api/user.html) web-socket message.

{% highlight JSON %}
{
  "route"           : "/user/register",
  "msgId"           : 123,
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content"         : {
    "username"        : "james_bond",
    "email"           : "jb@mi5.gov.co.uk"
  }
}
{% endhighlight %}

The **route** can be used to determine the method which processes this
request. In this case (since it is a web-socket message)
it will be processed by the class KA::WebSocket::User and the method
called will be **ws_register**. The code can be seen 
[here](https://github.com/Kantigen/ka-server/blob/master/lib/KA/WebSocket/User.pm#L104).

The principle for all web-socket calls should be to do the minimum
necessary processing and just return quickly.

The bare minimum in this case is to validate the request and to create
a new entry in the database User table for the new account. If any of
the checks fail (for example if the username is already taken) then the
code will throw an appropriate error, this will be returned to the
client as a SERVER web-socket message.

Assuming it succeeds, and the user account has been created, then
an email needs to be sent to the user. This is too much to do in the
web-socket call so a message is published on the **bg_email** message
queue.

{% highlight JSON %}
{
  "route"           : "/email/registrationCode",
  "content"         : {
    "username"        : "james_bond",
    "email"           : "jb@mi5.gov.co.uk"
  }
}
{% endhighlight %}

The **route** in this case relates to a background message queue worker
processed by **KA::MessageQueue::Email** method **bg_registrationCode**.
The code for which can be seen at TDB.


{% include section_title.html title="Building Upgrade Completed" %}

In this example, a timed event (completion of a building, arrival of
a ship) is scheduled. On completion, the event should be notified to
any web-socket client that is affected by the event.

Taking the example of a building completing an upgrade, the event
will not happen immediately so it needs to be scheduled.

<img src="/images/workflow1.png" alt="Workflow" style="width: 600px;"/>

The module **KA::DB::Result::Schedule** will create a database entry
for this event and in addition it will put an entry onto a beanstalk
queue which is timed to be taken off the queue at the appropriate time.

The use of a database table **and** a queue is just belt-and-braces
in case the events are lost from the beanstalk queue they can be
recreated from the Schedule database tables.

So, back to the example, the entry put onto the **bg_building** queue
is very simple.

{% highlight JSON %}
{
  "route"           : "/building/finishUpgrade",
  "content"         : {
    "building_id"     : 1234
  }
}
{% endhighlight %}

The scheduler ensures that this message is given a timer such that
it expires at the moment when the upgrade is due to be completed.

This is processed by the **bg_building worker** 
[**KA::MessageQueue::Building->bg_finishUpgrade** method](https://github.com/Kantigen/ka-server/blob/master/lib/KA/MessageQueue/Building.pm#L28)
which delegates the actual upgrade to [**KA::DB::Result::Building->finish_upgrade** method](https://github.com/Kantigen/ka-server/blob/master/lib/KA/DB/Result/Building.pm#L992)

Within **finish_upgrade** (TBD) a message is put onto the **ps_building** 
[publish-subscribe queue](/api/mq/ps_intro.html)
so that any web-socket client connected to the server can be informed. This cannot be a simple
message queue with one worker for several reasons.

We may be running more than one web-socket server (for scalability) so each one
needs to know about building upgrades to pass this information on to all
appropriate clients.

Other code may be interested, for example code which maintains the planet stats
(it is not done this way currently, but there are advantages in this approach)

For these reasons we publish to a pub-sub queue and each web-socket or other
modules will subscribe to the queue.

{% highlight JSON %}
{
  "route"           : "/building/upgraded",
  "content"         : {
    "building_id"     : 1234,
    "body_id"         : 456,
    "empire_id"       : 78
  }
}
{% endhighlight %}

Each subscriber will receive a message, for example, the web-socket code at
[**KA::WebSocket::Building->mq_upgraded](https://github.com/Kantigen/ka-server/blob/master/lib/KA/WebSocket/Building.pm#L35)
will simply pass this message on to all connected web-sockets for that empire_id as
described at [SERVER /building/upgraded](/api/building.html)

If any individual web-socket server has more than one client connection
for this empire then the same message will be passed on to each of them.



