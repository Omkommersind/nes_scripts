local lookDirection <const> = 0x0400
local xLow <const> = 0x04F0
local xHigh <const> = 0x0500
local yLow <const> = 0x0510
local yHigh <const> = 0x0520

local fg <const> = 0xFFFFFF
local bg <const> = 0x0000AA

local read = emu.read
local drawString = emu.drawString
local memNES = emu.memType.nesMemory

local directionNames = {
    [0xD0] = "right",
    [0x00] = "left",
}

local function read16(lowAddr, highAddr)
    return read(lowAddr, memNES, false) + read(highAddr, memNES, false) * 256
end

local function drawPlayerCoords()
    local x = read16(xLow, xHigh)
    local y = read16(yLow, yHigh)

    drawString(8, 218, string.format("x: %d", x), fg, bg)
    drawString(8, 228, string.format("y: %d", y), fg, bg)
end

local function drawLookDirection()
    local dir = directionNames[read(lookDirection, memNES, false)] or "left"

    drawString(8, 212, string.format("Looking: %s", dir), fg, bg)
end

emu.addEventCallback(drawPlayerCoords, emu.eventType.endFrame)
-- emu.addEventCallback(drawLookDirection, emu.eventType.endFrame)
emu.displayMessage("Script", "Darkwing Duck debug viewer loaded.")