require "tests.fixtures.ExtendedSimpleObject"

waxClass{"UberExtendedSimpleObject.lua", "ExtendedSimpleObject"}

function initWithAnimal(self, animal)
  self.super:initWithValue(animal)
  return self
end
