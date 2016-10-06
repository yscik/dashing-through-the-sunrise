CursorSystem = class("CursorSystem", System)

function CursorSystem:initialize()
  System.initialize(self)
  self.cursor = Cursor
  
  love.mouse.setVisible(false)
  
end

function CursorSystem:update(dt)
  self.cursor.move = love.mouse.isDown(2)
  self.cursor.x, self.cursor.y = love.mouse.getPosition()
  
  for k, entity in pairs(self.targets) do
    local pos = entity:get("Position")
    pos.x, pos.y = self.cursor.x, self.cursor.y
        
  end
  
end

function CursorSystem:requires()
    return {"CursorPosition", "Position"}
end