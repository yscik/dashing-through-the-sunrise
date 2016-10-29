
Plant = class("Plant", Building)

function Plant:initialize(asteroid, pos)
  Building.initialize(self)

  self:add(Position({reference = pos, center = {0, 0}, z = 2, parent = asteroid:get('Position')}))
  self:add(Render())

--  local generator = Generate({type = Resource.Power, amount: 5, cost: Consume({type = Resource.Silicon, amount: 12})}
--  self:add(generator)
--  self:add(Resources({generator.cost, Storage({type = Resource.Power, capacity = 100})}))
--  self:add(ResourceLink({type = Resource.Silicon, source = asteroid}))
--

end

local function getPoints(k, path)
  return _.map(path.outline, function(k,shape)
    return _.flatten(_.map(shape, function(k,v) return {v:unpack()} end))
  end)
end

function Plant:setPath(paths)
  self.paths = _.map(paths, getPoints)
end

function Plant:grow(dt)
  if self.o.size >= 25 then self.growing = false end

  self.o.size = self.o.size + dt
--  self.o.seed = self.o.seed + dt/100
  self:setPath(self:generate(self.o))
end

function Plant:update(dt)
  if self.growing then self:grow(dt) end
end

function Plant:built()
  self.created = true
  self.growing = true
  self:setPath(self:generate())

end

function Plant:draw ()

  if self.created then

    for i = 1, #self.paths, 1 do
      love.graphics.setColor(115,115,115, 255)
      for j = 1, #self.paths[i], 1 do
        love.graphics.polygon('fill', unpack(self.paths[i][j]))
        end
    end
--    self:debugDraw()
  else
    love.graphics.setColor(115,115,115, 255)
    love.graphics.circle('line', 0, 0, 10)

  end

end
