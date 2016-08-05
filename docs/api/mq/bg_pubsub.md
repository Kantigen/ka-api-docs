---
layout: article
title: Publish Subscribe Message Queue
---

The background Publish Subscribe Message Queue **bg_pubsub** is used to communicate
to the fanout exchange which controls the publishing and subscribing to pub-sub channels.


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


