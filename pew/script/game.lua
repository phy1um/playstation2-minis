
local D2D = require("draw2d")
local State = require("state")

local player = require("player")

local game = State({
  entities = {},
  player = nil,
})

function game:enter()
  local p = player.new(30, 40)
  self.player = p
  self:spawn(p)
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
  for _, e in ipairs(self.entities) do
    e:update(dt, self)
  end
end

function game:padPress(b)
  self.player:padPress(b)
end

function game:padRelease(b)
  self.player:padRelease(b)
end

return game
