local CursorComponent = Component.create("Cursor")

function CursorComponent:initialize()  
  self.x = 0;
  self.y = 0;
  self.move = false;
end

Cursor = CursorComponent()

CursorPosition = Component.create("CursorPosition")
