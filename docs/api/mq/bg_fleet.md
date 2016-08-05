---
layout: article
title: Background Fleet Message Queue
---

{% include section_title.html title="Background Fleet Message Queue" %}

The background fleet message queue **bg_fleet** is used to send messages to a background
process to indicate tasks such as completing a fleet build or a fleet arrival.


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


