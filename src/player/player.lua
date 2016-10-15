
Player = class("Player", Entity)

function Player:initialize(cursor)
  Entity.initialize(self)

  local pos = {x=300, y=200}
  self:add(Position({at = pos, center = {20, 20}}))
  self:add(Velocity())
  self:add(Canvas(40))
  
  self.battery = Storage({type = Resource.Power, capacity = 300, content = 200})
  
  self.burn = Burn({
      source = Consume({type = Resource.Power, rate = 1, sources = {self.battery}}), 
      target = Target({source = cursor, button = 'r', x = 0, y = 0})
    })
  
  self:add(self.burn)
  self:add(self.burn.target)
  
end

function Player:draw()

  love.graphics.clear()
  love.graphics.setColor(150,100,200)
  love.graphics.rectangle("fill", 5, 5, 30, 30)
  
end


function Player:burnto(target)
  self.burn.target = target
end


