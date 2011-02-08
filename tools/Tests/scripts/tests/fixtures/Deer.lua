waxClass{"Deer"}

-- class methods
----------------

function aClassMethod()
  return "yes"
end

function isEqual(class, other)
  return class.super:isEqual(other)
end

function returnsWhatYouSendIn(class, a, b, c)
  return a, b, c
end

-- instance methods
-------------------
function initWithName(self, name)
  self = self.super:init()
  self.name = name
  return self
end

function initWithFood(self, food)
  self.deerFood = "Deer" .. food
  return self.super:init()
end

function setDeath(self, death)
  self.death = death
end

function getName(self)
  return self.name
end

function doSomethingToAge(self, func)
  self.age = func(self.age)
end

function doubleAge(self)
  return self.age * 2
end

function tripleAge(self)
  return nil
end

function getInfo(self)
  return "DeerClass"
end

function getClassName(self)
  return "DeerClass"
end

function callgetClassNameFromSuper(self)
  return self:getClassName()
end

function getAgeFromSuper(self)
  return self.age
end

function hash(self)
  return 100
end