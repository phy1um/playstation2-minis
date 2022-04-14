
local D2D = require "draw2d"

local a = {
  inVram = false,
  playerST = {0, 0.5, 0.5, 1},
  rockST = {0.5, 1, 0.5, 1},
  planetA = {0, 0, 0.25, 0.25},
  planetB = {0.25, 0, 0.5, 0.25},
  cloud = {0.5, 0, 0.75, 0.25},
}

function a:loadTex(vr)
  self.sprites = D2D.loadTexture("sprites.tga")
  vr:texture(self.sprites)
end

function a:toVram()
  if self.inVram ~= true then
    D2D:uploadTexture(self.sprites)
    self.inVram = true
  end
end

return a
