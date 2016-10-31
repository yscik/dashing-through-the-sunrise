
Cluster = class("Cluster", Entity)

function Cluster:initialize()
  Entity.initialize(self)
  self.seed = love.math.random(1,300) / 2000
  self.asteroids = {}
  self:generate()
end

function Cluster:generate()

  local function overlaps(k, a, x, y, size)
    local ap = a:get('Position').at
    return math.min(math.abs(ap.y - y), math.abs(ap.x - x)) < math.min(a.options.size, size) * 10
  end

  for i = -5, 10, 1 do
    for j = -5, 10, 1 do
      local size = math.max(3, math.ceil(love.math.randomNormal(4,8)))

      local offset = size * 140
      local px, py = i * offset + 100 * love.math.noise(self.seed, i, j), j * offset + 100 * love.math.noise(self.seed, j, i)
      local collisions = _.select(self.asteroids, overlaps, px, py, size)
      if #collisions > 0 then
        px = px + 30*size
        py = py + 30*size
      end

      local a = Asteroid({x = px, y = py, r = 0}, {size = size})
      self.asteroids[#self.asteroids+1] = a
      systems.world:add(a)

      if love.math.random(1,10) > 5 then
        a:force(love.math.randomNormal(2, 2), love.math.randomNormal(2, 2), love.math.randomNormal(0.1, 0))
      end

    end
  end



end