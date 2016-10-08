---
layout: article
title: Planet API
---

{% include section_title.html title="Planet API" %}

The Planet routes provide methods to read and update a users Planet.

All routes are prefixed with **/body/**


{% include section_header.html title="Body has been recalculated" method="CLIENT" url="/body/recalculated" %}

This is a notification message to tell a user that one of their bodies has been recalculated.

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


{% include section_header.html title="Body has new incoming ships" method="CLIENT" url="/body/now_incoming_ships" %}

This is a notification message to tell a user that there are more incoming ships to one of their planets.

It is assumed that the user will have requested a list of all incoming ships when they
logged in or connected to one of their planets, so this call will only inform them of
new ships which have just been sent there.


{% highlight JSON %}
{ 
  "route"       : "/body/new_incoming_ships",
  "user_id"     : 3,
  "content"     : {
    "body_id"       : 6543,
    "empire_id"     : 3,
    "fleet_id"       : 3325,
    "allegiance"     : "own"
  }
}
{% endhighlight %}

**body_id** defines the body which the ships are targetted against, **empire_id** is the ID of the
empire that owns the planet (this will usually be the same as **user_id**.

**fleet_id** is the identifier of the new fleet which has been sent against the planet.

**allegiance** identifies the origin. This can be one of
  
  * **own** - one of your own ships
  * **ally** - from one of the empires in your own alliance.
  * **other** - anyone else, it may be trade, it may be an attack.
 


{% include section_header.html title="Fleet has just arrived at own planet" method="CLIENT" url="/body/fleet_arrival" %}

When a fleet arrives at one of a users own planets then they will be notified
by receiving the following message.


{% highlight JSON %}
{ 
  "route"       : "/body/fleet_arrival",
  "user_id"     : 3,
  "content"     : {
    "body_id"       : 6543,
    "empire_id"     : 3,
    "fleet_id"       : 3325,
    "allegiance"     : "own"
  }
}
{% endhighlight %}

**body_id** defines the body that has received the fleet, **empire_id** is the ID of the
empire that owns the planet (this will usually be the same as **user_id**.

**fleet_id** is the identifier of the new fleet which has been sent against the planet.

**allegiance** identifies the origin. This can be one of
  
  * **own** - one of your own ships
  * **ally** - from one of the empires in your own alliance.
  * **other** - anyone else, it may be trade, it may be an attack.
 



