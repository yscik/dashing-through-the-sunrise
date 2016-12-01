
GameState = class('GameState')

function GameState:initialize()
  self.menu = Menu()
  self.splash = Splash()
  self.showmenu = true
  self.timer = Timer()
end

function GameState:load()
  
  self.generating = true
  self.loading = true
  local seed = love.math.random(10000,2^50)
  love.math.setRandomSeed(seed)
  systems.sun:reset()
  systems.pool:asteroids()
  systems.pool.done = function()
    self:create()
    self.loading = false
    systems.pool:asteroids()
    systems.pool.done = function()
      self.generating = false
    end
   end
  systems.camera:lookAt(-400, 0)
  systems.camera.speed = 1
end

function GameState:create()
  
  if self.started then self:cleanup() end
  
  local seed = love.math.random(10000,2^50)
  love.math.setRandomSeed(seed)

  systems.cluster = LocalCluster()
  systems.world:add(systems.cluster)
  systems.sun:reset()
  systems.player = Player({x=100,100})
  systems.player:push(100000, 0)
  systems.world.player = systems.player
  systems.world:add(systems.player)
  systems.score:reset()
  
  local pos = systems.player:get("Position")
  systems.camera:lookAt(pos.at.x - 500, pos.at.y)
  
  local v = systems.player:get('Velocity')
  v.x, v.y, v.r = 3, 4, -0.1
  
  self:updateGame(1/60)
end

function GameState:start()
  if self.started then self:create() end
  self.started = true
  self.running = true
  self.showmenu = false
  systems.sun:start()
  
  local pos = systems.player:get("Position")
  local v = systems.player:get('Velocity')
  v.x, v.y, v.r = 0, 0, 0
  local b = systems.player:get('Body').body
  b:setPosition(pos.at.x, pos.at.y)
  b:setAngle(pos.at.r)
  
  
  self.tick = Timer.every(1, function() systems.world:tick(1) end)
  self.timer:after(3, function() systems.camera.speed = 10 end)
  if self.closing then self.timer:cancel(self.closing) end
end

function GameState:stop()
  self.running = false
  Timer.cancel(self.tick)
  self.showmenu = true
--  end)
  self.closing = self.timer:during(5, function(dt)
    systems.sun:addV(-20, dt)
    MovementSystem.move(systems.sun, dt)
  end)
end

function GameState:resume()
  self.running = true
  self.paused = false
  end

function GameState:pause()
  if self.paused then self:resume()
  else if self.running then
    self.running = false
    self.paused = true
  end
  end
end

function GameState:cleanup()
  systems.cluster:destroy()
  systems.world:remove(systems.cluster)
  systems.world:remove(systems.player)
  systems.world.player = nil
  systems.player = nil


end

local function moveCamera(dt, x, y)
  systems.camera:move((x - systems.camera.x)*systems.camera.speed*dt, (y - systems.camera.y)*systems.camera.speed*dt)
end

function GameState:updateGame(dt)
  systems.world:update(dt)
  systems.engine:update(dt)
  
  local pos = systems.player:get("Position")
  moveCamera(dt, pos.at.x + 200, pos.at.y)
end

function GameState:update(dt)
  self.timer:update(dt)
  if self.generating then
    systems.pool:update(dt)
  end
  if self.loading then
--    systems.input:update(dt)
    self.splash:update()
    systems.sun:animate(dt)
    
  else if self.running then
    Timer.update(dt)
    self:updateGame(dt)
    
  else
    self.menu:update()
--    systems.cluster:update(dt)
  
    
    systems.input:update(dt)
    systems.sun:animate(dt)
    MovementSystem.move(systems.player, dt)
  end
  end
end

