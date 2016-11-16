
Director = class("Director", Entity)

function Director:initialize()
  Entity.initialize(self)
  self.screen = {}
  self.screen.w, self.screen.h = love.graphics.getDimensions()
  print(self.screen.w)
end

function Director:update(dt)
  
  local sun = systems.sun
  local sunpos = sun:get('Position')
  local player = systems.player
  local ppos = player:get('Position')
  
  sun.distance = ppos.at.x - sunpos.at.x
   
  if sun.distance < -300 then
    systems.state:stop()
    return
  end
  
  for c, cluster in pairs(systems.cluster.nearby) do
  if cluster ~= nil then for k, asteroid in pairs(cluster) do
  
    local p = asteroid:get('Position')
    local dist = p.at.x - sunpos.at.x
  
    if(p.visible) then
  
      if dist > 40 then
        local body = asteroid:get('Body').body
        body:applyForce(-1 * body:getMass() * 100000 / (10 + dist/10)^2, 0)
      end
      if not asteroid.options.debris and dist < 160 then
        cluster[k] = nil
        local debris = asteroid:explode()
        _.push(cluster, unpack(debris))
      end
    end
    if asteroid.options.debris and dist < -200 then
      cluster[k] = nil
      systems.world:remove(asteroid)
    end
  end end
  end

--  sun.status.percent = sun.status.percent + dt
  sun:addV(1, dt)
  
  sunpos.at.x = sunpos.at.x + math.max(0, (ppos.at.x - self.screen.w/1.8 - sunpos.at.x) * 1 * dt)
  
  sunpos.at.y = sunpos.at.y + (ppos.at.y - sunpos.at.y) * 1 * dt
  
  if sun.distance < 800 then
    local rate = (800-sun.distance)/100
    systems.camera:move(math.random(-rate,rate), math.random(-rate,rate))
  end

end

