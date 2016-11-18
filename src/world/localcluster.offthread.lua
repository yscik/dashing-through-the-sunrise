
vector = require 'lib/hump/vector-light'
_ = require 'lib/moses/moses'

local binser = require('lib/binser/binser')

require('love.math')
require('src/world/asteroid-builder')
require 'src/utils/color'
require 'src/utils/math'

local size_mult = 30

local channel = love.thread.getChannel('cluster')

function generateCluster(x,y, sectorsize)
  
  local density = love.math.randomNormal(2, 6) * sectorsize / 500
  --  local density = 1
  local asteroids = {}
  local a = {}
  if x == 0 and y == 0 then a[#a+1] = {pos = {x = 100, y = 100}, size = 3} end
  
  local size = 3 + math.ceil(love.math.randomNormal(2,4))
  
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
      
      local a
      --pcall(function()
        a = BuildAsteroid({size = asize})
      --end)
      
      
      if a then
        asteroids[#asteroids+1] = {pos = {x = x * sectorsize + p.x, y = y * sectorsize +  p.y, r = 0}, options = {size = asize, data = a}}
      end
    
    end
  
  end
  --  print('Adding sector ' .. x ..'x' .. y .. ', ' .. #asteroids .. ' asteroids, size at ' .. size)
  
  print(#asteroids)
  return asteroids
  
end

local channel = {
  get = love.thread.getChannel('cluster_worker_to'),
  send = love.thread.getChannel('cluster_worker_from')
}

while true do
  local a = channel.get:demand()
  if a then
    local ast = generateCluster(a.x, a.y, a.sectorsize)
    local data = binser.serialize(a.x, a.y, ast)
    channel.send:push(data)
  end
  
end
