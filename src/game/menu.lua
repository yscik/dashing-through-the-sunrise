
Menu = class('Menu')

function Menu:initialize()
  local w, h = love.graphics.getDimensions()

  self.width = 400
  self.height = 100
  self.x = w / 2 - self.width/2
  self.y = h / 2 - 2 * self.height / 2
end

function Menu:update(dt)

  suit.layout:reset(self.x, self.y)
  suit.layout:padding(0, 50)
  if systems.state.paused then
    if suit.Button('Resume', suit.layout:row(self.width, self.height)).hit then
      systems.state:resume()
    end
  else
    if systems.state.started then
      suit.Label(string.format('%.0f seconds of sunshine', systems.score.seconds), suit.layout:row(self.width, self.height))
    end
  
    if suit.Button(not systems.state.started and 'Play' or 'Again', suit.layout:row(self.width, self.height)).hit then
      systems.state:start()
    end
  end
  if suit.Button('Quit', suit.layout:row(self.width, self.height)).hit then
    love.event.quit()
  end
  
  if systems.state.generating then
    local progress = systems.pool.count.done / systems.pool.count.total;
    suit.Label(string.format('(even more rocks)\n%.0f%%', progress*100), suit.layout:row(self.width, self.height))
  end
end

