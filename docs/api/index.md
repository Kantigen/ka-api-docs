---
layout: article
title: API Documents

---

Start
=====

{% include section_header.html method="SERVER" url="/foo" title="Do It" %}

All methods in this section can be carried out by a connection to the **/ws/start** server.

Each method appends to the route **/** e.g. 'login' method would be on route **/login**

The Start Server should be the first place you connect to on the game server. It will give you
the names of other servers which are currently active in the game. It also has the
functionality to allow you to log into your account.

