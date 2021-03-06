Position = Component.create("Position")

function Position:initialize(o)

  o = o or {}
  _.extend(self, o)
  self.at = o.reference or _.extend({x = 0, y = 0, r = 0}, o.at)

  self.center = not o.center and {x = 0, y = 0} or #o.center > 0 and {x = o.center[1], y = o.center[2]} or o.center

  self.parent = o.parent
  self.flipped = false
  self.visible = true
end

local dimensions = {"x", "y", "r"}

function Position:set(o)
  for k, dim in ipairs(dimensions) do
    if o[dim] then self.at[dim] = o[dim] end
  end
end

function Position:getXY()
  if self.parent then
    local px, py = vector.rotate(self.parent.at.r, self.at.x, self.at.y)
    return vector.add(px, py, self.parent.at.x or 0, self.parent.at.y or 0)
  else return self.at.x, self.at.y
  end

end

function Position:getR()
  return (self.at.r or 0) + (self.parent and self.parent.at.r or 0)
end

function Position:flip()
  self.flipped = not self.flipped
end

--function Position:__tostring()
--  return 'Position: [' .. table.__tostring(self.at) .. ']'
--end

Velocity = Component.create("Velocity", {"x", "y", "r"})

function Velocity:initialize(x, y, r)
    _.extend(self, {x = x or 0, y = y or 0, r = r or 0})
end

