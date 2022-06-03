
local D2D = require "draw2d"
local M = require "ps2math"
local entity = require "entity.entity"
local A = require "assets"

local planet = entity.define({
  pos = M.vec2(0,0),
  col = M.vec3(1, 0 ,0),
  a = 0x80,
  v = 0.1,
  uvs = {},
})

function planet.new(x, y, kind)
  if kind == nil then kind = "planetA" end
  return setmetatable({
    pos = M.vec2(x, y),
    uvs = kindToUvs(kind),
    v = kindToSpeed(kind),
    col = col(),
    a = 0x80,
  }, {__index = planet})
end


function planet:draw()
  local r = math.floor(0x80 * self.col.x)
  local g = math.floor(0x80 * self.col.y)
  local b = math.floor(0x80 * self.col.z)
  D2D:setColour(r, g, b, self.a)
  D2D:sprite(A.sprites, self.pos.x, self.pos.y, 40, 40,
    A.planetA[1], A.planetA[2], A.planetA[3], A.planetA[4])
end

function planet:update()
  local np = M.vec2(0, self.v)
  self.pos:add(np)
end

function kindToUvs(k)
  if k == "planetA" then
    return A.planetA
  elseif k == "planetB" then
    return A.planetB
  elseif k == "cloud" then
    return A.cloud
  else
    LOG.error("invalid planet type: " .. k)
    return A.planetA
  end
end

function kindToSpeed(k)
  if k == "cloud" then
    return math.random() * 0.7
  else
    return math.random() / 10
  end
end

function kindToAlpha(k)
  if k == "cloud" then
    return 0x10
  else
    return 0x80
  end
end

function col()
  local r = (math.random() * 0.2) + 0.2
  local g = (math.random() * 0.3) + 0.3
  local b = (math.random() * 0.3) + 0.3
  return M.vec3(r, g, b)
end

return planet

