local binser = require('lib/binser/binser')

Pool = class('Pool')

function Pool:initialize()
  self.pool = {}

  self.thread = love.thread.newThread('src/world/build.thread.lua')
  
  self.thread:start()
  self.worker = {
    to = love.thread.getChannel('asteroid_worker_to'),
    from = love.thread.getChannel('asteroid_worker_from')
  }

end

function Pool:add(group, item)
  if self.pool[group] == nil then self.pool[group] = {} end
  self.pool[group][#self.pool[group]+1] = item
  self.latest = item
  end

function Pool:get(group)
  print('pool ', group)
  return self.pool[group][love.math.random(1, #self.pool[group])]
end


function Pool:asteroids()

  self.count = {total = 0, done = 0}

  local poolsize = 70
  for size = 2, 10, 1 do
    for i = 0, poolsize, 1 do
      self.worker.to:push({size = size})
      self.count.total = self.count.total + 1
    end
  
    poolsize = math.ceil(poolsize * 0.8)

  end

end

function Pool:update(dt)

  local adata  = self.worker.from:pop()
  if adata ~= nil then
    self.count.done = self.count.done + 1
    self:add(binser.deserializeN(adata, 2))
    
  end
  if self.done and self.count.done == self.count.total then self:done() end
    
 end