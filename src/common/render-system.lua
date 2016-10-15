
RenderSystem = class("RenderSystem", System)

function RenderSystem:draw()

  local function render_at(pos, fn)
    love.graphics.push()
    love.graphics.translate(pos.at.x, pos.at.y)
    love.graphics.rotate(pos.at.r or 0 % (2*math.pi))
    love.graphics.translate(-pos.center.x, -pos.center.y)
    fn()
    love.graphics.pop()
    love.graphics.circle("fill", pos.at.x, pos.at.y, 2)
  end

  local function render(entity)
    local canvasc, pos = entity:get("Canvas"), entity:get("Position")

    if entity.draw then
      love.graphics.setCanvas(canvasc.canvas)
      love.graphics.clear()

      entity:draw()
      love.graphics.setCanvas()
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.setBlendMode("alpha")

      camera:attach()
      render_at(pos, function()
        love.graphics.draw(canvasc.canvas)
      end)
      camera:detach()

    end
  end


  local function outline(entity)
    local clk, pos = entity:get("Hitbox"), entity:get("Position")

    camera:attach()

    if clk.hover and clk.shape then
      render_at(pos, function()
        love.graphics.setColor(42,145,225)
        love.graphics.setLineWidth(2)
        love.graphics.line(clk.shape)
      end)
    end

    love.graphics.setColor(255,57,140)
    love.graphics.setLineWidth(1)
    clk.hc:draw()


    camera:detach()

  end

  for k, entity in pairs(self.targets.render) do render(entity) end
  for k, entity in pairs(self.targets.outline) do outline(entity) end

end

function RenderSystem:requires()
    return {render = {"Canvas", "Position"}, outline = {"Position", "Canvas", "Hitbox"}}
end