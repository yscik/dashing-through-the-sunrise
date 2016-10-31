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
require 'src/ui/command-panel'
require 'src/ui/ui-components'
require 'src/ui/ui-service'
require 'src/ui/font'

require 'src/player/target-component'
require 'src/player/burn-system'
require 'src/player/player'
require 'src/player/target-display'

require 'src/core/position-components'
require 'src/core/movement-system'

require 'src/core/render-system'

require 'src/resource/resource-types'
require 'src/resource/resource-components'
require 'src/resource/resource-system'
require 'src/resource/resource-connection'

require 'src/world/world'
require 'src/world/cluster'
require 'src/world/asteroid'
require 'src/world/asteroid-builder'

require 'src/build/buildcommand'
require 'src/build/building-entity'
require 'src/build/plant-entity'
require 'src/build/plant-gen'
require 'src/tool/mine'

game = {}

function game.load(arg)
    
    if arg[#arg] == "-debug" then require("lib/mobdebug").start() end

    systems = {}

    game.systems = systems

    systems.engine = Engine()
    systems.engine:addSystem(MovementSystem())

    systems.input = InputSystem()
    
    systems.engine:addSystem(systems.input)
    systems.engine:addSystem(BurnSystem())

    systems.engine:addSystem(RenderSystem(), "draw")
    
    systems.player = Player(systems.input.input)
    systems.camera = Camera(0,0)
    systems.ui = Ui(systems.camera, systems.input)
    systems.camera.smoother = Camera.smooth.linear(1)
    local target = TargetDisplay(systems.player.burn.target)
    systems.cursor = CursorEntity(systems.input.input)

    systems.ui:addPanel(CommandPanel({x = love.graphics.getWidth() - 60, y = 50}))
    systems.world = World(systems.engine)

    systems.engine:addEntity(systems.player)
    systems.world.player = systems.player

    Cluster()

    systems.engine:addEntity(target)
    systems.engine:addEntity(systems.cursor)

    Timer.every(1, function() systems.world:tick(1) end)
    
end

function game.draw()

    systems.camera:attach()
    systems.engine:draw()
    systems.camera:detach()

    systems.ui:draw()
    suit.draw()

    love.graphics.setColor(255,255,255)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    
    love.graphics.print("Player", 10, 30)
    love.graphics.print("BAT: "..tostring(systems.player.battery.content), 10, 50)
    love.graphics.print("Si: "..tostring(systems.player.storage.content), 10, 70)

end

function game.update(dt)
  
  Timer.update(dt)
  systems.world:update(dt)
  systems.engine:update(dt)
  local pos = systems.player:get("Position")
  systems.camera:move((pos.at.x- systems.camera.x)/2, (pos.at.y- systems.camera.y)/2)

end
