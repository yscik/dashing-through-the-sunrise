
RenderSystem = class("RenderSystem", System)
Render = Component.create("Render")

function RenderSystem.atPosition(pos, fn, ...)
  love.graphics.push()
  love.graphics.translate(pos:getXY())
  love.graphics.rotate((pos:getR() or 0) % (2*math.pi))
  love.graphics.translate(-pos.center.x, -pos.center.y)
  fn(...)
  love.graphics.pop()
  love.graphics.setColor(255,255,255,150)
--  love.graphics.circle("fill", pos.at.x, pos.at.y, 2)
end

function RenderSystem:render(entity)
  local pos = entity:get("Position")

  if self:visible(pos) then
    if entity.draw then
      RenderSystem.atPosition(pos, entity.draw, entity)
    end
    self:outline(entity)
  end
end

function RenderSystem:outline(entity)
  local clk, pos = entity:get("Hitbox"), entity:get("Position")

  if clk and clk.hover and clk.shape then
    RenderSystem.atPosition(pos, function()
      love.graphics.setColor(rgba("#A62424"))
      love.graphics.setLineWidth(3)
      love.graphics.polygon('line', clk.shape)
    end)
  end

--  -- debug hitbox drawing
--  love.graphics.setColor(255,57,140)
--  love.graphics.setLineWidth(1)
--  clk.hc:draw()

end

function RenderSystem:sort()

  local function getZ(entity)
    return entity:get('Position').z or 0
  end

  local function sortZ(a, b)
    return getZ(a) < getZ(b)
  end

  self.items = _.sort(_.clone(self.targets, true), sortZ)

end

function RenderSystem:draw()


  if self.changed then
    self:sort()
    self.changed = false
  end

  local w,h = love.graphics.getDimensions()
  self.bb = {systems.camera.x - w, systems.camera.y - h, systems.camera.x + w, systems.camera.y + h }

  for k, entity in ipairs(self.items) do
    self:render(entity)
  end
end

function RenderSystem:visible(pos)
  return pos.at.x > self.bb[1] and pos.at.y > self.bb[2] and pos.at.x < self.bb[3] and pos.at.y < self.bb[4]

end

function RenderSystem:onAddEntity()
  self.changed = true
end

function RenderSystem:requires()
    return {"Render", "Position"}
end