
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
  self:add(Position({at = {x = -1500 -options.scale*3, y = options.scale / 2}, z = 5, absolute = true}))
  self:add(Render())
  self.v = Velocity(40, 0)
  self:add(self.v)

  Timer.during(10, function(dt)
    self:addV(10, dt)
  end)

end

function Sun:draw ()

  love.graphics.push()
  love.graphics.setBlendMode('add', 'premultiplied')
  love.graphics.translate(self.status.percent, 0)
  love.graphics.scale(self.r, self.r)
  _.each(self.path, function(k, path)
    love.graphics.setColor(unpack(path.color))
    love.graphics.push()
    love.graphics.rotate(path.r)
    love.graphics.translate(path.d*40, 0)
    _.each(path.paths, function(k, tri)
        love.graphics.polygon("fill", tri)
    end)
    love.graphics.pop()
  end)
  love.graphics.setBlendMode('alpha', 'alphamultiply')
  love.graphics.pop()

end

function Sun:update(dt)
  self.t = self.t + dt
--  self.r = self.r + 0.01 * dt
  _.each(self.path, function(k, path)
    path.r = path.r + (3*love.math.noise(k * self.t * 0.1) - 1.5) * dt * 0.04
--    path.d = path.d + (love.math.random() - 0.5 - path.d) * 1 * dt
  end)

  self.status.percent = self.status.percent + dt
  self:addV(1, dt)
end

function Sun:addV(amount, dt)
  self.v.x = self.v.x + amount * dt
end


local function circle(size, scale, seed)

  local path = {}

  local count = 5 + size^0.5 * 6
  local baseAngle = math.pi*2 / count
  local v = v2(0,1)

  for i = 1, count, 1 do

    v = v:rotated(baseAngle)
    local p = v * (1500 + size + scale * 20 + scale^2*1 + love.math.noise(seed*100, v.x, v.y) * 10 + love.math.random(0, scale))

    path[#path+1],path[#path+2] = p.x, p.y

  end

  return path

end

function Sun:generate(o)

  local size = o.scale
  local seed = o.seed or love.math.random()
  self.seed = seed

  local paths = {}

  local color = 15
  local sat_base = 255

  local function add(i)
    paths[#paths+1] = {
      color = {HSL(math.random(color-15, color+20), sat_base - i *14, 90 - i * 4, 250 - i * 10)},
      r = math.random(-1,1),
      d = love.math.noise(i/100),
      paths = love.math.triangulate(unpack(circle(size, i, seed)))
    }
  end

  for i = 13, 1, -1 do add(i) end

  return {paths = paths }

end