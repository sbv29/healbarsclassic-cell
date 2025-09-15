local libCHC = LibStub("LibHealComm-4.0", true)
HealBarsClassic = LibStub("AceAddon-3.0"):NewAddon("HealBarsClassic-CellHotfix")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConsole = LibStub("AceConsole-3.0")
local healBarTable = {}
local shieldBarTable = {}
local masterFrameTable = {}
local statusGUIDs = {}
local shieldGUIDs = {}
local barTypes = { ['flat'] = {}, ['hot'] = {}, ['ownFlat'] = {}, ['ownHot'] = {}, ['afterOwnFlat'] = {} }
local currentHeals = {}
local playerGUID = UnitGUID('player')
local HBCdb = {}
local partyGUIDs = { [UnitGUID("player")] = "player" }
local globalFrameList = { ["player"] = _G["PlayerFrame"], ["pet"] = _G["PetFrame"], ["target"] = _G["TargetFrame"], ["focus"] = _G["FocusFrame"], ["party1"] = _G["PartyMemberFrame1"], ["partypet1"] = _G["PartyMemberFrame1PetFrame"], ["party2"] = _G["PartyMemberFrame2"], ["partypet2"] = _G["PartyMemberFrame2PetFrame"], ["party3"] = _G["PartyMemberFrame3"], ["partypet3"] = _G["PartyMemberFrame3PetFrame"], ["party4"] = _G["PartyMemberFrame4"], ["partypet4"] = _G["PartyMemberFrame4PetFrame"] }
HBCDefaultColors = { ['flat'] = { 130 / 255, 1, 0, 1.0 }, ['hot'] = { 110 / 255, 230 / 255, 55 / 255, 0.7 }, ['ownFlat'] = { 31 / 255, 113 / 255, 22 / 255, 1 }, ['ownHot'] = { 230 / 255, 76 / 255, 105 / 255, 0.7 } }
HealBarsClassic.invulStatusTextConfigList = { ['DIVSHLD'] = 'Divine Shield - DIVSHLD', ['DIVPROT'] = 'Divine Protection - DIVPROT', ['BLSPROT'] = 'Blessing of Protection - BLSPROT', ['ICEBLCK'] = 'Ice Block - ICEBLCK', ['DIVINTR'] = 'Divine Intervention - DIVINTR' }
HealBarsClassic.strongMitStatusTextConfigList = { ['EVASION'] = 'Evasion - EVASION', ['SHDWALL'] = 'Shield Wall - SHDWALL', ['CHEATDTH'] = 'Cheat Death - CHEATDTH' }
HealBarsClassic.softMitStatusTextConfigList = { ['BARKSKIN'] = 'Barkskin - BARKSKIN', ['PAINSPR'] = 'Pain Supression - PAINSPR', ['SHMRAGE'] = 'Shamanistic Rage - SHMRAGE' }
HealBarsClassic.miscStatusTextConfigList = {}
local defensiveSpells = { [642] = { name = 'DIVSHLD', duration = 12, priority = 2 } -- Divine Shield Rank 1
, [1020] = { name = 'DIVSHLD', duration = 12, priority = 2 }                        -- Divine Shield Rank 2
, [1022] = { name = 'BLSPROT', duration = 6, priority = 10 }                        -- Blessing of Protection Rank 1
, [5599] = { name = 'BLSPROT', duration = 6, priority = 10 }                        -- Blessing of Protection Rank 2
, [10278] = { name = 'BLSPROT', duration = 6, priority = 10 }                       -- Blessing of Protection Rank 3
, [498] = { name = 'DIVPROT', duration = 6, priority = 2 }                          -- Divine Protection Rank 1
, [5573] = { name = 'DIVPROT', duration = 6, priority = 2 }                         -- Divine Protection Rank 2
, [45438] = { name = 'ICEBLCK', duration = 10, priority = 2 }                       -- Ice Block
, [19753] = { name = 'DIVINTR', duration = 45, priority = 1 }                       -- Divine Intervention
-- (Rarely held for full duration & frequently breaks from release->res)							
, [26669] = { name = 'EVASION', duration = 15, priority = 20 }                      -- Evasion Rank 2
, [5277] = { name = 'EVASION', duration = 15, priority = 20 }                       -- Evasion Rank 1
, [871] = { name = 'SHDWALL', duration = 10, priority = 5 }                         -- Shield Wall
, [45182] = { name = 'CHEATDTH', duration = 3, priority = 5 }                       -- Cheat Death
, [22812] = { name = 'BARKSKIN', duration = 12, priority = 30 }                     -- Bark Skin
, [30823] = { name = 'SHMRGE', duration = 15, priority = 30 }                       -- Shamanistic Rage
, [33206] = { name = 'PAINSPR', duration = 8, priority = 25 }                       -- Pain Suppression
}
local shieldSpells = { [17] = {} -- Power Word: Shield Rank 1
, [592] = {}   -- Power Word: Shield Rank 2
, [600] = {}   -- Power Word: Shield Rank 3
, [3747] = {}  -- Power Word: Shield Rank 4
, [6065] = {}  -- Power Word: Shield Rank 5
, [6066] = {}  -- Power Word: Shield Rank 6
, [10898] = {} -- Power Word: Shield Rank 7
, [10899] = {} -- Power Word: Shield Rank 8
, [10900] = {} -- Power Word: Shield Rank 9
, [10901] = {} -- Power Word: Shield Rank 10
, [25217] = {} -- Power Word: Shield Rank 11
, [25218] = {} -- Power Word: Shield Rank 12
, [1463] = {}  -- Mana Shield Rank 1
, [8494] = {}  -- Mana Shield Rank 2
, [8495] = {}  -- Mana Shield Rank 3
, [10191] = {} -- Mana Shield Rank 4
, [10192] = {} -- Mana Shield Rank 5
, [10193] = {} -- Mana Shield Rank 6
, [27131] = {} -- Mana Shield Rank 6
, [11426] = {} -- Ice Barrier Rank 1
, [13031] = {} -- Ice Barrier Rank 2
, [13032] = {} -- Ice Barrier Rank 3
, [13033] = {} -- Ice Barrier Rank 4
, [27134] = {} -- Ice Barrier Rank 5
, [33405] = {} -- Ice Barrier Rank 6
, [7812] = {}  -- Sacrifice Rank 1
, [19438] = {} -- Sacrifice Rank 2
, [19440] = {} -- Sacrifice Rank 3
, [19441] = {} -- Sacrifice Rank 4
, [19442] = {} -- Sacrifice Rank 5
, [19443] = {} -- Sacrifice Rank 6
, [27273] = {} -- Sacrifice Rank 7
}
local HBCdefault = { global = { overhealPercent = 20, timeframe = 3, healTimeframe = 8, channelTimeframe = 3, showHots = true, seperateHots = true, seperateOwnHeals = false, healColor = HBCDefaultColors.flat, hotColor = HBCDefaultColors.hot, ownHealColor = HBCDefaultColors.ownFlat, ownHotColor = HBCDefaultColors.ownHot, defensiveIndicator = true, shieldGlow = false, enabledStatusTexts = { ['*'] = false, ['DIVSHLD'] = true, ['DIVPROT'] = true, ['BLSPROT'] = true, ['DIVINTR'] = true, ['ICEBLCK'] = true, ['SHDWALL'] = true, ['EVASION'] = true, ['CHEATDTH'] = true }, predictiveHealthLost = false, alternativeTexture = true, fastUpdate = false, fastUpdateDuration = 0.03 } }
function HealBarsClassic:ClearAllShields()
  local guidsToWipe = {}
  for guid, value in pairs(shieldGUIDs) do
    if value then table.insert(guidsToWipe, guid) end
  end
  wipe(shieldGUIDs)
  for _, guid in ipairs(guidsToWipe) do
    HealBarsClassic:UpdateGUIDHeals(guid)
  end
