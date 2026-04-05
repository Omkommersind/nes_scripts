local fg <const> = 0xFFFFFF
local bg <const> = 0x0000AA
local black <const> = 0x000000
local green <const> = 0x00AA00
local red <const> = 0xAA0000
local alertBg <const> = 0xFF0000
local maxHistoryEntries <const> = 5
local historyX <const> = 160
local historyY <const> = 33
local historySpacing <const> = 8

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
		local entryBg = black
		local entryText = string.format("%d", count)

		if count == 1 then
			entryBg = green
		end

		if count >= 10 then
			entryText = "X"
		end

		emu.drawString(historyX + (i - 1) * historySpacing, historyY, entryText, fg, entryBg)
	end
end

local function drawState()
	local isGrounded = getIsGround()

	if isGrounded then
		groundedFrames = groundedFrames + 1
		lastGroundedFrames = groundedFrames
	elseif wasGrounded and groundedFrames > 0 then
		pushGroundedHistory(groundedFrames)
		groundedFrames = 0
	else
		groundedFrames = 0
	end

	emu.drawRectangle(160, 16, 72, 24, black, true, 1, 0)
	emu.drawString(172, 16, "GROUNDED", fg)
	emu.drawString(172, 25, lastGroundedFrames, fg, black)
	drawGroundedHistory()

	wasGrounded = isGrounded
end

emu.addEventCallback(drawState, emu.eventType.endFrame)

emu.displayMessage("Script", "Frame perfect jump trainer")
