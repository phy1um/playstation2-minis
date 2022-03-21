local D2D = require("draw2d")
local VRAM = require("vram")
local game = require("game")

local state = game

local padHeldState = {}

function initPadState()
  padHeldState[PAD.X] = false
  padHeldState[PAD.LEFT] = false
  padHeldState[PAD.RIGHT] = false
  padHeldState[PAD.UP] = false
  padHeldState[PAD.DOWN] = false
  padHeldState[PAD.R1] = false
end

function updatePadState(st)
  for b, lastState in pairs(padHeldState) do
    local currentState = PAD.held(b)
    if currentState ~= lastState then
      if currentState == true then
        state:padPress(b)
      else 
        state:padRelease(b)
      end
    end
    padHeldState[b] = currentState
  end
end

function PS2PROG.start()
  PS2PROG.logLevel(LOG.debugLevel)
  DMA.init(DMA.GIF)
  GS.setOutput(640, 448, GS.INTERLACED, GS.NTSC) 
  local fb1 = VRAM.mem:framebuffer(640, 448, GS.PSM32, 1024)
  local fb2 = VRAM.mem:framebuffer(640, 448, GS.PSM32, 1024)
  local zb =  VRAM.mem:framebuffer(640, 448, GS.PSMZ24, 1024)
  GS.setBuffers(fb1, fb2, zb)
  D2D:screenDimensions(640, 448)

  D2D:clearColour(0x9, 0x9, 0x1D)

  local drawbuffer = RM.alloc(1024 * 5)
  D2D:bindBuffer(drawbuffer)
   
  state:enter()

  initPadState()
end

function PS2PROG.frame()
  updatePadState(state)
  D2D:frameStart()
  state:draw()
  state:update(1/30)
  D2D:frameEnd()
end
