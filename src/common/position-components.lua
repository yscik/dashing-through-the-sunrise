Position = Component.create("Position", {"x", "y", "r"})

function Position:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
    self.r = 0
end

Velocity = Component.create("Velocity", {"x", "y", "r"})

function Velocity:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
    self.r = 0
end