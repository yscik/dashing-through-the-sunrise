InputSystem = class("InputSystem", System)

local HC = require 'lib/hc'


function InputSystem:initialize()
  System.initialize(self)
  self.input = InputState()
  
  love.mouse.setVisible(false)
  love.mousepressed = function(...) return self:click(...) end
  love.keyreleased = function(...) return self:keyup(...) end
  
end

function InputSystem:click(x, y, button)
  if button == 1 then 
    if self.input.command == nil then self.input.command = Command(self.input) end
    if self.input.command:click() then self.input.command = nil end
  end
  
  if button == 2 then 
    self.input.move = {x = x, y = y}
  end
  
end

function InputSystem:keyup(x, y, button)
  if button == 1 then 
    if self.input.command == nil then self.input.command = Command(self.input) end
    if self.input.command:click() then self.input.command = nil end
  end
  
  if button == 2 then 
    self.input.move = {x = x, y = y}
  end
  
end

function InputSystem:update(dt)

  local input = self.input
  
  input.pos.x, input.pos.y = camera:mousePosition()
  
  input.target = nil
  
  for k, entity in pairs(self.targets) do
    local clickable, pos = entity:get("Clickable"), entity:get("Position").pos      
      clickable.hc:moveTo(pos.x, pos.y)
      clickable.hover = clickable.hc:contains(input.pos.x, input.pos.y)
      if clickable.hover then 
        input.target = entity
      end
  end
  
end


function InputSystem:requires()
    return {"Clickable", "Position"}
end

function InputSystem:onAddEntity(entity)
    local comp = entity:get("Clickable")
    
    comp.hc = HC.polygon(unpack(comp.shape))
end