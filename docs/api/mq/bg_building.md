---
layout: article
title: Background Building Queue
---

{% include section_title.html title="Background Building Message Queue" %}

The background building message queue **bg_building** is used to send messages
to a background process to initiate tasks associated with building construction
and work.


{% include section_header.html title="Building Finish Upgrade" method="MESSAGE" url="/building/finishUpgrade" %}

To indicate that a building upgrade has reached the scheduled time. This would normally be put onto the 
**bg_building** queue when the user starts an upgrade with a delay equal to the build time. When the
scheduled time is reached a background process will take it off the queue and process it.

{% highlight JSON %}
{
  "route"           : "/building/finishUpgrade",
  "content"         : {
    "building_id"     : 6550
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
    "building_id"     : 6550
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Building->bg_finishWork**

The **building_id** is the primary key for the building that is scheduled to complete it's work.

