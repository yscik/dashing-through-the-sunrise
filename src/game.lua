lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

vector = require 'lib/hump/vector-light'
Camera = require 'lib/hump/camera'
Timer = require 'lib/hump/timer'
_ = require 'lib/moses/moses'

suit = require 'lib/suit'

require 'src/utils/datacomponent'
require 'src/utils/color'

require 'src/control/input-state'
require 'src/control/input-system'
require 'src/control/command'
require 'src/control/cursor-entity'
require 'src/control/hitbox-component'

require 'src/ui/panel'
require 'src/ui/ui-components'
require 'src/ui/ui-service'
require 'src/ui/font'

require 'src/player/target-system'
require 'src/player/burn-system'
require 'src/player/player'
require 'src/player/target-display'

require 'src/common/position-components'
require 'src/common/movement-system'

require 'src/common/render-system'

require 'src/resource/resource-types'
require 'src/resource/resource-components'
require 'src/resource/resource-system'

require 'src/world/world'
require 'src/world/asteroid'
require 'src/world/asteroid-builder'

require 'src/build/buildcommand'
require 'src/build/building-entity'
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


    world = World(engine)

    engine:addEntity(player)
    world.player = player
    world:add(Asteroid({x =600, y = 200, r = 0}))
    local a2 = Asteroid({x = -200, y = -200, r = -2.6 }, {base = {10,300, 150,170, 300,200, 330,250, 250,350, 70,380}})
    world:add(a2)
    world:add(Asteroid({x = 100, y = 100}))
    world:add(Asteroid({x = 1000, y = -300, r = -2}, {base = {0,0, 100,-60, 200, -120, 300, 0, 400, -50, 500, 0, 400,100, 200, 100, 100, 130, 0,100 }}))

    a2:force(0,1,0.1)

    engine:addEntity(target)
    engine:addEntity(cursor)

    Timer.every(1, function() world:update(1) end)
    
end

function game.draw()

    camera:attach()
    engine:draw()
    camera:detach()
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
