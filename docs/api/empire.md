---
layout: article
title: Empire API
---

{% include section_title.html title="Empire API" %}

The Empire routes provide methods to create and update a users Empire.

All routes are prefixed with **/empire/**

{% include section_header.html title="Found Empire" method="CLIENT" url="/empire/found" %}

Once a User has registered and logged in they may found their Empire.


{% highlight JSON %}
{
  "route"           : "/empire/found",
  "msgId"           : 123,
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content"         : {
  }
}
{% endhighlight %}

There is no **content** currently for this API, the empire will be created, a home planet
will be chosen and the empire affinities will be set to 'Average'. We may change this in
the future.

{% include section_header.html title="Found Empire" method="SERVER" url="/empire/found" %}

This will be a **Standard Response** with the following data.

{% highlight JSON %}
{
  "route"           : "/empire/found",
  "msgId"           : 123,
  "status"          : 0,
  "message"         : "OK",
  "content"         : {
    "registrationStage" : "empireCreated"
  }
}
{% endhighlight %}

### registrationStage

This shows the next registration stage, e.g. 'empireCreated' indicates that 
the user has completed the registration process and created their empire.


