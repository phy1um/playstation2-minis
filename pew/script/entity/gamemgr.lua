local M = require("ps2math")
local rock = require("entity.rock")
local entity = require("entity.entity")
local T = require("text")
local D2D = require("draw2d")

local D_RIGHT = 0
local D_TOP = 1
local D_LEFT = 2
local D_BTM = 3

local mgr = entity.define({
  nextRock = 1,
  acc = 0,
  lastDir = 0,
  name = "GAMEMGR",
  score = 1000,
})

function mgr.new()
  return setmetatable({}, {__index = mgr})
end

function mgr:makeRock(x, y)
  local out = rock.new(x, y)
  rock.cb = function()
    self.score = self.score + 100
  end
  return out
end

function mgr:update(dt, state)
  self.nextRock = self.nextRock - dt
  if self.nextRock < 0 then
    self.nextRock = 4
    self.acc = self.acc+1
    local d = math.random(4) - 1
    while d == self.lastDir do d = math.random(4) - 1 end
    self.lastDir = d
    if d == D_RIGHT then
      local x = 660
      local y = (math.random() * 450) + 30
      state:spawn(self:makeRock(x, y))
    elseif d == D_LEFT then
      local x = -20
      local y = (math.random() * 450) + 30
      state:spawn(self:makeRock(x, y))
    elseif d == D_TOP then
      local y = -20
      local x = (math.random() * 610) + 30
      state:spawn(self:makeRock(x, y))
    elseif d == D_BTM then
      local y = 468
      local x = (math.random() * 610) + 30
      state:spawn(self:makeRock(x, y))
    end
  end
end

function mgr:draw()
  D2D:setColour(0xff, 0xff, 0xff, 0x80)
  T.printLines(10, 10, "Score: " .. self.score)
end

return mgr
