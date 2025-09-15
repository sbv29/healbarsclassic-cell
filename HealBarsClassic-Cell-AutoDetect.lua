-- HealBarsClassic AutoDetect - Cell Only
-- Automatically detects and integrates with Cell raid frame addon

local HealBarsClassicAutoDetect = CreateFrame("Frame")
local HealBarsClassic = HealBarsClassic

-- Cell detector
local cellDetector = {
    check = function() return _G["Cell"] ~= nil end,
    detector = function()
        local frames = {}
        
        -- Check if Cell is available and has unit buttons
        if not Cell or not Cell.unitButtons then
            return frames
        end
        
        -- Process Cell unit buttons
        for groupType, groupData in pairs(Cell.unitButtons) do
            if groupData and type(groupData) == "table" then
                for _, button in pairs(groupData) do
                    if button and button:IsVisible() and button.unit then
                        local healthBar = button.healthBar or button.Health
                        if healthBar then
                            table.insert(frames, {
                                frame = button,
                                displayedUnit = button.unit,
                                healthBar = healthBar
                            })
                        end
                    end
                end
            end
        end
        
        return frames
    end
}

-- Configuration
local config = {
    scanInterval = 2, -- seconds
    debugMode = false
}

-- State tracking
local cellDetected = false
local isInitialized = false

-- Utility functions
local function DebugPrint(message)
    if config.debugMode then
        print("|cFF00FF00HealBarsClassic AutoDetect|r: " .. tostring(message))
    end
end

local function DetectCell()
    if not cellDetected and cellDetector.check() then
        DebugPrint("Detected Cell addon")
        cellDetected = true
    end
    return cellDetected
end

local function RegisterCellDetector()
    if not HealBarsClassic or not cellDetected then
        return false
    end
    
    HealBarsClassic:RegisterFrameDetector("AutoDetect_Cell", function()
        return cellDetector.detector()
    end)
    DebugPrint("Registered Cell detector")
    return true
end

local function ScanForFrames()
    if not HealBarsClassic then
        return
    end
    
    HealBarsClassic:ScanForNewFrames()
    DebugPrint("Scanned for new Cell frames")
end

-- Main initialization
local function Initialize()
    if isInitialized then
        return
    end
    
    print("|cFF00FF00HealBarsClassic AutoDetect|r: Loading Cell integration...")
    
    -- Wait for HealBarsClassic to be available
    if not HealBarsClassic then
        print("|cFFFF0000HealBarsClassic AutoDetect|r: Waiting for HealBarsClassic...")
        C_Timer.After(1, Initialize)
        return
    end
    
    DebugPrint("Initializing Cell AutoDetect...")
    
    -- Detect Cell
    if DetectCell() then
        -- Register detector
        if RegisterCellDetector() then
            -- Initial scan
            ScanForFrames()
            
            -- Start periodic scanning
            C_Timer.After(config.scanInterval, function()
                HealBarsClassicAutoDetect:StartPeriodicScan()
            end)
            
            isInitialized = true
            DebugPrint("Cell AutoDetect initialized successfully")
        else
            C_Timer.After(1, Initialize)
        end
    else
        print("|cFFFF0000HealBarsClassic AutoDetect|r: Cell addon not detected, retrying...")
        C_Timer.After(2, Initialize)
    end
end

-- Periodic scanning
function HealBarsClassicAutoDetect:StartPeriodicScan()
    if not HealBarsClassic then
        return
    end
    
    -- Re-detect Cell in case it loaded late
    DetectCell()
    
    -- Scan for new frames
    ScanForFrames()
    
    -- Schedule next scan
    C_Timer.After(config.scanInterval, function()
        HealBarsClassicAutoDetect:StartPeriodicScan()
    end)
end

-- Event handling
HealBarsClassicAutoDetect:RegisterEvent("ADDON_LOADED")
HealBarsClassicAutoDetect:RegisterEvent("PLAYER_LOGIN")
HealBarsClassicAutoDetect:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "HealBarsClassic-AutoDetect" then
        -- Initialize when our addon loads
        C_Timer.After(2, Initialize)
    elseif event == "PLAYER_LOGIN" then
        -- Re-initialize on login
        C_Timer.After(3, Initialize)
    end
end)


-- Export for external access
_G.HealBarsClassicAutoDetect = HealBarsClassicAutoDetect