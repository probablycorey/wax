local input

repeat
  io.write("wax> ")
  input = io.read()
  local success, e = wax.eval(input)

  if not success then print("Error: " .. e) end
until not input
