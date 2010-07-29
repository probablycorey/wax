-- This is weird code... I'm just playing with an idea
function wax.frame(object)
  return setmetatable({
    object = object,
    center = function(self)
      local offset = (wax.frame(self.object:superview()).width - self.width) / 2
      self.x = offset
      return self
    end,
  },
  {
    __index = function(self, key)
      if key == "y" then key = "top"
      elseif key == "x" then key = "left"
      end
    
      if key == "left" then return object:frame().x
      elseif key == "right" then return object:frame().x + object:frame().width
      elseif key == "top" then return object:frame().y
      elseif key == "bottom" then return object:frame().y + object:frame().height
      elseif key == "height" then return object:frame().height
      elseif key == "width" then return object:frame().width
      else
        return nil
      end
    end,
    
    __newindex = function(self, key, value)
      if key == "y" then key = "top"
      elseif key == "x" then key = "left"
      end
    
    
      local frame = object:frame()
      if key == "left" then frame.x = value
      elseif key == "right" then frame.x = value - frame.width
      elseif key == "top" then frame.y = value
      elseif key == "bottom" then frame.y = value - frame.height
      elseif key == "height" then frame.height = value
      elseif key == "width" then frame.width = value
      
      
      elseif key == "stretchBottom" then frame.height = math.max(0, frame.height - frame.y)
      
      else
        return nil
      end
      
      object:setFrame(frame)
      
      return self
    end
  })
end