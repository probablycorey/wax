waxClass{"BlueController", UIViewController}

function init(self)
  self.super:initWithNibName_bundle("BlueView", nil)
  
  return self
end

function viewDidLoad(self)
  -- All IB views are accessed through tags. You set a view's tag with the 
  -- inspector window in IB
  
  self.button = self:view():viewWithTag(1)
  self.button:addTarget_action_forControlEvents(self, "buttonTouched:", UIControlEventTouchUpInside) 

  self.textField = self:view():viewWithTag(2)  
  self.textField:setText("This was created in Lua!")
end

function buttonTouched(self, sender)
  self:view():superview():addSubview(orangeController:view())
  self:view():removeFromSuperview()
end