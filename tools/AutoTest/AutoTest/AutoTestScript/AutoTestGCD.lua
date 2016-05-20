waxClass{"AutoTestGCD"}

function autoTestStart( self )
	print("begin AutoTestGCD autoTestStart");
	local main_queue = dispatch_get_main_queue();
    print(string.format("main_queue=%s", dispatch_queue_get_label(main_queue)));
    print(string.format("main_queue=%s", dispatch_queue_get_label(main_queue)));
    
    local global_queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    print(string.format("global_queue=%s", dispatch_queue_get_label(global_queue)));
    
    local  create_queue = dispatch_queue_create("com.taobao.test", DISPATCH_QUEUE_SERIAL);
    print(string.format("create_queue=%s", dispatch_queue_get_label(create_queue)));
    
--    local  current_queue = dispatch_get_current_queue();
--    print(string.format("current_queue=%s", dispatch_queue_get_label(current_queue)));

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), 
    	toblock(
			function( )
				print(string.format("dispatch_async"));
			end)
    );
    
    dispatch_async(dispatch_get_main_queue(), 
    	toblock(
			function( )
				print(string.format("dispatch_async"));
			end)
    );

    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), 
    	toblock(
			function( )
				print(string.format("dispatch_sync"));
			end)
    );
    local va = UIView:init()
print("va=", va)
local vb = UIViewController:init()
print("vb=", vb)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (5 * NSEC_PER_SEC)), dispatch_get_main_queue(), 
    	toblock(
			function( )
				print(string.format("dispatch_after"));
			end)
    );
    print("start dispatch_apply")

    
  --   local semaphore = dispatch_semaphore_create(0);
  --   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (5 * NSEC_PER_SEC)), dispatch_queue_create("com.taobao.test", DISPATCH_QUEUE_SERIAL), 
		-- toblock(
		-- 	function()
		-- 		print(string.format("dispatch_semaphore_t dispatch_semaphore_signal"));
  --       		dispatch_semaphore_signal(semaphore);
  --       		print("semaphore=", tostring(semaphore))
		-- 	end)
  --   );
  --   dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
 
    local time = dispatch_time(DISPATCH_TIME_NOW, 10);
    print(string.format("DISPATCH_TIME_NOW=%d time=%d", DISPATCH_TIME_NOW, time));

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (5 * NSEC_PER_SEC)), dispatch_get_main_queue(), 
		toblock(
			function( )
				print("lua dispatch_after")
			end)
    );

    --test download 

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), 
    	toblock(
			function( )
				
				print("dispatch_async start download");
				local request = NSURLRequest:requestWithURL(NSURL:URLWithString("http://gw.alicdn.com/tps/i2/TB1M4BWHpXXXXbYXVXXdIns_XXX-1125-352.jpg_q50.jpg"));
		        local data = NSURLConnection:sendSynchronousRequest_returningResponse_error(request, nil, nil);
		        print("dispatch_async end download");

		        dispatch_async(dispatch_get_main_queue(), 
					toblock(
						function( )
							print("dispatch_async back to main");
							if data ~= nil then
								print(string.format("data.length=%d", data:length()));
							end
						end)
		        )
			end)
    );
    print("end AutoTestGCD autoTestStart");
end