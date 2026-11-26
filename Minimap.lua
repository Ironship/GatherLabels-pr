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
