local _, ns = ...

-- Round button on the edge of the minimap. Left-click opens Settings,
-- right-click turns the icons on or off, Shift-click turns the sparkle on
-- the nearest node on or off, drag to move it around the map.

local ICON = "Interface\\Icons\\INV_Misc_Flower_02"
local button

local function UpdatePosition()
  local angle = math.rad(GatherLabelsDB.minimapAngle or 200)
  local radius = Minimap:GetWidth() / 2 + 5
  button:ClearAllPoints()
  button:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
end

local function OnClick(_, mouseButton)
  if IsShiftKeyDown() then
    ns.ToggleShine()
  elseif mouseButton == "RightButton" then
    ns.Set("enabled", not ns.db.enabled)
    ns.Print("Minimap icons " .. (ns.db.enabled and "on." or "off."))
  else
    ns.ToggleSettings()
  end
end

local function AppendResourceList(prefix, names)
  if not names or #names == 0 then return end
  local parts = {}
  for i = 1, #names do
    local n = names[i]
    local need, have, color = ns.SkillInfo and ns.SkillInfo(n)
    if need then
      local colored = have and ("|cff" .. color .. n .. "|r") or n
      parts[i] = colored .. " |cffaaaaaa(" .. need .. ")|r"
    else
      parts[i] = n
    end
  end
  GameTooltip:AddLine(prefix .. table.concat(parts, ", "), 0.82, 0.82, 0.82, true)
end

local function Build()
  button = CreateFrame("Button", "GatherLabelsMinimapButton", Minimap)
  button:SetSize(31, 31)
  button:SetFrameStrata("MEDIUM")
  button:SetFrameLevel(8)
  button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  button:RegisterForDrag("LeftButton")
  button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

  local background = button:CreateTexture(nil, "BACKGROUND")
  background:SetSize(20, 20)
  background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
  background:SetPoint("TOPLEFT", 7, -5)

  local icon = button:CreateTexture(nil, "ARTWORK")
  icon:SetSize(17, 17)
  icon:SetTexture(ICON)
  icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
  icon:SetPoint("TOPLEFT", 7, -6)

  local border = button:CreateTexture(nil, "OVERLAY")
  border:SetSize(53, 53)
  border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
  border:SetPoint("TOPLEFT")

  button:SetScript("OnClick", OnClick)
  button:SetScript("OnEnter", function(self)
    ns.Skin.ClickTip(self, "Gather Labels", {
      { "Left-click", "Settings" },
      { "Right-click", "Icons on or off" },
      { "Shift-click", "Sparkle the nearest node" },
      { "Drag", "Move this button" },
    })
    local mapID = (ns.ZoneMap and ns.ZoneMap()) or (C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player"))
    local z = mapID and ns.ZONE_DATA and ns.ZONE_DATA[mapID]
    if z then
      local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
      local zoneName = info and info.name
      GameTooltip:AddLine(" ")
      GameTooltip:AddLine(zoneName and ("In this zone (" .. zoneName .. "):") or "In this zone:", 1, 0.82, 0)
      AppendResourceList("|cffffd100Herbs:|r ", z.herbs)
      AppendResourceList("|cffffd100Ore:|r ", z.ores)
      local fishParts = {}
      if z.pools then
        for i = 1, #z.pools do
          fishParts[#fishParts + 1] = "|cff70c8e0" .. z.pools[i] .. "|r"
        end
      end
      if z.fish then
        local maxFish = 6
        local shown = math.min(#z.fish, maxFish)
        for i = 1, shown do
          local f = z.fish[i]
          local fname = (C_Item and C_Item.GetItemNameByID and C_Item.GetItemNameByID(f[2]))
            or (GetItemInfo and GetItemInfo(f[2]))
            or f[1]
          fishParts[#fishParts + 1] = fname
        end
        if #z.fish > maxFish then
          fishParts[#fishParts + 1] = "|cffaaaaaa+" .. (#z.fish - maxFish) .. " more|r"
        end
      end
      if #fishParts > 0 then
        GameTooltip:AddLine("|cffffd100Fish:|r " .. table.concat(fishParts, ", "), 0.82, 0.82, 0.82, true)
      end
      GameTooltip:Show()
    end
  end)
  button:SetScript("OnLeave", function() GameTooltip:Hide() end)

  button:SetScript("OnDragStart", function(self)
    GameTooltip:Hide()
    self:SetScript("OnUpdate", function()
      local mx, my = Minimap:GetCenter()
      local px, py = GetCursorPosition()
      local scale = Minimap:GetEffectiveScale()
      GatherLabelsDB.minimapAngle = math.deg(math.atan2(py / scale - my, px / scale - mx))
      UpdatePosition()
    end)
  end)
  button:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)

  UpdatePosition()
end

function ns.SetMinimapShown(on)
  GatherLabelsDB.minimapHidden = not on
  if button then button:SetShown(on) end
  if ns.OnSettingsChanged then ns.OnSettingsChanged() end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
  Build()
  button:SetShown(not GatherLabelsDB.minimapHidden)
end)

-- Retail also lists addons in the minimap's addon menu; this is what runs
-- when Gather Labels is picked there (set in GatherLabels.toc).
function GatherLabels_OnAddonCompartmentClick(_, mouseButton)
  OnClick(nil, mouseButton)
end
