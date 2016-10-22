
MineCommand = DataComponent("MineCommand")

function MineCommand:execute()

  self.rescon = ResourceConnection()

  self.rescon.target = {entity = player, position = player:get('Position')}
  self.rescon.active = false;

  self:checkTarget()

end

function MineCommand:checkTarget()
  ui:getTarget({ block_click = true,
    callback = function(input)
      if input.click and input.target and input.target.class.name == "Asteroid" then

        local parentPos = input.target:get('Position')
        local pos = {}
        pos.x, pos.y = vector.rotate(-parentPos.at.r, vector.sub(input.pos.x, input.pos.y, parentPos.at.x, parentPos.at.y))
        pos.r = vector.angleTo(pos.x, pos.y) + math.pi/2

        self.rescon.source = {entity = input.target, position = Position({ at = pos, parent = parentPos})};
        self.rescon:setup()
        world:add(self.rescon)
        return true
      end
      return false
    end
  })
end