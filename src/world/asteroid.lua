
Asteroid = class("Asteroid", Entity)

function Asteroid:initialize(pos, options)
  Entity.initialize(self)
  options = _.defaults(options or {}, {

  })

  self.options = options

  self:setPath({self:generate(options)})

  self:contents()

  self:add(Body({shape = self.renderPath, at = pos, mass = options.size * 1000, friction = 0.9, restitution = 0.3}))


  self:add(Position({z = 1}))
  self:add(Render())

end

local colors = {
  Water = '#9FAAC7',
  Iron = '#7E898C',
  Silicon = '#706B6B',
  Carbon = '#625955',
}

function Asteroid:contents()
  local mat = Materials[love.math.random(1,#Materials)]

  self.crust = Storage({type = mat, content = 1000, capacity = 1000})

  self:add(Resources({
    self.crust
  }))


  self.color = {rgba(colors[mat]) }
  local shade = love.math.random(0, 30) - 15
  for i = 1, #self.color-1, 1 do
    self.color[i] = self.color[i] + shade
    end

end


function Asteroid:setPath(path)
  self.path = path
  self.renderPath = love.math.triangulate(self.path)

end

function Asteroid:draw ()

  love.graphics.setColor(unpack(self.color))
  _.each(self.renderPath, function(k, path)
    love.graphics.polygon("fill", path)
  end)

end

function Asteroid:force(x,y,r)
  local b = self:get('Body')
  b.body:applyLinearImpulse(x*20,y*20)
  b.body:applyAngularImpulse(r*60)
end


