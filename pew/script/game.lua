
local D2D = require("draw2d")
local State = require("state")
local SL = require("slotlist")

local player = require("entity.player")
local rock = require("entity.rock")
local planet = require("entity.planet")
local stars = require("entity.star")
local gameManager = require("entity.gamemgr")

local PX = 30

debugDrawFlag = false

local game = State({
  entities = SL.new(50),
  bgs = SL.new(50),
  aabbs = SL.new(50),
  player = nil,
  viewWidth = 640,
  viewHeight = 448,
  width = 640 + (2*PX),
  height = 448 + (2*PX),
})

function doWrap(e, st)
  if e.pos.x < -PX then e.pos.x = e.pos.x + st.width
  elseif e.pos.x > st.width - PX then e.pos.x = e.pos.x - st.width
  end

  if e.pos.y < -PX then e.pos.y = e.pos.y + st.height
  elseif e.pos.y > st.height - PX then e.pos.y = e.pos.y - st.height
  end
end

local offset = 30
local gap = 115
local N = 6
function game:decorate()
  for i=1,5,1 do
    local n = math.random(N) - 1
    local xx = offset + gap*n + math.random()*20 - 10
    local yy = math.random() * 440
    self.bgs:push(planet.new(xx, yy, "planetB"), 1)
  end
end

function game:enter()
  local p = player.new(30, 40)
  self.player = p
  self:spawn(p)
  self:decorate()
  self.bgstars = stars.new(-20, -20, 660, 500, 100)
  self:spawn(gameManager.new())
end

function game:spawn(e)
  self.entities:push(e, 1)
  LOG.debug("spawn " .. e.name .. " @ " .. tostring(e.pos))
  e:onSpawn(self)
end

function game:addArea(b)
  self.aabbs:push(b, 1)
end

function game:draw()
  self.bgstars:draw()
  self.bgs:each(function(e)
    e:draw()
  end)
  self.entities:each(function(e)
    if e.pos.x > -30 and e.pos.y > -30 and
      e.pos.x < 670 and e.pos.y < 480 then
        e:draw()
    end
  end)

  if debugDrawFlag == false then 
    return 
  end

  self.aabbs:each(function(a)
    D2D:setColour(0xff, 0, 0, 0x20)
    D2D:rect(a.pos.x, a.pos.y, a.bound.x, a.bound.y)
  end)
end

function game:update(dt)
  self.bgstars:update(dt)
  self.entities:each(function(e, state, i)
    if e:update(dt, self) == false then
      self.entities:setState(i, 0)
      e:onDestroy(self)
    end
    if e.pos.x < -PX or e.pos.y < -PX or 
      e.pos.x > self.width or e.pos.y > self.height then
        if e.wrap == true then
          doWrap(e, self)
        else
          self.entities:setState(i, 0)
          e:onDestroy(self)
        end
    end
  end)

  self.aabbs:each(function(aabb, state, i)
    if aabb.active == false then
      self.aabbs:setState(i, 0)
    else
      self.entities:each(function(e)
        e:collide(aabb)
      end)
    end
  end)
end

function game:padPress(b)
  if b == PAD.SELECT then
    debugDrawFlag = not debugDrawFlag
    reload("entity.player")
  end
  self.player:padPress(b)
end

function game:padRelease(b)
  self.player:padRelease(b)
end

return game
