waxClass{"OrangeController", UIViewController}

function init(self)
  self.super:initWithNibName_bundle("OrangeView", nil)

  return self
end

function viewDidLoad(self)
  -- All outlets are dynamically set to values on the lua object. To do this you
  -- need to create a custom 'OrangeController' class in IB's Library Window.
  --
  -- Here are the steps I took to bind the views to this lua object
  -- 1.) Click the 'classes' tab in the Library Windown
  -- 2.) Find the UIViewController class, right click and choose 'New Subclass...'
  -- 3.) Name the subclass 'OrangeController'
  -- 4.) The class editor for 'OrangeController' is now at the bottom of the 
  --     Library Window, click on the 'Outlets' tab
  -- 5.) Add an outlet named 'button'
  -- 6.) Add an outlet named 'textfield'
  -- 7.) Set the File's Owner to 'OrangeController'
  -- 8.) Hookup the views like you normally would in IB
  --
  -- I wish I could automate these steps like macruby does, but I'm not sure how
  -- to tap into IB
  
  self.button:addTarget_action_forControlEvents(self, "buttonTouched:", UIControlEventTouchUpInside) 
  self.textField:setText("This was also created in Lua!")
end

function buttonTouched(self, sender)
  self:view():superview():addSubview(blueController:view())
  self:view():removeFromSuperview()
end