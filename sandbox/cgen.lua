
Asteroid = class("Asteroid")

local vector = require 'lib/hump/vector'

function Asteroid:initialize()

  self.paths = self:generate()
end

function Asteroid:generate()
  local scale = love.math.random(3,15)
  local seed = love.math.random(-1000, 1000)
  local center = vector(0,0)

  local outline = circle(center, scale, seed)
--
--  local a = (outline[4] - center) * 0.5
--  local inside1 = circle(a, scale / 2, seed +1)
--
--  local b = (inside1[4] - a) * 0.5 + a
--  local inside2 = circle(b, scale / 3, seed +2)

  return {outline} --, circle(center, scale*0.61, seed+0.23), circle(center, scale*0.31, seed+0.49)}
end

function circle(center, scale, seed)

  local path = {}

  local count = scale^0.5 * 30
  local baseAngle = math.pi*2 / count
  local v = vector(0,1)

  for i = 1, count, 1 do

    v = v:rotated(baseAngle)
    local p = v * (scale*1 + love.math.noise(seed, v.x, v.y)*scale * 30 + love.math.random(0, scale * 1))

    path[i] = center + p

  end

  return path

end


function Asteroid:reseed()
  self.paths = self:generate()
end

function getPoints(vectorlist)
  local s1 = _.map(vectorlist, function(k,v)
      return {v:unpack()}  end)
  local s2 = _.flatten(s1)
  return unpack(s2)
end

function Asteroid:draw ()

  local stepSize = (255 / #self.paths)

  for s = 1, #self.paths, 1 do
    local path = self.paths[s]
--    local op = stepSize * s
    local op = 255
    love.graphics.setLineWidth(6)
    love.graphics.setColor(200, 160, 100, op)
    love.graphics.polygon("line", getPoints(path))


    for i = 1, #path, 1 do
--      if path.mark[i] then love.graphics.setColor(rgba("#00C619"))
--      else
      love.graphics.setColor(200,200,200, op)
--      end

--      love.graphics.circle('fill', path[i].x, path[i].y, 1)

    end
--
--    if #path.normal == #path.path then
--      for i = 1, #path.path-1, 2 do
--        love.graphics.setLineWidth(1)
--        love.graphics.setColor(rgba("#499D53", stepSize * s))
--        love.graphics.line(path.path[i], path.path[i+1], path.path[i] + path.normal[i]*20, path.path[i+1] + path.normal[i+1]*20)
--      end
--    end

  end

end