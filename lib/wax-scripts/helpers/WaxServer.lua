-- I don't know where the proper place for this file is. It's not really a helper
waxClass{"WaxServer"}

-- Class Method
---------------
function start(self)
  self.server = wax.class['wax_server']:init()

  local err = self.server and self.server:startOnPort(9000)
  if err then
    puts("Failed creating server: %s", err and err:description() or "Server Not Created")
    return err
  end

  self.server:setDelegate(self)

  -- redirect print
  local formerPrint = print
  _G.print = function(s)
    formerPrint(s)
    self.server:send(tostring(s) .. "\n")
  end

  return nil
end

function showPrompt(self)
  self.server:send "> "
end

-- DebugServerDelegate
----------------------
function connected(self)
  self:showPrompt()
end

function disconnected(self)
  self.server:send("GOODBYE!")
end

function dataReceived(self, data)
  local input = NSString:initWithData_encoding(data, NSASCIIStringEncoding)
  local success, err = wax.eval(input)

  if not success then self.server:send("Error: " .. err .. "\n") end

  self:showPrompt()
end
