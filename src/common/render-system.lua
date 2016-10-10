
RenderSystem = class("RenderSystem", System)

function RenderSystem:draw()

  for k, entity in pairs(self.targets) do
    local canvasc, pos = entity:get("Canvas"), entity:get("Position").pos
    
    if entity.draw then         
      love.graphics.setCanvas(canvasc.canvas)
      love.graphics.clear()
      
      entity:draw()
      love.graphics.setCanvas()
      love.graphics.setColor(255, 255, 255, 255)
      love.graphics.setBlendMode("alpha")
      
      camera:attach()
      love.graphics.draw(canvasc.canvas, (pos.x or 0) - canvasc.width/2, (pos.y or 0) - canvasc.height/2)
      camera:detach()
    
    end
    
  end
end

function RenderSystem:requires()
    return {"Canvas", "Position"}
end