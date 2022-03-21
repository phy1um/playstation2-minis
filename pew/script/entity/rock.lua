
local D2D = require("draw2d")
local M = require("ps2math")

local CX = 320
local CY = 224
local RROT = 0.3

local rock = {
  pos = M.vec2(0, 0),
  rv = 1.4,
  theta = 0,
  dir = M.vec2(0, 0),
  speed = 2.4,
  scale = 1,
  wrap = true,
  name = "ROCK",
}

function rock.new(x, y)
  local dc = M.vec2(CX - x, CY - y)
  dc:normalize()
  local rangle = (math.random() * (2*RROT)) - RROT
  dc:rotate(rangle)
  local out = setmetatable({
    pos = M.vec2(x, y),
    dir = dc,
  }, {__index = rock})

  return out
end

function rock:update(dt)
  local delta = M.vec2From(self.dir)
  delta:scale(self.speed)
  self.pos:add(delta)
end

function rock:draw()
  D2D:setColour(0xff, 0xff, 0, 0x80)
  D2D:rect(self.pos.x, self.pos.y, 20, 20)
end


return rock
