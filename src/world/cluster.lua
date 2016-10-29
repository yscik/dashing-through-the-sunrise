
Cluster = class("Cluster", Entity)

function Cluster:initialize()
  Entity.initialize(self)
  self.seed = love.math.random(1,300) / 2000
  self:generate()
end

function Cluster:generate()

  for i = -5, 10, 1 do
    for j = -5, 10, 1 do
      local size = math.max(3, math.ceil(love.math.randomNormal(4,8)))

      local offset = size * 140
      local px, py = i * offset + 100 * love.math.randomNormal(2, 1), j * offset + 100 * love.math.randomNormal(2, 1)

      local a = Asteroid({x = px, y = py, r = 0}, {size = size})
      systems.world:add(a)

      if love.math.random(1,10) > 5 then
        a:force(love.math.randomNormal(2, 2), love.math.randomNormal(2, 2), love.math.randomNormal(0.1, 0))
      end

    end
  end



end