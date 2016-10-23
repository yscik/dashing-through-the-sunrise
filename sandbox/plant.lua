
Plant = class("Plant")

local vector = require 'lib/hump/vector'

function Plant:initialize()

  self.paths = self:generate()
end

local function n(min, max, ...)
  return min + (max-min) * love.math.noise(...)
end


local function getNormal(a, p, b)
  return ((a - p) + (p - b)):rotated(math.pi/2):normalized()

end


local function thicken(path, size)

  local maxw = size
  local function w(i)
    return maxw - (i-2) * maxw / #path
  end
  local rects = {}
  for i = 2, #path, 1 do
    local a,b,c = path[i-1], path[i], path[i+1] or path[i]
    if not a.normal then a.normal = getNormal(path[i-2] or a, a, b) end
    b.normal = getNormal(a,b,c)

    local wa, wb = w(i), w(i+1)
    rects[#rects+1] = {a + a.normal * wa, b + b.normal * wb, b - b.normal * wb, a - a.normal * wa}
  end

  return rects
end

local function line(center, angle, size, seed, thickness)

  local path = { center }

  if(size < 2) then return nil end
  local count = math.max(2, size)
  local v = vector(0,-1):rotated(angle)

  local d = -1 + love.math.noise(seed) * 2
  for i = 2, count, 1 do

    local prev = path[i-1]
    local p = (30 * ((size-i)/(size)) * v:rotated(n(-1, 1, prev.x / 50, prev.y/50, seed)))

    path[i] = prev + p

  end

  local branches = {}
  for b = 1, count, 1 do
    local bd = (b/2 % 2 == 0 and 1 or -1)
    if b < count / 3 * 2 and b % 2 == 0 then
      _.push(branches, line(path[b], angle + (math.pi/3) * bd, (size - b) / 2, seed+b, (count-b)/count * thickness))
--    else if count > 4 then
--      _.push(branches, line(path[b], angle + (math.pi/3) * bd, 3, seed+b, 3))
--    end
    end
  end


  return {path = path, outline = thicken(path, thickness)}, unpack(branches)

end

function Plant:generate(o)
  o = _.defaults(o or {}, {
    size = 2,
    seed = love.math.random()
  })
  self.o = o

  local center = vector(0,0)


--  local b1 = line(outline[math.floor(scale/2)], 0.7, scale/2, seed+1)
--  local b2 = line(outline[math.floor(scale/4)], -0.4, scale/2, seed+2)
--  local b3 = line(b2[3], -0.8, scale/4, seed+3)
--  local b4 = line(b1[3], 1, scale/4, seed+4)

  return {line(center, 0, o.size, o.seed, 2)}
end

function Plant:reseed()
  self.paths = self:generate()
end

function Plant:grow(dt)
  self.o.size = math.min(self.o.size + dt, 25)
  self.o.seed = self.o.seed + dt/100
  self.paths = self:generate(self.o)
end
function Plant:update(dt)
  self:grow(dt)
end

function getPoints(vectorlist)
  local s1 = _.map(vectorlist, function(k,v)
      return {v:unpack()}  end)
  local s2 = _.flatten(s1)
  return unpack(s2)
end

function Plant:draw ()

  local stepSize = (255 / #self.paths)

  for s = 1, #self.paths, 1 do
    local path = self.paths[s].path
--    local op = stepSize * s
    local op = 255

    local outline = self.paths[s].outline
    for i = 1, #outline, 1 do
      love.graphics.setColor(115,115,115, 255)
      love.graphics.polygon('fill', getPoints(outline[i]))
    end

    love.graphics.setLineWidth(1)
    love.graphics.setColor(119, 68, 82, op)
--    love.graphics.line(getPoints(path))

    for i = 1, #path, 1 do
      local p = path[i]
      love.graphics.setColor(200,200,200, op)
--      end

--      love.graphics.circle('fill', p.x, p.y, 1)

--      if p.normal then
--        love.graphics.setLineWidth(1)
--        love.graphics.setColor(54, 153, 90)
--        love.graphics.line(p.x, p.y, p.x + p.normal.x*10, p.y + p.normal.y*10)
--      end

    end


  end

end