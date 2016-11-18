
local binser = require('lib/binser/binser')

LocalCluster = class("LocalCluster", Entity)

local sectorsize = 1500
local function sk(x,y) return x .. 'x'.. y end

function LocalCluster:initialize()
  Entity.initialize(self)
  self.seed = love.math.random(1,300) / 2000
  self.sectors = {}
  
  self.thread = love.thread.newThread('src/world/localcluster.offthread.lua')
  
  self.thread:start()
  self.worker = {
    to = love.thread.getChannel('cluster_worker_to'),
    from = love.thread.getChannel('cluster_worker_from')
  }
  
  self.sectors[sk(0,0)] = self:generate(0,0)
  self.nearby = {self.sectors[sk(0,0)]}

end

function LocalCluster:update()
  
  local newCluster = self.worker.from:pop()
  if newCluster ~= nil then
    self:add(binser.deserializeN(newCluster, 3))
  end
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

function LocalCluster:generate(x,y)
  
  self.worker.to:push({x = x, y = y, sectorsize = sectorsize})
  return {}
end

function LocalCluster:add(x, y, data)
  
  local asteroids = {}
  for k,adata in ipairs(data) do
    
    local a = Asteroid(adata.pos, adata.options)
    
    systems.world:add(a)
    asteroids[#asteroids+1] = a
    
    --      print('Added [' .. size ..'] '.. p.x .. ', ' .. p.y .. ' at ' .. x ..'x'.. y)
    
    a:force(-love.math.randomNormal(10, adata.options.size * 20), love.math.randomNormal(adata.options.size * 20, 0), love.math.randomNormal(adata.options.size * 0.3, 0))
  end
  
  self.sectors[sk(x,y)] = asteroids
end
