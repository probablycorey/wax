local input

repeat
  io.write("wax> ")
  local success, e = pcall(function()
    input = io.read()
    wax.eval(input)
  end)

  if not success then print("Error: " .. e) end
until not input
