local M = require("ps2math")
local rock = require("entity.rock")

local D_RIGHT = 0
local D_TOP = 1
local D_LEFT = 2
local D_BTM = 3

local mgr = {
  pos = M.vec2(0,0),
  nextRock = 1,
  acc = 0,
  lastDir = 0,
}

function mgr.new()
  return setmetatable({}, {__index = mgr})
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
      state:spawn(rock.new(x, y)) 
    elseif d == D_LEFT then
      local x = -20
      local y = (math.random() * 450) + 30
      state:spawn(rock.new(x, y)) 
    elseif d == D_TOP then
      local y = -20
      local x = (math.random() * 610) + 30
      state:spawn(rock.new(x,y))
    elseif d == D_BTM then
      local y = 468
      local x = (math.random() * 610) + 30
      state:spawn(rock.new(x,y))
    end
  end
end

function mgr:draw() end

return mgr
