
local D2D = require("draw2d")
local text = {
  texture = nil,
  charWidth = 8,
  charHeight = 14,
  charS = 0.03125,
  charT = 0.25
}

local function getCharacterIndex(i)
  if i >= 0 and i <= 32 then
    return i+96
  elseif i >= 33 and i <= 126 then
    return i-32
  else
    error("bad character index in string " .. i)
  end
end

function text:drawString(line, x, y)
  for i=1,#line,1 do
    local ci = getCharacterIndex(string.byte(line, i))
    local ts = (ci % self.charsPerLine) * self.charS
    local tt = math.floor(ci/self.charsPerLine) * self.charT
    D2D:sprite(self.texture, x+(self.charWidth*i), y, self.charWidth, self.charHeight, ts, tt, 
      ts + self.charS, tt + self.charT)
  end
end

function text:printLines(x, y, ...)
  for i, l in ipairs({...}) do
    self:drawString(l, x, y + ((i-1)*self.charHeight))
  end
end

function text.new(texture, charWidth, charHeight)
  return setmetatable({
    texture = texture,
    charWidth = charWidth,
    charHeight = charHeight,
    charS = charWidth / texture.width,
    charT = charHeight / texture.height,
    charsPerLine = 32,
    resident = false,
  }, { __index = text })
end

return text
