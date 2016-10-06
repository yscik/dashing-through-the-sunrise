
CanvasSystem = class("CanvasSystem", System)

function CanvasSystem:draw()

  for k, entity in pairs(self.targets) do
    local canvas, pos = entity:get("Canvas").canvas, entity:get("Position")
    
    if entity.draw then         
      love.graphics.setCanvas(canvas)

      entity:draw()
      
      love.graphics.setCanvas()
      love.graphics.draw(canvas, pos.x, pos.y)
    end
    
  end
end

function CanvasSystem:requires()
    return {"Canvas", "Position"}
end