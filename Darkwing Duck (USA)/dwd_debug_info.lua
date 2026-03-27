local lookDirection <const> = 0x0400
local xScreen <const> = 0x0450

local xLow <const> = 0x04F0
local xHigh <const> = 0x0500

local yLow <const> = 0x0510
local yHigh <const> = 0x0520

local bg <const> = 0x0000AA
local fg <const> = 0xFFFFFF

local function drawPlayerCoords()
    local playerXLow = emu.read(xLow, emu.memType.nesMemory, false)
	local playerXHigh = emu.read(xHigh, emu.memType.nesMemory, false)
	local x = playerXLow + playerXHigh * 256

    local playerYLow = emu.read(yLow, emu.memType.nesMemory, false)
	local playerYHigh = emu.read(yHigh, emu.memType.nesMemory, false)
	local y = playerYLow + playerYHigh * 256
	
    emu.drawString(8, 218, "x: " .. tostring(x), fg, bg)
    emu.drawString(8, 228, "y: " .. tostring(y), fg, bg)
end

local function drawLookDirection()
	local lookingAt = emu.read(lookDirection, emu.memType.nesMemory, false)
	local dir = "left"
	
	if lookingAt == 0xD0 then
		dir = "right"
	end
		
	emu.drawString(8, 212, "Looking: " .. dir, fg, bg)
end

emu.addEventCallback(drawPlayerCoords, emu.eventType.endFrame)
--emu.addEventCallback(drawLookDirection, emu.eventType.endFrame)
emu.displayMessage("Script", "Darkwing Duck debug viewer loaded.")