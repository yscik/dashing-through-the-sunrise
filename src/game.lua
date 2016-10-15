lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

vector = require 'lib/hump/vector-light'
Camera = require 'lib/hump/camera'
Timer = require 'lib/hump/timer'
_ = require 'lib/moses/moses'

suit = require 'lib/suit'


require 'src/utils/datacomponent'

require 'src/control/input-state'
require 'src/control/input-system'
require 'src/control/command'
require 'src/control/cursor-entity'
require 'src/control/hitbox-component'

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

require 'src/world/world'
require 'src/world/asteroid'

require 'src/build/buildcommand'
require 'src/build/powerplant-entity'

game = {}

function game.load(arg)
    
    if arg[#arg] == "-debug" then require("mobdebug").start() end

    engine = Engine()
    engine:addSystem(MovementSystem())

    inputSystem = InputSystem()
    
    engine:addSystem(inputSystem)
    engine:addSystem(TargetSystem())
    engine:addSystem(BurnSystem())
    engine:addSystem(RenderSystem(), "draw")
    
    player = Player(inputSystem.input)
    camera = Camera(0,0)
    ui = Ui(camera, inputSystem)
    camera.smoother = Camera.smooth.linear(1)
    local target = TargetDisplay(player:get("Target"))
    local cursor = CursorEntity(inputSystem.input)

    local a1 = Asteroid({x =600, y = 200, r = 0})
    local a2 = Asteroid({x = -200, y = -200, r = -0.6 })

    world = World(engine)

    engine:addEntity(player)
    world.player = player
    world:add(a1)
    world:add(a2)

    engine:addEntity(target)
    engine:addEntity(cursor)
    
end

function game.draw()
    engine:draw()
    ui:draw()
    suit.draw()
    
    love.graphics.setColor(255,255,255)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    
    love.graphics.print("Player", 10, 30)
    love.graphics.print("BAT: "..tostring(player.battery.content), 10, 50)

end

function game.update(dt)
  
  Timer.update(dt)
  engine:update(dt)
  local pos = player:get("Position")
  camera:move((pos.at.x-camera.x)/2, (pos.at.y-camera.y)/2)

  if love.keyboard.isDown('escape') then
    love.event.quit()
    end
end
