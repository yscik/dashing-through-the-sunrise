
Player = class("Player", Entity)

function Player:initialize(cursor)
  Entity.initialize(self)

  local pos = {x=500, y=-600}
  self:add(Position({at = pos, center = {20, 20}, z = 2}))
  self:add(Velocity())
  self:add(Render())

  self.battery = Storage({type = Resource.Power, capacity = 300, content = 200})
  
  self.burn = Burn({
      source = Consume({type = Resource.Power, rate = 1, sources = {self.battery}}), 
      target = Target({})
    })
  
  self:add(self.burn)

  self.storage = Storage({type = 'Silicon', content = 0, capacity = 400})
  self:add(Resources({
    self.storage
  }))

  
end

function Player:draw()

  love.graphics.setColor(150,100,200)
  love.graphics.rectangle("fill", 5, 5, 30, 30)
  
end


function Player:moveTo(...)
  self.burn.target:set(...)
end


