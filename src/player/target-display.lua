
TargetDisplay = class("TargetDisplay", Entity)

local size = 5

function TargetDisplay:initialize(target)
  Entity.initialize(self)
  self.target = target
  _.extend(target, {w = 10, h = 10})

  self:add(Position({reference = target, center = {size, size}}))
  self:add(Canvas(size*2))
  
end

function TargetDisplay:draw()

  love.graphics.clear()
  if self.target.set then
    love.graphics.setColor(50,100,200)
    love.graphics.circle("fill", size, size, 3)
  end

end
