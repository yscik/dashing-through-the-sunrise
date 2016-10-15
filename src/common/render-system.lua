
RenderSystem = class("RenderSystem", System)
Render = Component.create("Render")

function RenderSystem.atPosition(pos, fn, ...)
  love.graphics.push()
  love.graphics.translate(pos.at.x, pos.at.y)
  love.graphics.rotate(pos.at.r or 0 % (2*math.pi))
  love.graphics.translate(-pos.center.x, -pos.center.y)
  fn(...)
  love.graphics.pop()
  love.graphics.setColor(255,255,255,150)
  love.graphics.circle("fill", pos.at.x, pos.at.y, 2)
end

function RenderSystem.render(entity)
  local pos = entity:get("Position")

  if entity.draw then
    RenderSystem.atPosition(pos, entity.draw, entity)
  end
end

function RenderSystem.outline(entity)
  local clk, pos = entity:get("Hitbox"), entity:get("Position")

  if clk.hover and clk.shape then
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
  camera:attach()
    for k, entity in pairs(self.targets.render) do RenderSystem.render(entity) end
    for k, entity in pairs(self.targets.outline) do RenderSystem.outline(entity) end
  camera:detach()
end

function RenderSystem:requires()
    return {render = {"Render", "Position"}, outline = {"Position", "Render", "Hitbox"}}
end