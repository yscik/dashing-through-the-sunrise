
ResourceConnection = class("ResourceConnection", Entity)

function ResourceConnection:initialize()
  Entity.initialize(self)

end
function ResourceConnection:setup()

  self.type = 'Silicon'
  self:add(Position({}))
  self:add(Render())
  systems.world:add(self)

end



function ResourceConnection:close()

  systems.world:remove(self)

end

function ResourceConnection:update (dt)

  local sx,sy = self.source.position:getXY()
  local tx,ty = self.target.position:getXY()
  local distance = vector.dist(sx, sy, tx, ty)

  if distance > 150 then
    self:close()
    return
  end

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

