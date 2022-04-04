local M = require("ps2math")
local D2D = require("draw2d")
local playerBullet = require("entity.playerbullet")
local entity = require("entity.entity")
local AABB = require("aabb")
local A = require "assets"

local PX = 30

local player = entity.define({
  pos = M.vec2(0,0),
  speed = 85.2,
  width = 30,
  height = 40,
  theta = 0,
  bulletTimer = 0.1,
  transform = M.mat3(),
  wrap = true,
  name = "PLAYER",
})

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

  D2D:textri(A.player,
    p1.x, p1.y, 0, 0.5, 
    p2.x, p2.y, 0, 0.5,
    p3.x, p3.y, 1, 0)
end

function player.new(x, y)
  local a = AABB.new(x, y, 15, 15)
  return setmetatable({pos = M.vec2(x, y), aabb=a}, {__index = player})
end

function player:update(dt, st)
  self.bulletTimer = self.bulletTimer - dt
  local rx = PAD.axis(PAD.axisRightX)
  local ry = PAD.axis(PAD.axisRightY)
  local rv = M.vec2(rx, ry)
  if rv:length() > 0.8 then
    self.theta = math.atan(ry, rx)
  end

  local dir = M.vec2(PAD.axis(PAD.axisLeftX), PAD.axis(PAD.axisLeftY))
  dir:scale(self.speed * dt)
  self.pos:add(dir)
  self.aabb.pos:add(dir)

  if self.spawnBullet == true then
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

function player:collide(aabb)
  if aabb.kind == "playerdamage" and aabb:testAABB(self.aabb) then
    LOG.info("player ow")
  end
end

function player:padPress(b)
  if b == PAD.R1 and self.bulletTimer < 0 then
    self.spawnBullet = true
    self.bulletTimer = 1
  end
end

function player:padRelease(b) end


return player
