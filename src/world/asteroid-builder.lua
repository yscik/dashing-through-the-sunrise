
local HC = require 'lib/hc'

function Asteroid:generate(o)

  local path = _.clone(o.base)
  local steps = {}

  local noise = 1

  local function n(i)
    return ((i-1)%(#path))+1
  end
  local function p(i)
    return path[n(i)]
  end

  local function d(min, max)
    noise = noise+1
    return min + (love.math.noise(noise+o.seed,min+o.seed)*(max-min))
  end

  local function transformMidPoint(rate, ax,ay,bx,by)
    local px,py = vector.mul(d(-rate/2, rate), vector.normalize(vector.rotate(math.pi/2+d(-0.5,0.5), vector.sub(ax,ay,bx,by))))
--    px,py = vector.rotate(0, vector.mul(1, px, py))
--    return vector.add(px,py, vector.mul(0.5, vector.add(ax,ay,bx,by)))
    return px, py
  end

  local function addPoint(i)
    local ax,ay,bx,by = p(i), p(i+1), p(i+2), p(i+3)
    local cx,cy = ax + (bx-ax) /2, ay + (by-ay) / 2
    table.insert(path, i+2, cy)
    table.insert(path, i+2, cx)

  end
  local function displacePoint(i, rate)
    local ax,ay,cx,cy,bx,by = p(i-2), p(i-1), p(i), p(i+1), p(i+2), p(i+3)

    local tx,ty = transformMidPoint(rate, ax,ay,bx,by)
    table.remove(path, i)
    table.remove(path, i)
    table.insert(path, i, cy+ty)
    table.insert(path, i, cx+tx)

  end

  local function subd()
    for i = 1, #path*2, 4 do
      addPoint(i)
    end
  end

  local function noise(rate)
    for i = 1, #path, 2 do
      displacePoint(i, rate)
      end
  end

  local function scale(s)
    local hc = HC.polygon(unpack(_.take(path, #path - 2)))
    hc:scale(s)
    path = {hc:unpack()}
  end


--  steps[#steps+1] = _.clone(path)

--  scale(2)
--  subd()
--  if #o.base > 10 then
--    noise(40)
--  end
--  subd()
--  noise(10)
--  subd()
--  noise(5)

--  smoothPoint(1)
--  smoothPoint(3)
--  smoothPoint(5)

--  steps[#steps+1] = _.clone(path)
--  transform()

--
--  path[#path+1] = path[1]
--  path[#path+1] = path[2]

  return path
--  return steps

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
--  for i = 1, #self.path, 1 do
--    local path = self.path[i]
--    love.graphics.setColor(rgba("#843939", stepSize * i))
--    love.graphics.polygon("line", path)
----    love.graphics.setColor(250,250,250, stepSize * i)
----
----    for i = 1, #path-1, 2 do
----      love.graphics.circle('fill', path[i], path[i+1], 2)
----
----    end
--  end
--
--end