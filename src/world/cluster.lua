
Cluster = class("Cluster", Entity)

function Cluster:initialize()
  Entity.initialize(self)
  self.seed = love.math.random(1,300) / 2000
  self.asteroids = {}
  self:generate()
end

function Cluster:generate()

  local function overlaps(k, a, x, y, size)
--    return false
    local ap = a:get('Position').at
    return math.min(math.abs(ap.y - y), math.abs(ap.x - x)) < math.min(a.options.size, size) * 10
  end

  for i = -3,0, 1 do
    for j = -3, 0, 1 do
      local size = math.max(3, math.ceil(love.math.randomNormal(4,6)))

      local offset = 100 + 50 * size
      local r = (love.math.random(0,250))
      local px, py = i * offset + r, j * offset + r

      local collisions = _.select(self.asteroids, overlaps, px, py, size)
      while #collisions > 0 do
        px = px + 50*size
        py = py + 50*size
        collisions = _.select(self.asteroids, overlaps, px, py, size)
      end

      local a = Asteroid({x = px, y = py, r = 0}, {size = size})
      a.label = i .. 'x'.. j
      self.asteroids[#self.asteroids+1] = a
      systems.world:add(a)

--      if love.math.random(1,10) > 5 then
--        a:force(love.math.randomNormal(10, 0), love.math.randomNormal(10, 0), love.math.randomNormal(0.8, 0))
--      end

    end
  end



end