
Powerplant = class("Powerplant", Entity)

function Powerplant:initialize(asteroid)
  Entity.initialize(self)
  self:add(Position(x,y))
  self:add(Canvas())
  local generator = Generate({type = Resource.Power, amount: 5, cost: Consume({type = Resource.Silicon, amount: 12})}
  self:addMultiple(generator, generator.cost)
  self:add(Storage({type = Resource.Power, capacity = 100}))
  self:add(ResourceLink({type = Resource.Silicon, source = asteroid}))
  
  self.path = {10,100, 0,80, 5,55, 8,30, 1,0, 30,0, 28,50, 35,75, 30, 100};
  
  
end

function Powerplant:draw ()

  love.graphics.setColor(30,200,50)
  love.graphics.polygon("fill", self.path)

end

