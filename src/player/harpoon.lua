
Harpoon = class("Harpoon", Entity)

function Harpoon:initialize(player, input)
  Entity.initialize(self)

  self.player = player
  self.growing = {size = 0}
  self.target = {x = 0, y = 0}
  local px,py = self.player:get('Position'):getXY()
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

  self:add(Position({at = {0,0}, z = 2}))

  self:add(Render())

end

function Harpoon:findTarget(x, y)
  local ppos, pbody = self.player:get('Position'), self.player:get('Body').body
  local hit = {fraction = 2};

  local function getBody(fixture, x, y, xn, yn, fraction)
    local body = fixture:getBody()
    if body ~= pbody  and hit.fraction > fraction then
      hit.body = body
      hit.x, hit.y, hit.fraction = x, y, fraction
    end

    return -1
  end
  systems.physics.world:rayCast(ppos.at.x, ppos.at.y, x, y, getBody)

  return hit
end

function Harpoon:connect(hit)

  local ppos, pbody = self.player:get('Position'), self.player:get('Body').body
  self.joint = love.physics.newDistanceJoint(pbody, hit.body, ppos.at.x, ppos.at.y, hit.x, hit.y, true)
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
  local px, py = self.player:get('Position'):getXY()
  self.target.x, self.target.y = px + self.growing.size * (target.x - px), py + self.growing.size * (target.y - py)
  self.growing.size = self.growing.size + self.growing.rate * dt
end

function Harpoon:draw()

  love.graphics.setColor(rgba('#D6BE80'))
  love.graphics.setLineWidth(2)

  if self.joint then
    love.graphics.line(self.joint:getAnchors())
  else
    local px,py = self.player:get('Position'):getXY()
    love.graphics.line(px,py, self.target.x, self.target.y)
  end


end

