
local Object = require 'lib/classic'
local vector = require 'lib/vector'

local Cursor = Object:extend("Cursor")

function Cursor:new()
  self.pos = {x = 0, y = 0};
  self.move = false;
  self.canvas = love.graphics.newCanvas()
  
  love.mouse.setVisible(false)
  
end

function Cursor:draw ()

  love.graphics.setCanvas(self.canvas)

  love.graphics.setColor(150,100,200)
  love.graphics.circle("fill", 6, 6, 6)
  love.graphics.setCanvas()
  love.graphics.draw(self.canvas, self.pos.x, self.pos.y)

end

function Cursor:update(dt)
  self.move = love.mouse.isDown(2)
  self.pos.x, self.pos.y = love.mouse.getPosition()
    
end

return Cursor
