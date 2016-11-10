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
require 'src/ui/status-panel'
require 'src/ui/ui-components'
require 'src/ui/ui-service'
require 'src/ui/font'

require 'src/player/target-component'
require 'src/player/burn-system'
require 'src/player/player'
require 'src/player/target-display'
require 'src/player/harpoon'
require 'src/player/rocket'

require 'src/core/position-components'
require 'src/core/movement-system'

require 'src/core/render-system'
require 'src/core/physics-system'

require 'src/resource/resource-types'
require 'src/resource/resource-components'
require 'src/resource/resource-system'
require 'src/resource/resource-connection'

require 'src/world/world'
require 'src/world/cluster'
require 'src/world/asteroid'
require 'src/world/asteroid-builder'
require 'src/world/background'
require 'src/world/sun'

require 'src/game/capture'

require 'src/build/buildcommand'
require 'src/build/building-entity'
require 'src/build/plant-entity'
require 'src/build/plant-gen'
require 'src/tool/mine'

debugWorldDraw = require('lib/debugWorldDraw')
game = {}

function game.load(arg)
    
    if arg[#arg] == "-debug" then require("mobdebug").start() end

    systems = {}


    game.systems = systems

    systems.engine = Engine()
    systems.engine:addSystem(MovementSystem())

    systems.input = InputSystem()

    systems.physics = PhysicsSystem()
    systems.engine:addSystem(systems.physics)
    systems.engine:addSystem(systems.input)
    systems.engine:addSystem(BurnSystem())

    systems.engine:addSystem(RenderSystem(), "draw")
    
    systems.camera = Camera(0,0)
    systems.ui = Ui(systems.camera, systems.input)
    systems.camera.smoother = Camera.smooth.linear(1)
--    local target = TargetDisplay(systems.player.burn.target)
    systems.cursor = CursorEntity(systems.input.input)

--    systems.ui:addPanel(CommandPanel({x = love.graphics.getWidth() - 60, y = 50}))
--    systems.ui:addPanel(StatusPanel(systems.player, {x = love.graphics.getWidth() - 210, y = 260}))
    systems.world = World(systems.engine)
    systems.sun = Sun({scale = h})
    systems.world:add(systems.sun)

    local x1, y1 = 0, 0
    local cluster = Cluster()
    local a = cluster.asteroids[math.floor(#cluster.asteroids/3)];
    local p = a:get('Position')
    local body = a:get('Body').body
    x1, y1 = body:getWorldPoints(body:getFixtureList()[1]:getShape():getPoints())

    systems.player = Player({x=x1+30, y = y1+40})
    systems.world.player = systems.player
    systems.world:add(systems.player)

    local a = cluster.asteroids[math.floor(#cluster.asteroids/3+1)];
    local p = a:get('Position')
    local body = a:get('Body').body
    x1, y1 = body:getWorldPoints(body:getFixtureList()[1]:getShape():getPoints())

    local p2 = Player({x=x1+30, y = y1+40})
    p2.color = {rgba('#A840D2') }
    p2:get('Body').body:setAngle(2)
    p2:get('Body').body:applyLinearImpulse(1000, 105)
    systems.world:add(p2)

--    Player({x=x1+30, y = y1+40})


  --    systems.engine:addEntity(target)
    systems.engine:addEntity(systems.cursor)

    systems.bg = {
      item = Background(),
      camera =  Camera(1000,1000)
    }

    Timer.every(1, function() systems.world:tick(1) end)
    
end

function game.draw()

--    systems.bg.camera:attach()
    systems.bg.item:draw()
--    systems.bg.camera:detach()

    systems.camera:attach()
    systems.engine:draw()
--    debugWorldDraw(systems.physics.world,-5000, -5000,5000, 5000)
    systems.camera:detach()

    systems.ui:draw()
    suit.draw()

    love.graphics.setColor(255,255,255)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)

end

function game.update(dt)

  Timer.update(dt)
  systems.world:update(dt)
  systems.engine:update(dt)
  local pos = systems.player:get("Position")
--  systems.bg.camera:move((pos.at.x - systems.camera.x)/3, (pos.at.y - systems.camera.y)/3)
  systems.camera:lookAt(pos.at.x, pos.at.y)

end
