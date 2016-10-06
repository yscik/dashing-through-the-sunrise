lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

vector = require 'lib/vector-light'

require 'src/cursor/cursor-component'
require 'src/cursor/cursor-entity'
require 'src/cursor/cursor-system'

require 'src/player/burn-system'
require 'src/player/player'

require 'src/common/position-components'
require 'src/common/movement-system'

require 'src/common/canvas-component'
require 'src/common/canvas-system'

require 'src/world/asteroid'

function love.load(arg)
    
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    engine = Engine()
    engine:addSystem(MovementSystem())
    engine:addSystem(CursorSystem())
    engine:addSystem(BurnSystem())
    engine:addSystem(CanvasSystem(), "draw")
    
    player = Player()
    cursor = CursorEntity()
    local a1 = Asteroid(400, 200)
    
    engine:addEntity(player)
    engine:addEntity(a1)
    engine:addEntity(cursor)
    
end

function love.draw()
    engine:draw()
end

function love.update(dt)
  
  engine:update(dt)

  if love.keyboard.isDown('escape') then
    love.event.quit()
    end
end
