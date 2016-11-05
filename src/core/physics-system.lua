
PhysicsSystem = class("PhysicsSystem", System)
Body = Component.create("Body")


function Body:initialize(o)
  _.extend(self, o)

  self.body = love.physics.newBody(systems.physics.world, o.at.x, o.at.y, 'dynamic')
  self.body:setMass(o.mass)
  self.body:setAngularDamping(.5)
  self.fixtures = {}
  _.each(o.shape, function(k, path)
    local fix = love.physics.newFixture(self.body, love.physics.newPolygonShape(path))
    fix:setFriction(o.friction or .5)
    fix:setRestitution(o.restitution or .5)
    self.fixtures[k] = fix

  end)


end

function PhysicsSystem:initialize()
  System.initialize(self)
  self.meter = 50
  love.physics.setMeter(self.meter)
  self.world = love.physics.newWorld(0, 0, true)
end


function PhysicsSystem:gravity(a,b)
  if a == b then return end
  local ax, ay = a.body:getPosition()
  local bx, by = b.body:getPosition()

  local dx,dy = vector.normalize(ax-bx, ay-by)
  local r = vector.dist(ax,ay, bx, by) / self.meter
  if r == 0 then return end
  local f = a.body:getMass() * b.body:getMass() / r^2 * 10 --* 6.674*10^-11

  a.body:applyForce(-dx*f, -dy*f)
  b.body:applyForce(dx*f, dy*f)

end

function PhysicsSystem:update(dt)

  local players = {systems.player:get('Body') }

  self.world:update(dt)
  local bodies = {}
  for k, entity in pairs(self.targets) do
    local body, pos = entity:get('Body'), entity:get('Position')
    _.each(players, function(k,p) self:gravity(p, body) end)
--    bodies[#bodies] = body
    pos.at.x, pos.at.y = body.body:getPosition()
    pos.at.r = body.body:getAngle()
  end

end


function PhysicsSystem:onAddEntity(entity)

  self.last = entity
end

function PhysicsSystem:requires()
  return {"Body", "Position"}
end