---
layout: article
title: Starmap API
---

{% include section_title.html title="Starmap API" %}

This route provides functions to display and manipulate the starmap.

All routes are prefixed with **/starmap/**

{% include section_header.html title="XXXXXXXX" method="CLIENT" url="/starmap/xxxxxxx" %}


{% highlight JSON %}
{  
  "route"           : "/starmap/clientCode",
  "msgId"           : 123,
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427"
}
{% endhighlight %}

The **msgId** and **clientCode** are as described in the Message Format section.

If the client already has a **clientCode** then it should be provided, in which case
it will be validated by the server. If there is no existing **clientCode** then it
can be left blank.



{% include section_header.html title="XXXXXX" method="SERVER" url="/user/XXXXXXXX" %}

This is the async response of the server to the client **/clientCode** message.

{% highlight JSON %}
{
  "route"           : "/user/clientCode",
  "msgId"           : 123,
  "status"          : 0,
  "message"         : "OK",
  "content"         : {
    "clientCode"        : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
    "registrationStage" : "loginWithPassword"
  }
}
{% endhighlight %}

### clientCode

If the clientCode was supplied by the client, and was valid, it will be returned. If it
was not valid a new one will be provided.

### registrationStage

If the clientCode provided matches a user, then the appropriate registration stage will
be returned for that user. If it is a new clientCode then it will not be able to match
against an existing user so it will return 'register' although logging in with a
username/password is also valid if one is known.

