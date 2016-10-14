Ui = class("Ui", Entity)

function Ui:initialize(camera, inputs)
  Entity.initialize(self)
  self.system = {camera = camera, input = inputs}
  self.panels = {}
  
end

function Ui:addPanel(anchor, content)
  
  self.panels[#self.panels] = Panel(anchor, content)
end

function Ui:draw()
  _.invoke(self.panels, Panel.draw, self.system.camera)
end


function Ui:getTarget(callback)
  return self.system.input:listenMouse(callback)
end