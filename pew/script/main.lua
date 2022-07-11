
local D2D = require("draw2d")
local VRAM = require("vram")
local game = require("game")
local T = require("text")
local A = require("assets")

local state = game

local padHeldState = {}

function initPadState()
  padHeldState[PAD.X] = false
  padHeldState[PAD.LEFT] = false
  padHeldState[PAD.RIGHT] = false
  padHeldState[PAD.UP] = false
  padHeldState[PAD.DOWN] = false
  padHeldState[PAD.R1] = false
  padHeldState[PAD.SELECT] = false
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

  T.font = D2D.loadTexture(PS2_SCRIPT_PATH .. "bigfont.tga")

  DMA.init(DMA.GIF)
  GS.setOutput(640, 448, GS.INTERLACED, GS.NTSC) 

  local fb1 = VRAM.mem:framebuffer(640, 448, GS.PSM32, 256)
  local fb2 = VRAM.mem:framebuffer(640, 448, GS.PSM32, 256)
  local zb =  VRAM.mem:framebuffer(640, 448, GS.PSMZ24, 256)
  GS.setBuffers(fb1, fb2, zb)
  D2D:screenDimensions(640, 448)

  D2D:clearColour(0x2, 0x2, 0x4)

  local drawbuffer = RM.alloc(1024 * 5)
  D2D:bindBuffer(drawbuffer)


  local vr = VRAM.slice(VRAM.mem.head)
  A:loadFont("bigfont.tga", 8, 16)
  A:loadTex(vr)
   
  state:enter()

  initPadState()
end

local fontUploaded = false

function PS2PROG.frame()
  updatePadState(state)
  D2D:frameStart()
  if fontUploaded ~= true then
    D2D:uploadTexture(T.font)
    T.font.resident = true
    fontUploaded = true
  end
  A:toVram()
  state:draw()
  state:update(1/30)
  D2D:frameEnd()
end
