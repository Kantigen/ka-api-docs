---
layout: article
title: Planet API
---

{% include section_title.html title="Planet API" %}

The Planet routes provide methods to read and update a users Planet.

All routes are prefixed with **/planet/**


{% include section_header.html title="Body has been recalculated" method="CLIENT" url="/body/recalculated" %}

This is a notification message to tell a user that one of their planets has been recalculated.

Whenever a body owned by a user is recalculated, due to a building being completed, demolished, ship arrival etc.
this message is sent to all connections open by that user. If the user is interested in the actual
statistics they can make a request (TBD) to retrieve them.


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

