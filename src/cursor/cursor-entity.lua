CursorEntity = class("CursorEntity", Entity)

function CursorEntity:initialize()
  Entity.initialize(self)
  self:add(Position())
  self:add(CursorPosition())
  self:add(Canvas())

end

function CursorEntity:draw ()
  
  love.graphics.setColor(150,100,200)
  love.graphics.circle("line", 8, 8, 6)

end