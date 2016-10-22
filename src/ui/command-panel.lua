CommandPanel = class("CommandPanel")

function CommandPanel:initialize(pos)

  self.options = {
    {label = 'M', action = MineCommand() },
    {label = 'B', action = BuildCommand() }
  }
  self.pos = pos
  self.permanent = true

  systems.input:onKey('m', {callback = function()
    MineCommand():execute()
  end })
end

function CommandPanel:draw()

  local function drawOption(k, option)
    local pos = {suit.layout:row(30,30)}
    if option.action and suit.Button(option.label, {id= self.id .. '.'.. k}, unpack(pos)).hit then
      option.action:execute()
    end

  end

  local px,py = self.pos.x, self.pos.y

  love.graphics.setColor(56,56,56, 150)
  love.graphics.rectangle("fill", px, py, 50, 200)

  suit.layout:push(px+10, py+10)
  suit.layout:padding(10,10)

  _.each(self.options, drawOption)
  suit.layout:pop()

end