end
function HealBarsClassic:ColorTest(case)
  if not currentHeals[playerGUID] then currentHeals[playerGUID] = {} end
  local playerHeals = currentHeals[playerGUID]
  if not case or case == 1 then
    table.insert(playerHeals, { healType = 'ownFlat', amount = 700 })
    table.insert(playerHeals, { healType = 'flat', amount = 800 })
    table.insert(playerHeals, { healType = 'ownHot', amount = 500 })
    table.insert(playerHeals, { healType = 'hot', amount = 500 })
  elseif case == 2 then
    table.insert(playerHeals, { healType = 'ownFlat', amount = 500 })
    table.insert(playerHeals, { healType = 'flat', amount = 500 })
  elseif case == 3 then
    table.insert(playerHeals, { healType = 'flat', amount = 500 })
    table.insert(playerHeals, { healType = 'ownFlat', amount = 500 })
  end
  HealBarsClassic:UpdateGUIDHeals(playerGUID)
end
function HealBarsClassic:getHealColor(healType)
  local colorVarName, colorTable
  if healType == 'flat' or healType == 'afterOwnFlat' then
    colorTable = HBCdb.global.healColor
  elseif healType == 'hot' then
    colorTable = HBCdb.global.hotColor
  elseif healType == 'ownFlat' then
    colorTable = HBCdb.global.ownHealColor
  else
    colorTable = HBCdb.global.ownHotColor
  end
  if colorTable then return unpack(colorTable) end
end
function HealBarsClassic:CreateDefaultHealBars()
  for name, unitFrame in pairs(globalFrameList) do
    HealBarsClassic:createHealBars(unitFrame)
  end
