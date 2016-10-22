
MineCommand = DataComponent("MineCommand")

function MineCommand:execute()

  self.rescon = ResourceConnection()

  self.rescon.target = {entity = systems.player, position = systems.player:get('Position')}
  self.rescon.active = false;

  self:checkTarget()

end

function MineCommand:checkTarget()

  systems.ui:getTarget({ block_click = true,
    callback = function(input)
      if input.click and input.target and input.target.class.name == "Asteroid" then

        local parentPos = input.target:get('Position')
        local pos = {}
        pos.x, pos.y = vector.rotate(-parentPos.at.r, vector.sub(input.pos.x, input.pos.y, parentPos.at.x, parentPos.at.y))
        pos.r = vector.angleTo(pos.x, pos.y) + math.pi/2

        self.rescon.source = {entity = input.target, position = Position({ at = pos, parent = parentPos})};

        self:goAndStart(input.pos)

        return true
      end
      return false
    end,
    cursor = self.cursor
  })
end

function MineCommand.cursor()
  love.graphics.setColor(rgba("#E71414"))
  love.graphics.rectangle("line", -5, -5, 10, 10)
end

function MineCommand:goAndStart(target)
  systems.player:moveTo(target, {callback = function()
    self.rescon:setup()
  end })
end