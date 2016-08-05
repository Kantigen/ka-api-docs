---
layout: article
title: Captcha Message Queue
---

{% include section_title.html title="Background Captcha Message Queue" %}

The background messaging queue **bg_captcha** is used to send messages to
a background process to create new captcha images.


{% include section_header.html title="Captcha Generate" method="MESSAGE" url="/captcha/generate" %}

Whenever the latest captcha is used a job is put onto the **bg_captcha** queue to indicate that a 
new captcha image needs to be prepared.

{% highlight JSON %}
{
  "route"           : "/captcha/generate",
  "content"         : {
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Captcha->bg_generate**

There is no content required, the message itself is sufficient to generate a new captcha.



