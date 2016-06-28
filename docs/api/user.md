---
layout: article
title: User API
---

{% include section_title.html title="User API" %}

The User Server provides the API to manage user registration, login, logout
and user configuration.

All routes are prefixed with **/user/**

{% include section_header.html title="Client Code" method="CLIENT" url="/user/clientCode" %}

The client either requests a new client-code, or asks for an existing code to
be validated.

{% highlight JSON %}
{  
  "route"           : "/user/clientCode",
  "msgId"           : 123,
  "clientCode"      : "1b4e28ba-2fa1-11d2-883f-0016d3cca427"
}
{% endhighlight %}

The **msgId** and **clientCode** are as described in the Message Format section.

If the client already has a **clientCode** then it should be provided, in which case
it will be validated by the server. If there is no existing **clientCode** then it
can be left blank.



{% include section_header.html title="Client Code" method="SERVER" url="/user/clientCode" %}

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

{% include section_header.html title="User Registration" method="CLIENT" url="/user/register" %}

This is the first stage of registration where a username and email address are specified.

{% highlight JSON %}
{
  "route"           : "/user/register",
  "msgId"           : 123,
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

