local D2D = require("draw2d")
local T = require("text")

local mm = {
  cursorPos = 1,
  actions = {},
  itemSep = 30,
  margin = {x=100, y=60},
  baseCol = {r=0xff,g=0xff,b=0xff},
  highlight = {r=0xff,g=0,b=0},
}

function mm:addEntry(name, action)
  table.insert(self.actions, {name=name, action=action})
end

function mm:update(dt)

end

function mm:draw()
  for i, v in ipairs(self.actions) do
    if i == self.cursorPos then
      D2D:setColour(self.highlight.r, self.highlight.g, self.highlight.b, 0x80)
    else
      D2D:setColour(self.baseCol.r, self.baseCol.g, self.baseCol.b, 0x80)
    end
    T.printLines(self.margin.x, self.margin.y + (i-1)*self.itemSep, v.name) 
  end
end

function mm:inputEvent(b, s)
  print(b, s)
  if b == PAD.UP and s == true then
    self.cursorPos = math.max(1, self.cursorPos - 1)
  elseif b == PAD.DOWN and s == true then
    self.cursorPos = math.min(#self.actions, self.cursorPos + 1)
  elseif b == PAD.X and s == true then
    self.actions[self.cursorPos].action()
  end
end

return {
  new = function()
    return setmetatable({}, { __index = mm })
  end
}
