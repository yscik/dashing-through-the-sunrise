StatusPanel = class("StatusPanel")

function StatusPanel:initialize(player, pos)

  self.entity = player
  self.pos = pos
  self.permanent = true

end

function StatusPanel:draw()

  local function drawOption(k, option)
    local pos = {suit.layout:row(30,30)}
    if option.action and suit.Button(option.label, {id= self.id .. '.'.. k}, unpack(pos)).hit then
      option.action:execute()
    end

  end

  local px,py = self.pos.x, self.pos.y

  local components = self.entity:get('Resources').components
  love.graphics.setColor(56,56,56, 150)
  love.graphics.rectangle("fill", px, py, 200, #components*50)

  suit.layout:push(px+10, py+10)
  suit.layout:padding(10,10)

  Panel.printResources(components)
  suit.layout:pop()

end
