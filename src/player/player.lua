
Player = class("Player", Entity)

function Player:initialize()
  Entity.initialize(self)
  
  self:add(Position({x=300, y=200, r = 0}))
  self:add(Velocity())
  self:add(Canvas())
  
  self.burn = Burn({cost = Consume({type = Resource.Power, rate = 1}), target = Target({source = Cursor, button = 'r'})})
  self:add(self.burn)
  self:add(self.burn.target)
  
  self.battery = Storage({type = Resource.Power, capacity = 300, content = 200})
  
  self:add(Resources({
        self.burn.cost, 
        self.battery
  }))
  
  local a,b,c = self:get("Consume")
end

function Player:draw()

  love.graphics.clear()
  love.graphics.setColor(150,100,200)
  love.graphics.rectangle("fill", 0, 0, 30, 30)
  love.graphics.print("B"..self.battery.content, 0, 40)
  
end
