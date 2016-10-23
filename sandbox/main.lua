
class = require 'lib/lovetoys/lib/middleclass'
_ = require 'lib/moses/moses'

require 'plant'

local e = null

function love.load(arg)

  if arg[#arg] == "-debug" then require("mobdebug").start() end

  e = Plant()


end

function love.draw()

  love.graphics.clear()
  love.graphics.translate(900, 900)
  e:draw()

end

function love.update(dt)

  e:update(dt)

end


function love.keypressed(key)
  e:reseed()
  if key == 'escape' then love.event.quit() end
end
