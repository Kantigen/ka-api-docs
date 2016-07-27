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
    "empirename"      : "earthling",
    "email"           : "jb@mi5.gov.co.uk"
  }
}
{% endhighlight %}

### username
This must be a unique name, not currently used by any other account.

### email
This must be a valid email address which is not registered against any other empire
name.

The server will send the user an email with a one-time registration code allowing the
user to proceed to the initial login.



{% include section_header.html title="User Registration" method="SERVER" url="/user/register" %}

This will be a **Standard Response** with the following data.

{% highlight JSON %}
{
  "route"           : "/user/register",
  "msgId"           : 123,
  "status"          : 0,
  "message"         : "OK",
  "content"         : {
    "username"        : "james_bond",
    "registrationStage" : "loginWithEmailCode"
  }
}
{% endhighlight %}

### username

The username requested in the Client request will be returned.

### registrationStage

This shows the next registration stage, e.g. 'loginWithEmailCode' indicates that 
the user needs to validate their email address by entering the Email 
Validation Code



{% include section_header.html title="Login with Email Code" method="CLIENT" url="/user/loginWithEmailCode" %}

The email sent to the user as the first stage of User Registration can be used to
confirm the users email address and complete the second stage of registration.

{% highlight JSON %}
{
  "route"           : "/user/loginWithEmailCode",
  "msgId"           : 123,
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content"         : {
    "emailCode"       : "4e288cea-1389-2d88-3721-3e4fa998cff0"
  }
}
{% endhighlight %}


### emailCode

The **emailCode** provided in the email sent to the user needs to be supplied.


The server will respond (asynchronously) with the following message.



{% include section_header.html title="Login with Email Code" method="SERVER" url="/user/loginWithEmailCode" %}

In response to the Client User Registration call, the server will send an acknowledgement
of the registration.

{% highlight JSON %}
{
  "route"           : "/user/loginWithEmailCode",
  "msgId"           : 123,
  "status"          : 0,
  "message"         : "OK",
  "content"         : {
    "registrationStage"      : "enterNewPassword"
  }
}
{% endhighlight %}

### registrationStage

This specifies the next stage of the registration process, the user is required
to enter a new password.



{% include section_header.html title="Enter New Password" method="CLIENT" url="/user/enterNewPassword" %}

In **registrationStage** 'enterNewPassword' the user needs to specify a password before
they can access their account.

{% highlight JSON %}
{
  "route"           : "/user/enterNewPassword",
  "msgId"           : 123,
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content"         : {
    "password"        : "top5ecr3t"
  }
}
{% endhighlight %}

### password

The **password** needs to be at least five characters, include upper-case and
lower-case characters and numeric characters.

The server will respond (asynchronously) with the following message.



{% include section_header.html title="Enter New Password " method="SERVER" url="/user/enterNewPassword" %}

In response to the Enter New Password call, the server will send an acknowledgement.

{% highlight JSON %}
{
  "route"           : "/user/enterNewPassword",
  "msgId"           : 123,
  "status"          : 0,
  "message"         : "OK",
  "content"         : {
    "registrationStage" : "foundEmpire"
  }
}
{% endhighlight %}

### registrationStage

This shows that the user has completed registration but they now need to found (create)
their empire. Until that time they can still use the chat system.



{% include section_header.html title="Login with Password" method="CLIENT" url="/user/loginWithPassword" %}

Normal login is by specifying a username and password.

{% highlight JSON %}
{
  "route"           : "/user/loginWithPassword",
  "msgId"           : 123,
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content"         : {
    "username"        : "james_bond",
    "password"        : "top5ecr3t"
  }
}
{% endhighlight %}


### username
The username to log in by.

### password
The password.

The server will respond (asynchronously) with the following message.



{% include section_header.html title="Login with Password" method="SERVER" url="/user/loginWithPassword" %}

In response to the Client Login with Password call, the server will send an acknowledgement.

{% highlight JSON %}
{
  "route"           : "/user/loginWithPassword",
  "msgId"           : 123,
  "status"          : 0,
  "message"         : "OK",
}
{% endhighlight %}

