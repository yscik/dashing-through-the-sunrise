
Player = class("Player", Entity)

function Player:initialize()
  Entity.initialize(self)
  
  self:add(Position({x=300, y=200, r = 0}))
  self:add(Velocity())
  self:add(Canvas(40,40))
  
  self.battery = Storage({type = Resource.Power, capacity = 300, content = 200})
  
  self.burn = Burn({
      source = Consume({type = Resource.Power, rate = 1, sources = {self.battery}}), 
      target = Target({source = Cursor, button = 'r'})
    })
  
  self:add(self.burn)
  self:add(self.burn.target)
  
end

function Player:draw()

  love.graphics.clear()
  love.graphics.setColor(150,100,200)
  love.graphics.rectangle("fill", 5, 5, 30, 30)
  
end