end
function HealBarsClassic:createHealBars(unitFrame, textureType)
  if not unitFrame or unitFrame:IsForbidden() or not unitFrame:GetName() then
    return
  end
  if masterFrameTable[unitFrame:GetName()] then return end
  masterFrameTable[unitFrame:GetName()] = unitFrame
  if not healBarTable[unitFrame] then healBarTable[unitFrame] = {} end
  local currentBarList = healBarTable[unitFrame]
  
  -- Get the health bar for proper parent/positioning
  local _, healthBar = HealBarsClassic:GetFrameInfo(unitFrame)
  
  for healType, properties in pairs(barTypes) do
    if not currentBarList[healType] then
      -- Always create heal bars as children of the unit frame for consistency
      local healFrame = CreateFrame("StatusBar", "HBCIncHealBar" .. unitFrame:GetName() .. healType, unitFrame)
      
      healFrame:SetFrameStrata("LOW")
      if (unitFrame:GetName() == 'FocusFrame') then
        healFrame:SetFrameLevel(healFrame:GetFrameLevel())
      else
        -- For Cell frames, set frame level to be behind name but above health bar
        if unitFrame.widgets and unitFrame.widgets.healthBar then
          -- Position behind name text but above health bar
          healFrame:SetFrameStrata("MEDIUM")
          healFrame:SetFrameLevel(healthBar:GetFrameLevel() + 1)
        else
          healFrame:SetFrameLevel(healFrame:GetFrameLevel() - 1)
        end
      end
      
      if textureType == 'raid' or HBCdb.global.alternativeTexture then
        healFrame:SetStatusBarTexture("Interface\\RaidFrame\\Raid-Bar-Hp-Fill")
      else
        healFrame:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
      end
      
      -- For Cell frames, use a solid texture and position behind name
      if unitFrame.widgets and unitFrame.widgets.healthBar then
        -- Use a solid texture instead of status bar texture
        local texture = healFrame:CreateTexture(nil, "BACKGROUND")
        texture:SetAllPoints()
        texture:SetColorTexture(1, 1, 1, 1) -- White solid color
        texture:SetBlendMode("BLEND")
        
        -- Set the status bar texture to transparent so only our solid texture shows
        healFrame:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
        healFrame:SetStatusBarColor(0, 0, 0, 0) -- Transparent
      end
      healFrame:SetMinMaxValues(0, 1)
      healFrame:SetValue(1)
      healFrame:SetStatusBarColor(HealBarsClassic:getHealColor(healType))
      
      -- For Cell frames, set the solid texture color
      if unitFrame.widgets and unitFrame.widgets.healthBar then
        local r, g, b = HealBarsClassic:getHealColor(healType)
        -- The solid texture color is set in the texture creation above
        healFrame:SetAlpha(0.8)
      end
      
      healFrame:Hide()
      currentBarList[healType] = healFrame
    end
  end
  local _, healthBar = HealBarsClassic:GetFrameInfo(unitFrame)
  
  -- For Cell frames, create shield frame as a child of the health bar
  local shieldFrame
  if unitFrame.widgets and unitFrame.widgets.healthBar then
    -- Cell frame - create shield as child of health bar
    shieldFrame = healthBar:CreateTexture("HBCShieldBar" .. unitFrame:GetName(), 'ARTWORK', nil, 2)
  else
    -- Blizzard frame - create shield as child of health bar
    shieldFrame = healthBar:CreateTexture("HBCShieldBar" .. unitFrame:GetName(), 'ARTWORK', nil, 2)
  end
  
  shieldFrame:SetTexture("Interface\\RaidFrame\\Shield-Overshield")
  shieldFrame:SetBlendMode("ADD")
  shieldFrame:SetWidth(16)
  shieldFrame:Hide()
  shieldBarTable[unitFrame] = shieldFrame
  
  local eventFrame = CreateFrame("Frame", "HealBarsClassicEventFrame" .. unitFrame:GetName(), unitFrame)
  eventFrame:SetScript("OnEvent", function (self)
    HealBarsClassic:UpdateHealBars(self:GetParent())
  end)
  local shieldEventFrame = CreateFrame("Frame", "HealBarsClassicAuraEventFrame" .. unitFrame:GetName(), unitFrame)
  shieldEventFrame:SetScript("OnEvent", function (self)
    HealBarsClassic:UpdateAuras(self:GetParent())
  end)
  shieldEventFrame:RegisterUnitEvent('UNIT_AURA', (HealBarsClassic:GetFrameInfo(unitFrame)))
  shieldEventFrame:RegisterUnitEvent('UNIT_HEALTH', (HealBarsClassic:GetFrameInfo(unitFrame)))
  shieldEventFrame:RegisterUnitEvent('UNIT_MAXHEALTH', (HealBarsClassic:GetFrameInfo(unitFrame)))
  
end
function HealBarsClassic:UpdateGUIDHeals(GUID)
  if partyGUIDs[targetGUID] then
    if globalFrameList[partyGUIDs[targetGUID]] then
      HealBarsClassic:UpdateHealBars(
        globalFrameList[partyGUIDs[targetGUID]])
    end
  end
  for frameName, unitFrame in pairs(masterFrameTable) do
    local displayedUnit = HealBarsClassic:GetFrameInfo(unitFrame)
    if displayedUnit and UnitGUID(displayedUnit) == GUID then
      HealBarsClassic:UpdateHealBars(unitFrame)
      if unitFrame.statusText then
        CompactUnitFrame_UpdateStatusText(unitFrame)
      end
      HealBarsClassic:UpdateShieldGlow(unitFrame)
    end
  end
  
  -- Force update Cell frames specifically
  HealBarsClassic:UpdateCellFrames(GUID)
end

function HealBarsClassic:UpdateCellFrames(GUID)
  -- Update all Cell frames for the given GUID
  for frameName, unitFrame in pairs(masterFrameTable) do
    if unitFrame.widgets and unitFrame.widgets.healthBar then
      local displayedUnit = HealBarsClassic:GetFrameInfo(unitFrame)
      if displayedUnit and UnitGUID(displayedUnit) == GUID then
        HealBarsClassic:UpdateHealBars(unitFrame)
      end
    end
  end
end
function HealBarsClassic:GetFrameInfo(unitFrame)
  local displayedUnit, healthBar
  if not unitFrame then return end
  
  -- Check if it's a Cell unit button
  if unitFrame.widgets and unitFrame.widgets.healthBar then
    -- Cell unit button structure
    displayedUnit = unitFrame.states and unitFrame.states.displayedUnit or unitFrame.unit
    healthBar = unitFrame.widgets.healthBar
  else
    -- Original Blizzard frame structure
    if unitFrame.displayedUnit ~= nil then
      displayedUnit = unitFrame.displayedUnit
    else
      displayedUnit = unitFrame.unit
    end
    
    if unitFrame.healthBar ~= nil then
      healthBar = unitFrame.healthBar
    else
      healthBar = unitFrame.healthbar
    end
  end
  
  return displayedUnit, healthBar
