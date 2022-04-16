local M = require("ps2math")

local entity = {
  pos = M.vec2(0,0)
}

function entity:onSpawn() end
function entity:onDestroy() end
function entity:collide() end
function entity:draw() end
function entity:update() end

function entity.define(t)
  if t.name == nil then t.name = "UN-NAMED" end
  LOG.info("DEFINE " .. t.name)
  for k, v in pairs(entity) do
    LOG.info("DEFINE: test " .. k .. " in " .. tostring(t[k]))
    if t[k] == nil and k ~= "define" then
      LOG.info("E set field on " .. t.name .. ": " .. k)
      t[k] = v
    end
  end
  return t
end

return entity
