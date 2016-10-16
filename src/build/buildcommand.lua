
BuildCommand = DataComponent("BuildCommand")

function BuildCommand:execute()

  self.pos = {x= 0, y = 0, r = 0}
  self.plant = Powerplant(self.parent, self.pos)
  self.plant.status = 0

  world:add(self.plant)

  self:checkTarget()
end

function BuildCommand:checkTarget()
  ui:getTarget({ block_click = true,
    callback = function(input)
      self.plant.status = 0
      if input.target and input.target == self.parent then
        self.plant.status = 30
        local parentPos = self.parent:get('Position')
        self.pos.x, self.pos.y = vector.rotate(-parentPos.at.r, vector.sub(input.pos.x, input.pos.y, parentPos.at.x, parentPos.at.y))
        self.pos.r = vector.angleTo(self.pos.x, self.pos.y) + math.pi/2
        if input.click then self:add() return true end
      end
      return false
    end
    })

end

function BuildCommand:add()
  self.plant.status = 100
  self.plant:built()
end