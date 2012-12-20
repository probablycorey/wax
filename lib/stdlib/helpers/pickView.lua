
function startPick()
    local w = UIApplication:sharedApplication():keyWindow()
    _interceptor = InterceptorView:alloc():initWithFrame(w:bounds())
    w:addSubview(_interceptor)
    return "Go on, touch something. Get the view by calling endPick() when you're done."
end

function endPick()
    local v = _interceptor:pickedView()
    _interceptor:removeFromSuperview()
    return v
end

-- wax doesn't automagically bridge C functions
function CGRectContainsPoint(rect, point)
    return rect.x <= point.x
       and point.x <= rect.x + rect.width
       and rect.y <= point.y
       and point.y <= rect.y + rect.height
end

waxClass{"InterceptorView", UIView}

function touchesEnded_withEvent(self, touches, event)
    local point = touches:anyObject():locationInView(self)
    local w = UIApplication:sharedApplication():keyWindow()
    local pointInWindow = w:convertPoint_fromView(point, self)
    self.pickedView_ = self:findOwnerOfPoint_startingWith(pointInWindow, w)
    print(self.pickedView_:class())
end

function pickedView(self)
    return self.pickedView_
end

function findOwnerOfPoint_startingWith(self, point, view)
    if view == self then
        return nil
    end

    if not CGRectContainsPoint(view:bounds(), point) then
        return nil
    end

    local betterResult = nil

    for i, subview in ipairs(view:subviews()) do
        pointInSubview = subview:convertPoint_fromView(point, view)
        betterResult = self:findOwnerOfPoint_startingWith(pointInSubview, subview) or betterResult
    end

    return betterResult or view
end
