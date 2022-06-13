local M = require("ps2math")
local rock = require("entity.rock")
local entity = require("entity.entity")
local player = require"entity.player"
local A = require("assets")
local D2D = require("draw2d")

local D_RIGHT = 0
local D_TOP = 1
local D_LEFT = 2
local D_BTM = 3

local mgr = entity.define({
  nextRock = 1,
  nextRockDelay = 4,
  rockSpawnedCount = 0,
  rockSpawnMax = 8,
  acc = 0,
  lastDir = 0,
  name = "GAMEMGR",
  score = 0,
  gameOver = false,
  gameOverTimer = 3,
})

function mgr.new()
  return setmetatable({}, {__index = mgr})
end

function mgr:makePlayer(x, y)
  local out = player.new(x, y)
  out.onDeath = function()
    LOG.debug("GAME OVER")
    out.alive = false
    self.gameOver = true
  end
  self.getHealth = function() 
    return out.health
  end
  return out
end

function mgr:makeRock(x, y)
  local out = rock.new(x, y)
  out.cb = function()
    self.score = self.score + 100
    self.rockSpawnedCount = self.rockSpawnedCount - 1
  end
  return out
end

function mgr:update(dt, state)
  if self.gameOver == true then
    self.gameOverTimer = self.gameOverTimer - dt
    return
  end
  self.nextRock = self.nextRock - dt
  if self.nextRock < 0 and self.rockSpawnedCount < self.rockSpawnMax then
    self.nextRock = self.nextRockDelay
    self.acc = self.acc+1
    local d = math.random(4) - 1
    while d == self.lastDir do d = math.random(4) - 1 end
    self.lastDir = d
    local x = 0
    local y = 0
    if d == D_RIGHT then
      x = 660
      y = (math.random() * 450) + 30
    elseif d == D_LEFT then
      x = -20
      y = (math.random() * 450) + 30
    elseif d == D_TOP then
      y = -20
      x = (math.random() * 610) + 30
    elseif d == D_BTM then
      y = 468
      x = (math.random() * 610) + 30
    end
    state:spawn(self:makeRock(x, y))
    self.rockSpawnedCount = self.rockSpawnedCount + 1
  end
end

function mgr:draw()
  D2D:setColour(0x80, 0x80, 0x80, 0x80)
  --T.printLines(10, 10, "Score: " .. self.score)
  A.font:printLines(10, 10, "Score: " .. string.format("%06s", self.score))
  A.font:printLines(200, 10, "Health: " .. self.getHealth())
  if self.gameOver == true and self.gameOverTimer < 0 then
    A.font:centerPrint(0, 200, 640, "GAME OVER") 
  end
end


return mgr
