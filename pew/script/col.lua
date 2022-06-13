local M = require"ps2math"

local colCircle = {
  pos = M.vec2(0,0),
  r = 0,
  active = true,
  kind = "generic",
  signal = function() end
}

function colCircle.new(x, y, r) 
  return setmetatable({
    pos = M.vec2(x, y),
    r = r,
  },
  {
    __index = colCircle,
    __tostring = function(self)
      return "C" .. tostring(self.pos) .. "R=" .. self.r
    end
  })
end

function colCircle:testPoint(x, y)
  local other = M.vec2(x, y)
  other:sub(self.pos) 
  if other:length() < self.r then
    return true
  else 
    return false
  end
end

function colCircle:testOther(other)
  local oc = M.vec2From(other.pos)
  oc:sub(self.pos)
  local rsum = self.r + other.r
  if oc:length() < rsum then
    return true
  else
    return false
  end
end

function colCircle:testRect(x, y, w, h)
  return self:testPoint(x, y)
    or self:testPoint(x+w, y)
    or self:testPoint(x, y+h)
    or self:testPoint(x+w, y+h)
end

return colCircle

