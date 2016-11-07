
Rocket = class("Rocket", Entity)

function Rocket:initialize(player, input)
  Entity.initialize(self)
  self.size = 8

  self.player = player
  local ppos = player:get('Position').at
  local dx,dy = vector.normalize(input.x - ppos.x, input.y - ppos.y)

  self:add(Position({at = ppos, z = 2}))

  local body = Body({at = {x = ppos.x + dx * 50, y = ppos.y + dy * 50}})
  body.body:setBullet(true)
  body.body:setLinearDamping(.2)
  local fix = love.physics.newFixture(body.body, love.physics.newCircleShape(self.size), 1000)
  fix:setFriction(.5)
  fix:setRestitution(.3)

  local speed = 100000
  local pbody = player:get('Body').body
  local pvx,pvy = pbody:getLinearVelocity()
  body.body:applyLinearImpulse(dx*speed+pvx, dy*speed+pvy)

  pbody:applyLinearImpulse(dx*-speed/40, dy*-speed/40)

  self:add(body)
  self:add(Render())

  systems.world:add(self)

end

function Rocket:update(dt)
  if vector.len(self:get('Body').body:getLinearVelocity()) < 200 then self:destroy() end
end

function Rocket:destroy()
  systems.world:remove(self)
end

function Rocket:draw()

  love.graphics.setColor(rgba('#EE3636'))

  love.graphics.polygon('fill', 8,0, -1,6, -1,-6)


end

