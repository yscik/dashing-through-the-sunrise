
Asteroid = class("Asteroid", Entity)

function Asteroid:initialize(pos, options)
  Entity.initialize(self)
  options = _.defaults(options or {}, {

  })

  self.options = options

  self:setPath({self:generate(options)})

  self:add(Body({shape = self.renderPath, at = pos, mass = 2000 / options.size^0.5, friction = 0.5, restitution = 0.3}))


  self:add(Position({z = 1}))
  self:add(Render())
  self.color = love.math.randomNormal(30, 160)

end


function Asteroid:setPath(path)
  self.path = path
  self.renderPath = love.math.triangulate(self.path)

end

function Asteroid:draw ()

  love.graphics.setColor(self.color, self.color, self.color, 255)
--  love.graphics.polygon("line", self.path)
  _.each(self.renderPath, function(k, path)
    love.graphics.polygon("fill", path)
  end)
  love.graphics.setColor(255,255,255,255)
--  love.graphics.print(self.label, 100, 0)


end

function Asteroid:force(x,y,r)
  local b = self:get('Body')
  b.body:applyLinearImpulse(x*20,y*20)
  b.body:applyAngularImpulse(r*60)
end


