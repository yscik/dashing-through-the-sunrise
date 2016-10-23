
local v2 = require 'lib/hump/vector'

local function circle(center, scale, seed)

  local path = {}

  local count = scale^0.5 * 8
  local baseAngle = math.pi*2 / count
  local v = v2(0,1)

  for i = 1, count, 1 do

    v = v:rotated(baseAngle)
    local p = v * (scale*1 + love.math.noise(seed, v.x, v.y)*scale * 30 + love.math.random(0, scale * 1))

    path[i] = center + p

  end

  return path

end


local function getPoints(vectorlist)
  local s1 = _.map(vectorlist, function(k,v)
    return {v:unpack()}  end)
  local s2 = _.flatten(s1)
  return unpack(s2)
end

function Asteroid:generate(o)
  local scale = o.size or love.math.random(3,15)
  local seed = o.seed or love.math.random(-1000, 1000)
  local center = v2(0,0)

  local outline = circle(center, scale, seed)
  --
  --  local a = (outline[4] - center) * 0.5
  --  local inside1 = circle(a, scale / 2, seed +1)
  --
  --  local b = (inside1[4] - a) * 0.5 + a
  --  local inside2 = circle(b, scale / 3, seed +2)

  return getPoints(outline)
end


--
--function Asteroid:update(dt)
--  self.options.seed = self.options.seed + 1
--  self.path = self:generate(self.options)
--end
--
--function Asteroid:draw ()
--
--  local stepSize = (255 / #self.path)
--
--
--  for s = 1, #self.path, 1 do
--    local step = self.path[s]
--    love.graphics.setLineWidth(2)
--    love.graphics.setColor(rgba("#843939", stepSize * s))
--    love.graphics.polygon("line", step.path)
--
--
--    for i = 1, #step.path-1, 2 do
--      if step.mark[i] then love.graphics.setColor(rgba("#00C619"))
--      else love.graphics.setColor(250,250,250, stepSize * s)
--      end
--
--      love.graphics.circle('fill', step.path[i], step.path[i+1], 2)
--
--    end
--
--    if #step.normal == #step.path then
--    for i = 1, #step.path-1, 2 do
--      love.graphics.setLineWidth(1)
--      love.graphics.setColor(rgba("#499D53", stepSize * s))
--      love.graphics.line(step.path[i], step.path[i+1], step.path[i] + step.normal[i]*20, step.path[i+1] + step.normal[i+1]*20)
--    end
--    end
--
--  end
--
--end