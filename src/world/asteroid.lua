
Asteroid = class("Asteroid", Entity)

function Asteroid:initialize(pos, options)
  Entity.initialize(self)
  options = _.defaults(options or {}, {

  })

  self.options = options

  local data = self:generate(options)
  self.path = data.paths

  self:add(Body({entity = self, shape = _.pluck(data.paths, 'path'), at = pos, mass = 2000 / options.size^0.5, friction = 0.5, restitution = 0.3}))

  self:add(Position({z = 1}))
  self:add(Render())

end

function Asteroid:draw ()

--  love.graphics.setColor(255,255,255,255)
--  love.graphics.polygon("line", self.path)
  _.each(self.path, function(k, path)
    love.graphics.setColor(unpack(path.color))
    love.graphics.polygon("fill", path.path)
  end)
--  love.graphics.print(self.label, 100, 0)

end

function Asteroid:capture(player)
  if not self.cap then
    self.cap = Capture(self, player)
    systems.world:add(self.cap)
  else self.cap:progress()
  end
end
function Asteroid:capture_end()
  self.cap = nil
end

function Asteroid:force(x,y,r)
  local b = self:get('Body')
  b.body:applyLinearImpulse(x*20,y*20)
  b.body:applyAngularImpulse(r*60)
end


