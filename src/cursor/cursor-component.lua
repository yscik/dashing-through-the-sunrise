local CursorComponent = Component.create("Cursor")

function CursorComponent:initialize()  
  self.x = 0;
  self.y = 0;
  self.button = {};
end

Cursor = CursorComponent()

CursorPosition = Component.create("CursorPosition")
