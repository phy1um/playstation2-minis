
local state = {}

function state:enter() end
function state:draw() end
function state:update(dt) end
function state:padPress(b) end
function state:padRelease(b) end

return function(m) return setmetatable(m, {__index = state}) end
