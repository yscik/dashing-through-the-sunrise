lovetoys = require("lib/lovetoys/lovetoys")
lovetoys.initialize({globals = true, debug = true})

vector = require 'lib/hump/vector-light'
Camera = require 'lib/hump/camera'
Timer = require 'lib/hump/timer'
_ = require 'lib/moses/moses'

suit = require 'lib/suit'

require 'src/utils/datacomponent'
require 'src/utils/color'
require 'src/utils/math'

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
require 'src/world/localcluster'
require 'src/world/asteroid'
require 'src/world/asteroid-builder'
require 'src/world/pool'
require 'src/world/background'
require 'src/world/sun'

require 'src/game/state'
require 'src/game/menu'
require 'src/game/splash'
require 'src/game/score'
require 'src/game/director'

require 'src/build/buildcommand'
require 'src/build/building-entity'
require 'src/build/plant-entity'
require 'src/build/plant-gen'
require 'src/tool/mine'

debugWorldDraw = require('lib/debugWorldDraw')
game = {}

function game.load(arg)
    
    io.output():setvbuf("no")
    if arg[#arg] == "-debug" then
      DEBUG = require("mobdebug")
      DEBUG.start()
      DEBUG.off()
    
    else
      DEBUG = { on = function() end, off = function() end }
    end

    systems = {}
    systems.state = GameState()

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

    if(systems.input.showCursor) then
      systems.cursor = CursorEntity(systems.input.input)
      systems.engine:addEntity(systems.cursor)
    end

    systems.world = World(systems.engine)
    systems.score = Score()
    systems.world:add(systems.score)
    systems.world:add(Director())
    
    systems.pool = Pool()


--    local a = Asteroid({x = 400, y = 0}, {size = 10})
--    systems.world:add(a)
--    Timer.after(1, function() a:explode() end)

    local h = love.graphics.getHeight()/2
    systems.sun = Sun({scale = h})
    systems.world:add(systems.sun)


    systems.bg = Background()
    
    systems.state:load()
--    systems.state:create()
--    systems.state:start()

    DEBUG.on()
    
    
end

function game.draw()

    systems.bg:draw()

    systems.camera:attach()
    love.graphics.push()
--    love.graphics.scale(1.3)
    systems.engine:draw()
    love.graphics.pop()
--    debugWorldDraw(systems.physics.world,-5000, -5000, 7000, 7000)
    systems.camera:detach()

    systems.ui:draw()
    suit.draw()

--  systems.bg.camera:attach()
--  systems.sun:draw()
--  systems.bg.camera:detach()

    love.graphics.setColor(255,255,255, 255)
    love.graphics.print('Build 2016-12-02', 10, 10)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), love.graphics.getWidth() - 150, 10)

end

function game.update(dt)
  systems.state:update(dt)

end


function love.threaderror(thread, errorstr)
  print("Thread error!\n"..errorstr)
end