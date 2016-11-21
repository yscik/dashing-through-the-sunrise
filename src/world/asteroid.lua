
Asteroid = class("Asteroid", Entity)

function Asteroid:initialize(pos, options)
  Entity.initialize(self)
  options = _.defaults(options or {}, {
  })
  self.options = options

  self.data = options.data
  self.path = self.data.paths

  self.bodyopts = {entity = self, shape = _.pluck(self.data.paths, 'path'), at = pos, mass = 2000 / options.size^0.5, friction = 0.7, restitution = 0.1}
  if not pcall(function() self:add(Body(self.bodyopts)) end) then
    self.failed = true
  end
  
  
  self:add(Position({at = pos, z = 1}))
  self:add(Render({cache = not options.debris, size = {options.size*50, options.size*50}}))
  self.scale = 1

end

function Asteroid:draw ()

  love.graphics.push()
  if self.options.debris then
--    love.graphics.scale(1/self.scale)
  end
  _.each(self.path, function(k, path)
    local r,g,b,a = unpack(path.color)
    if self.options.debris then
      r = r + self.scale * 4
      g = g + self.scale * 4
      b = b + self.scale * 4
      a = a - 200*(self.scale-1)
    end
    love.graphics.setColor(r,g,b,a)
    love.graphics.polygon("fill", path.path)
  end)
  love.graphics.pop()
  
--  love.graphics.setColor(255,255,255,255)
--  love.graphics.print(self.label or "xx", 0, 0)

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
  b.body:applyLinearImpulse(x*1000,y*1000)
  b.body:applyAngularImpulse(r*1000000)
end

function Asteroid:update(dt)

  if self.options.debris and self.scale < 2 then
    self.scale = self.scale + 0.1 * dt
  end
end


local Delaunay = require 'lib/delaunay/delaunay'


function Asteroid:explode()

  local pos = self:get('Position')

  systems.world:remove(self)

  local debris = {}
   
  local shapes = self.data.paths
  _.each(shapes, function(k, path)
    path.tri = Delaunay.Triangle(
      Delaunay.Point(path.path[1], path.path[2]),
      Delaunay.Point(path.path[3], path.path[4]),
      Delaunay.Point(path.path[5], path.path[6]))
  end)
  
--  for i = 1, #shapes, 10 do
--    local px,py = shapes[i].tri:getCenter()
--    local a = Asteroid({x = pos.at.x + px, y = pos.at.y + py}, {size = 1, data = {paths = self:generate({size = math.random(1,3), color = shapes[i].color}).paths}})
--    systems.world:add(a)
--    a:force(math.random(0,100), math.random(-100,100), math.random(-1,1))
--  end
  
  while shapes and #shapes > 0 do

    local r = math.random(1, #shapes)
    local px,py = shapes[r].tri:getCenter()
    local size = 80

    local m = _.groupBy(shapes, function(k, shape)
      
    return (shape.tri.p1:isInCircle(px, py, size) and shape.tri.p2:isInCircle(px, py, size) and shape.tri.p3:isInCircle(px, py, size))
--      return (Delaunay.Point(shape.tri:getCenter()):isInCircle(px,py, size))
        and 'win' or 'out'
    end)
    if m.win and #m.win > 0 then
      shapes = m.out
      local a = Asteroid(pos.at, {size = 1, data = {paths = m.win}, debris = true})
      systems.world:add(a)
      debris[#debris+1] = a
      if #m.win > 3 then
--        Timer.after(1, function()
          a:force(love.math.noise(px/100, py/100)*-50*#m.win, #m.win*love.math.noise(px/100, py/100)*50-100, #m.win*love.math.noise(px/100, py/100)*2-4)
--          end)
      end
    end
--
  end
  
  return debris
  
end

