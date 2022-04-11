
local D2D = require "draw2d"
local M = require "ps2math"
local entity = require "entity.entity"
local A = require "assets"

1ocal planet = entity.define({
  pos = M.vec2(0,0),
})

function planet.new(x, y)
  return setmetatable({pos = M.vec2(x, y)}, {__index = planet})
end


function planet:draw()
  D2D:setColour(0xff * self.col.x, 0xff * self.col.y, 0xff * self.col.z, 0x80)
  D2D:sprite(A.sprite, self.pos.x, self.pos.y, 32, 32,
    A.planetA[1], A.planetA[3], A.planetA[2], A.planetA[4])
end

return planet
