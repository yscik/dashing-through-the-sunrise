
vector = require 'lib/hump/vector-light'
_ = require 'lib/moses/moses'

local binser = require('lib/binser/binser')

require('love.math')
require('src/world/asteroid-builder')
require 'src/utils/color'
require 'src/utils/math'

local channel = {
  get = love.thread.getChannel('asteroid_worker_to'),
  send = love.thread.getChannel('asteroid_worker_from')
}

while true do
  local a = channel.get:demand()
  if a then
  
    local ast
    while not pcall(function()
      ast = BuildAsteroid(a)
    end) do end
    
    local data = binser.serialize(a.size, ast)
    channel.send:push(data)
  end
  
end
