
Asteroid = class("Asteroid", Entity)

function Asteroid:initialize(pos)
  Entity.initialize(self)
  
  self.path = {10,300, 54,206, 150,170, 300,200, 330,250, 250,350, 200, 340, 70,380, 10,300};
  
  self:add(Position(pos))
  self:add(Canvas(350,400))
  self:add(Clickable({shape = self.path, command = 
        PanelCommand { content = {
            {type = "Title", label = "Asteroid" },
            {type = "Info", label = "Resources" },
            {label = "Scan", action = ScanCommand({target = self}) },
            {label = "Build powerplant", action = BuildCommand { parent = self } }
          }, entity = self }
    }))
  
  self:add(Resources({
      Storage({type = 'Silicon', content = 1000})
  }))

end

function Asteroid:draw ()

  love.graphics.setColor(200,200,200)
  love.graphics.polygon("fill", self.path)
  
  if self:get("Clickable").hover then
    love.graphics.setColor(42,145,225)
    love.graphics.setLineWidth(6)
    love.graphics.line(self.path)
  end


end


