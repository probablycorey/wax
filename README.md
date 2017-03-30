Wax is being maintained by Alibaba
----------

[![Join the chat at https://gitter.im/alibaba/wax](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/alibaba/wax?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Thanks to @probablycorey for creating such a great project.
Wax is the best bridge between Lua and Objective-C, we will be maintaining it here. We have fixed a lot of issues such as 64-bit support and thread-safety. We have also added many features such as converting Lua functions to OC blocks, calling OC blocks in Lua, getting/setting private ivars, built-in commonly used C functions, and even Lua code debugging.

Wax
---

Wax is a framework that lets you write native iPhone apps in 
[Lua](http://www.lua.org/about.html). It bridges Objective-C and Lua using the 
Objective-C runtime. With Wax, **anything** you can do in Objective-C is **automatically**
available in Lua! What are you waiting for, give it a shot!

Why write iPhone apps in Lua?
-----------------------------

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

For some simple Wax apps, check out the [examples folder](https://github.com/alibaba/wax/tree/master/examples).

How would I create a UIView and color it red?

``` lua
-- forget about using alloc! Memory is automatically managed by Wax
view = UIView:initWithFrame(CGRect(0, 0, 320, 100))

-- use a colon when sending a message to an Objective-C Object
-- all methods available to a UIView object can be accessed this way
view:setBackgroundColor(UIColor:redColor())
```

What about methods with multiple arguments?

``` lua
-- Just add underscores to the method name, then write the arguments like
-- you would in a regular C function
UIApplication:sharedApplication():setStatusBarHidden_animated(true, false)
```

How do I send an array/string/dictionary

``` lua
-- Wax automatically converts array/string/dictionary objects to NSArray,
-- NSString and NSDictionary objects (and vice-versa)
images = {"myFace.png", "yourFace.png", "theirFace.png"}
imageView = UIImageView:initWithFrame(CGRect(0, 0, 320, 460))
imageView:setAnimationImages(images)
```

What if I want to create a custom UIViewController?

``` lua
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
```

You said HTTP calls were easy, I don't believe you...

``` lua
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
```

Since Wax converts NSString, NSArray, NSDictionary and NSNumber to native Lua values, you have to force objects back to Objective-C sometimes. Here is an example.

``` lua
local testString = "Hello lua!"
local bigFont = UIFont:boldSystemFontOfSize(30)
local size = toobjc(testString):sizeWithFont(bigFont)
puts(size)
```
    
How do I convert Lua functions to Objective-C blocks? [see more detail](https://github.com/alibaba/wax/wiki/Block).

``` lua
UIView:animateWithDuration_animations_completion(1, 
    toblock(
        function()
            label:setCenter(CGPoint(300, 300))
        end
    ),
    toblock(
             function(finished)
                print('lua animations completion ' .. tostring(finished))
            end
    ,{"void", "BOOL"})
)

---OC method is -(void)testReturnIdWithFirstIdBlock:(id(^)(id aFirstId, BOOL aBOOL, int aInt, NSInteger aInteger, float aFloat, CGFloat aCGFloat, id aId))block
self:testReturnIdWithFirstIdBlock(
toblock(
    function(aFirstId, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
        print("aFirstId=" .. tostring(aFirstId))
        -- assert(aFirstId == self, "aFirstInt不等")
        assertResult(self, aBOOL, aInt, aInteger, aFloat, aCGFloat, aId)
        print("LUA TEST SUCCESS: testReturnIdWithFirstIdBlock")
        return aFirstId
    end
    , {"id","id", "BOOL", "int", "NSInteger", "float", "CGFloat", "id"})
)
```

What about calling Objective-C blocks?[see more detail](https://github.com/alibaba/wax/wiki/Block).

``` lua
--OC block type is id (^)(NSInteger, id, BOOL, CGFloat)
--just like lua function
local res = block(123456, aObject, true, 123.456);

--or you can call like this:
local res = luaCallBlockWithParamsTypeArray(block, {"id","NSInteger", "id", "BOOL", "CGFloat"},  123456, aObject, true, 123.456);
```

What if my instance variables are privately implemented?

``` lua
print(self:view():getIvarInt("_countOfMotionEffectsInSubtree"))

self:setIvar_withObject("_title", "abcdefg")
print(self:getIvarObject("_title"))

self:setIvar_withObject("_infoDict", {k11="v11", k22="v22"})
print(toobjc(self:getIvarObject("_infoDict")))
```

You want to call some C functions?

``` lua
luaSetWaxConfig({openBindOCFunction=true})--bind built-in C function

dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), 
        toblock(
            function( )
                print(string.format("dispatch_async"));
            end)
    );

UIGraphicsBeginImageContext(CGSize(200,400));
UIApplication:sharedApplication():keyWindow():layer():renderInContext(UIGraphicsGetCurrentContext());
local aImage =UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();

local imageData =UIImagePNGRepresentation(aImage);
print("imageData.length=", imageData.length);
local image = aImage;
local data = UIImageJPEGRepresentation(image, 0.8);
print("data.length=", data:length());
```

Lua code debug
------
Any way to debug my Lua code?   
Ofcourse, you can use the powerfull ZeroBraneStudio to debug. [see more detail](https://github.com/alibaba/wax/tree/master/examples/LuaCodeDebug).

Lua code in Xcode
------
[Wax-In-Xcode](https://github.com/intheway/Wax-In-Xcode) plugin can help you for Lua code format, syntax highlighting and code completion.   

Watch OS 
------
Can Wax run on watch OS?
Thanks to the cross platform characteristics of Lua, Wax can run on watch OS certainly. see tools/WaxWatchFramework and examples/WaxWatchExample

Swift
------
Can Wax work in Swift?
Swift has no runtime feature, but it's compatible with Objective-c, so runtime method invoking and swizzing can be used in some conditions. [see more detail](https://github.com/alibaba/wax/wiki/UseInSwift).

```
waxClass{"SwiftExample.TestSwiftVC"}
function viewDidLoad(self)
	self:ORIGviewDidLoad();
	--call class method
	objc_getClass("SwiftExample.TestSwiftVC"):testClassReturnVoidWithaId(self:view())
end
function tableView_didSelectRowAtIndexPath(self, tableView, indexPath)
	local vc = objc_getClass("SwiftExample.TestBSwiftVC"):initWithNibName_bundle("TestBSwiftVC", nil);
    self:navigationController():pushViewController_animated(vc, true);
end
```

Use with cocoapods
----------
see demo in `examples/InstallationExample/InstallWithCocoaPods` .  
* add `pod 'wax', :git=>'https://github.com/alibaba/wax.git', :tag=>'1.1.0'` to your podfile. (tag in your needs)  
* then you can run lua code.

``` lua
wax_start(nil, nil);
wax_runLuaString("print('hello wax')");
```
    
Setup & Tutorials
-----------------

[Setting up Wax](https://github.com/alibaba/wax/wiki/Installation)

[How does Wax work?](https://github.com/alibaba/wax/wiki/Overview)

[Simple Twitter client in Wax](https://github.com/alibaba/wax/wiki/Twitter-example)

Which API's are included?
-------------------------

They all are! I can't stress this enough, anything that is written in Objective-C (even external frameworks) will work automatically in Wax! UIAcceleration works like UIAcceleration, MapKit works like MapKit, GameKit works like GameKit, Snozberries taste like Snozberries!

Created By
----------
Corey Johnson (probablycorey at gmail dot com)

More
----
* [Feature Requests? Bugs?](https://github.com/alibaba/wax/issues) - Issue tracking and release planning.
* [Mailing List](http://groups.google.com/group/iphonewax)
* Quick questions or issues? Send an email to [@Zhengwei Yin (Junzhan)](mailto:junzhan.yzw@taobao.com)
* Communicate in gitter: [https://gitter.im/alibaba/wax](https://gitter.im/alibaba/wax)
* Communicate in QQ group: 196306834

Contribute
----------
[@Zhengwei Yin (Junzhan)](mailto:inthewayapple@163.com)  
Fork it, change it, commit it, push it, send pull request; instant glory!


The MIT License
---------------
Wax is Copyright (C) 2009 Corey Johnson See the file LICENSE for information of licensing and distribution.
