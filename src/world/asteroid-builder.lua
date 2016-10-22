
local Polygon = require 'lib/hc.polygon'
local v2 = require 'lib/hump/vector'

function Asteroid:generate(o)

  local path = _.clone(o.base)
  local steps = {}
  local mark = {}
  local normal = {}


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

  local function getNormal(i)
    local a, c, b = v2(p(i-2), p(i-1)), v2(p(i), p(i+1)), v2(p(i+2), p(i+3))

    return ((a - c) + (c - b)):rotated(math.pi/2):normalized():unpack()


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
    local newPath = {}
    local shape = Polygon(unpack(path))
    for i = 1, #path, 2 do
      local nx, ny = getNormal(i)

      local cx, cy = p(i), p(i+1)
      normal[i], normal[i+1] = nx, ny
      newPath[i], newPath[i+1] = cx + nx * s, cy + ny * s
    end
    path = newPath
  end

  mark[3] = true

  local function step()
    steps[#steps+1] = {path = _.clone(path), normal = normal, mark = mark }
    normal = {}
  end
--
--  local function scale(s)
--    local hc = Polygon(unpack(path))
--    hc:scale(s)
--    path = {hc:unpack()}
--  end


  subd()
  scale(0)
  step()

    noise(10)
--  scale(20)
--  step()

  scale(-60)

  step()

--  return path

   return steps

end

function Asteroid:update(dt)
  self.options.seed = self.options.seed + 1
  self.path = self:generate(self.options)
end

function Asteroid:draw ()

  local stepSize = (255 / #self.path)


  for s = 1, #self.path, 1 do
    local step = self.path[s]
    love.graphics.setLineWidth(2)
    love.graphics.setColor(rgba("#843939", stepSize * s))
    love.graphics.polygon("line", step.path)


    for i = 1, #step.path-1, 2 do
      if step.mark[i] then love.graphics.setColor(rgba("#00C619"))
      else love.graphics.setColor(250,250,250, stepSize * s)
      end

      love.graphics.circle('fill', step.path[i], step.path[i+1], 2)

    end

    if #step.normal == #step.path then
    for i = 1, #step.path-1, 2 do
      love.graphics.setLineWidth(1)
      love.graphics.setColor(rgba("#499D53", stepSize * s))
      love.graphics.line(step.path[i], step.path[i+1], step.path[i] + step.normal[i]*20, step.path[i+1] + step.normal[i+1]*20)
    end
    end

  end

end