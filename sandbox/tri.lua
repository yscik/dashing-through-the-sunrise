
local Delaunay = require 'lib/delaunay'
local Point    = Delaunay.Point
local Polygon = require('lib/hc.polygon')
local vector = require 'lib/hump/vector'

Asteroid = class("Asteroid")

function Asteroid:initialize()

  self.paths = self:generate()
end


local function getPoints(vectorlist)
  local s1 = _.map(vectorlist, function(k,v)
    return {v.x, v.y}  end)
  local s2 = _.flatten(s1)
  return unpack(s2)
end

local function circle(center, scale, seed)

  local path = {}

  local count = scale^0.5 * 30
  local baseAngle = math.pi*2 / count
  local v = vector(0,1)

  for i = 1, count, 1 do

    v = v:rotated(baseAngle)
    local p = center + v * (scale*1 + love.math.noise(seed*100, v.x, v.y)*scale * 30 + love.math.random(0, scale * 1))

    path[i] = Point(p.x, p.y)

  end

  return path

end


local function grid(poly, cell_size, variance)

  local x1,y1, x2, y2 = poly:bbox()
  local half_cell_size = cell_size * 0.5
  local margin = 0

  local points = {}
  for i = x1 + margin, x2 - margin, cell_size do
    for j = y1 + margin, y2 - margin, cell_size do

      if poly:contains(i,j) then

      local x = (i + half_cell_size) + love.math.random(-variance, variance)
      local y = (j + half_cell_size) + love.math.random(-variance, variance)

--      if poly:contains(x,y) then

      points[#points+1] = Point(math.floor(x), math.floor(y))
      end
  end
  end

  return points

end

function Asteroid:generate()
  local scale = love.math.random(3,15)
  local seed = love.math.random()
  local center = vector(0,0)
  self.seed = seed
  local outline = circle(center, scale, seed)


  local poly = Polygon(getPoints(outline))
  local cellsize = 20


  local points = grid(poly, cellsize, cellsize/3)
  _.push(points, unpack(outline))

--  return {points}

  local tris = _.filter(Delaunay.triangulate(unpack(points)), function(k, tri)
--    return true
    return poly:contains(tri:getCenter())
  end)

  local n = function(x,y)
    local scale = 600
    return love.math.noise(self.seed + (x/scale), self.seed + (y/scale))
  end

  local color = love.math.random(-5, 20)
  local sat_base = love.math.random(0, 20)
  return _.map(tris, function(k, tri)
    local cx,cy = tri:getCenter()
    local n1 = n(cx,cy)
    local n2 = n(14 + cx, 19 + cy)
    return {
    color = {HSL(color + n1 * 12, sat_base + 25*n1 + color*0.5, 60 + 50 * n2, 255)},
    path = {tri.p1.x, tri.p1.y, tri.p2.x, tri.p2.y, tri.p3.x, tri.p3.y}}  end)

end


function Asteroid:reseed()
--  love.graphics.rotate(love.math.random(-3, 3))
  self.paths = self:generate()
end

function Asteroid:draw ()

--  local stepSize = (255 / #self.paths)

  for s = 1, #self.paths, 1 do
    local path = self.paths[s]
    --    local op = stepSize * s
--    local op = 255
    love.graphics.setLineWidth(1)
--    love.graphics.setColor(200, 190, 200, 255)
--    if s == #self.paths then
--      love.graphics.setColor(200, 160, 100, 255)
--      love.graphics.setLineWidth(1)
--    end

    love.graphics.setColor(unpack(path.color))
    love.graphics.polygon("fill", path.path)
--    love.graphics.print(s, path.path[3], path.path[4])


    for i = 1, #path, 1 do
      --      if path.mark[i] then love.graphics.setColor(rgba("#00C619"))
      --      else
      love.graphics.setColor(200,200,200, op)
      --      end

--            love.graphics.circle('fill', path[i], path[i+1], 1)
--            love.graphics.circle('fill', path[i].x or 0, path[i].y or 0, 1)

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