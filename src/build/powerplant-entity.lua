
Building = class("Powerplant", Entity)

function Building:initialize()
  Entity.initialize(self)
end

Powerplant = class("Powerplant", Building)

function Powerplant:initialize(asteroid, position)
  Building.initialize(self)
  self:add(Position(position))
  self:add(Canvas(50, 120))

--  local generator = Generate({type = Resource.Power, amount: 5, cost: Consume({type = Resource.Silicon, amount: 12})}
--  self:add(generator)
--  self:add(Resources({generator.cost, Storage({type = Resource.Power, capacity = 100})}))
--  self:add(ResourceLink({type = Resource.Silicon, source = asteroid}))
--

  self.path = {10,100, 0,80, 5,55, 8,30, 1,0, 30,0, 28,50, 35,75, 30, 100};

end

function Powerplant:built()
  self:add(Clickable({shape = self.path}))
end

function Building:draw ()

  local opacity = self.status / 100 * 255
  love.graphics.setColor(130,140,150, opacity)
  love.graphics.polygon("fill", self.path)

end

