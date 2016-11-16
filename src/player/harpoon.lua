
Harpoon = class("Harpoon", Entity)

local function ppos(player, dx, dy)
  local p = player:get('Position')
  local px, py = vector.add(p.at.x, p.at.y, vector.rotate(p.at.r, dx or 0, dy or 0))

  return px,py
end

local function getTargetXY(target)
  if target.body then return target.body:getWorldPoint(target.x ,target.y)
  else return target.x, target.y end
end

function Harpoon:initialize(player, input)
  Entity.initialize(self)

  self.player = player
  self.growing = {size = 0}
  self.target = {x = 0, y = 0}

  local px, py = ppos(player)
  local x,y = vector.add(px, py, vector.mul(1000, vector.normalize(input.x - px, input.y - py)))

  local hit = self:findTarget(x, y)
  local target = hit.body and hit or {x = x, y = y }

  local speed = 1500 -- px/sec
  local distance = vector.dist(px, py, getTargetXY(target))
  local time = distance / speed
  self.growing.rate = 1 / time

  Timer.during(time, function(dt) self:grow(dt, target) end, function()
    if self.destroyed then return end
    if hit.body then
      self:connect(hit)
    else self:destroy()
    end
  end)

  self:add(Position({at = {0,0}, z = 2, absolute = true}))

  self:add(Render())

end

function Harpoon:findTarget(x, y)
  local pbody = self.player:get('Body').body
  local px, py = ppos(self.player)

  local hit = {fraction = 2};

  local function getBody(fixture, x, y, xn, yn, fraction)
    local body = fixture:getBody()
    if body ~= pbody  and hit.fraction > fraction then
      hit.body = body
      hit.fraction = fraction
      hit.x, hit.y = body:getLocalPoint(x, y)
    end

    return -1
  end
  systems.physics.world:rayCast(px, py, x, y, getBody)

  return hit
end

function Harpoon:connect(hit)

  
  local px, py = ppos(self.player)
  local pbody = self.player:get('Body').body
  if hit.body:isDestroyed() then self:destroy() return end
  local bx, by = hit.body:getWorldPoint(hit.x, hit.y)
  self.joint = love.physics.newDistanceJoint(pbody, hit.body, px, py, bx, by, true)
  self.distance = self.joint:getLength()
  self.joint:setFrequency(100)
  self.joint:setDampingRatio(.1)
  local vx, vy = pbody:getLinearVelocity()
  
  
  self.jspeed = vector.rotate((math.atan2(bx, by)-math.pi/2), vx, vy)
  print('v '..vx..',' .. vy ..' = ' .. self.jspeed)
  
--  self.player:push(vector.mul(1000, vector.normalize(bx-px, by-py)))

end

function Harpoon:update(dt)
  if self.joint then
    if self.joint:isDestroyed() then self:destroy() return end
    local l = self.joint:getLength()
    if l < self.distance * 0.7 then self:destroy() return
    else self.joint:setLength(l - (l / self.distance)^2 * self.distance^0.5 * 20 * dt - self.jspeed/3 * dt)

--    self:get('Position')
    end
    if l < self.distance * 0.9 and #self.player:get('Body').body:getContactList() > 0 then self:destroy() return
    end
  
    local n,m
    n,m, self.target.x, self.target.y = self.joint:getAnchors()

  end
end

function Harpoon:destroy()
  self.destroyed = true
  if self.joint then
    if not self.joint:isDestroyed() then self.joint:destroy() end
    self.joint = nil
  end
  systems.world:remove(self)
end


function Harpoon:grow(dt, target)
  if self.destroyed or target.body and target.body:isDestroyed() then return end
  local px, py = ppos(self.player)
  local x, y = getTargetXY(target)
  self.target.x, self.target.y = px + self.growing.size * (x - px), py + self.growing.size * (y - py)
  self.growing.size = self.growing.size + self.growing.rate * dt
end

function Harpoon:draw()

  love.graphics.setColor(rgba('#2B7196'))
  love.graphics.setLineWidth(2)

  local px, py = ppos(self.player, 0, -5)
  love.graphics.line(px,py, getTargetXY(self.target))


end

