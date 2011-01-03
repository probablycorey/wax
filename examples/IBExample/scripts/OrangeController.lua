waxClass{"OrangeController", UIViewController}

IBOutlet "textField" -- This makes the property visible from IB

function init(self)
  self.super:initWithNibName_bundle("OrangeView", nil)
  return self
end

function viewDidLoad(self)
  -- The button and textField varibles are automatically created and added to the class via IB
  self.textField:setText("This was also created in Lua!")
end

-- Put IBAction next to, or above a function to make it appear in IB
function buttonTouched(self, sender) -- IBAction
  local parentView = self:view():superview()
  UIView:beginAnimations_context(nil, nil)
  UIView:setAnimationTransition_forView_cache(UIViewAnimationTransitionFlipFromRight, parentView, true)
  self:view():removeFromSuperview()
  parentView:addSubview(blueController:view())
  UIView:commitAnimations()
end