
Asteroid = class("Asteroid", Entity)

function Asteroid:initialize(pos, options)
  Entity.initialize(self)
  options = _.defaults(options or {}, {
    base =  {10,300, 150,170, 300,200, 330,250, 250,350, 70,380},
    seed = love.math.random(-100,100),
    size = options and options.base and 100 or love.math.random(40,130)

  })

  self.options = options

  self:setPath(self:generate(options))

  self:add(Velocity(0,0, 0))
  self:add(Hitbox({shape = self.path, command =
        PanelCommand { content = {
            {type = "title", label = "Asteroid" },
            {type = "info", label = "Resources" , value = {Panel.printResources, self}},
            {label = "Scan", action = ScanCommand({target = self}) },
            {label = "Build powerplant", action = BuildCommand { parent = self } }
          }, entity = self }
    }))

  self:add(Position({at = pos,
--    center = self:get('Hitbox').center,
    z = 1}))
  self:add(Render())

  self:add(Resources({
      Storage({type = 'Silicon', content = 1000})
  }))

end
--
function Asteroid:setPath(path)
  self.path = path
  self.renderPath = love.math.triangulate(self.path)

end

function Asteroid:draw ()

  love.graphics.setColor(200,200,200)
  _.each(self.renderPath, function(k, path)
    love.graphics.polygon("fill", path)
  end)

end

function Asteroid:force(x,y,r)
  local v = self:get('Velocity')
  v.x, v.y, v.r = x or 0, y or 0, r or 0
end


