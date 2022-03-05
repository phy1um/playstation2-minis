local M = require("ps2math")
local D2D = require("draw2d")

local PX = 30

local playerBullet = {
  pos = M.vec2(0,0),
  speed = 100,
  width = 2,
  height = 2,
  angle = 0,
  colour = {1,1,1}
}

function playerBullet:draw() 
  D2D:setColour(0xff * self.colour[1],
    0xff * self.colour[2],
    0xff * self.colour[3],
    0x80)
  D2D:rect(self.pos.x, self.pos.y, self.width, self.height)
end

function playerBullet:update(dt)
  local fwd = M.vec2(self.speed*dt,0)
  fwd:rotate(self.angle)
  self.pos:add(fwd)
  if self.pos.x < -20 or self.pos.x > 670 or self.pos.y < -20
    or self.pos.y > 470 then return false end
end

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

function player:update(dt, st)
  local rx = PAD.axis(PAD.axisRightX)
  local ry = PAD.axis(PAD.axisRightY)
  local rv = M.vec2(rx, ry)
  if rv:length() > 0.2 then
    self.theta = math.atan(ry, rx)
  end

  local dir = M.vec2(PAD.axis(PAD.axisLeftX), PAD.axis(PAD.axisLeftY))
  dir:scale(self.speed * dt)
  self.pos:add(dir)

  if self.pos.x < -PX then self.pos.x = self.pos.x + st.width
  elseif self.pos.x > st.width - PX then self.pos.x = self.pos.x - st.width
  end

  if self.pos.y < -PX then self.pos.y = self.pos.y + st.height
  elseif self.pos.y > st.height - PX then self.pos.y = self.pos.y - st.height
  end




  if self.spawnBullet == true then
    LOG.debug("spawn bullet @ " .. tostring(self.pos))
    local bo = M.vec2From(self.pos)
    local offset = M.vec2(self.height,0)
    offset:rotate(self.theta)
    bo:add(offset)
    local bullet = setmetatable({
      pos = bo,
      angle = self.theta,
    }, { __index = playerBullet })
    st:spawn(bullet)
    self.spawnBullet = false
  end
end

function player:padPress(b)
  if b == PAD.X then
    self.spawnBullet = true
  end
end

function player:padRelease(b) end

return player
