local M = require("ps2math")

local aabb = {
  pos = M.vec2(0,0),
  bound = M.vec2(0,0),
  active = true,
  kind = "generic",
  signal = function() end
}

function aabb.new(x, y, w, h)
  return setmetatable({
    pos = M.vec2(x, y),
    bound = M.vec2(w, h),
  }, {__index = aabb, 
      __tostring = function(x)
                      return tostring(x.pos) .. ":" .. tostring(x.bound)
                    end
  })
end

function aabb:testPoint(x, y)
  return x >= self.pos.x and x < self.pos.x + self.bound.x
   and y >= self.pos.y and y < self.pos.y + self.bound.y
end

function aabb:testAABB(other)
  return other:testPoint(self.pos.x, self.pos.y)
    or other:testPoint(self.pos.x + self.bound.x, self.pos.y)
    or other:testPoint(self.pos.x, self.pos.y + self.bound.y)
    or other:testPoint(self.pos.x + self.bound.x, self.pos.y + self.bound.y)
end

function aabb:testRect(x, y, w, h)
  return self:testPoint(x, y)
    or self:testPoint(x+w, y)
    or self:testPoint(x, y+h)
    or self:testPoint(x+w, y+h)
end

return aabb
