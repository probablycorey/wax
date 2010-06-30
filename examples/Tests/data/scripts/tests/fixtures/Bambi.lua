waxClass{"Bambi", Deer}

function initWithAge(self, age)
  self.super:init()
  self.age = age
  return self
end

function initWithFood(self, food)
  self.super:initWithFood(food)
  self.bambiFood = "Bambi" .. food
  self.food = food
  return self
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