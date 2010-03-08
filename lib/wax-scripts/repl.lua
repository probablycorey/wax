while true do
  io.write "> "
  local input = io.read()
  
  local func, err = loadstring("_ = (" .. input ..") puts(_)")
  if err then
    puts("ERROR: %s", err)
  else
    func()
  end
end