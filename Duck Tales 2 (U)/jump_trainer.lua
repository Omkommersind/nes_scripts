local fg <const> = 0xFFFFFF
local bg <const> = 0x0000AA
local alertBg <const> = 0xFF0000
local maxHistoryEntries <const> = 5
local historyX <const> = 8
local historyY <const> = 8
local historyLineHeight <const> = 10

local groundedFrames = 0
local lastGroundedFrames = 0
local wasGrounded = false
local groundedHistory = {}

local function getIsGround()
	local v = emu.read(0x00B0, emu.memType.nesMemory, false)
	return (v & 0x04) ~= 0
end

local function pushGroundedHistory(count)
	table.insert(groundedHistory, 1, count)

	if #groundedHistory > maxHistoryEntries then
		table.remove(groundedHistory)
	end
end

local function drawGroundedHistory()
	for i = 1, #groundedHistory do
		local count = groundedHistory[i]
		local entryBg = bg
		if count == 1 then
			entryBg = alertBg
		end

		emu.drawString(historyX, historyY + (i - 1) * historyLineHeight, string.format("%d", count), fg, entryBg)
	end
end

local function drawState()
	local isGrounded = getIsGround()

	if isGrounded then
		groundedFrames = groundedFrames + 1
		lastGroundedFrames = groundedFrames
		emu.drawString(8, 210, "GROUNDED", fg, bg)
	elseif wasGrounded and groundedFrames > 0 then
		pushGroundedHistory(groundedFrames)
		groundedFrames = 0
	else
		groundedFrames = 0
	end

	local groundFramesBg = bg
	if lastGroundedFrames == 1 then
		groundFramesBg = alertBg
	end

	emu.drawString(8, 220, string.format("GROUND FRAMES: %d", lastGroundedFrames), fg, groundFramesBg)
	drawGroundedHistory()

	wasGrounded = isGrounded
end

emu.addEventCallback(drawState, emu.eventType.endFrame)

emu.displayMessage("Script", "Frame perfect jump trainer")
