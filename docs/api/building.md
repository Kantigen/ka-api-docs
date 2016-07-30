---
layout: article
title: Building API
---

{% include section_title.html title="Building API" %}

The Building routes provide methods to manage and receive notifications about any
building owned by the user.

All routes are prefixed with **/building/**

{% include section_header.html title="Building Upgraded" method="SERVER" url="/building/upgraded" %}

Whenever a building, anywhere in the users empire, completes an upgrade then a notification
is sent from the server to the client.

{% highlight JSON %}
{
  "route"           : "/building/upgraded",
  "status"          : 0,
  "message"         : "OK",
  "content"         : {
    "building_id"     : "6443",
    "body_id"         : "7546",
    "empire_id"       : "3"
  }
}
{% endhighlight %}

This is the minimum data to indicate which building/body is affected by the upgrade
it is up to the client to decide if they want to request further information. (See TBD)

