
local D2D = require("draw2d")
local State = require("state")
local SL = require("slotlist")

local player = require("entity.player")
local rock = require("entity.rock")
local gameManager = require("entity.gamemgr")

local PX = 30

local game = State({
  entities = SL.new(50),
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

  --LOG.info("wrap " .. e.name)
end

function game:enter()
  local p = player.new(30, 40)
  self.player = p
  self:spawn(p)
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
  self.entities:each(function(e)
    if e.pos.x > -30 and e.pos.y > -30 and
      e.pos.x < 670 and e.pos.y < 480 then
        e:draw()
    end
  end)
  self.aabbs:each(function(a)
    D2D:setColour(0xff, 0, 0, 0x20)
    D2D:rect(a.pos.x, a.pos.y, a.bound.x, a.bound.y)
  end)
end

function game:update(dt)

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
  self.player:padPress(b)
end

function game:padRelease(b)
  self.player:padRelease(b)
end

return game
