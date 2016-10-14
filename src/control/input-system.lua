InputSystem = class("InputSystem", System)

local HC = require 'lib/hc'

function InputSystem:initialize()
  System.initialize(self)
  self.input = InputState()
  self.listener = { mouse = {}}
  
  love.mouse.setVisible(false)
  love.mousepressed = function(...) return self:click(...) end
  love.keyreleased = function(...) return self:keyup(...) end
  
end

function InputSystem:click(x, y, button)
  if button == 1 and self.input.target and not _.any(self.listener, 'block_click') then
    local ca = self.input.target:get('Clickable')
    if ca and ca.command then ca.command:execute(self.input) end
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
  
end

function InputSystem:listenMouse(options)
  self.listener.mouse[#self.listener.mouse+1] = options
end

function InputSystem:update(dt)

  local input = self.input
  
  input.pos.x, input.pos.y = camera:mousePosition()
  input.click = love.mouse.isDown(1)
  if love.mouse.isDown(2) then
    self.input.move = {x = x, y = y }
  end
  
  input.target = nil
  
  for k, entity in pairs(self.targets) do
    local clickable, pos = entity:get("Clickable"), entity:get("Position").pos      
      clickable.hc:moveTo(pos.x, pos.y)
      clickable.hover = clickable.hc:contains(input.pos.x, input.pos.y)
      if clickable.hover then 
        input.target = entity
      end
  end

  for i, listener in ipairs(self.listener.mouse) do
    if listener.callback(input) then self.listener.mouse[i] = nil end
  end
  
end


function InputSystem:requires()
    return {"Clickable", "Position"}
end

function InputSystem:onAddEntity(entity)
    local comp = entity:get("Clickable")
    
    comp.hc = HC.polygon(unpack(comp.shape))
end