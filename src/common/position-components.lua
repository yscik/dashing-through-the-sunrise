Position = Component.create("Position")

function Position:initialize(o)

  self.at = o.reference or _.extend({x = 0, y = 0, r = 0}, o.at)
  self.center = not o.center and {x = 0, y = 0} or #o.center > 0 and {x = o.center[1], y = o.center[2]} or o.center
end

Velocity = Component.create("Velocity", {"x", "y", "r"})

function Velocity:initialize(x, y, r)
    _.extend(self, {x = x or 0, y = y or 0, r = r or 0})
end