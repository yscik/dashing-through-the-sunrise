
Asteroid = class("Asteroid", Entity)

function Asteroid:initialize(pos)
  Entity.initialize(self)
  
  self.path = {10,300, 54,206, 150,170, 300,200, 330,250, 250,350, 200, 340, 70,380, 10,300};

--  self:add(Velocity(0,0, 0))
  self:add(Hitbox({shape = self.path, command =
        PanelCommand { content = {
            {type = "title", label = "Asteroid" },
            {type = "info", label = "Resources" , value = {Panel.printResources, self}},
            {label = "Scan", action = ScanCommand({target = self}) },
            {label = "Build powerplant", action = BuildCommand { parent = self } }
          }, entity = self }
    }))

  self:add(Position({at = pos, center = self:get('Hitbox').center}))
  self:add(Render())

  self:add(Resources({
      Storage({type = 'Silicon', content = 1000})
  }))

end

function Asteroid:draw ()

  love.graphics.setColor(200,200,200)
  love.graphics.polygon("fill", self.path)

end


