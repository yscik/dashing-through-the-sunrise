
RenderSystem = class("RenderSystem", System)

function RenderSystem:draw()

  local function render_at(pos, dim, fn)
    local cx, cy = dim.width/2, dim.height/2
    love.graphics.push()
    love.graphics.translate((pos.x or 0), (pos.y or 0))
    love.graphics.rotate((pos.r or 0) % (2*math.pi))
    love.graphics.translate(-cx, -cy)
    fn()
    love.graphics.pop()
    love.graphics.circle("fill", (pos.x or 0), (pos.y or 0), 2)
  end

  local function render(entity)
    local canvasc, pos = entity:get("Canvas"), entity:get("Position").pos

    if entity.draw then
      love.graphics.setCanvas(canvasc.canvas)
      love.graphics.clear()

      entity:draw()
      love.graphics.setCanvas()
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.setBlendMode("alpha")

      camera:attach()
      render_at(pos, canvasc, function()
        love.graphics.draw(canvasc.canvas)
      end)
      camera:detach()

    end
  end


  local function outline(entity)
    local clk, canvasc, pos = entity:get("Clickable"), entity:get("Canvas"), entity:get("Position").pos

    if not clk.hover or not clk.shape then return end

    camera:attach()
    render_at(pos, canvasc, function()
      love.graphics.setColor(42,145,225)
      love.graphics.setLineWidth(6)
      love.graphics.line(clk.shape)
    end)

    camera:detach()

  end

  for k, entity in pairs(self.targets.render) do render(entity) end
  for k, entity in pairs(self.targets.outline) do outline(entity) end

end

function RenderSystem:requires()
    return {render = {"Canvas", "Position"}, outline = {"Position", "Canvas", "Clickable"}}
end