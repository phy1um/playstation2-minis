
local D2D = require("draw2d")
local State = require("state")

local player = require("player")
local rock = require("entity.rock")
local gameManager = require("gamemgr")

local PX = 30

local game = State({
  entities = {},
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

  LOG.info("wrap " .. e.name)
end

function game:enter()
  local p = player.new(30, 40)
  self.player = p
  self:spawn(p)
  self:spawn(gameManager.new())
end

function game:spawn(e)
  table.insert(self.entities, e)
end

function game:draw()
  for _, e in ipairs(self.entities) do
    if e.pos.x > -30 and e.pos.y > -30 and
      e.pos.x < 670 and e.pos.y < 480 then
      e:draw()
    end
  end
end

function game:update(dt)
  local killList = {}
  for i, e in ipairs(self.entities) do
    if e:update(dt, self) == false then
      table.insert(killList, i)
    end
    if e.pos.x < -PX or e.pos.y < -PX or 
      e.pos.x > self.width or e.pos.y > self.height then
        if e.wrap == true then
          doWrap(e, self)
        else
          table.insert(killList, i) 
        end
    end
  end

  for _, i in ipairs(killList) do
    table.remove(self.entities, i)
  end
end

function game:padPress(b)
  self.player:padPress(b)
end

function game:padRelease(b)
  self.player:padRelease(b)
end

return game
