local M = require("ps2math")
local D2D = require("draw2d")
local AABB = require("aabb")
local entity = require("entity.entity")

local playerBullet = entity.define({
  pos = M.vec2(0,0),
  speed = 100,
  width = 2,
  height = 2,
  angle = 0,
  colour = {1,1,1},
  alive = true,
  name = "PBULLET",
})

function playerBullet:onSpawn(st)
  self.aabb = AABB.new(self.pos.x, self.pos.y, self.width, self.height)
  self.aabb.kind = "enemydamage"
  self.aabb.signal = function(s)
    if s == "kill" then self.alive = false end 
  end
  st:addArea(self.aabb)
end

function playerBullet:onDestroy(st)
  self.aabb.active = false
end

function playerBullet:draw() 
  D2D:setColour(0xff * self.colour[1],
    0xff * self.colour[2],
    0xff * self.colour[3],
    0x80)
  D2D:rect(self.pos.x, self.pos.y, self.width, self.height)
end

function playerBullet:update(dt)
  if self.alive == false then return false end
  local fwd = M.vec2(self.speed*dt,0)
  fwd:rotate(self.angle)
  self.pos:add(fwd)
  if self.pos.x < -20 or self.pos.x > 670 or self.pos.y < -20
    or self.pos.y > 470 then return false end
  self.aabb.pos = self.pos
end

return playerBullet
