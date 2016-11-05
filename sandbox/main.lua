
class = require 'lib/lovetoys/lib/middleclass'
_ = require 'lib/moses/moses'

require 'plant'
require 'cgen'

local e = null

function love.load(arg)

  if arg[#arg] == "-debug" then require("mobdebug").start() end

  e = Asteroid()


end

function love.draw()

  love.graphics.clear()
  love.graphics.translate(900, 500)
  e:draw()

end

function love.update(dt)

  if e.update then e:update(dt) end

end


function love.keypressed(key)
  e:reseed()
  if key == 'escape' then love.event.quit() end
end
