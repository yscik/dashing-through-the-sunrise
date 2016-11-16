InputSystem = class("InputSystem", System)

local HC = require 'lib/hc'

function InputSystem:initialize()
  System.initialize(self)
  self.input = InputState()
  self.listener = { mouse = {}, key = {}}
  
  love.mouse.setVisible(false)
  love.mousepressed = function(...) return self:click(...) end
  love.keyreleased = function(...) return self:keyup(...) end
  
end

function InputSystem:click(x, y, button)
 if not systems.state.running then return end
  
 if button == 1 then
    systems.player:hook(self.input.pos)
  end

  end

function InputSystem:keyup(key)
  
  if self.listener.key[key] then
    self.listener.key[key].callback(self.input)
  end

  if key == 'escape' then
    return systems.state:pause()
  end

end

function InputSystem:listenMouse(options)
  self.listener.mouse[#self.listener.mouse+1] = options
end


function InputSystem:onKey(key, options)
  self.listener.key[key] = options
  options.removeListener = _.bind(self.onKey, self, key, nil)
end


function InputSystem:setInputState()
  local input = self.input

  input.pos.x, input.pos.y = systems.camera:mousePosition()
  input.click = love.mouse.isDown(1)

  input.target = nil
end

function InputSystem:update(dt)

  self:setInputState()

  systems.player:lookAt(self.input.pos)
  
  if not systems.state.running then return end

  for i, listener in ipairs(self.listener.mouse) do
    if listener.callback(self.input) then
      if self.listener.mouse[i].after then self.listener.mouse[i].after() end
      self.listener.mouse[i] = nil
    end
  end

--
--  if love.keyboard.isDown('space') then
--    systems.player:capture()
--  end

  if love.keyboard.isDown('a') then
    systems.player:rotate(-1)
  end

  if love.keyboard.isDown('d') then
    systems.player:rotate(1)
  end

  if love.keyboard.isDown('w') then
    systems.player:move(1)
  end

  if love.keyboard.isDown('s') then
    systems.player:move(-1)
  end

end

function InputSystem:requires()
    return {"Hitbox", "Position"}
end