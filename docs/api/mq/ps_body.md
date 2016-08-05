---
layout: article
title: Body Pub/Sub
---

{% include section_title.html title="Body Pub/Sub" %}

The Body Publish/Subscribe queue **ps_body** is used to publish events related to a body,
for example, that the body stats have been recalculated.

Processes that wish to be informed about these events can subscribe to the channel,
for example the Web Socket connection can pass this information on to any client connection
that owns the body so that they can take appropriate action.



{% include section_header.html title="Pub/Sub Body Recalculated" method="MESSAGE" url="/body/recalculated" %}

This would be published by the module **KA::DB::Result::Map::Body::Planet->recalc_stats** whenever a
significant event has happened (building upgraded, ship arrived etc.)


{% highlight JSON %}
{
  "route"       : "/body/recalculated",
  "user_id"     : 3,
  "content"     : {
    "body_id"       : 6543,
    "empire_id"     : 3
  }
}
{% endhighlight %}

Processed by **KA::WebSocket::Body->mq_recalculated**

**user_id** is the primary key for the logged in user. This will be used by the Web Socket to
direct the message to any client connection of the owner of the body (if connected).

**body_id** is the primary key for the affected body.

**empire_id** is usually the same as the **user_id**




