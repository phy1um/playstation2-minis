
local D2D = require("draw2d")
local M = require("ps2math")
local entity = require("entity.entity")
local COL = require "col"
local A = require "assets"

local CX = 320
local CY = 224
local RROT = 0.3

local rock = entity.define({
  pos = M.vec2(0, 0),
  rv = 1.4,
  theta = 0,
  dir = M.vec2(0, 0),
  speed = 2.4,
  scale = 1,
  wrap = true,
  name = "ROCK",
  transform = M.mat3(),
})

function rock.new(x, y)
  local dc = M.vec2(CX - x, CY - y)
  dc:normalize()
  local rangle = (math.random() * (2*RROT)) - RROT
  dc:rotate(rangle)
  local out = setmetatable({
    pos = M.vec2(x, y),
    dir = dc,
    aabb = COL.new(x, y, 12)
  }, {__index = rock})
  out.aabb.kind = "playerdamage"
  return out
end

function rock:onSpawn(st)
  st:addArea(self.aabb)
end

function rock:onDestroy()
  self.aabb.active = false
  if self.cb then
    self.cb()
  end
end

function rock:update(dt)
  self.aabb.pos:copy(self.pos)
  if self.kill == true then return false end
  local delta = M.vec2From(self.dir)
  delta:scale(self.speed)
  self.pos:add(delta)
  self.theta = self.theta + 0.8 * dt
end

function rock:draw()
  self.transform[0] = math.cos(self.theta) 
  self.transform[1] = -1 * math.sin(self.theta) 
  self.transform[2] = self.pos.x
  self.transform[3] = math.sin(self.theta) 
  self.transform[4] = math.cos(self.theta) 
  self.transform[5] = self.pos.y 

  local p1 = M.vec3(-15, -15, 1)
  local p2 = M.vec3(-15, 15, 1)
  local p3 = M.vec3(15, 15, 1)
  local p4 = M.vec3(15, -15, 1)

  self.transform:apply(p1)
  self.transform:apply(p2)
  self.transform:apply(p3)
  self.transform:apply(p4)

  D2D:setColour(0x60, 0x55, 0x55, 0x80)
  D2D:textri(A.sprites, 
    p1.x, p1.y, A.rockST[1], A.rockST[3],
    p2.x, p2.y, A.rockST[1], A.rockST[4],
    p3.x, p3.y, A.rockST[2], A.rockST[4])
  D2D:textri(A.sprites, 
    p3.x, p3.y, A.rockST[2], A.rockST[4],
    p4.x, p4.y, A.rockST[2], A.rockST[3],
    p1.x, p1.y, A.rockST[1], A.rockST[3])


end

function rock:collide(aabb)
  if aabb.kind == "enemydamage" and aabb:testOther(self.aabb) then
    LOG.info("OW")
    self.kill = true
    aabb.signal("kill")
  end
end


return rock
