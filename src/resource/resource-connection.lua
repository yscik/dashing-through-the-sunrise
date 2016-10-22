
ResourceConnection = class("ResourceConnection", Entity)

function ResourceConnection:initialize()
  Entity.initialize(self)

end
function ResourceConnection:setup()

  self.type = 'Silicon'
  self:add(Position({}))
  self:add(Render())

  --  local generator = Generate({type = Resource.Power, amount: 5, cost: Consume({type = Resource.Silicon, amount: 12})}
  --  self:add(generator)
  --  self:add(Resources({generator.cost, Storage({type = Resource.Power, capacity = 100})}))
  --  self:add(ResourceLink({type = Resource.Silicon, source = asteroid}))
  --

end

function ResourceConnection:update (dt)

  local source, target = self.source.entity:get('Resources'), self.target.entity:get('Resources')

  local from = _.findWhere(source.map.Storage, {type= self.type })
  local to = _.findWhere(target.map.Storage, {type= self.type })

  local rate = 1 * dt

  if to.content < to.capacity and from.content > rate then
    from.content = from.content - rate
    to.content = to.content + rate
  end

end

function ResourceConnection:draw ()

  local sx,sy = self.source.position:getXY()
  local tx,ty = self.target.position:getXY()

  love.graphics.setLineWidth(3)
  love.graphics.setColor(rgba("#E71414"))

  love.graphics.line(sx, sy, tx, ty)



end

