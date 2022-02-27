
local D2D = require("draw2d")
local text = {
  font = nil
}

function getCharacterIndex(i)
  if i >= 0 and i <= 32 then
    return i+96
  elseif i >= 33 and i <= 126 then
    return i-32
  else
    error("bad character index in string " .. i)
  end
end

local CHAR_WIDTH_S = 0.03125
local CHAR_HEIGHT_T = 0.25

function drawString(line, x, y)
  for i=1,#line,1 do
    local ci = getCharacterIndex(string.byte(line, i))
    local ts = (ci % 32) * CHAR_WIDTH_S
    local tt = math.floor(ci/32) * CHAR_HEIGHT_T
    D2D:sprite(text.font, x+(8*i), y, 8, 16, ts, tt, 
      ts + CHAR_WIDTH_S, tt + CHAR_HEIGHT_T)
  end
end

function text.printLines(x, y, ...)
  for i, l in ipairs({...}) do
    drawString(l, x, y + ((i-1)*16))
  end
end


return text
