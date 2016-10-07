Position = Component.create("Position")

function Position:initialize(pos)
    self.pos = pos or {x = 0, y = 0, r = 0}
end

Velocity = Component.create("Velocity", {"x", "y", "r"})

function Velocity:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
    self.r = 0
end