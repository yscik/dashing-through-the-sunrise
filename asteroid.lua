
local Object = require 'lib/classic'

local Asteroid = Object:extend("Asteroid")

function Asteroid:new(x, y)
  self.x = x;
  self.y = y;
  self.path = {0,300, 54,206, 150,170, 300,200, 330,250, 250,350, 200, 340, 70,380, 0,300};
  self.canvas = love.graphics.newCanvas()
  
end

function Asteroid:draw ()

  love.graphics.setCanvas(self.canvas)

  love.graphics.setColor(200,200,200)
  love.graphics.polygon("fill", self.path)
  love.graphics.setCanvas()
  love.graphics.draw(self.canvas, self.x, self.y)

end

function Asteroid:update(dt, x)
  
  
end

return Asteroid
