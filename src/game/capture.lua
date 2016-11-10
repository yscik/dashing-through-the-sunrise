Capture = class("Capture", Entity)

function Capture:initialize(asteroid, player)
  Entity.initialize(self)
  self.asteroid = asteroid
  self.state = 0
  self:start(player)
  self:add(Render())
end

function Capture:draw()
  local height = 100
  if self.state > 0 then
    love.graphics.setColor(200,200,200,255)
    love.graphics.setLineWidth(2)
    local p = self.point
    local top = -self.state/100*height
    love.graphics.line(0, 0, 0, top)
    love.graphics.setColor(self.player.color)
    love.graphics.polygon('fill', 0,top, 0,top*0.7, -top*0.3,top * 0.85)

--    love.graphics.print("cap " .. self.state, 0, 0)
  end
end

function Capture:start(player)
  self.state = 40
  self.player = player
  local ppos = player:get('Position')
  local px, py = self.asteroid:get('Body').body:getLocalPoint(ppos:getXY())
  local p = self.asteroid:get('Position')
  local r = vector.angleTo(ppos.at.x - p.at.x, ppos.at.y - p.at.y)
  local dx, dy = vector.rotate(r, -55, 20)

  self:add(Position({at = {x = px + dx, y = py + dy, r = ppos.at.r - p.at.r}, parent = p}))

  self.inProgress = true
  self.capturing = true

end

function Capture:update(dt)
  if not self.inProgress then return end

  local speed = dt * 25
  if self.capturing then
    self.state = self.state + speed
    if self.state >= 100 then self:done() end
  else
    self.state = self.state - speed
    if self.state < 40 then self:cancel() end
  end

  self.capturing = false
end

function Capture:done()
  self.state = 100
  self.captured = true
  self.inProgress = false
end

function Capture:cancel()
  self.state = 0
  self.player = nil
  self.inProgress = false

  self.asteroid:capture_end(self)
  systems.world:remove(self)
end


function Capture:progress()
  self.capturing = true
end