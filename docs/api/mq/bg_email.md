---
layout: article
title: Email Message Queue
---

{% include section_title.html title="Email Message Queue" %}

The background messaging queue **bg_email** is used to send messages to
a background process to send out emails.


{% include section_header.html title="Email Registration Code" method="MESSAGE" url="/email/registrationCode" %}

To complete the User Registration process, the user needs to receive an email with
a unique Validation URL to click on.

This is triggered by putting the following message onto the **bg_email** queue.

{% highlight JSON %}
{
  "route"           : "/email/registrationCode",
  "content"         : {
    "username"        : "james_bond",
    "email"           : "jb@mi5.gov.co.uk"
  }
}
{% endhighlight %}

This will be processed by the **KA::MessageQueue::Email->bg_registrationCode** method.

{% include section_header.html title="Email Forgotten Password" method="MESSAGE" url="/email/forgotPassword" %}

On a forgotten password, an email is sent to the users registered email address
which contains a unique URL to allow them to change their password.

This is triggered by putting the following message onto the **bg_email** queue.

{% highlight JSON %}
{
  "route"           : "/email/forgotPassword",
  "content"         : {
    "username"        : "james_bond",
    "email"           : "jb@mi5.gov.co.uk"
  }
}
{% endhighlight %}

This will be processed by the **KA::MessageQueue::Email->bg_forgotPassword** method.

