CursorSystem = class("CursorSystem", System)

function CursorSystem:initialize()
  System.initialize(self)
  self.cursor = Cursor
  
  love.mouse.setVisible(false)
  
end

function CursorSystem:update(dt)
  self.cursor.button.l, self.cursor.button.m, self.cursor.button.r = love.mouse.isDown(1), love.mouse.isDown(3), love.mouse.isDown(2)
  self.cursor.x, self.cursor.y = camera:mousePosition()
  
  for k, entity in pairs(self.targets) do
    local pos = entity:get("Position").pos
    pos.x, pos.y = self.cursor.x, self.cursor.y
        
  end
  
end

function CursorSystem:requires()
    return {"CursorPosition", "Position"}
end