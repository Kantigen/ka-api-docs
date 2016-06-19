---
layout: article
title: User API
---

{% include section_title.html title="User API" %}

The User Server provides the API to manage user registration, login, logout
and user configuration.



{% include section_header.html title="Client Code" method="CLIENT" url="/clientCode" %}

The client either requests a new client-code, or asks for an existing code to
be validated.

{% highlight JSON %}
{
  "route"           : "/clientCode",
  "msgId"           : "123",
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427"
}
{% endhighlight %}

The **msgId** and **clientCode** are as described in the Message Format section.

If the client already has a **clientCode** then it should be provided, in which case
it will be validated by the server. If there is no existing **clientCode** then it
can be left blank.



{% include section_header.html title="Client Code" method="SERVER" url="/clientCode" %}

This is the async response of the server to the client **/clientCode** message.

{% highlight JSON %}
{
  "route"           : "/clientCode",
  "msgId"           : "123",
  "code"            : "0",
  "message"         : "Success",
  "content"         : {
    "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427"
  }
}
{% endhighlight %}

The **clientCode** returned in the **content** will be the existing one (if
provided and valid) or a new one.



{% include section_header.html title="User Registration" method="CLIENT" url="/register" %}

This is the first stage of registration where a username and email address are specified.

{% highlight JSON %}
{
  "route"           : "/register",
  "msgId"           : "123",
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content"         : {
    "username"        : "james_bond",
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



{% include section_header.html title="User Registration" method="SERVER" url="/register" %}

This will be a **Standard Response** with the following data.

{% highlight JSON %}
{
  "route"           : "/register",
  "msgId"           : "123",
  "code"            : "0",
  "message"         : "Success",
  "data"            : {
    "username"        : "james_bond",
    "loginStage"      : "enterEmailCode"
  }
}
{% endhighlight %}

### username

The username requested in the Client request will be returned.

### loginStage

This shows the current registration stage, **enterEmailCode** indicates that 
the user needs to validate their email address by entering the Email 
Validation Code



{% include section_header.html title="Login with Email Code" method="CLIENT" url="/loginWithEmailCode" %}

The email sent to the user as the first stage of User Registration can be used to
confirm the users email address and complete the second stage of registration.

{% highlight JSON %}
{
  "route"           : "/loginWithEmailCode",
  "msgId"           : "123",
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427",
  "content"         : {
    "emailCode"       : "4e288cea-1389-2d88-3721-3e4fa998cff0"
  }
}
{% endhighlight %}


### emailCode

The **emailCode** provided in the email sent to the user needs to be supplied.


The server will respond (asynchronously) with the following message.



{% include section_header.html title="Login with Email Code" method="SERVER" url="/loginWithEmailCode" %}

In response to the Client User Registration call, the server will send an acknowledgement
of the registration.

{% highlight JSON %}
{
  "route"           : "/loginWithEmailCode",
  "msgId"           : "123",
  "code"            : "0",
  "message"         : "Success",
  "content"         : {
    "loginStage"      : "requireNewPassword"
  }
}
{% endhighlight %}

### loginStage

This specifies the next stage of the registration process, the user is required
to enter a new password.



{% include section_header.html title="Enter New Password" method="CLIENT" url="/enterNewPassword" %}

In **loginStage** 'requireNewPassword' the user needs to specify a password before
they can access their account.

{% highlight JSON %}
{
  "route"           : "/enterNewPassword",
  "msgId"           : "123",
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



{% include section_header.html title="Enter New Password " method="SERVER" url="/enterNewPassword" %}

In response to the Enter New Password call, the server will send an acknowledgement.

{% highlight JSON %}
{
  "route"           : "/enterNewPassword",
  "msgId"           : "123",
  "code"            : "0",
  "message"         : "Success",
  "content"         : {
    "loginStage"      : "loggedIn"
  }
}
{% endhighlight %}

### loginStage

This shows that the user is now logged into the system.



{% include section_header.html title="Login with Password" method="CLIENT" url="/loginWithPassword" %}

Normal login is by specifying a username and password.

{% highlight JSON %}
{
  "route"           : "/loginWithPassword",
  "msgId"           : "123",
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



{% include section_header.html title="Login with Password" method="SERVER" url="/loginWithPassword" %}

In response to the Client Login with Password call, the server will send an acknowledgement
of the registration.

{% highlight JSON %}
{
  "route"           : "/loginWithPassword",
  "msgId"           : "123",
  "code"            : "0",
  "message"         : "Success",
  "content"         : {
    "loginStage"      : "loggedIn"
  }
}
{% endhighlight %}

### loginStage

This shows that the user is now logged into the system.


