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
  end

 if button == 2 then
    systems.player:hook(self.input.pos)
  end

  end

function InputSystem:keyup(key)

  if self.listener.key[key] then
    self.listener.key[key].callback(self.input)
  end

  if key == 'escape' then
    return systems.ui:clear() or love.event.quit()
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

--  systems.player:look(self.input.pos)

  for i, listener in ipairs(self.listener.mouse) do
    if listener.callback(self.input) then
      if self.listener.mouse[i].after then self.listener.mouse[i].after() end
      self.listener.mouse[i] = nil
    end
  end
  
end

function InputSystem:requires()
    return {"Hitbox", "Position"}
end