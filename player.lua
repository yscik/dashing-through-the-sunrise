
local Object = require 'lib/classic'
local vector = require 'lib/vector'

local Player = Object:extend("Player")

function Player:new(x, y)
  self.pos = {x = x, y = y, r = 0};
  self.v = vector.new(0,0);
  self.cursor = nil
  
  self.canvas = love.graphics.newCanvas()
  
end

function Player:draw ()

  love.graphics.setCanvas(self.canvas)

  love.graphics.setColor(150,100,200)
  love.graphics.rectangle("fill", 0, 0, 30, 30)
  love.graphics.setCanvas()
  love.graphics.draw(self.canvas, self.pos.x, self.pos.y, self.pos.r, 1, 1, 15, 15)

end

function Player:update(dt)
  local speed = 0.1
  self.v.r = 0
  if self.cursor.move then
    local d = vector.new(self.cursor.pos.x - self.pos.x, self.cursor.pos.y - self.pos.y):normalizeInplace()
    self.v = self.v + (d * 0.3)
    
  end
  
  self.pos.x = self.pos.x + self.v.x * dt
  self.pos.y = self.pos.y + self.v.y * dt
  
  self.v = self.v * (1 - (0.3 * dt))
  
  --self.pos.r = self.pos.r + self.v.r * dt
  
end

return Player
