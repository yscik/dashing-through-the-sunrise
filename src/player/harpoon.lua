
Harpoon = class("Harpoon", Entity)

local function ppos(player, dx, dy)
  local p = player:get('Position')
  local px, py = vector.add(p.at.x, p.at.y, vector.rotate(p.at.r, dx or 10, dy or 10))

  return px,py
end

function Harpoon:initialize(player, input)
  Entity.initialize(self)

  self.player = player
  self.growing = {size = 0}
  self.target = {x = 0, y = 0}

  local px, py = ppos(player)
  local x,y = vector.add(px, py, vector.mul(1000, vector.normalize(input.x - px, input.y - py)))

  local hit = self:findTarget(x, y)
  local target = hit.body and {x = hit.x, y = hit.y} or {x = x, y = y }

  local speed = 1500 -- px/sec
  local distance = vector.dist(px, py, target.x, target.y)
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
  local px, py = ppos(self.player, 30, -20)

  local hit = {fraction = 2};

  local function getBody(fixture, x, y, xn, yn, fraction)
    local body = fixture:getBody()
    if body ~= pbody  and hit.fraction > fraction then
      hit.body = body
      hit.x, hit.y, hit.fraction = x, y, fraction
    end

    return -1
  end
  systems.physics.world:rayCast(px, py, x, y, getBody)

  return hit
end

function Harpoon:connect(hit)

  local px, py = ppos(self.player)
  local pbody = self.player:get('Body').body
  self.joint = love.physics.newDistanceJoint(pbody, hit.body, px, py, hit.x, hit.y, true)
  self.distance = self.joint:getLength()
  self.joint:setFrequency(10000)
  self.joint:setDampingRatio(.9)

end

function Harpoon:update(dt)
  if self.joint then
    local l = self.joint:getLength()
    if l < 50 then self:destroy()
    else self.joint:setLength(self.joint:getLength() - self.distance^0.5 * 10 * dt)

--    self:get('Position')
    end
    if l < self.distance * 0.9 and #self.player:get('Body').body:getContactList() > 0 then self:destroy() end

  end
end

function Harpoon:destroy()
  self.destroyed = true
  if self.joint then
    self.joint:destroy()
    self.joint = nil
  end
  systems.world:remove(self)
end

function Harpoon:grow(dt, target)
  if self.destroyed then return end
  local px, py = ppos(self.player)
  self.target.x, self.target.y = px + self.growing.size * (target.x - px), py + self.growing.size * (target.y - py)
  self.growing.size = self.growing.size + self.growing.rate * dt
end

function Harpoon:draw()

  love.graphics.setColor(rgba('#4F4444'))
  love.graphics.setLineWidth(2)

  if self.joint then
    local px, py = ppos(self.player, 10, -10)
    local target = {self.joint:getAnchors()}
    love.graphics.line(px, py, target[3], target[4])
  else
    local px, py = ppos(self.player, 10, -10)
    love.graphics.line(px,py, self.target.x, self.target.y)
  end


end

