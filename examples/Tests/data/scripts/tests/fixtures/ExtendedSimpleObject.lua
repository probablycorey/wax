waxClass{"ExtendedSimpleObject", SimpleObject}

function init(self)
  self.super:init()
  return self
end

function initWithAnimal(self, animal)
  self.super:initWithValue(animal)
  return self
end

function initWithValue(self, value)
  self.super:initWithValue(value)
  return self
end

function valueOverride(self)
  return "NOT THE ORIGINAL"
end

function stringForTesting(self)
  return "Look at me!"
end

function stringForTestingWithArg(self, string)
  return "So say " .. tolua(string)
end
