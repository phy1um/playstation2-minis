local M = require("ps2math")
local D2D = require("draw2d")

local player = {
  pos = M.vec2(0,0),
  speed = 85.2,
  width = 30,
  height = 40,
  theta = 0,
  transform = M.mat3(),
}

function player:draw()
  D2D:setColour(0xff, 0x0, 0x0, 0x80)

  local p1 = M.vec3(- self.height/2, - self.width/2, 1)
  local p2 = M.vec3(- self.height/2, self.width/2, 1)
  local p3 = M.vec3(self.height/2, 0, 1)
  self.transform[0] = math.cos(self.theta) 
  self.transform[1] = -1 * math.sin(self.theta) 
  self.transform[2] = self.pos.x
  self.transform[3] = math.sin(self.theta) 
  self.transform[4] = math.cos(self.theta) 
  self.transform[5] = self.pos.y

  self.transform:apply(p1)
  self.transform:apply(p2)
  self.transform:apply(p3)

  D2D:triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)
end

function player.new(x, y)
  return setmetatable({pos = M.vec2(x, y)}, {__index = player})
end

function player:update(dt)
  local rx = PAD.axis(PAD.axisRightX)
  local ry = PAD.axis(PAD.axisRightY)
  local rv = M.vec2(rx, ry)
  if rv:length() > 0.2 then
    self.theta = math.atan(ry, rx)
  end

  local dir = M.vec2(PAD.axis(PAD.axisLeftX), PAD.axis(PAD.axisLeftY))
  dir:scale(self.speed * dt)
  LOG.debug("moving at " .. tostring(dir))
  self.pos:add(dir)
end

return player
