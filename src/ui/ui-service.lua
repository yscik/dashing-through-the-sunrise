Ui = class("Ui", Entity)

function Ui:initialize(camera)
  Entity.initialize(self)
  self.camera = camera
  self.panels = {}
  
end

function Ui:addPanel(anchor, content)
  
  self.panels[#self.panels] = Panel(anchor, content)
end

function Ui:draw()
  _.invoke(self.panels, Panel.draw, self.camera)
end
