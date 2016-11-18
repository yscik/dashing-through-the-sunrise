

local Delaunay = require 'lib/delaunay/delaunay'
local Point = Delaunay.Point
local Polygon = require 'lib/hc.polygon'
local v2 = require 'lib/hump/vector'


local function getPoints(vectorlist)
  local s1 = _.map(vectorlist, function(k,v)
    return {v.x, v.y}  end)
  local s2 = _.flatten(s1)
  return unpack(s2)
end

local function circle(center, scale, seed)

  local path = {}

  local count = 3 + scale^0.5 * 10
  local baseAngle = math.pi*2 / count
  local v = v2(0,1)

  for i = 1, count, 1 do

    v = v:rotated(baseAngle)
    local p = center + v * (scale*1 + love.math.noise(seed*100, v.x, v.y)*scale * 30 + love.math.random(0, scale * 2))

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

function BuildAsteroid(o)
  local scale = o.size or love.math.random(3,15)
  local seed = o.seed or love.math.random()
  local center = v2(0,0)
  
  local outline = circle(center, scale, seed)


  local outline_points = {getPoints(outline)}
  local poly = Polygon(unpack(outline_points))
  local cellsize = 60


  local points = grid(poly, cellsize, cellsize/3)
  _.push(points, unpack(outline))

  --  return {points}

  local tris = _.filter(Delaunay.triangulate(unpack(points)), function(k, tri)
    --    return true
    return poly:contains(tri:getCenter())
  end)

  local n = function(x,y)
    local scale = 600
    return love.math.noise(seed + (x/scale), seed + (y/scale))
  end

  local color = love.math.random(-5, 20)
  local sat_base = love.math.random(0, 20)
  return {
   seed = seed,
   outline = love.math.triangulate(outline_points),
   paths = _.map(tris, function(k, tri)
    local cx,cy = tri:getCenter()
    local n1 = n(cx,cy)
    local n2 = n(14 + cx, 19 + cy)
    return {
      color = o.color or {HSL(color + n1 * 12, sat_base + 25*n1 + color*0.5, 60 + 50 * n2, 255)},
      path = {tri.p1.x, tri.p1.y, tri.p2.x, tri.p2.y, tri.p3.x, tri.p3.y}}
  end)}

end
