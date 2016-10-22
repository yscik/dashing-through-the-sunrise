Ui = class("Ui", Entity)

function Ui:initialize()
  Entity.initialize(self)

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
  _.invoke(self.panels, 'draw', systems.camera)
end


function Ui:getTarget(callback)
  if callback.cursor then systems.cursor:setMode(callback.cursor) end

  return systems.input:listenMouse(_.extend({}, callback, {after = function()
    if callback.cursor then systems.cursor:reset() end
  end}))
end

function Ui:clear()
  local s = #self.panels
  for i=s,1,-1 do
    if not self.panels[i].permanent then
      table.remove(self.panels, i)
    end
  end

  return s ~= #self.panels
end