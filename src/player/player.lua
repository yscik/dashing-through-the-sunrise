
Player = class("Player", Entity)

function Player:initialize()
  Entity.initialize(self)
  self:add(Position(100,50))
  self:add(Velocity())
  self:add(Canvas())
  self:add(BurnTarget())
  
end

function Player:draw()

  love.graphics.setColor(150,100,200)
  love.graphics.rectangle("fill", 0, 0, 30, 30)

end
