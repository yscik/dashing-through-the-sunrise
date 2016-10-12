InputState = class("InputState")

function InputState:initialize()  
  self.pos = {x = 0, y = 0};
  self.uiPos = {x = 0, y = 0};
  self.target = nil
  self.move = nil
  self.command = nil
end
