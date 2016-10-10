
TargetDisplay = class("TargetDisplay", Entity)

function TargetDisplay:initialize(target)
  Entity.initialize(self)
  self.target = target
  self:add(Position(target))
  self:add(Canvas(10,10))
  
end

function TargetDisplay:draw()

  love.graphics.clear()
  if self.target.set then
    love.graphics.setColor(50,100,200)
    love.graphics.circle("fill", 5, 5, 3)
  end

end
