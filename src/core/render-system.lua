
RenderSystem = class("RenderSystem", System)
Render = Component.create("Render")

function Render:initialize(options)
  options = options or {}
  _.extend(self, options)
  
--  if options.cache and not options.canvas then
--    self:setCache(options.cache)
--  end
end

function Render:setCache(enabled)
  self.cache = enabled
  if enabled then
    
  else
  self.canvas = nil
  end
end

function Render:render(fn, ...)
  
  local w, h = self.size and self.size[1], self.size[2] or love.graphics.getDimensions()
  self.canvas = love.graphics.newCanvas(w, h, "normal", 8)
  self.w, self.h = self.canvas:getDimensions()
  
  love.graphics.push()
  love.graphics.reset()
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.translate(self.w/2, self.h/2)
  fn(...)
  love.graphics.setCanvas()
  self.rendered = true
  love.graphics.pop()
  
end

function RenderSystem.drawCanvas(render)
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.translate(-render.w/2, -render.h/2)
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(render.canvas)
  love.graphics.setBlendMode("alpha")
end

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
  local pos, render = entity:get("Position"), entity:get('Render')
  
--  if self:visible(pos) ~= pos.visible then print(entity.id .. ': ' .. (v and 'visible' or 'hidden')) end
  
  pos.visible = self:visible(pos)

  if pos.visible or pos.absolute then
    if entity.draw then
      if render.cache then
        if not render.rendered then
          render:render(entity.draw, entity)
        end
        RenderSystem.atPosition(pos, RenderSystem.drawCanvas, render)
      else
        RenderSystem.atPosition(pos, entity.draw, entity)
      end
    end
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

function RenderSystem:initialize()
  System.initialize(self)
  self.items = {}
  self.bb = {}
end

function RenderSystem:draw()
  local margin = 300
  local w,h = love.graphics.getDimensions()
  self.bb.x1, self.bb.y1, self.bb.x2, self.bb.y2 =
    systems.camera.x - w/2 - margin,
    systems.camera.y - h/2- margin,
    systems.camera.x + w/2 + margin,
    systems.camera.y + h/2 + margin
  

  for z, items in pairs(self.items) do
    for id, entity in pairs(items) do
      if self.targets[entity.id] == nil then self.items[z][id] = nil
      else self:render(entity) end
    end
  end
end

function RenderSystem:visible(pos)
  return pos.at.x > self.bb.x1 and pos.at.y > self.bb.y1 and pos.at.x < self.bb.x2 and pos.at.y < self.bb.y2

end


local function getZ(entity)
  return entity:get('Position').z or 0
end

function RenderSystem:onAddEntity(entity)
  local z = getZ(entity)
  if self.items[z] == nil then self.items[z] = {} end
  self.items[z][entity.id] = entity
end

function RenderSystem:requires()
    return {"Render", "Position"}
end