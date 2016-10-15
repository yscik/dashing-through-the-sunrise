Canvas = Component.create("Canvas")

function Canvas:initialize(width, height)
  self.canvas = love.graphics.newCanvas(width, height or width);
  self.width = width;
  self.height = height or width;
end