end
function HealBarsClassic:UpdateHealBars(unitFrame)
  if not unitFrame then return end
  local displayedUnit, healthBar = HealBarsClassic:GetFrameInfo(unitFrame)
  if not displayedUnit or not UnitExists(displayedUnit) or not healBarTable[unitFrame] then
    return
  end
  local eventFrame = _G['HealBarsClassicEventFrame' .. unitFrame:GetName()]
  eventFrame:RegisterUnitEvent("UNIT_HEALTH", (HealBarsClassic:GetFrameInfo(unitFrame)))
  eventFrame:RegisterUnitEvent("UNIT_MAXHEALTH", (HealBarsClassic:GetFrameInfo(unitFrame)))
  local unit = displayedUnit
  local maxHealth = UnitHealthMax(unit)
  local health = UnitHealth(unit)
  local healthWidth = healthBar:GetWidth() * (health / maxHealth)
  local maxWidth = healthBar:GetWidth() *
      (1 + (HBCdb.global.overhealPercent / 100))
  local healWidthTotal = 0
  local currentHealsForGUID = currentHeals[UnitGUID(displayedUnit)]
  if not currentHealsForGUID then
    HealBarsClassic:ClearHealBar(unitFrame)
    return
  end
  
  
  for index, healInfo in ipairs(currentHealsForGUID) do
    local healType = healInfo.healType
    local barFrame = healBarTable[unitFrame][healType]
    local amount = healInfo.amount
    if amount and amount > 0 and (health < maxHealth or HBCdb.global.overhealPercent > 0) and healthBar:IsVisible() then
      barFrame:Show()
      local healWidth = healthBar:GetWidth() * (amount / maxHealth)
      if healthWidth + healWidthTotal + healWidth >= maxWidth then
        healWidth = maxWidth - healthWidth - healWidthTotal
        if healWidth <= 0 then barFrame:Hide() end
      end
      barFrame:SetSize(healWidth, healthBar:GetHeight())
      barFrame:ClearAllPoints()
      
      -- For Cell frames, use absolute positioning
      if unitFrame.widgets and unitFrame.widgets.healthBar then
        local healthBarLeft = healthBar:GetLeft()
        local healthBarTop = healthBar:GetTop()
        local healthBarWidth = healthBar:GetWidth()
        local healthBarHeight = healthBar:GetHeight()
        
        if healthBarLeft and healthBarTop then
          barFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", 
            healthBarLeft + healthWidth + healWidthTotal, 
            healthBarTop)
          barFrame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 
            healthBarLeft + healthWidth + healWidthTotal, 
            healthBarTop - healthBarHeight)
        else
          -- Fallback to relative positioning
          barFrame:SetPoint("TOPLEFT", healthBar, "TOPLEFT", healthWidth + healWidthTotal, 0)
          barFrame:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT", healthWidth + healWidthTotal, 0)
        end
        
        -- Ensure Cell heal bars are positioned behind name but above health bar
        barFrame:SetFrameStrata("MEDIUM")
        barFrame:SetFrameLevel(healthBar:GetFrameLevel() + 1)
        barFrame:SetAlpha(0.8)
      else
        -- Original Blizzard frame positioning
        barFrame:SetPoint("TOPLEFT", healthBar, "TOPLEFT", healthWidth + healWidthTotal, 0)
        barFrame:SetPoint("BOTTOMLEFT", healthBar, "BOTTOMLEFT", healthWidth + healWidthTotal, 0)
      end
      healWidthTotal = healWidthTotal + healWidth
      
    else
      barFrame:Hide()
    end
  end
end
function HealBarsClassic:UpdateShieldGlow(unitFrame)
  local displayedUnit, healthBar = HealBarsClassic:GetFrameInfo(unitFrame)
  local shieldFrame = _G['HBCShieldBar' .. unitFrame:GetName()]
  if HBCdb.global.shieldGlow and displayedUnit and shieldGUIDs[UnitGUID(displayedUnit)] then
    local maxHealth = UnitHealthMax(displayedUnit)
    local health = UnitHealth(displayedUnit)
    local healthWidth = healthBar:GetWidth() * (health / maxHealth)
    shieldFrame:SetPoint('TOPLEFT', healthBar, 'TOPLEFT', healthWidth - 7, 0)
    shieldFrame:SetHeight(healthBar:GetHeight())
    shieldFrame:Show()
  else
    shieldFrame:Hide()
  end
end
local function UnitFrame_SetUnitHook(unitFrame)
  HealBarsClassic:UnRegisterAllInactiveFrames()
  HealBarsClassic:UpdateHealBars(unitFrame)
end

hooksecurefunc("UnitFrame_SetUnit", UnitFrame_SetUnitHook)
local function CompactUnitFrame_SetUnitHook(unitFrame)
  HealBarsClassic:createHealBars(unitFrame, 'raid')
end
hooksecurefunc("CompactUnitFrame_SetUnit", CompactUnitFrame_SetUnitHook)
function HealBarsClassic:UpdateAuras(unitFrame)
  local index = 1
  local statusUpdate = false
  local unitId = HealBarsClassic:GetFrameInfo(unitFrame)
  if not unitId then return end
  local targetGUID = UnitGUID(unitId)
  if not targetGUID then return end
  if not statusGUIDs[targetGUID] then statusGUIDs[targetGUID] = {} end
  wipe(statusGUIDs[targetGUID])
  shieldGUIDs[targetGUID] = false
  repeat
    local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitBuff(unitId, index)
    if spellId then
      if HBCdb.global.defensiveIndicator then
        local spell = defensiveSpells[spellId]
        if spell and HBCdb.global.enabledStatusTexts[spell.name] then
          statusGUIDs[targetGUID][spell] = true
          statusUpdate = true
        end
      end
      if HBCdb.global.shieldGlow then
        local spell = shieldSpells[spellId]
        if spell then
          shieldGUIDs[targetGUID] = true
          statusUpdate = true
        end
      end
      index = index + 1
    end
  until (not spellId)
  HealBarsClassic:UpdateGUIDHeals(targetGUID)
