
Asteroid = class("Asteroid", Entity)

function Asteroid:initialize(x, y)
  Entity.initialize(self)
  self:add(Position(x,y))
  self:add(Canvas())
  
  self.path = {0,300, 54,206, 150,170, 300,200, 330,250, 250,350, 200, 340, 70,380, 0,300};
  
  
end

function Asteroid:draw ()

  love.graphics.setColor(200,200,200)
  love.graphics.polygon("fill", self.path)

end

