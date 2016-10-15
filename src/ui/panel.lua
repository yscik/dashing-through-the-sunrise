Panel = class("Panel")

function Panel:initialize(anchor, content)
--  self:add(UiPosition {anchor = anchor})
  self.anchor = anchor
  
  self.content = content
end

function Panel:draw(camera)
  
  function drawOption(k, option)
    if suit.Button(option.label, suit.layout:row(180,30)).hit and option.action then
      option.action:execute()
      ui:removePanel(self)
    end
  end

  local pos = {x = 20, y = 200}
  
  local height = #self.content * 50
  local ax,ay = camera:cameraCoords(self.anchor.x, self.anchor.y)
  
  love.graphics.setColor(15,201,255,150)
  love.graphics.circle("fill", pos.x + 100, pos.y + height/2, 5)
  
  love.graphics.setColor(56,56,56, 150)
  love.graphics.rectangle("fill", pos.x, pos.y, 200, height)
  love.graphics.setLineWidth(3)
  love.graphics.setColor(15,201,255,150)
  love.graphics.line(pos.x + 100, pos.y + height/2, ax, ay)  
  love.graphics.circle("fill", ax, ay, 5)
  
  suit.layout:reset(pos.x+10, pos.y+10)
  suit.layout:padding(10,10)

  _.each(self.content, drawOption)
  
end

function Panel:click()

end
