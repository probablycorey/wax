waxClass{"Bambi", Deer}

function initWithAge(self, age)
  self = self.super:init()
  self.age = age
  self.name = "Bambi"
  return self
end

function initWithFood(self, food)
  self = self.super:initWithFood(food)
  self.bambiFood = "Bambi" .. food
  self.food = food
  return self
end

function setDeath(self, death)
  self.super:setDeath(death)
end

function getAge(self)
  return self.age
end

function getFood(self)
  return self.food
end

function tripleAge(self)
  return self.age * 3
end

function getInfo(self)
  return self.super:getInfo() .. ":BambiClass"
end

function hash(self)
  return tostring(self.super:hash()) .. ":10"
end

function getClassName(self)
  return "BambiClass"
end

function callgetClassNameFromSuper(self)
  return self.super:callgetClassNameFromSuper()
end

function getAgeFromSuper(self)
  return self.super:getAgeFromSuper()
end