puts "GOT ME GOOD"
waxClass{"WaxServer", protocols = {"DebugServerDelegate"}}

-- Class Method
---------------
function start(self)
  self.server = DebugServer:init()
  
  local err
  if not self.server or not self.server:start(err) then
    puts("Failed creating server: %s", err and err:description() or "Server Not Created")
    return false
  end
  
  self.server:setDelegate(self)
  
  -- redirect print
  local formerPrint = print
  _G.print = function(s)
    formerPrint(s)
    self.server:output(tostring(s) .. "\n")
  end
  
  return true
end

function showPrompt(self)
  self.server:output "> "
end

-- DebugServerDelegate
----------------------
function connected(self)
  self:showPrompt()
end

function disconnected(self)
  self.server:output("GOODBYE!")
end

function dataReceived(self, data)
  local success, err = pcall(function()
    local input = NSString:initWithData_encoding(data, NSASCIIStringEncoding)
    local code = loadstring(input)

    if not code then error("Error interpreting line.") 
    else code()
    end
    
  end)
  
  if not success then self.server:output(("Error: %s\n").format(err)) end
  
  self:showPrompt()
end