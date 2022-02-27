local D2D = require("draw2d")
local VRAM = require("vram")
local game = require("game")

local state = game

function PS2PROG.start()
  PS2PROG.logLevel(LOG.debugLevel)
  DMA.init(DMA.GIF)
  local fb1 = VRAM.mem:framebuffer(640, 448, GS.PSM32, 1024)
  local fb2 = VRAM.mem:framebuffer(640, 448, GS.PSM32, 1024)
  local zb =  VRAM.mem:framebuffer(640, 448, GS.PSMZ24, 1024)
  GS.setBuffers(fb1, fb2, zb)
  D2D:screenDimensions(640, 448)

  D2D:clearColour(0x2b, 0x2b, 0x2b)

  local drawbuffer = RM.alloc(1024 * 5)
  D2D:bindBuffer(drawbuffer)
   
  state:enter()
end

function PS2PROG.frame()
  D2D:frameStart()
  state:draw()
  state:update(1/30)
  D2D:frameEnd()
end
