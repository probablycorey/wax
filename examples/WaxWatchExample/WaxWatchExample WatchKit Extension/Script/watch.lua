
waxClass{"ExtensionDelegate"}

function applicationDidBecomeActive(self)
	self:ORIGapplicationDidBecomeActive();
	print("lua applicationDidBecomeActive")
end

function applicationWillResignActive(self)
	self:ORIGapplicationWillResignActive();
	print("lua applicationWillResignActive")
end



waxClass{"InterfaceController"}

function showAlert(self)
	if self.isShowedAlert ~= true then
		self.isShowedAlert = true
		WKAlertActionStyleDefault = 0
		WKAlertControllerStyleAlert = 0
		local action = WKAlertAction:actionWithTitle_style_handler("hello wax", WKAlertActionStyleDefault, 
			toblock(
				function ()
					print("lua handler")
				end
			, {"void"})
	    )
	    self:presentAlertControllerWithTitle_message_preferredStyle_actions("title wax", "message wax", WKAlertControllerStyleAlert,  {action});
	end
end

function willActivate(self)
	print("lua InterfaceController willActivate")

	self:performSelector_withObject_afterDelay("showAlert", nil, 2)

	self:ORIGwillActivate()
end

function didDeactivate(self)
	print("lua InterfaceController didDeactivate")
	self:ORIGdidDeactivate()
end
