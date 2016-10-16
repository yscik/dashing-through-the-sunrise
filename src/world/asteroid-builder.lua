
function Asteroid:generate(o)

  local path = _.clone(o.base)

  local function n(i)
    return ((i-1)%(#path))+1
  end
  local function p(i)
    return path[n(i)]
  end

  local function d(x,y, min, max)
    return min + (love.math.noise(x+o.seed,y+o.seed)*(max-min))
  end

  local function transformMidPoint(rate, ax,ay,bx,by)
    local px,py = vector.mul(rate, vector.rotate(math.pi/2, vector.sub(ax,ay,bx,by)))
    px,py = vector.rotate(d(px,py, 0.3, 0.8), vector.mul(d(py,px, 0.1, 0.4), px, py))
    return vector.add(px,py, vector.mul(0.5, vector.add(ax,ay,bx,by)))
  end

  local function addPoint(i)
    local ax,ay,bx,by = p(i), p(i+1), p(i+2), p(i+3)
    local cx,cy = transformMidPoint(1, ax,ay,bx,by)
    table.insert(path, i+2, cy)
    table.insert(path, i+2, cx)

  end
  local function smoothPoint(i)
    local ax,ay,bx,by = p(i-2), p(i-1), p(i+2), p(i+3)

    local cx,cy = transformMidPoint(0.1, ax,ay,bx,by)
    table.remove(path, i)
    table.remove(path, i)
    table.insert(path, i, cy)
    table.insert(path, i, cx)

  end

  local function subd()
    for i = 1, #path*2, 4 do
      addPoint(i)
    end
  end

  local function smooth()
    for i = 1, #path, 4 do
      smoothPoint(i)
      end
  end

  subd()
  smooth()
  subd()
  smooth()

  path[#path+1] = path[1]
  path[#path+1] = path[2]

  return path

end

