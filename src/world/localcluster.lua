
LocalCluster = class("LocalCluster", Entity)

local sectorsize = 1000
local function sk(x,y) return x .. 'x'.. y end

function LocalCluster:initialize()
  Entity.initialize(self)
  self.seed = love.math.random(1,300) / 2000
  self.sectors = {}

--  self:generate(0,0)
end

function LocalCluster:update()
  local ppos = systems.player:get('Position')
  local x,y = math.round(ppos.at.x / sectorsize), math.round(ppos.at.y / sectorsize)

  for i = x-1, x+1, 1 do
  for j = y-1, y+1, 1 do
      if self.sectors[sk(i,j)] == nil then
        print('Adding sector ' .. i ..'x' .. j)
        self.sectors[sk(i,j)] = self:generate(i,j) end
    end
  end
end

local size_mult = 30

function LocalCluster:generate(x,y)

  local density = love.math.randomNormal(2, 7)
  local asteroids = {}
  local a = {}

  local size = math.ceil(love.math.randomNormal(1,8))

  while(#asteroids < density and size >= 3) do

    local p = {x = math.random(0, sectorsize - size * size_mult), y = math.random(0, sectorsize - size * size_mult) }
--    print('Trying [' .. size ..'] '.. p.x .. ', ' .. p.y .. ' at ' .. x ..'x'.. y)

    size = size - size * 0.1

    if not _.any(a, function(b)
--      print(vector.dist(b.pos.x, b.pos.y, p.x, p.y) ..' < ' .. (b.size + size) * size_mult)
      return vector.dist(b.pos.x, b.pos.y, p.x, p.y) < (b.size + size) * size_mult
    end) then
      local asize = math.round(size)
--      print('ok')
      a[#a+1] = {pos = p, size = asize }

      local a = Asteroid({x = x * sectorsize + p.x, y = y * sectorsize +  p.y, r = 0}, {size = asize})
      asteroids[#asteroids+1] = a
      systems.world:add(a)

    end



    --      if love.math.random(1,10) > 5 then
    --        a:force(love.math.randomNormal(10, 0), love.math.randomNormal(10, 0), love.math.randomNormal(0.8, 0))
    --      end

  end

  return asteroids;


end