
Player = class("Player", Entity)

function Player:initialize(pos)
  Entity.initialize(self)


  self:add(Position({at = pos, center = {20,20}, z = 2}))
  local body = Body({shape = {{-15,15, 15,15, 15,-15, -15,-15}}, mass = 100, at = pos, friction = .8, restitution = 0.1})
  body.body:setBullet(true)
  body.body:setAngularDamping(.9)
  body.body:setLinearDamping(.9)
  self:add(body)
  self:add(Render())

end

function Player:tick(dt)

end

function Player:draw()

  love.graphics.setColor(rgba('#6E6C6C'))
  love.graphics.rectangle("fill", 5, 5, 30, 30)
  
end


function Player:moveTo(target)
  local body, pos = self:get('Body').body, self:get('Position')
  local dx, dy = vector.normalize(target.x - pos.at.x, target.y - pos.at.y)
  body:applyLinearImpulse(dx*0.1, dy*0.1)
end


function Player:hook(target)
  if self.harpoon then self.harpoon:destroy() end
  self.harpoon = Harpoon(self, target)
  systems.world:add(self.harpoon)
end



