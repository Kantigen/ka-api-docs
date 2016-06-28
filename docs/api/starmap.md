---
layout: article
title: Starmap API
---

{% include section_title.html title="Starmap API" %}

This route provides functions to display and manipulate the starmap.

All routes are prefixed with **/starmap/**

{% include section_header.html title="Get Star Map" method="CLIENT" url="/starmap/get_map_chunk" %}


{% highlight JSON %}
{  
  "route"           : "/starmap/get_map_chunk",
  "msgId"           : 123,
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content"         : {
    "left"            : -50,
    "bottom"          : 250
  }
}
{% endhighlight %}

The starmap is requested in chunks of 50 x 50 units square. The **left** and **bottom**
values must lie on the map co-ordinates modulus 50. The above call will request a
chunk of the starmap data from x co-ordinates -50 to -1 (inclusive) and y
co-ordinates 250 to 299 inclusive.


{% include section_header.html title="Get Star Map" method="SERVER" url="/starmap/get_map_chunk" %}

This is the async response of the server to the client **/starmap/get_map_chunk** request.


{% highlight JSON %}
{
  "route"           : "/starmap/get_map_chunk",
  "msgId"           : 123,
  "status"          : 0,
  "message"         : "OK",
  "content"         : {
    "stars" : {
      "99" : {
        "name"        : "Sol",
        "color"       : "yellow",
        "x"           : -41,
        "y"           : 27,
        "sector"      : 1,
        "alliance"    : 23,
        "influence"   : 55,
        "bodies" : {
          "332" : {
            "name"        : "Mercury",
            "orbit"       : 1,
            "type"        : "habitable planet",
            "image"       : "p34",
            "size"        : 58,
            "empire"      : 332,
            "has_fissure" : 1
          },
          "333" : {
          }
        }
      },
      "293" : {
      },
      "298" : {
      }
    },
    "alliances" : {
      "23" : {
        "name"          : "The Borg Collective",
        "image"         : "borg_logo"
      },
      "45" : {
        "name"          : "Stellar Traders",
        "image"         : "st_logo"
      }
    },
    "empires" : {
      "332" : {
        "name"          : "Invader",
        "alignment"     : "hostile",
        "isolationist"  : 0
      },
      "359" : {
      }
    }
  }
}
{% endhighlight %}

### stars

Each star in the chunk is shown in a section of JSON indexed by it's database ID.
Most attributes of a star are self-explanatory. **alliance** is the database ID
for the alliance if the star is seized. **influence** is the influence the 
alliance has over the star.

### bodies

If the requesting empire has a probe at that star then the bodies around that star will be
shown in the **bodies** section indexed by the database ID of the body. If not this will be omitted. 

If the body is occupied then the **empire** occupying the body shows the empire database ID.

### alliances

Every alliance referred to in the chunk is shown in this section. This avoids duplication
of data.

### empires

Every empire referred to in the chunk is shown in this section. This avoids duplication.




