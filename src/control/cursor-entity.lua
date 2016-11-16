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

  love.graphics.setColor(rgba("#45B3F0"))
  love.graphics.setLineWidth(1)

  if not self.mode then
    love.graphics.circle("line", 0, 0, 4)
  else self.mode() end

end