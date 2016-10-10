lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

vector = require 'lib/hump/vector-light'
Camera = require 'lib/hump/camera'
Timer = require 'lib/hump/timer'
extend = require 'src/utils/extend'
_ = require('lib/moses/moses')

require 'src/utils/datacomponent'

require 'src/cursor/cursor-component'
require 'src/cursor/cursor-entity'
require 'src/cursor/cursor-system'

require 'src/player/target-system'
require 'src/player/burn-system'
require 'src/player/player'
require 'src/player/target-display'

require 'src/common/position-components'
require 'src/common/movement-system'

require 'src/common/canvas-component'
require 'src/common/canvas-system'

require 'src/resource/resource-types'
require 'src/resource/resource-components'
require 'src/resource/resource-system'

require 'src/world/asteroid'

function love.load(arg)
    
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    
    engine = Engine()
    engine:addSystem(MovementSystem())
    engine:addSystem(CursorSystem())
    engine:addSystem(TargetSystem())
    engine:addSystem(BurnSystem())
    engine:addSystem(CanvasSystem(), "draw")
    
    player = Player()
    camera = Camera(0,0)
    camera.smoother = Camera.smooth.linear(1)
    target = TargetDisplay(player:get("Target"))
    cursor = CursorEntity()
    local a1 = Asteroid(400, 200)
    
    engine:addEntity(a1)
    engine:addEntity(target)
    engine:addEntity(player)
    engine:addEntity(cursor)
    
end

function love.draw()
    engine:draw()
     love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)

end

function love.update(dt)
  
  Timer.update(dt)
  engine:update(dt)
  local pos = player:get("Position").pos
  camera:move((pos.x-camera.x)/2, (pos.y-camera.y)/2)

  if love.keyboard.isDown('escape') then
    love.event.quit()
    end
end