end
function HealBarsClassic:GROUP_ROSTER_UPDATE()
  HealBarsClassic:UnRegisterAllInactiveFrames()
  
  -- Initialize party/raid frames when group changes
  C_Timer.After(0.5, function()
    HealBarsClassic:InitializeGroupFrames()
  end)
  
  -- Also handle immediate party/raid frame updates
  C_Timer.After(0.1, function()
    HealBarsClassic:UpdatePartyRaidFrames()
  end)
end

function HealBarsClassic:UpdatePartyRaidFrames()
  -- Update party frames if in party
  if UnitInParty("player") then
    local unitFrame = _G["CompactPartyFrameMember1"]
    local num = 1
    while unitFrame do
      HealBarsClassic:UpdateHealBars(unitFrame)
      num = num + 1
      unitFrame = _G["CompactPartyFrameMember" .. num]
    end
  end
  
  -- Update raid frames if in raid
  if UnitInRaid("player") then
    local unitFrame = _G["CompactRaidFrame1"]
    local num = 1
    while unitFrame do
      HealBarsClassic:UpdateHealBars(unitFrame)
      num = num + 1
      unitFrame = _G["CompactRaidFrame" .. num]
    end
    
    -- Update raid group frames
    for i = 1, 8 do
      local grpHeader = "CompactRaidGroup" .. i
      if _G[grpHeader] then
        for k = 1, 5 do
          local unitFrame = _G[grpHeader .. "Member" .. k]
          if unitFrame then
            HealBarsClassic:UpdateHealBars(unitFrame)
          end
        end
      end
    end
  end
end

function HealBarsClassic:InitializeGroupFrames()
  -- Update party GUIDs
  for guid, unit in pairs(partyGUIDs) do
    if strsub(unit, 1, 5) == "party" then partyGUIDs[guid] = nil end
  end
  
  -- Add current party members to GUID tracking
  if UnitInParty("player") then
    for i = 1, MAX_PARTY_MEMBERS do
      local p = "party" .. i
      if UnitExists(p) then
        partyGUIDs[UnitGUID(p)] = p
      else
        break
      end
    end
  end
  
  -- Update party/raid frames if in group
  if UnitInParty("player") or UnitInRaid("player") then
    HealBarsClassic:PLAYER_ROLES_ASSIGNED()
  end
  
  -- Always update individual frames
  HealBarsClassic:UpdateIndividualFrames()
  
end

function HealBarsClassic:PLAYER_LOGIN()
  -- Initialize frames when player logs in
  C_Timer.After(2, function()
    HealBarsClassic:UpdateIndividualFrames()
  end)
end

function HealBarsClassic:PLAYER_ENTERING_WORLD()
  -- Update frames when entering world (zones, instances, etc.)
  C_Timer.After(1, function()
    HealBarsClassic:UpdateIndividualFrames()
  end)
end

function HealBarsClassic:RAID_ROSTER_UPDATE()
  -- Handle raid roster changes
  C_Timer.After(0.3, function()
    HealBarsClassic:InitializeGroupFrames()
  end)
end
function HealBarsClassic:UnRegisterAllInactiveFrames()
  for frameName, unitFrame in pairs(masterFrameTable) do
    local eventFrame = _G['HealBarsClassicEventFrame' .. frameName]
    if eventFrame then
      local displayedUnit = HealBarsClassic:GetFrameInfo(unitFrame)
      if frameName ~= 'target' and frameName ~= 'player' and frameName ~= 'focus' then
        eventFrame:UnregisterAllEvents()
      end
    end
  end
end
function CompactUnitFrame_UpdateStatusTextHBCHook(unitFrame)
  if not unitFrame.statusText or not unitFrame.optionTable.displayStatusText or not UnitIsConnected(unitFrame.displayedUnit) or UnitIsDeadOrGhost(unitFrame.displayedUnit) then
    return
  end
  local healthLost = UnitHealthMax(unitFrame.displayedUnit) - UnitHealth(unitFrame.displayedUnit)
  if HBCdb.global.defensiveIndicator then
    local guid = UnitGUID(unitFrame.displayedUnit)
    local statusEffects = statusGUIDs[guid] or {}
    local priorityEffect = {}
    for effect, _ in pairs(statusEffects) do
      if not priorityEffect.priority or (priorityEffect.priority > effect.priority) then
        priorityEffect.name = effect.name
        priorityEffect.priority = effect.priority
      end
    end
    if priorityEffect.name then
      unitFrame.statusText:SetFormattedText("%s", priorityEffect.name)
      unitFrame.statusText:Show()
      return
    end
  end
  if unitFrame.optionTable.healthText == "losthealth" and HBCdb.global.predictiveHealthLost and currentHeals then
    local currentHeals = currentHeals[UnitGUID(unitFrame.displayedUnit)] or {}
    local totalHeals = 0
    for index, healInfo in ipairs(currentHeals) do
      totalHeals = totalHeals + healInfo.amount
    end
    local healthDelta = totalHeals - healthLost
    if healthDelta >= 0 then
      unitFrame.statusText:Hide()
    else
      unitFrame.statusText:SetFormattedText("%d", healthDelta)
      unitFrame.statusText:Show()
    end
  end
