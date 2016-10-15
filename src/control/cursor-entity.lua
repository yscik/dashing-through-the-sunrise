CursorEntity = class("CursorEntity", Entity)

local size = 10

function CursorEntity:initialize(input)
  Entity.initialize(self)
  self:add(Position({reference = input.pos, center = {size,size}}))
  self:add(Canvas(size*2))

end

function CursorEntity:draw ()
  
  love.graphics.setColor(150,100,200)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", size, size, 6)
end