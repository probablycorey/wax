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
  local success, err = pcall(function()
    local input = NSString:initWithData_encoding(data, NSASCIIStringEncoding)
    if not input:match("=") then 
      input = "do return (" .. input .. ") end"
    end
    
    local code, err = loadstring(input, "Remote Console")
    if err then
      error("Syntax Error: " .. err)
    else
      puts(code())
    end
  end)

  if not success then self.server:send("Error: " .. err .. "\n") end

  self:showPrompt()
end
