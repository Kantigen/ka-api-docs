---
layout: article
title: Background Starmap Message Queue
---

{% include section_title.html title="Background Starmap Message Queue" %}

Whenever tasks associated with the starmap are required these can be put on the **bg_starmap**
message queue so they can be processed by a background handler.

{% include section_header.html title="Starmap Get Map Chunk" method="MESSAGE" url="/starmap/getMapChunk" %}

When a Client requests a chunk of the starmap from the Web Socket Server, and it is not cached, then
the Web Socket will generate a message requesting that a background process calculates it.

{% highlight JSON %}
{
  "route"           : "/starmap/getMapChunk",
  "user_id"         : 3,
  "content"         : {
    "sector"          : 0,
    "left"            : -50,
    "bottom"          : 250
  }
}
{% endhighlight %}

Processed by **KA::MessageQueue::Starmap->bg_getMapChunk**

A chunk is always 50 x 50 units in size.

The **sector** is the starmap sector (currently only sector 0 is defined)

The **left** is the x co-ordinate of the left of the 50 x 50 starmap churk, this must be on a 50 unit boundary.

The **bottom** is the y co-ordinate of the bottom of the 50 x 50 star map chunk, this must be on a 50 unit boundary.

the **user_id** identifies the requesting User. When the Starmap chunk has been generated and put in
the cache a message is published to all Web Socket Servers which will send the chunk on to any client
connection made by that user.