end
function HealBarsClassic:OnInitialize()
  HBCdb = LibStub("AceDB-3.0"):New("HealBarSettings", HBCdefault)
  HBCdb.RegisterCallback(HealBarsClassic, "OnProfileChanged", "UpdateColors")
  HealBarsClassic.HBCdb = HBCdb
  HealBarsClassic:CreateDefaultHealBars()
  HealBarsClassic:CreateConfigs()
  hooksecurefunc("CompactUnitFrame_UpdateStatusText", CompactUnitFrame_UpdateStatusTextHBCHook)
  libCHC.RegisterCallback(HealBarsClassic, "HealComm_HealStarted", "HealComm_HealUpdated")
  libCHC.RegisterCallback(HealBarsClassic, "HealComm_HealStopped")
  libCHC.RegisterCallback(HealBarsClassic, "HealComm_HealDelayed", "HealComm_HealUpdated")
  libCHC.RegisterCallback(HealBarsClassic, "HealComm_HealUpdated")
  libCHC.RegisterCallback(HealBarsClassic, "HealComm_ModifierChanged")
  libCHC.RegisterCallback(HealBarsClassic, "HealComm_GUIDDisappeared")
  AceConsole:RegisterChatCommand('hbc', function (args)
    HealBarsClassic:ChatCommand(args)
  end)
  AceConsole:RegisterChatCommand('HealBarsClassic', function (args)
    HealBarsClassic:ChatCommand(args)
  end)
  C_Timer.After(HBCdb.global.fastUpdateDuration, HealBarsClassic.UpdateHealthValuesLoop)
  
  -- Initialize individual frames immediately for solo play
  C_Timer.After(1, function()
    HealBarsClassic:UpdateIndividualFrames()
  end)
  
  -- Cell integration
  HealBarsClassic:SetupCellIntegration()
end

function HealBarsClassic:SetupCellIntegration()
  
  -- Wait for Cell to load
  if not Cell then
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, addonName)
      if addonName == "Cell" then
        self:UnregisterEvent("ADDON_LOADED")
        C_Timer.After(2, function()
          HealBarsClassic:SetupCellIntegration()
        end)
      end
    end)
    return
  end
  
  
  -- Hook the CellUnitButton_OnLoad function
  if not HealBarsClassic._cellHookAttempted then
    HealBarsClassic._cellHookAttempted = true
    hooksecurefunc("CellUnitButton_OnLoad", function(button)
      HealBarsClassic:createHealBars(button, 'raid')
    end)
  end
  
  -- Hook into Cell's layout updates
  if Cell.RegisterCallback then
    Cell.RegisterCallback(HealBarsClassic, "UpdateLayout", "OnCellLayoutUpdate")
  end
  
  -- Process existing Cell buttons with multiple attempts
  C_Timer.After(1, function()
    HealBarsClassic:ProcessExistingCellButtons()
  end)
  
  C_Timer.After(3, function()
    HealBarsClassic:ProcessExistingCellButtons()
  end)
  
  C_Timer.After(5, function()
    HealBarsClassic:ProcessExistingCellButtons()
  end)
  
  -- Start periodic Cell button monitoring
  HealBarsClassic:StartCellMonitoring()
end

function HealBarsClassic:StartCellMonitoring()
  
  -- Monitor for Cell buttons every 3 seconds
  HealBarsClassic.cellTicker = C_Timer.NewTicker(3, function()
    if Cell and Cell.unitButtons then
      HealBarsClassic:ProcessExistingCellButtons()
    end
  end)
end


function HealBarsClassic:ProcessExistingCellButtons()
  if not Cell or not Cell.unitButtons then 
    return 
  end
  
  
  local processedCount = 0
  local integratedCount = 0
  
  -- Process all existing unit buttons
  for groupType, groupData in pairs(Cell.unitButtons) do
    if groupData and groupData.units then
      for unitId, button in pairs(groupData.units) do
        if button and button.widgets and button.widgets.healthBar then
          processedCount = processedCount + 1
          
          -- Check if already integrated
          if not masterFrameTable[button:GetName()] then
            HealBarsClassic:createHealBars(button, 'raid')
            integratedCount = integratedCount + 1
          end
        end
      end
    end
  end
  
end

function HealBarsClassic:OnCellLayoutUpdate()
  -- Process any new buttons that might have been created
  C_Timer.After(0.1, function()
    HealBarsClassic:ProcessExistingCellButtons()
  end)
end

function HealBarsClassic:ForceInitialize()
  print("|c42f581FFHealBarsClassic|r: Force initializing addon...")
  
  -- Recreate default heal bars
  HealBarsClassic:CreateDefaultHealBars()
  
  -- Update all individual frames
  HealBarsClassic:UpdateIndividualFrames()
  
  -- Update party/raid frames if in group
  if UnitInParty("player") or UnitInRaid("player") then
    HealBarsClassic:PLAYER_ROLES_ASSIGNED()
  end
  
  print("|c42f581FFHealBarsClassic|r: Force initialization complete!")
end


function HealBarsClassic:ChatCommand(args)
  if args ~= nil then arg = AceConsole:GetArgs(args, 1) end
  if arg == nil then
    AceConfigDialog:Open('HBCOptions')
  elseif arg == 'rc' then
    AceConsole:Print('|c42f581FFHealBarsClassic|r - These players have casted a heal while using a compatible healing addon:\n')
    local nameSet = {}
    for frameName, unitFrame in pairs(masterFrameTable) do
      displayedUnit = HealBarsClassic:GetFrameInfo(unitFrame)
      if displayedUnit and UnitGUID(displayedUnit) and libCHC:GUIDHasHealed(UnitGUID(displayedUnit)) then
        nameSet[(UnitName(displayedUnit))] = true
      end
    end
    for name, _ in pairs(nameSet) do AceConsole:Print(name) end
  elseif arg == 'init' or arg == 'initialize' then
    HealBarsClassic:ForceInitialize()
  else
    AceConsole:Print('|c42f581FFHealBarsClassic|r\n' ..
      '|c42f5daFF/hbc|r - Open settings menu.\n' ..
      '|c42f5daFF/hbc rc|r - Raid Check. Players only show if you\'ve seen them cast' ..
      ' a heal since they\'ve joined the raid. Cross-addon compatible.\n' ..
      '|c42f5daFF/hbc init|r - Force initialize addon (useful when solo).')
  end
