-- This is weird code... I'm just playing with an idea
function wax.frame(object)
  return wax.dimensions(object, "frame")
end

function wax.bounds(object)
  return wax.dimensions(object, "bounds")
end

function wax.dimensions(object, varName)
  return setmetatable({
    object = object,
    center = function(self)
      local offset = (wax.dimensions(self.object:superview(), varName).width - self.width) / 2
      self.x = offset
      return self
    end,
  },
  {
    __index = function(self, key)
      if key == "y" then key = "top"
      elseif key == "x" then key = "left"
      end

      local dimensions = (varName == "frame") and object:frame() or object:bounds()
      if key == "left" then return dimensions.x
      elseif key == "right" then return dimensions.x + dimensions.width
      elseif key == "top" then return dimensions.y
      elseif key == "bottom" then return dimensions.y + dimensions.height
      elseif key == "height" then return dimensions.height
      elseif key == "width" then return dimensions.width

      elseif key == "size" then return CGSize(dimensions.width, dimensions.height)
      elseif key == "origin" then return CGPoint(dimensions.x, dimensions.y)

      else
        error("Unknown frame key: " .. key)
      end
    end,

    __newindex = function(self, key, value)
      if key == "y" then key = "top"
      elseif key == "x" then key = "left"
      end

      local dimensions = (varName == "frame") and object:frame() or object:bounds()
      if key == "left" then dimensions.x = value
      elseif key == "right" then dimensions.x = value - dimensions.width
      elseif key == "top" then dimensions.y = value
      elseif key == "bottom" then dimensions.y = value - dimensions.height
      elseif key == "height" then dimensions.height = value
      elseif key == "width" then dimensions.width = value

      elseif key == "size" then dimensions.width = value.width dimensions.height = value.height
      elseif key == "origin" then dimensions.x = value.x dimensions.y = value.y
      elseif key == "stretchTop" then
        dimensions.height = dimensions.height - (value - dimensions.y)
        dimensions.y = value
      elseif key == "stretchBottom" then
        dimensions.height = dimensions.height + (value - (dimensions.height + dimensions.y))
      elseif key == "stretchRight" then
        dimensions.width = dimensions.width + (value - (dimensions.width + dimensions.x))
      else
        error("Unknown frame key: " .. key)
      end

      if (varName == "frame") then
        object:setFrame(dimensions)
      else
        object:setBounds(dimensions)
      end

      return self
    end
  })
end