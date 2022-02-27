
local D2D = require("draw2d")
local State = require("state")

local player = require("player")

local game = State({
  entities = {},
})

function game:enter()
  local p = player.new(30, 40)
  table.insert(self.entities, p)
end

function game:draw()
  for _, e in ipairs(self.entities) do
    e:draw()
  end
end

function game:update(dt)
  for _, e in ipairs(self.entities) do
    e:update(dt)
  end
end

return game
