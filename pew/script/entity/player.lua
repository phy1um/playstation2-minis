local M = require("ps2math")
local D2D = require("draw2d")
local playerBullet = require("entity.playerbullet")
local entity = require("entity.entity")
local AABB = require("aabb")
local A = require "assets"

local PX = 30

local player = entity.define({
  pos = M.vec2(0,0),
  velocity = M.vec2(0,0),
  maxVelocity = 3, -- NOT IN PIXELS/SEC
  accel = 4,
  width = 30,
  height = 40,
  theta = 0,
  bulletTimer = 0.1,
  transform = M.mat3(),
  wrap = true,
  name = "PLAYER",
})

function player:draw()
  D2D:setColour(0x60, 0x60, 0x60, 0x80)

  local p1 = M.vec3(-15,-15,1)
  local p2 = M.vec3(15,-15,1)
  local p3 = M.vec3(-15,15,1)
  local p4 = M.vec3(15,15,1)

  self.transform[0] = math.cos(self.theta) 
  self.transform[1] = -1 * math.sin(self.theta) 
  self.transform[2] = self.pos.x
  self.transform[3] = math.sin(self.theta) 
  self.transform[4] = math.cos(self.theta) 
  self.transform[5] = self.pos.y

  self.transform:apply(p1)
  self.transform:apply(p2)
  self.transform:apply(p3)
  self.transform:apply(p4)

  D2D:textri(A.sprites,
    p1.x, p1.y, A.playerST[1], A.playerST[3],
    p2.x, p2.y, A.playerST[2], A.playerST[3],
    p3.x, p3.y, A.playerST[1], A.playerST[4])
  D2D:textri(A.sprites,
    p4.x, p4.y, A.playerST[2], A.playerST[4],
    p2.x, p2.y, A.playerST[2], A.playerST[3],
    p3.x, p3.y, A.playerST[1], A.playerST[4])

  if debugDrawFlag == false then return end

  D2D:setColour(0xff, 0xff, 0x0, 0x20)
  local m = M.vec2(30,0)
  m:rotate(self.theta)
  m:add(self.pos)
  D2D:rect(m.x - 3, m.y - 3, 6, 6)
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
  dir:scale(self.accel * dt)
  self.velocity:add(dir)
  if self.velocity:length() > self.maxVelocity then
    local c = self.maxVelocity/self.velocity:length()  
    self.velocity:scale(c)
  end
  self.pos:add(self.velocity)

  if self.spawnBullet == true then
    local bo = M.vec2From(self.pos)
    local offset = M.vec2(5,0)
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
