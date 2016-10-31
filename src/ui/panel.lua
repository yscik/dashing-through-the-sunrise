Panel = class("Panel")

function Panel:initialize(anchor, content)
--  self:add(UiPosition {anchor = anchor})
  self.anchor = anchor
  
  self.content = content

end

function Panel:draw(camera)

  local function drawOption(k, option)
    local pos = {suit.layout:row(180,30)}
    if option.action and suit.Button(option.label, {id= self.id .. '.'.. k}, unpack(pos)).hit then
      option.action:execute()
      systems.ui:removePanel(self)
    end

    if option.type == "title" then

      love.graphics.setFont(Font.title)
      love.graphics.setColor(255,255,255,255)
      love.graphics.printf(option.label, pos[1], pos[2], pos[3])
      love.graphics.setFont(Font.default)
    end

    if option.type == "info" and option.value then
      love.graphics.setColor(255,255,255,255)
      love.graphics.printf(option.label, pos[1], pos[2], pos[3])

      if option.value[1] then option.value[1](option.value[2]) end
    end

  end

  local height = #self.content * 50
  local px,py = suit.layout:row(200, height)
  
  local ax,ay = camera:cameraCoords(self.anchor.x, self.anchor.y)
  
  love.graphics.setColor(15,201,255,150)
  love.graphics.circle("fill", px + 100, py + height/2, 5)
  
  love.graphics.setColor(56,56,56, 150)
  love.graphics.rectangle("fill", px, py, 200, height)
  love.graphics.setLineWidth(2)
  love.graphics.setColor(60,60,60,130)
  love.graphics.line(px + 100, py + height/2, ax, ay)
  love.graphics.circle("fill", ax, ay, 4)

  suit.layout:push(px+10, py+10)
  suit.layout:padding(10,10)

  _.each(self.content, drawOption)
  suit.layout:pop()

end

function Panel.printResources(components)

  for k,res in ipairs(components) do
    love.graphics.setColor(255,255,255,255)
    suit.layout:push(suit.layout:row(180,30))
    local pos = {suit.layout:col(120, 30)}
    love.graphics.printf(res.type or "", pos[1], pos[2], pos[3])
    pos = {suit.layout:col(120, 20)}
    love.graphics.printf(string.format('%.0f/%.0f', res.content or 0, res.capacity or 0), pos[1], pos[2], pos[3])

    if res.capacity then
      love.graphics.setColor(56,56,56, 150)
      love.graphics.rectangle('fill', pos[1], pos[2] + 18, 50, 3)
      love.graphics.setColor(rgba('#5AB5F1'))
      love.graphics.rectangle('fill', pos[1], pos[2] + 18, 50 * (res.content / res.capacity), 3)
    end
    suit.layout:pop()
  end

end

function Panel:click()

end
