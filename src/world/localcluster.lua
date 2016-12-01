
--local binser = require('lib/binser/binser')

LocalCluster = class("LocalCluster", Entity)

local sectorsize = 1500
local function sk(x,y) return x .. 'x'.. y end

function LocalCluster:initialize()
  Entity.initialize(self)
  self.seed = love.math.random(1,300) / 2000
  self.sectors = {}
  
--  self.thread = love.thread.newThread('src/world/localcluster.offthread.lua')
--
--  self.thread:start()
--  self.worker = {
--    to = love.thread.getChannel('cluster_worker_to'),
--    from = love.thread.getChannel('cluster_worker_from')
--  }

--  self.sectors[sk(0,0)] = self:generate(0,0)
  self.nearby = {self.sectors[sk(0,0)]}

end


function LocalCluster:update()
  
--  local newCluster = self.worker.from:pop()
--  if newCluster ~= nil then
--    self:add(binser.deserializeN(newCluster, 3))
--  end

  local ppos = systems.player:get('Position')
  local x,y = math.round(ppos.at.x / sectorsize), math.round(ppos.at.y / sectorsize)
  --  local xo = x + math.round((ppos.at.x % sectorsize) / sectorsize)
  --  local yo = y + math.round((ppos.at.y % sectorsize) / sectorsize)
  
  --  print('At ' .. x .. 'x' .. y .. ' h ' .. xo .. ',' .. yo)
  for i = x-1, x+1, 1 do
    for j = y-1, y+1, 1 do
      --      print('Check ' .. i .. 'x' .. j)
      if self.sectors[sk(i,j)] == nil then
        self.sectors[sk(i,j)] = self:generate(i,j) end
    end
  end
  
  local i = x - 3
  for j = y-10, y+10, 1 do
    if self.sectors[sk(i,j)] ~= nil then
      print('Removing sector ' .. i ..'x' .. j)
      self:clear(self.sectors[sk(i,j)])
      self.sectors[sk(i,j)] = nil end
  end
  
  self.nearby = {
    self.sectors[sk(x,y)],
    self.sectors[sk(x,y-1)],
    self.sectors[sk(x,y+1)],
    self.sectors[sk(x-1,y)],
    self.sectors[sk(x+1,y-1)],
    self.sectors[sk(x-1,y+1)]
  }
  
end

function LocalCluster:destroy()
  for i,s in pairs(self.sectors) do
    self:clear(s)
  end
end

function LocalCluster:clear(sector)
  for i,a in pairs(sector) do systems.world:remove(a) end
end


local size_mult = 34

function LocalCluster:generate(x,y)
  
--  self.worker.to:push({x = x, y = y, sectorsize = sectorsize})

  local density = love.math.randomNormal(2, 6) * sectorsize / 500
  --  local density = 1
  local asteroids = {}
  local a = {}
  if x == 0 and y == 0 then a[#a+1] = {pos = {x = 100, y = 100}, size = 3} end
  
  local size = math.min(10, 3 + math.ceil(love.math.randomNormal(2,4)))
  
  while(#asteroids < density and size >= 2) do
    
    local p = {x = math.random(0, sectorsize - size/2 * size_mult), y = math.random(0, sectorsize - size/2 * size_mult) }
    --    print('Trying [' .. size ..'] '.. p.x .. ', ' .. p.y .. ' at ' .. x ..'x'.. y)
    
    size = size - size * 0.02
    
    if not _.any(a, function(b)
      --      print(vector.dist(b.pos.x, b.pos.y, p.x, p.y) ..' < ' .. (b.size + size) * size_mult)
      return vector.dist(b.pos.x, b.pos.y, p.x, p.y) < (b.size + size) * size_mult
    end) then
      local asize = math.round(size)
      --      print('ok')
      a[#a+1] = {pos = p, size = asize }
      
      local ad = systems.pool:get(asize)
      
      asteroids[#asteroids+1] = {pos = {x = x * sectorsize + p.x, y = y * sectorsize +  p.y, r = 0}, options = {size = asize, data = ad}}
    
    end
  
  end
  --  print('Adding sector ' .. x ..'x' .. y .. ', ' .. #asteroids .. ' asteroids, size at ' .. size)
  
  return self:add(asteroids)
  
end

function LocalCluster:add(data)
  
  local asteroids = {}
  for k,adata in ipairs(data) do
    
    local a = Asteroid(adata.pos, adata.options)
    
    if not a.failed then
      systems.world:add(a)
      asteroids[#asteroids+1] = a
    
    --      print('Added [' .. size ..'] '.. p.x .. ', ' .. p.y .. ' at ' .. x ..'x'.. y)
    
      a:force(-love.math.randomNormal(10, adata.options.size * 20), love.math.randomNormal(adata.options.size * 20, 0), love.math.randomNormal(adata.options.size * 0.3, 0))
    end
  end
  
  return asteroids
end
