
Command = class("Command")

function Command:initialize(state)
  self.input = state
  self.state = self.start
  
end


function Command:click(...)
  return self.state and self:state(...)
end


function Command:start()
  self.target = self.input.target
  if not self.target then return self.state end
  
  return self:ui(self.target)
end


function Command:ui()
  local options = self.target:get("Options").options
  local panel = ui:addPanel(self.target:get("Position").pos, options)
  
  function checkClick()
    return state
  end
  
  return checkClick
end

function Command:selectBuilding(option)
  
  self.building = option
  
end

function Command:addTarget()
  
end