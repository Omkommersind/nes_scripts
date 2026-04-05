local fg <const> = 0xFFFFFF
local bg <const> = 0x0000AA
local alertBg <const> = 0xFF0000
local groundedFrames = 0
local lastGroundedFrames = 0

local function getIsGround()
	local v = emu.read(0x00B0, emu.memType.nesMemory, false)
	return (v & 0x04) ~= 0
end

local function drawState()
	if getIsGround() then
		groundedFrames = groundedFrames + 1
		lastGroundedFrames = groundedFrames
		emu.drawString(8, 210, "GROUNDED", fg, bg)
	else
		groundedFrames = 0
	end

	local groundFramesBg = bg
	if lastGroundedFrames == 1 then
		groundFramesBg = alertBg
	end

	emu.drawString(8, 220, string.format("GROUND FRAMES: %d", lastGroundedFrames), fg, groundFramesBg)
end

emu.addEventCallback(drawState, emu.eventType.endFrame)

emu.displayMessage("Script", "Frame perfect jump trainer")
