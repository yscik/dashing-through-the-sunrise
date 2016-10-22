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
  if button == 1 and self.input.target and not _.findWhere(self.listener.mouse, {block_click = true}) then
    local ca = self.input.target:get('Hitbox')
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

function InputSystem:checkHitbox(entity)
  local hitbox, pos = entity:get("Hitbox"), entity:get("Position")

  if hitbox.inactive then return end

  local ox, oy = 0, 0
  local pr,px,py = pos:getR(), pos:getXY()
  if (pos.center ~= hitbox.center) then
    ox, oy = vector.rotate(pr, hitbox.center.x - pos.center.x, hitbox.center.y - pos.center.y)
  end

  hitbox.hc:moveTo(px + ox, py + oy)
  hitbox.hc:setRotation(pr)
  hitbox.hover = hitbox.hc:contains(self.input.pos.x, self.input.pos.y)

  if hitbox.hover then
    self.input.target = entity
  end
end



function InputSystem:setInputState()
  local input = self.input

  input.pos.x, input.pos.y = systems.camera:mousePosition()
  input.click = love.mouse.isDown(1)

  input.target = nil
end

function InputSystem:update(dt)

  self:setInputState()

  if love.mouse.isDown(2) then
    systems.player:moveTo(self.input.pos)
  end


  for k, entity in pairs(self.targets) do
    self:checkHitbox(entity)
  end

  for i, listener in ipairs(self.listener.mouse) do
    if listener.callback(self.input) then self.listener.mouse[i] = nil end
  end
  
end

function InputSystem:requires()
    return {"Hitbox", "Position"}
end