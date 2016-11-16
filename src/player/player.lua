
Player = class("Player", Entity)

function Player:initialize(pos)
  Entity.initialize(self)

  self.hits = 0
  self.color = {rgba('#1060A4') }
  self.asteroids = {}

  self:add(Position({at = pos, center = {20,20}, z = 4}))
  local body = Body({shape = {{-5,10, 5,10, 5,-20, -5,-20}}, mass = 200, at = pos, friction = .7, restitution = 0.1})
  body.body:setBullet(true)
  body.body:setAngularDamping(.6)
  body.body:setLinearDamping(.1)

  local head = love.physics.newFixture(body.body, love.physics.newCircleShape(0, -15, 8), 70)
  head:setUserData({contact = function(body, contact) self:headhit(body, contact) end})

  self.foot = love.physics.newFixture(body.body, love.physics.newPolygonShape({-5,10, 5,10, 5,8, -5,8}), 70)

  local x,y,mass,inertia = body.body:getMassData()
  body.body:setMassData(0,5, 100, 160000)
  self:add(body)
  self:add(Render())
  self:add(Velocity())

  self:character()
end

function Player:character()
  self.avatar = {leg = -.1, head = -0.1, gun = 0}

end

function Player:headhit(body, contact)
  self.hits = self.hits + 1
end

function Player:isLanded()
  local contacts = self:get('Body').body:getContactList()
  local u;

  _.each(contacts, function(k, contact)
    local a,b = contact:getFixtures()
    if a == self.foot then u = b:getUserData() end
    if b == self.foot then u = a:getUserData() end
  end)

  if u and u.component and u.component.entity and u.component.entity.class.name == 'Asteroid' then
    self.asteroid = u.component.entity
  else self.asteroid = nil end
end

function Player:update(dt)
  self:isLanded()
  local f = self:get('Position').flipped and -1 or 1
  self.avatar.leg = -math.abs(self.avatar.leg + (self:get('Body').body:getAngularVelocity()*f*0.7 - self.avatar.leg)*dt*10)
--  self.avatar.head = self.avatar.head + dt*0.1

  self.normal = function()
    
  end
end

function Player:draw()

  love.graphics.push()
  love.graphics.scale(0.3)
  love.graphics.translate(60, 10)
  if self:get('Position').flipped then
    love.graphics.scale(-1, 1)
    love.graphics.translate(-15, 0)

  end
  love.graphics.setColor(rgba('#6E6C6C'))

  --body
  love.graphics.setColor(rgba('#999999'))
  love.graphics.rectangle("fill", 5, 5, 20, 50)

  --leg
  love.graphics.push()
  love.graphics.translate(15,50)
  love.graphics.rotate(self.avatar.leg)
  love.graphics.setColor(rgba('#999999'))
  love.graphics.rectangle("fill", -10, 0, 22, 44)
  love.graphics.pop()

  --jetpack
  love.graphics.setColor(rgba('#cccccc'))
  love.graphics.rectangle("fill", -15, 0, 30, 70)

  --head
  love.graphics.push()
  love.graphics.translate(10,10)
  love.graphics.rotate(self.avatar.head)
  love.graphics.setColor(rgba('#cccccc'))
  love.graphics.circle("fill", 0, 0, 30)
  love.graphics.rotate(0.1)
  love.graphics.setColor(rgba('#111111'))
  love.graphics.rectangle("fill", -19, -20, 50, 40)
  love.graphics.pop()

--
--  --gun
--  love.graphics.push()
--  love.graphics.translate(15,25)
--
--  love.graphics.rotate(self.avatar.gun)
--  love.graphics.setColor(unpack(self.color))
--  love.graphics.rectangle("fill", -40, -13, 100, 25)
--  love.graphics.pop()

  --arm
  love.graphics.push()
  love.graphics.translate(10,40)
  --  love.graphics.rotate(-0.8)
  love.graphics.rotate(self.avatar.gun)
--  love.graphics.setColor(unpack(self.color))
--  love.graphics.rectangle("fill", 10, -15, 20, 20)
  love.graphics.setColor(rgba('#999999'))
  love.graphics.rectangle("fill", -10, -10, 50, 20)
  love.graphics.pop()

  love.graphics.pop()

  love.graphics.setColor(255,255,255,255)
--  love.graphics.print(self.debug, 100,0)

end


function Player:moveTo(target)
  local body, pos = self:get('Body').body, self:get('Position')
  local dx, dy = vector.normalize(target.x - pos.at.x, target.y - pos.at.y)
  body:applyLinearImpulse(dx*0.1, dy*0.1)
end


local function normalizeAngle(a)
  return a == 0 and 0 or a / math.abs(a) * (math.abs(a) % (math.pi * 2))
end
function Player:lookAt(target)
  local p = self:get('Position')

--  local r = normalizeAngle(p.at.r)

  local direction = math.atan2(vector.rotate(-p.at.r, target.x - p.at.x, target.y - p.at.y))

  p.flipped = direction < 0
  local f = p.flipped and -1 or 1

  local dd = -math.abs(direction) + 1.5
--  local dd = direction/math.abs(direction) * (math.abs(direction) % (math.pi))

  self.debug = string.format("%.1f, %.1f", direction, p.at.r)
--  if self.flip then dd = dd * -1 end
  self.avatar.head = math.max(-1, math.min(1, dd))
  self.avatar.gun = dd

--  if dd < -math.pi then self.flip = not self.flip end

--  if dd > 1 or dd < -1 then
--    self:get('Body').body:applyTorque(100000 * dd * f)
--    end

end

function Player:hook(target)
  if self.harpoon and self.harpoon.destroyed then self.harpoon = nil end

  if self.harpoon then
    self.harpoon:destroy()
    self.harpoon = nil
  end

  self.harpoon = Harpoon(self, target)
  systems.world:add(self.harpoon)
--  end
end

function Player:capture()
  if self.asteroid then
    self.asteroid:capture(self)
  end
end

function Player:fire(target)
  Rocket(self, target)
end

function Player:push(...)
  self:get('Body').body:applyForce(...)
end

function Player:move(d)
  local p = self:get('Position')
  self:get('Body').body:applyForce(vector.rotate(p.at.r, 4000 * d * (p.flipped and -1 or 1), 0))
end

function Player:rotate(d)
  self:get('Body').body:applyTorque(300000 * d)
end
