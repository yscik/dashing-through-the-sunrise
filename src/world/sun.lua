
Sun = class("Sun", Entity)
local v2 = require 'lib/hump/vector'

function Sun:initialize(options)
  Entity.initialize(self)

  self.options = options
  self.status = {percent = -100, scale = options.scale}

  local data = self:generate(options)
  self.path = data.paths
  self.t = 0.5
  self.r = 1
  self.radius = options.scale
  
  self:add(Position({z = 5}))
  self:add(Render())
  self.v = Velocity(0, 0)
  self:add(self.v)

  self.distance = 0

end

function Sun:start()
  
  Timer.during(15, function(dt)
    self:addV(10, dt)
  end)

end

function Sun:reset()
  self.t = 0.5
  local pos = self:get('Position')
  pos.at.x, pos.at.y = -self.options.scale*1.6, self.options.scale / 2
  self.v.x, self.v.y, self.v.r = 40, 0, 0
end

function Sun:draw ()

  love.graphics.push()
  love.graphics.setBlendMode('add', 'premultiplied')
--  love.graphics.scale(0.25)
  love.graphics.translate(-850, -self.radius*3)
  _.each(self.path, function(k, path)
    love.graphics.setColor(unpack(path.color))
    love.graphics.push()
--    love.graphics.rotate(path.r)
    love.graphics.translate(path.d * 20, path.r*self.radius)
    _.each(path.paths, function(k, tri)
--        love.graphics.polygon("line", tri)
        love.graphics.polygon("fill", tri)
    end)
    love.graphics.pop()
  end)
  love.graphics.setBlendMode('alpha', 'alphamultiply')
  love.graphics.pop()

end

function Sun:update(dt)
  self:animate(dt)
end

function Sun:animate(dt)
  self.t = self.t + dt
--  self.r = self.r + 0.01 * dt
  _.each(self.path, function(k, path)
--    print(math.round(love.math.noise(self.t)))
    path.r = math.clamp(-1, path.r - (3*love.math.noise(k, self.t/10) - 1.5) * dt * 0.05, 1)
    path.d = math.clamp(-1, path.r - (3*love.math.noise(k, self.t/20) - 1.5) * dt * 0.1, 1)
  end)


end

function Sun:addV(amount, dt)
  self.v.x = self.v.x + amount * dt
end


local function circle(size, scale, seed)
  
  local w = scale * 15
  print('path')
  print(size)
  local path = {0,0}

  local count = size/100
  
  local v = v2(1,0)

  for i = 0, count, 1 do
    local d = math.abs(i - count/2) / (count/2)
    
    local px, py = math.max(1, w + math.cos(math.asin(d)) * 500 - love.math.noise(10/scale, i/10) * 50 - love.math.random(0, scale)), i * 100
    --
    print(px, py)
    path[#path+1],path[#path+2] = px, py
  end
  
  path[#path+1],path[#path+2] = 0, size
  
  
  return path

end

function Sun:generate(o)

  local size = o.scale * 6
  local seed = o.seed or love.math.random()
  self.seed = seed

  local paths = {}

  local color = 6
  local sat_base = 255

  local function add(i)
    paths[#paths+1] = {
      color = {HSL(math.random(color-15, color+20), sat_base - i *6, 105 - i * 4, 250 - i * 10)},
      r = 0,
      d = love.math.noise(i/100),
      paths = love.math.triangulate(unpack(circle(size, i, seed)))
    }
  end

  for i = 30, 1, -1 do add(i) end
  
  paths[#paths+1] = {
    color = {255, 255, 255, 255},
    r = 0,
    d = 0,
    paths = {{50,0, 50, size, -size, size, -size, 0}}
  }

  return {paths = paths }

end