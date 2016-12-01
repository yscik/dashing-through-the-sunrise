
Splash = class('Splash')

function Splash:initialize()
  local w, h = love.graphics.getDimensions()
  self.width = 400
  self.height = 60
  self.x = w / 2 - self.width/2
  self.y = h / 2
end

function Splash:update(dt)

  suit.layout:reset(self.x, self.y)
  suit.layout:padding(0, 20)
  
  local progress = systems.pool.count.done / systems.pool.count.total;
  love.graphics.setFont(systems.ui.fonts.title)
  suit.Label('Dashing through the Sunrise', {align = center, color = {normal = {fg = {rgba('#C89C67')}}}}, 0, self.y - 200, love.graphics.getWidth())
  love.graphics.setFont(systems.ui.fonts.base)
  suit.Label('generating space rocks', suit.layout:row(self.width, self.height))
  suit.Label(string.format('%.0f%%', progress*100), suit.layout:row(self.width, self.height))
end

