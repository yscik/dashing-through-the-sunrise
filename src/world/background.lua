

local function grid(w, h, cell_size, variance)

  local half_cell_size = cell_size * 0.5

  local points = {}
  for i = 0, w, cell_size do
    for j = 0, h, cell_size do

      local x = (i + half_cell_size) + love.math.random(-variance, variance)
      local y = (j + half_cell_size) + love.math.random(-variance, variance)

      points[#points+1] = {x = math.floor(x), y = math.floor(y), color = love.math.random(0, 100) }

    end
  end

  return points

end

Background = class('Background')

function Background:initialize()

  self.points = grid(3000, 3000, 100, 60)

end


function Background:draw()

  _.each(self.points, function(k, point)
    love.graphics.setColor(point.color,point.color,point.color,255)
    love.graphics.circle('fill', point.x, point.y, 1)
  end)

end