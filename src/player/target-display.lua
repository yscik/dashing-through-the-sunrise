
TargetDisplay = class("TargetDisplay", Entity)

local size = 5

function TargetDisplay:initialize(target)
  Entity.initialize(self)
  self.target = target

  self:add(Position({reference = target.pos.at, center = {size, size}, z = 7}))
  self:add(Render())
  
end

function TargetDisplay:draw()

  if self.target.active then
    love.graphics.setColor(50,100,200)
    love.graphics.circle("fill", size, size, 3)
  end

end
