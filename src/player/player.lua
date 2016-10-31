
Player = class("Player", Entity)

function Player:initialize()
  Entity.initialize(self)

  local pos = {x=0, y=0}
  self:add(Position({at = pos, center = {20, 20}, z = 2}))
  self:add(Velocity())
  self:add(Render())

  self.tanks = {
    Water = Storage({type = Res.Water, content = 0, capacity = 400}),
    H2 = Storage({type = Res.H2, content = 100, capacity = 400}),
    O2 = Storage({type = Res.O2, content = 100, capacity = 400})
  }

  self.battery = Storage({type = Res.Power, capacity = 300, content = 200})
  
  self.burn = Burn({
      tank = Consume({rate = 1, multiple = true, sources = {
        { storage = self.tanks.O2, rate = 0.5 },
        { storage = self.tanks.H2, rate = 1 }
        }}),
      target = Target({})
    })
  
  self:add(self.burn)

  self.storage = Storage({type = 'Silicon', content = 0, capacity = 400})
  self:add(Resources({
    self.storage,
    self.battery,
    self.tanks.Water,
    self.tanks.H2,
    self.tanks.O2
  }))

  self.parts = {}
  self.parts.elyz = Electrolyzer({power = self.battery, water = self.tanks.Water, O2 = self.tanks.O2, H2 = self.tanks.H2})

end

function Player:tick(dt)
  _.invoke(self.parts, 'tick', dt)
end
function Player:draw()

  love.graphics.setColor(rgba('#6E6C6C'))
  love.graphics.rectangle("fill", 5, 5, 30, 30)
  
end


function Player:moveTo(...)
  self.burn.target:set(...)
end


