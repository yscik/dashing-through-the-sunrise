Score = class('Score', Entity)

function Score:initialize()
  Entity.initialize(self)
  self.seconds = 0
end

function Score:update(dt)
  self.seconds = self.seconds + dt
end