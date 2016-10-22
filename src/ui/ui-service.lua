Ui = class("Ui", Entity)

function Ui:initialize(camera, inputs)
  Entity.initialize(self)
  self.system = {camera = camera, input = inputs}
  self.panels = {}
  
end

function Ui:addPanel(panel)
  
  self.panels[#self.panels+1] = panel
  panel.id = #self.panels
end


function Ui:removePanel(panel)
  _.remove(self.panels, panel)
end

function Ui:draw()
  suit.layout:reset(20, 200)
  suit.layout:padding(10,10)
  _.invoke(self.panels, 'draw', self.system.camera)
end


function Ui:getTarget(callback)
  return self.system.input:listenMouse(callback)
end