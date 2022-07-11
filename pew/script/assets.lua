
local D2D = require "draw2d"
local T = require "text"

local a = {
  inVram = false,
  playerST = {0, 0.5, 0.5, 1},
  rockST = {0.5, 1, 0.5, 1},
  planetA = {0, 0, 0.25, 0.25},
  planetB = {0.25, 0, 0.5, 0.25},
  cloud = {0.5, 0, 0.75, 0.25},
  fontTex = nil,
  font = nil,
}

function a:loadTex(vr)
  self.sprites = D2D.loadTexture(PS2_SCRIPT_PATH .. "sprites.tga")
  vr:texture(self.sprites)
  vr:texture(self.fontTex)
end

function a:toVram()
  if self.inVram ~= true then
    D2D:uploadTexture(self.sprites)
    D2D:uploadTexture(self.fontTex)
    a.font.resident = true
    self.inVram = true
  end
end

function a:loadFont(fnt, cw, ch)
  a.fontTex = D2D.loadTexture(fnt)
  a.font = T.new(a.fontTex, cw, ch)
end

return a
