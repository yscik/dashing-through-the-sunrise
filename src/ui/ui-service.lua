Ui = class("Ui", Entity)

function Ui:initialize()
  Entity.initialize(self)

  self.font = love.graphics.newFont('res/AmaticSC-Regular.ttf', 52)
  self.bold = love.graphics.newFont('res/Amatic-Bold.ttf', 52)
  self.panels = {}
  
  suit.theme.color.hovered.bg = {227, 144, 95}
  suit.theme.color.active.bg = {243, 235, 131}
  
end

function Ui:addPanel(panel)
  
  self.panels[#self.panels+1] = panel
  panel.id = #self.panels
end


function Ui:removePanel(panel)
  _.remove(self.panels, panel)
end

function Ui:draw()
  love.graphics.setFont(self.font)
  suit.layout:reset(20, 200)
  suit.layout:padding(10,10)
  _.invoke(self.panels, 'draw', systems.camera)
  
  love.graphics.setColor(255,255,255,150)

  love.graphics.print(string.format('%.2f', systems.score.seconds), love.graphics.getWidth() - 300, 10)
--  love.graphics.print(string.format('%.2f', systems.sun.distance), love.graphics.getWidth() - 300, 10)
--  love.graphics.print((systems.sun:get('Position').visible and 'sun' or ''), love.graphics.getWidth() - 400, 10)
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