end
function HealBarsClassic:UpdateColors()
  for unitFrame, unitFrameBars in pairs(healBarTable) do
    for barType, barFrame in pairs(unitFrameBars) do
      barFrame:SetStatusBarColor(HealBarsClassic:getHealColor(barType))
    end
  end
end
function HealBarsClassic:UpdateHealthValuesLoop()
  if HBCdb.global.fastUpdate then
    -- Update raid frames if in party/raid
    if UnitInParty("player") or UnitInRaid("player") then
      local unitFrame = _G["CompactRaidFrame1"]
      local num = 1
      while unitFrame do
        if unitFrame.displayedUnit and UnitExists(unitFrame.displayedUnit) then
          CompactUnitFrame_UpdateMaxHealth(unitFrame.healthBar:GetParent())
          CompactUnitFrame_UpdateHealth(unitFrame.healthBar:GetParent())
        end
        num = num + 1
        unitFrame = _G["CompactRaidFrame" .. num]
      end
      for i = 1, 8 do
        local grpHeader = "CompactRaidGroup" .. i
        if _G[grpHeader] then
          for k = 1, 5 do
            unitFrame = _G[grpHeader .. "Member" .. k]
            if unitFrame and unitFrame.displayedUnit and UnitExists(unitFrame.displayedUnit) then
              CompactUnitFrame_UpdateMaxHealth(unitFrame.healthBar:GetParent())
              CompactUnitFrame_UpdateHealth(unitFrame.healthBar:GetParent())
            end
          end
        end
      end
    end
    
    -- Always update individual frames (player, target, focus, etc.) regardless of party/raid status
    for frameName, unitFrame in pairs(masterFrameTable) do
      if unitFrame and not unitFrame:IsForbidden() then
        local displayedUnit, healthBar = HealBarsClassic:GetFrameInfo(unitFrame)
        if displayedUnit and UnitExists(displayedUnit) and healthBar then
          -- Update health values for individual frames
          HealBarsClassic:UpdateHealBars(unitFrame)
        end
      end
    end
    
    C_Timer.After(HBCdb.global.fastUpdateDuration, HealBarsClassic.UpdateHealthValuesLoop)
  else
    C_Timer.After(1, HealBarsClassic.UpdateHealthValuesLoop)
  end
end
function HealBarsClassic:PLAYER_TARGET_CHANGED(frame)
  HealBarsClassic:UpdateHealBars(_G['TargetFrame'])
  HealBarsClassic:UpdateAuras(_G['TargetFrame'])
end
function HealBarsClassic:PLAYER_ROLES_ASSIGNED()
  local frame, unitFrame, num
  for guid, unit in pairs(partyGUIDs) do
    if strsub(unit, 1, 5) == "party" then partyGUIDs[guid] = nil end
  end
  if UnitInParty("player") then
    for i = 1, MAX_PARTY_MEMBERS do
      local p = "party" .. i
      if UnitExists(p) then
        partyGUIDs[UnitGUID(p)] = p
      else
        break
      end
    end
    unitFrame = _G["CompactPartyFrameMember1"]
    num = 1
    while unitFrame do
      HealBarsClassic:UpdateHealBars(unitFrame)
      num = num + 1
      unitFrame = _G["CompactPartyFrameMember" .. num]
    end
    unitFrame = _G["CompactRaidFrame1"]
    num = 1
    while unitFrame do
      HealBarsClassic:UpdateHealBars(unitFrame)
      num = num + 1
      unitFrame = _G["CompactRaidFrame" .. num]
    end
  end
  if UnitInRaid("player") then
    for k = 1, NUM_RAID_PULLOUT_FRAMES do
      frame = _G["RaidPullout" .. k]
      for z = 1, frame.numPulloutButtons do
        unitFrame = _G[frame:GetName() .. "Button" .. z]
        HealBarsClassic:UpdateHealBars(unitFrame)
      end
    end
    for i = 1, 8 do
      local grpHeader = "CompactRaidGroup" .. i
      if _G[grpHeader] then
        for k = 1, 5 do
          unitFrame = _G[grpHeader .. "Member" .. k]
          HealBarsClassic:UpdateHealBars(unitFrame)
        end
      end
    end
  end
  
  -- Always update individual frames regardless of party/raid status
  HealBarsClassic:UpdateIndividualFrames()
end

function HealBarsClassic:UpdateIndividualFrames()
  -- Update player, target, focus, and pet frames
  local framesToUpdate = {
    "PlayerFrame",
    "TargetFrame", 
    "FocusFrame",
    "PetFrame"
  }
  
  for _, frameName in ipairs(framesToUpdate) do
    local frame = _G[frameName]
    if frame then
      HealBarsClassic:UpdateHealBars(frame)
    end
  end
  
  -- Update party frames if they exist
  for i = 1, MAX_PARTY_MEMBERS do
    local frame = _G["PartyMemberFrame" .. i]
    if frame then
      HealBarsClassic:UpdateHealBars(frame)
    end
    local petFrame = _G["PartyMemberFrame" .. i .. "PetFrame"]
    if petFrame then
      HealBarsClassic:UpdateHealBars(petFrame)
    end
  end
