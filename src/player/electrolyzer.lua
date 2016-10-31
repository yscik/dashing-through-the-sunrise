

Electrolyzer = class("Electrolyzer", Entity)

function Electrolyzer:initialize(tanks)
  Entity.initialize(self)
  self.tanks = tanks
  self.active = false

end

function Electrolyzer:tick(dt)
  local rate = 0.5
  local h2_conversion = 1
  local power_use = 0.4
  local o2_conversion = 0.5

  if self.active and self.tanks.water.has(rate * dt) and self.tanks.power.has(rate * dt * power_use) then
    self.tanks.water.use(rate * dt)
    self.tanks.H2.add(rate * dt * h2_conversion)
    self.tanks.O2.add(rate * dt * o2_conversion)
    self.tanks.power.use(rate * dt * power_use)
  end

end


function Electrolyzer:execute()
  self.active = not self.active
end