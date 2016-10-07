
Player = class("Player", Entity)

function Player:initialize()
  Entity.initialize(self)
  self:add(Position({x=300, y=200, r = 0}))
  self:add(Velocity())
  self:add(Canvas())
  self.burn = Burn({cost = Resource.Power, target = Target({source = Cursor, button = 'r'})})
  self:add(self.burn)
  self:add(self.burn.target)
  self:add(Consume({type = Resource.Power}))
  self:add(Storage({type = Resource.Power, capacity = 300, current = 200}))
  
end

function Player:draw()

  love.graphics.clear()
  love.graphics.setColor(150,100,200)
  love.graphics.rectangle("fill", 0, 0, 30, 30)
  
end
