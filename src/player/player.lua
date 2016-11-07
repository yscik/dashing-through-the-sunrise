
Player = class("Player", Entity)

function Player:initialize(pos)
  Entity.initialize(self)

  self.hits = 0
  self.color = {rgba('#F4903B')}

  self:add(Position({at = pos, center = {20,20}, z = 4}))
  local body = Body({shape = {{-30,25, 0,25, 0,-15, -30,-15}}, mass = 70, at = pos, friction = .8, restitution = 0.1})
  body.body:setBullet(true)
  body.body:setAngularDamping(1)
  body.body:setLinearDamping(.5)

  local head = love.physics.newFixture(body.body, love.physics.newCircleShape(-14, -16, 15), 70)
  head:setUserData({contact = function(body, contact) self:headhit(body, contact) end})

  local x,y,mass,inertia = body.body:getMassData()
  body.body:setMassData(0,10, 10, 60000)
  self:add(body)
  self:add(Render())

  self:character()
end

function Player:character()
  self.flip = false
  self.avatar = {leg = -.1, head = -0.1, gun = 0}

end

function Player:headhit(body, contact)
  self.hits = self.hits + 1
end

function Player:update(dt)
    self.avatar.leg = -math.abs(self.avatar.leg + (self:get('Body').body:getAngularVelocity()*0.3 - self.avatar.leg)*dt*5)
--  self.avatar.head = self.avatar.head + dt*0.1

  self.normal = function()
    
  end
end

function Player:draw()

  love.graphics.push()
  love.graphics.scale(0.5)
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


  --gun
  love.graphics.push()
  love.graphics.translate(15,25)
  love.graphics.rotate(-0.1)
  love.graphics.rotate(self.avatar.gun)
  love.graphics.setColor(unpack(self.color))
  love.graphics.rectangle("fill", -40, -13, 100, 25)
  love.graphics.pop()

  --arm
  love.graphics.push()
  love.graphics.translate(10,40)
  love.graphics.rotate(-0.8)
  love.graphics.rotate(self.avatar.gun)
  love.graphics.setColor(rgba('#999999'))
  love.graphics.rectangle("fill", -10, -10, 50, 20)
  love.graphics.pop()

  love.graphics.pop()

  love.graphics.setColor(255,255,255,255)
--  love.graphics.print(self.hits, 100,0)

end


function Player:moveTo(target)
  local body, pos = self:get('Body').body, self:get('Position')
  local dx, dy = vector.normalize(target.x - pos.at.x, target.y - pos.at.y)
  body:applyLinearImpulse(dx*0.1, dy*0.1)
end


function Player:lookAt(target)
  local p = self:get('Position')
  local direction = (vector.angleTo(target.x - p.at.x, target.y - p.at.y, vector.rotate(p.at.r, 1, 0)))
  self.debug = string.format("%.1f, %.1f", direction, p.at.r)
  local dd = direction
  if self.flip then dd = dd * -1 end
  self.avatar.head = math.max(-.9, math.min(.7, self.avatar.head + 0.01 * (dd - self.avatar.head)))
  self.avatar.gun = math.max(-.8, math.min(.8, self.avatar.gun + 0.01 * (dd - self.avatar.gun)))

--  if dd < -math.pi then self.flip = not self.flip end

--  if dd > 1 or dd < -1 then
    self:get('Body').body:applyTorque(100000 * dd)
--    end

end

function Player:hook(target)
  if self.harpoon and self.harpoon.destroyed then self.harpoon = nil end

  if self.harpoon then
    self.harpoon:destroy()
    self.harpoon = nil
  else
    self.harpoon = Harpoon(self, target)
    systems.world:add(self.harpoon)
  end
end


end



