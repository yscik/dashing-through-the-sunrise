lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

vector = require 'lib/hump/vector-light'
Camera = require 'lib/hump/camera'
Timer = require 'lib/hump/timer'
extend = require 'src/utils/extend'
_ = require 'lib/moses/moses'

suit = require 'lib/suit'


require 'src/utils/datacomponent'

require 'src/control/input-state'
require 'src/control/input-system'
require 'src/control/command'
require 'src/control/cursor-entity'
require 'src/control/clickable-component'

require 'src/ui/panel'
require 'src/ui/ui-components'
require 'src/ui/ui-service'

require 'src/player/target-system'
require 'src/player/burn-system'
require 'src/player/player'
require 'src/player/target-display'

require 'src/common/position-components'
require 'src/common/movement-system'

require 'src/common/canvas-component'
require 'src/common/render-system'

require 'src/resource/resource-types'
require 'src/resource/resource-components'
require 'src/resource/resource-system'

require 'src/world/asteroid'

function love.load(arg)
    
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    
    engine = Engine()
    engine:addSystem(MovementSystem())
    
    inputSytem = InputSystem()
    
    engine:addSystem(inputSytem)
    engine:addSystem(TargetSystem())
    engine:addSystem(BurnSystem())
    engine:addSystem(RenderSystem(), "draw")
    
    player = Player(inputSytem.input)
    camera = Camera(0,0)
    ui = Ui(camera)
    camera.smoother = Camera.smooth.linear(1)
    target = TargetDisplay(player:get("Target"))
    cursor = CursorEntity(inputSytem.input)
    local a1 = Asteroid(400, 200)
    
    engine:addEntity(a1)
    engine:addEntity(target)
    engine:addEntity(player)
    engine:addEntity(cursor)
    
end

function love.draw()
    engine:draw()
    ui:draw()
    suit.draw()
    
    love.graphics.setColor(255,255,255)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    
    love.graphics.print("Player", 10, 30)
    love.graphics.print("BAT: "..tostring(player.battery.content), 10, 50)

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
