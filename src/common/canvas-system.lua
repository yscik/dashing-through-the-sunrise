
CanvasSystem = class("CanvasSystem", System)

function CanvasSystem:draw()

  for k, entity in pairs(self.targets) do
    local canvas, pos = entity:get("Canvas").canvas, entity:get("Position").pos
    
    if entity.draw then         
      love.graphics.setCanvas(canvas)
      love.graphics.clear()
      
      entity:draw()
      love.graphics.setCanvas()
      
      camera:attach()
      love.graphics.draw(canvas, pos.x, pos.y)
      camera:detach()
    
    end
    
  end
end

function CanvasSystem:requires()
    return {"Canvas", "Position"}
end