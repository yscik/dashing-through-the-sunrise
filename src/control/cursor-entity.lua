CursorEntity = class("CursorEntity", Entity)

local size = 10

function CursorEntity:initialize(input)
  Entity.initialize(self)
  self:add(Position({reference = input.pos, z = 10}))
  self:add(Render())

  self.mode = nil

end

function CursorEntity:setMode(mode)
  self.mode = mode
end

function CursorEntity:reset()
  self.mode = nil
end

function CursorEntity:draw ()

  love.graphics.setColor(rgba("#205E8D"))
  love.graphics.setLineWidth(2)

  if not self.mode then
    love.graphics.circle("line", 0, 0, 6)
  else self.mode() end

end