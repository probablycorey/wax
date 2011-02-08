Wax is a framework that lets you write native iPhone apps in 
[Lua](http://www.lua.org/about.html). It bridges Objective-C and Lua using the 
Objective-C runtime. With Wax, **anything** you can do in Objective-C is **automatically**
available in Lua! What are you waiting for, give it a shot!

Why write iPhone apps in Lua?
---------------------------------------

I love writing iPhone apps, but would rather write them in a dynamic language than in Objective-C. Here 
are some reasons why many people prefer Lua + Wax over Objective-C...

* Automatic Garbage Collection! Gone are the days of alloc, retain, and release.

* Less Code! No more header files, no more static types, array and dictionary literals! 
  Lua enables you to get more power out of less lines of code.

* Access to every Cocoa, UITouch, Foundation, etc.. framework, if it's written in Objective-C, 
  Wax exposes it to Lua automatically. All the frameworks you love are all available to you!

* Super easy HTTP requests. Interacting with a REST webservice has never been eaiser

* Lua has closures, also known as blocks! Anyone who has used these before knows how powerful they can be.

* Lua has a build in Regex-like pattern matching library.

Examples
--------

For some simple Wax apps, check out the [examples folder](http://github.com/probablycorey/wax/tree/master/examples/).

How would I create a UIView and color it red?

    -- forget about using alloc! Memory is automatically managed by Wax
    view = UIView:initWithFrame(CGRect(0, 0, 320, 100))

    -- use a colon when sending a message to an Objective-C Object
    -- all methods available to a UIView object can be accessed this way
    view:setBackgroundColor(UIColor:redColor())

What about methods with multiple arguments?

    -- Just add underscores to the method name, then write the arguments like
    -- you would in a regular C function
    UIApplication:sharedApplication():setStatusBarHidden_animated(true, false)

How do I send an array/string/dictionary

    -- Wax automatically converts array/string/dictionary objects to NSArray,
    -- NSString and NSDictionary objects (and vice-versa)
    images = {"myFace.png", "yourFace.png", "theirFace.png"}
    imageView = UIImageView:initWithFrame(CGRect(0, 0, 320, 460))
    imageView:setAnimationImages(images)

What if I want to create a custom UIViewController?

    -- Created in "MyController.lua"
    --
    -- Creates an Objective-C class called MyController with UIViewController
    -- as the parent. This is a real Objective-C object, you could even
    -- reference it from Objective-C code if you wanted to.
    waxClass{"MyController", UIViewController}

    function init()
      -- to call a method on super, simply use self.super
      self.super:initWithNibName_bundle("MyControllerView.xib", nil)
      return self
    end

    function viewDidLoad()
      -- Do all your other stuff here
    end

You said HTTP calls were easy, I don't believe you...

    url = "http://search.twitter.com/trends/current.json"

    -- Makes an asyncronous call, the callback function is called when a
    -- response is received
    wax.http.request{url, callback = function(body, response)
      -- request is just a NSHTTPURLResponse
      puts(response:statusCode())

      -- Since the content-type is json, Wax automatically parses it and places
      -- it into a Lua table
      puts(body)
    end}

Since Wax converts NSString, NSArray, NSDictionary and NSNumber to native Lua values, you have to force objects back to Objective-C sometimes. Here is an example.

    local testString = "Hello lua!"
    local bigFont = UIFont:boldSystemFontOfSize(30)
    local size = toobjc(testString):sizeWithFont(bigFont)
    puts(size)

Setup & Tutorials
-----------------

[Setting up Wax](https://github.com/probablycorey/wax/wiki/Installation)

[How does Wax work?](https://github.com/probablycorey/wax/wiki/Overview)

[Simple Twitter client in Wax](https://github.com/probablycorey/wax/wiki/Twitter)

Which API's are included?
-------------------------

They all are! I can't stress this enough, anything that is written in Objective-C (even external frameworks) will work automatically in Wax! UIAcceleration works like UIAcceleration, MapKit works like MapKit, GameKit works like GameKit, Snozberries taste like Snozberries!

Created By
----------
Corey Johnson (probablycorey at gmail dot com)

More
----
* [Feature Requests? Bugs?](http://github.com/probablycorey/wax/issues) - Issue tracking and release planning.
* [Mailing List](http://groups.google.com/group/iphonewax)
* [IRC: #wax](irc://chat.freenode.net/#wax) on http://freenode.net
* Quick question or problem? IM **probablyCorey** on AIM

Contribute
----------
Fork it, change it, commit it, push it, send pull request; instant glory!


The MIT License
---------------
Wax is Copyright (C) 2009 Corey Johnson See the file LICENSE for information of licensing and distribution.
