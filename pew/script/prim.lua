
local D2D = require "draw2d"

local prim = {
  divs = 7,
}

function prim.circle(x, y, r)
  local theta = 0
  local px = r
  local py = 0
  local delta = math.pi * 2 / (prim.divs - 1) 
  for i=1,prim.divs,1 do
    theta = theta + delta
    local nx = math.cos(theta) * r
    local ny = math.sin(theta) * r
    D2D:triangle(x, y, x + nx, y + ny, x + px, y + py)
    px = nx
    py = ny
  end
end

return prim