end
function HealBarsClassic:HealComm_HealUpdated(event, casterGUID, spellID, healType, endTime, ...)
  if (bit.band(healType, libCHC.DIRECT_HEALS) > 0 or healType == libCHC.BOMB_HEALS) and (endTime - GetTime()) >
      HBCdb.global.healTimeframe then
    self:UpdateIncoming(endTime - GetTime() - HBCdb.global.healTimeframe, ...)
  else
    self:UpdateIncoming(nil, ...)
  end
end
function HealBarsClassic:HealComm_HealStopped(event, casterGUID, spellID, healType, interrupted, ...)
  self:UpdateIncoming(nil, ...)
end
function HealBarsClassic:HealComm_ModifierChanged(event, guid)
  self:UpdateIncoming(nil, guid)
end
function HealBarsClassic:HealComm_GUIDDisappeared(event, guid)
  self:UpdateIncoming(nil, guid)
end
function HealBarsClassic:ResetHealBars()
  wipe(currentHeals)
  for unitFrame, _ in pairs(healBarTable) do
    HealBarsClassic:ClearHealBar(unitFrame)
  end
end
function HealBarsClassic:ClearHealBar(unitFrame)
  for _, barFrame in pairs(healBarTable[unitFrame]) do
    barFrame:SetWidth(0)
    barFrame:Hide()
  end
end
function HealBarsClassic:UpdateIncoming(callbackTime, ...)
  local targetGUID, healType
  local currentTime = GetTime()
  local hotType = bit.bor(libCHC.HOT_HEALS, libCHC.BOMB_HEALS)
  local channelType = libCHC.CHANNEL_HEALS
  if HBCdb.global.showHots and not HBCdb.global.seperateHots then
    healType = bit.bor(hotType, libCHC.DIRECT_HEALS)
  else
    healType = libCHC.DIRECT_HEALS
  end
  for i = 1, select("#", ...) do
    targetGUID = select(i, ...)
    local targetHealMod = (libCHC:GetHealModifier(targetGUID) or 1)
    if not currentHeals[targetGUID] then
      currentHeals[targetGUID] = {}
    else
      wipe(currentHeals[targetGUID])
    end
    if not HBCdb.global.seperateOwnColor then
      local flatAmount = (libCHC:GetHealAmount(targetGUID, healType, currentTime + HBCdb.global.healTimeframe) or 0) + (libCHC:GetHealAmount(targetGUID, channelType, currentTime + HBCdb.global.channelTimeframe) or 0)
      table.insert(currentHeals[targetGUID], { healType = 'flat', amount = flatAmount * targetHealMod })
      if HBCdb.global.showHots and HBCdb.global.seperateHots then
        table.insert(currentHeals[targetGUID], { healType = 'hot', amount = (libCHC:GetHealAmount(targetGUID, hotType, currentTime + HBCdb.global.timeframe) or 0) * targetHealMod })
      end
    else
      local ownHealAmount, _, ownHealTime = libCHC:GetTimeframeHealAmount(targetGUID, healType, currentTime, currentTime + HBCdb.global.healTimeframe, nil, playerGUID)
      ownHealAmount = ownHealAmount + (libCHC:GetTimeframeHealAmount(targetGUID, channelType, currentTime, currentTime + HBCdb.global.channelTimeframe, nil, playerGUID) or 0)
      ownHealAmount = ownHealAmount * targetHealMod
      local beforeHealAmount = 0
      if ownHealTime then
        beforeHealAmount = (libCHC:GetTimeframeHealAmount(targetGUID, healType, currentTime, ownHealTime - 0.001, playerGUID) or 0) + (libCHC:GetTimeframeHealAmount(targetGUID, channelType, currentTime, ownHealTime - 0.001, playerGUID) or 0)
        beforeHealAmount = beforeHealAmount * targetHealMod
      else
        ownHealTime = 0
      end
      local afterHealAmount = (libCHC:GetTimeframeHealAmount(targetGUID, healType, ownHealTime, currentTime + HBCdb.global.healTimeframe, playerGUID) or 0)
      afterHealAmount = afterHealAmount + (libCHC:GetTimeframeHealAmount(targetGUID, channelType, ownHealTime, currentTime + HBCdb.global.channelTimeframe, playerGUID) or 0)
      afterHealAmount = afterHealAmount * targetHealMod
      table.insert(currentHeals[targetGUID], { healType = 'flat', amount = beforeHealAmount })
      table.insert(currentHeals[targetGUID], { healType = 'ownFlat', amount = ownHealAmount })
      table.insert(currentHeals[targetGUID], { healType = 'afterOwnFlat', amount = afterHealAmount })
      if HBCdb.global.showHots then
        if HBCdb.global.seperateHots then
          table.insert(currentHeals[targetGUID], { healType = 'ownHot', amount = (libCHC:GetHealAmount(targetGUID, hotType, GetTime() + HBCdb.global.timeframe, playerGUID) or 0) * targetHealMod })
          table.insert(currentHeals[targetGUID], { healType = 'hot', amount = (libCHC:GetOthersHealAmount(targetGUID, hotType, GetTime() + HBCdb.global.timeframe) or 0) * targetHealMod })
        else
          table.insert(currentHeals[targetGUID], { healType = 'hot', amount = (libCHC:GetHealAmount(targetGUID, hotType, currentTime + HBCdb.global.timeframe) or 0) * targetHealMod })
        end
      end
    end
    HealBarsClassic:UpdateGUIDHeals(targetGUID)
  end
  if callbackTime then
    local args = { ... }
    C_Timer.After(callbackTime, function ()
      HealBarsClassic:UpdateIncoming(nil, unpack(args))
    end)
  end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
eventFrame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("RAID_ROSTER_UPDATE")
eventFrame:SetScript("OnEvent", function (self, event, ...)
  HealBarsClassic[event](self, ...)
end)
