Canvas = Component.create("Canvas")

function Canvas:initialize(width, height)
  self.canvas = love.graphics.newCanvas(width, height);
  self.width = width;
  self.height = height;
end