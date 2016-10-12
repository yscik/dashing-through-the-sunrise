Panel = class("Panel", Entity)

function Panel:initialize(anchor, content)
  Entity.initialize(self)  
--  self:add(UiPosition {anchor = anchor})
  self.anchor = anchor
  
  self.content = content
end

function Panel:draw(camera)
  
  function drawOption(k, option)
    love.graphics.setColor(85, 114, 126)
    love.graphics.rectangle("fill", 5, (k-1) * 50 + 5, 190, 40)
    love.graphics.setColor(255,255,255)
    love.graphics.print(option.label, 10, (k-1) * 50 + 10)
  end

  local pos = { x = 20, y = 200 }
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
  
  love.graphics.push()
  love.graphics.translate(pos.x, pos.y)
  _.each(self.content, drawOption)
  love.graphics.pop()
  
end

function Panel:click()
  
end