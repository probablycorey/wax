waxClass{"Deer"}

function initWithName(self, name)
  self.super:init()
  self.name = name
  return self
end

function initWithFood(self, food)
  return nil
end

function getName(self)
  return self.name
end

function doubleAge(self)
  return self.age * 2
end

function tripleAge(self)
  return nil
end