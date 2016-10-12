CursorEntity = class("CursorEntity", Entity)

function CursorEntity:initialize(input)
  Entity.initialize(self)
  self:add(Position(input.pos))
  self:add(Canvas(20,20))

end

function CursorEntity:draw ()
  
  love.graphics.setColor(150,100,200)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 10, 10, 6)
end