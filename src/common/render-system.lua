
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

function RenderSystem.render(entity)
  local pos = entity:get("Position")

  if entity.draw then
    RenderSystem.atPosition(pos, entity.draw, entity)
  end
end

function RenderSystem.outline(entity)
  local clk, pos = entity:get("Hitbox"), entity:get("Position")

  if clk and clk.hover and clk.shape then
    RenderSystem.atPosition(pos, function()
      love.graphics.setColor(42,145,225)
      love.graphics.setLineWidth(2)
      love.graphics.line(clk.shape)
    end)
  end

--  -- debug hitbox drawing
--  love.graphics.setColor(255,57,140)
--  love.graphics.setLineWidth(1)
--  clk.hc:draw()

end

function RenderSystem:draw()

  local function getZ(entity)
    return entity:get('Position').z or 0
  end

  local function sortZ(a, b)
    return getZ(a) < getZ(b)
  end

  _.sort(self.targets, sortZ)

    for k, entity in pairs(self.targets) do
      RenderSystem.render(entity)
      RenderSystem.outline(entity)
    end
end

function RenderSystem:requires()
    return {"Render", "Position"}
end