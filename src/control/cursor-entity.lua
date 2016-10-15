CursorEntity = class("CursorEntity", Entity)

local size = 10

function CursorEntity:initialize(input)
  Entity.initialize(self)
  self:add(Position({reference = input.pos, z = 10}))
  self:add(Render())

end

function CursorEntity:draw ()
  
  love.graphics.setColor(150,100,200)
  love.graphics.setLineWidth(2)
  love.graphics.circle("line", 0, 0, 6)
end