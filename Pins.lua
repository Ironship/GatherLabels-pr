local _, ns = ...

-- Draws an icon (and optionally the name) on the minimap for every saved
-- spot in range, at the same place the game draws its dot.

local RING_TEX = "Interface\\AddOns\\GatherLabels\\Media\\Ring"
local RING_COLORS = {
  herb = { 0.35, 0.95, 0.35 },
  ore = { 1.0, 0.78, 0.25 },
  fish = { 0.35, 0.85, 1.0 },
  treasure = { 1.0, 0.85, 0.35 },
}

local pins, used = {}, 0

local function PinOnEnter(self)
  GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
  local names = {}
  for name in pairs(self.spot.n) do
    if ns.IsDrawn(name) then names[#names + 1] = name end
  end
  table.sort(names, function(a, b) return self.spot.n[a] > self.spot.n[b] end)
  for i, name in ipairs(names) do
    local icon = ns.Icon(name)
    local text = icon and ("|T" .. icon .. ":0|t " .. name) or name
    if i == 1 then GameTooltip:SetText(text) else GameTooltip:AddLine(text, 1, 1, 1) end
    local skill = ns.SkillText(name)
    if skill then GameTooltip:AddLine("   " .. skill) end
  end
  if self.level then GameTooltip:AddLine(self.level == "above" and "Above you" or "Below you", 1, 0.82, 0) end
  if self.spot.cave then GameTooltip:AddLine("In a cave or building", 0.8, 0.6, 0.4) end
  GameTooltip:AddLine("Click: show an arrow to it", 0.5, 0.8, 1)
  if #names > 1 then
    GameTooltip:AddLine("Different nodes have spawned here; the top one was seen last.", 0.6, 0.6, 0.6, true)
  end
  GameTooltip:Show()
end

local function GetPin(i)
  local pin = pins[i]
  if pin then return pin end
  pin = CreateFrame("Frame", nil, Minimap)
  pin:SetFrameLevel(Minimap:GetFrameLevel() + 2)
  pin.icon = pin:CreateTexture(nil, "ARTWORK")
  pin.icon:SetAllPoints()
  pin.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
  pin.ring = pin:CreateTexture(nil, "ARTWORK")
  pin.ring:SetAllPoints()
  pin.ring:SetTexture(RING_TEX)
  pin.ring:Hide()
  -- Brown frame: in a cave or building.
  pin.caveBorder = pin:CreateTexture(nil, "BACKGROUND")
  pin.caveBorder:SetPoint("TOPLEFT", -2, 2)
  pin.caveBorder:SetPoint("BOTTOMRIGHT", 2, -2)
  pin.caveBorder:SetColorTexture(0.55, 0.35, 0.15, 1)
  -- Small arrow in the corner: above or below you (the game's own arrows).
  pin.levelArrow = pin:CreateTexture(nil, "OVERLAY")
  pin.levelArrow:SetTexture("Interface\\Minimap\\Minimap-PositionArrows")
  pin.levelArrow:SetSize(12, 12)
  pin.levelArrow:SetPoint("CENTER", pin, "TOPRIGHT", 0, 0)
  pin.label = pin:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
  pin.label:SetPoint("LEFT", pin, "RIGHT", 2, 0)
  local font, size = pin.label:GetFont()
  pin.label:SetFont(font, (size or 10) - 1, "OUTLINE")
  pin.label:SetTextColor(1, 1, 1)
  pin:EnableMouse(true)
  pin:SetScript("OnEnter", PinOnEnter)
  pin:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" and ns.SetTarget then ns.SetTarget(self.wx, self.wy, self.name, self.spot.cave) end
  end)
  pin:SetScript("OnLeave", function() GameTooltip:Hide() end)
  pins[i] = pin
  return pin
end

-- Name to show for a spot: the node seen there last, unless it's switched
-- off, then the most recent one that is switched on.
local function ShownName(spot)
  if spot.last and spot.n[spot.last] and ns.IsDrawn(spot.last) then return spot.last end
  local best, bestTime
  for name, seen in pairs(spot.n) do
    if ns.IsDrawn(name) and (not bestTime or seen > bestTime) then best, bestTime = name, seen end
  end
  return best
end

ns.ShownName = ShownName

-- What Update() is drawing around right now; kept here so placing a pin
-- needs no new function (and no garbage) on every redraw.
local cur = {}

local function Place(x, y, name, spot, alpha, level, isLive)
  local c = cur
  local north, east = x - c.px, c.py - y
  local sx = (east * c.cos + north * c.sin) * c.pixelsPerYard
  local sy = (north * c.cos - east * c.sin) * c.pixelsPerYard
  local edge, inside = c.edge
  if c.square then
    inside = math.abs(sx) <= edge and math.abs(sy) <= edge
  else
    inside = sx * sx + sy * sy <= edge * edge
  end
  if not inside then return end
  used = used + 1
  local db = ns.db
  local pin = GetPin(used)
  pin.spot, pin.wx, pin.wy, pin.name = spot, x, y, name
  local useRing = (not isLive) and db.ringMode and true or false
  local size = useRing and math.max(db.iconSize + 4, 16) or db.iconSize
  pin:SetSize(size, size)
  pin:ClearAllPoints()
  pin:SetPoint("CENTER", Minimap, "CENTER", sx, sy)
  pin:SetAlpha(alpha)
  pin.ring:SetShown(useRing)
  pin.icon:SetShown(not useRing)
  if useRing then
    local cat = (spot and spot.c) or ns.Category(name) or "herb"
    local col = RING_COLORS[cat] or RING_COLORS.herb
    pin.ring:SetVertexColor(col[1], col[2], col[3], 1)
  else
    pin.icon:SetTexture(ns.Icon(name))
  end
  pin.level = level
  pin.caveBorder:SetShown((spot.cave and not useRing) and true or false)
  if level then
    pin.levelArrow:SetTexCoord(0, 1, level == "above" and 0 or 0.5, level == "above" and 0.5 or 1)
  end
  pin.levelArrow:SetShown(level ~= nil)
  -- Name coloured by skill, like the game: red too low, grey no skill points.
  local _, have, color = ns.SkillInfo(name)
  local label = have and ("|cff" .. color .. name .. "|r") or name
  pin.label:SetText(spot.cave and (label .. " |cffc8a070(cave)|r") or label)
  pin.label:SetShown(db.labels)
  pin:Show()
end

local function Update(continent, px, py, facing, radius)
  local db = ns.db
  if not db then return end
  used = 0
  if not (db.enabled and facing) then continent = nil end
  if continent then
    local half = Minimap:GetWidth() / 2
    cur.px, cur.py = px, py
    cur.pixelsPerYard = half / radius
    cur.square = GetMinimapShape and GetMinimapShape() == "SQUARE"
    cur.cos, cur.sin = math.cos(facing), math.sin(facing)
    cur.edge = half - db.iconSize / 2

    -- WoW Forever: the dots the scanner just read (Scan.lua).
    local live = ns.liveContinent == continent and ns.liveDots or nil
    local hasLive = live ~= nil and #live > 0
    if hasLive then
      for _, dot in ipairs(live) do
        if ns.IsDrawn(dot.name) then Place(dot.x, dot.y, dot.name, dot.spot, 1, dot.level, true) end
      end
    end

    -- Saved spots: all of them when the scanner has no live dots; on Forever
    -- with live dots only if asked for, faded, and not where a dot was just read.
    local cells = db.spots[continent]
    if cells and (not hasLive or db.showSaved) then
      local alpha = hasLive and 0.5 or 1
      local cell = ns.CELL
      for i = math.floor((px - radius) / cell), math.floor((px + radius) / cell) do
        for j = math.floor((py - radius) / cell), math.floor((py + radius) / cell) do
          local list = cells[i .. ":" .. j]
          if list then
            for _, spot in ipairs(list) do
              local name = ShownName(spot)
              local covered = false
              if name and live then
                for _, dot in ipairs(live) do
                  if (dot.x - spot.x) ^ 2 + (dot.y - spot.y) ^ 2 < 225 then covered = true break end
                end
              end
              if name and not covered then Place(spot.x, spot.y, name, spot, alpha, nil, false) end
            end
          end
        end
      end
    end
  end
  for i = used + 1, #pins do pins[i]:Hide() end
end

-- Redraw only when something changed: you moved or turned, the minimap
-- zoomed, a scan finished, or a setting or saved spot changed.
local driver = CreateFrame("Frame")
local wait, dirty = 0, true
local lastContinent, lastX, lastY, lastFacing, lastRadius
driver:SetScript("OnUpdate", function(_, elapsed)
  wait = wait - elapsed
  if wait > 0 then return end
  wait = 0.1
  if not Minimap:IsVisible() then return end
  -- Read once per check and handed to Update(), not asked for again.
  local continent, x, y = ns.PlayerWorldPos()
  local facing, radius = ns.MinimapFacing(), ns.MinimapRadius()
  if not dirty and continent == lastContinent and facing == lastFacing and radius == lastRadius
      and (not x or ((x - lastX) ^ 2 + (y - lastY) ^ 2 < 0.25)) then
    return
  end
  dirty = false
  lastContinent, lastX, lastY, lastFacing, lastRadius = continent, x, y, facing, radius
  Update(continent, x, y, facing, radius)
end)

function ns.RefreshPins()
  wait, dirty = 0, true
end
ns.OnSpotsChanged = function()
  ns.RefreshPins()
  if ns.ShineChanged then ns.ShineChanged() end
  if ns.OnSettingsChanged then ns.OnSettingsChanged() end
end
