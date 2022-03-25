
local D2D = require("draw2d")
local State = require("state")

local player = require("entity.player")
local rock = require("entity.rock")
local gameManager = require("entity.gamemgr")

local PX = 30

local game = State({
  entities = {},
  aabbs = {},
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
  table.insert(self.entities, e)
  LOG.debug("spawn " .. e.name .. " @ " .. tostring(e.pos))
  e:onSpawn(self)
end

function game:addArea(b)
  table.insert(self.aabbs, b)
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
      e:onDestroy(self)
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

  local aabbKillList = {}
  for i, aabb in ipairs(self.aabbs) do
    if aabb.active == false then
      table.insert(aabbKillList, i)
    else
      for _, e in ipairs(self.entities) do
        e:collide(aabb)
      end
    end
  end

  for _, i in ipairs(killList) do
    table.remove(self.entities, i)
    for j=i+1,#killList,1 do
      if killList[j] > killList[i]  then killList[i] = killList[i] - 1 end
    end
  end

  for _, i in ipairs(aabbKillList) do
    table.remove(self.aabbs, i)
    for j=i+1,#aabbKillList,1 do
      if aabbKillList[j] > aabbKillList[i]  then aabbKillList[i] = aabbKillList[i] - 1 end
    end

  end
end

function game:padPress(b)
  self.player:padPress(b)
end

function game:padRelease(b)
  self.player:padRelease(b)
end

return game
