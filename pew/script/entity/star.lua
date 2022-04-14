local M = require "ps2math"
local D2D = require "draw2d"
local entity = require "entity.entity"
local SL = require "slotlist"

local stars = entity.define({
  pos = M.vec2(0,0),
  entries = SL.new(5),
  range = M.vec2(0, 0),
  name = "stars",
})

function stars:add() 
  local xx = math.random(self.pos.x, self.range.x+1) - 1 + math.random()
  local yy = math.random(self.pos.y, self.range.y+1) - 1 + math.random()
  local s = {
    x = xx,
    y = yy,
    d = math.random(),
    p = math.random() * 2 + 4,
    m = math.min(math.random() + 0.3, 1)
  }
  self.entries:push(s, 1)
end

function stars:update(dt)
  self.entries:each(function(star)
    step(star, dt)
  end)
end

function stars:draw()
  self.entries:each(function(star)
    draw(star)
  end)
end

function step(star, dt)
  star.d = star.d + dt 
end

function draw(star)
  local brightness = math.max(0, math.min(1, math.sin(star.d) + star.m)) * 0.1 + 0.4
  D2D:setColour(math.floor(brightness*0x80), math.floor(brightness*0x80), math.floor(brightness*0x80), 0x80)
  D2D:rect(star.x, star.y, 3.1, 3.1)
end

function stars.new(x, y, w, h, n)
  local st = setmetatable({
    entries = SL.new(n),
    pos = M.vec2(x, y),
    range = M.vec2(w, h),
  }, {__index = stars})
  for i=1,n,1 do
    st:add()
  end
  return st
end

return stars
