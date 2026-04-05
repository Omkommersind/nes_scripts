local fg <const> = 0xFFFFFF
local black <const> = 0x000000
local green <const> = 0x00AA00

local maxHistoryEntries <const> = 5
local historyLifetimeFrames <const> = 120
local historyX <const> = 172
local historyY <const> = 33
local historySpacing <const> = 10

local panelX <const> = 160
local panelY <const> = 16
local panelWidth <const> = 72
local panelHeight <const> = 24
local panelTextX <const> = 172
local panelLabelY <const> = 16
local panelValueY <const> = 25

local currentFrame = 0
local groundedFrames = 0
local lastGroundedFrames = 0
local wasGrounded = false
local isGroundedNow = false
local groundedHistory = {}

local function getIsGrounded()
	local value = emu.read(0x00B0, emu.memType.nesMemory, false)
	return (value & 0x04) ~= 0
end

local function pruneExpiredHistory()
	local activeHistory = {}

	for i = 1, #groundedHistory do
		local entry = groundedHistory[i]
		if currentFrame <= entry.expiresAt then
			table.insert(activeHistory, entry)
		end
	end

	groundedHistory = activeHistory
end

local function pushGroundedHistory(count)
	table.insert(groundedHistory, 1, {
		count = count,
		expiresAt = currentFrame + historyLifetimeFrames,
	})

	if #groundedHistory > maxHistoryEntries then
		table.remove(groundedHistory)
	end
end

local function getHistoryText(count)
	if count >= 10 then
		return "X"
	end

	return string.format("%d", count)
end

local function getHistoryBackground(count)
	if count == 1 then
		return green
	end

	return black
end

local function updateGroundedState()
	local isGrounded = getIsGrounded()
	isGroundedNow = isGrounded

	if isGrounded then
		groundedFrames = groundedFrames + 1
		lastGroundedFrames = groundedFrames
	elseif wasGrounded and groundedFrames > 0 then
		pushGroundedHistory(groundedFrames)
		groundedFrames = 0
	end

	if not isGrounded then
		groundedFrames = 0
	end

	wasGrounded = isGrounded
end

local function drawGroundedPanel()
	emu.drawRectangle(panelX, panelY, panelWidth, panelHeight, black, true, 1, 0)
	if isGroundedNow then
		emu.drawString(panelTextX, panelLabelY, "GROUNDED", fg)
	end
	emu.drawString(panelTextX, panelValueY, lastGroundedFrames, fg, black)
end

local function drawGroundedHistory()
	for i = 1, #groundedHistory do
		local entry = groundedHistory[i]
		local x = historyX + (i - 1) * historySpacing
		local text = getHistoryText(entry.count)
		local background = getHistoryBackground(entry.count)

		emu.drawString(x, historyY, text, fg, background)
	end
end

local function onEndFrame()
	currentFrame = currentFrame + 1
	pruneExpiredHistory()
	updateGroundedState()
	drawGroundedPanel()
	drawGroundedHistory()
end

emu.addEventCallback(onEndFrame, emu.eventType.endFrame)

emu.displayMessage("Script", "Frame perfect jump trainer")
