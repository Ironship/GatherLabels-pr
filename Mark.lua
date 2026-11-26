local _, ns = ...

-- Marks the node the arrow points to (the one you clicked, or the next stop
-- of the farming route) right in the 3D world: a small twinkling star over
-- the spot, shown only once you are near it (Settings: "Sparkle only closer
-- than", 50 yards by default). It is see-through
-- enough that the plant or vein still shows.
-- Addons can't make the plant or vein itself glow; this uses the game's own
-- map waypoint (the same marker as a map pin you place yourself), which the
-- game keeps at the right place on your screen as you move, and draws the
-- sparkle on it.

local mine -- { mapID, x, y } of the waypoint Gather Labels placed
local auto -- { continent, x, y, name } of the nearest node, sparkled by itself (below)
local want -- { continent, x, y, user } the spot to sparkle once you're close enough
local poke = false -- a new marker: check the sparkle on the next frame

-- 1.8.0: like Quest Glint, the sparkle (and the game's marker under it) only
-- shows when you are near the node, so it isn't in your face from across
-- the zone. The arrow still points the way from any distance.
local LEAVE = 10 -- yards past the range before the sparkle goes away again
local function Range()
  return tonumber(ns.db and ns.db.shineRange) or 50
end

local function SamePoint(point)
  if not mine or not point or point.uiMapID ~= mine.mapID then return false end
  local x, y = point.position:GetXY()
  return math.abs(x - mine.x) < 0.0005 and math.abs(y - mine.y) < 0.0005
end

local function ClearCurrentWaypoint()
  if C_Map.HasUserWaypoint() and SamePoint(C_Map.GetUserWaypoint()) then
    C_Map.ClearUserWaypoint()
  end
end

-- Take our marker down (the spot stays wanted).
local function Clear()
  if not mine then return end
  pcall(ClearCurrentWaypoint)
  mine = nil
end

-- Put the game's marker on the wanted spot.
local function Place()
  if not want or not ns.db.worldMark or not (C_Map.SetUserWaypoint and C_SuperTrack and UiMapPoint and CreateVector2D) then return end
  local mapID = ns.ZoneMap and ns.ZoneMap() or C_Map.GetBestMapForUnit("player")
  if not mapID then return end
  pcall(function()
    -- The sparkle on the nearest node never takes over a pin someone else
    -- placed (you, or Quest Glint). A node you clicked does.
    if not want.user and C_Map.HasUserWaypoint() then return end
    if C_Map.CanSetUserWaypointOnMap and not C_Map.CanSetUserWaypointOnMap(mapID) then return end
    local _, pos = C_Map.GetMapPosFromWorldPos(want.continent, CreateVector2D(want.x, want.y), mapID)
    if not pos then return end
    local mx, my = pos:GetXY()
    if mx < 0 or mx > 1 or my < 0 or my > 1 then return end
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, mx, my))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    mine = { mapID = mapID, x = mx, y = my }
    poke = true -- show it straight away
  end)
end

-- Show the marker once you're within range, take it down when you walk away.
local function CheckRange()
  if not want then return end
  local continent, px, py = ns.PlayerWorldPos()
  local far = true
  if continent and continent == want.continent then
    local d = math.sqrt((want.x - px) ^ 2 + (want.y - py) ^ 2)
    if mine then far = d > Range() + LEAVE else far = d > Range() end
  end
  if far then Clear() elseif not mine then Place() end
end

function ns.UnmarkInWorld()
  want = nil
  Clear()
end

-- user: you asked for this node (clicked it, or the farming route).
function ns.MarkInWorld(continent, x, y, user)
  Clear()
  if not ns.db.worldMark then want = nil return end
  want = { continent = continent, x = x, y = y, user = user and true or false }
  CheckRange()
end

---------------------------------------------------------------------------
-- The sparkle
---------------------------------------------------------------------------

local glow = CreateFrame("Frame", "GatherLabelsWorldGlow", UIParent)
glow:SetSize(80, 80)
glow:SetFrameStrata("BACKGROUND")
glow:EnableMouse(false)
glow:Hide()

-- Star colour by node type: herbs soft green, ore icy blue, fish aqua,
-- chests gold. Each a little white so it reads as light.
local TINT = {
  herb = { 0.75, 1, 0.7 }, ore = { 0.75, 0.88, 1 }, fish = { 0.6, 1, 0.95 }, treasure = { 1, 0.88, 0.5 },
}
local tint = TINT.herb

local SPARKS = 3
local random = math.random

-- A four-pointed star (the game's cooldown flash, turned upright).
local function Star(layer, size)
  local tex = glow:CreateTexture(nil, layer)
  tex:SetTexture("Interface\\Cooldown\\star4")
  tex:SetBlendMode("ADD")
  tex:SetRotation(math.pi / 4)
  tex:SetSize(size, size)
  return tex
end

-- Big star in the middle, slowly breathing.
glow.core = Star("ARTWORK", 36)
glow.core:SetPoint("CENTER", 0, 6)
local breathe = glow.core:CreateAnimationGroup()
breathe:SetLooping("BOUNCE")
local breatheScale = breathe:CreateAnimation("Scale")
if breatheScale.SetScaleFrom then
  breatheScale:SetScaleFrom(0.85, 0.85)
  breatheScale:SetScaleTo(1, 1)
else
  breatheScale:SetScale(1.18, 1.18)
end
breatheScale:SetDuration(1.4)
breatheScale:SetSmoothing("IN_OUT")

-- Small stars that pop up around it, twinkle, drift up a little and fade,
-- each time somewhere new.
glow.sparks = {}
for i = 1, SPARKS do
  local spark = Star("OVERLAY", 12)
  spark:SetAlpha(0)
  local group = spark:CreateAnimationGroup()
  local fadeIn = group:CreateAnimation("Alpha")
  fadeIn:SetFromAlpha(0)
  fadeIn:SetToAlpha(1)
  fadeIn:SetOrder(1)
  local rise = group:CreateAnimation("Translation")
  rise:SetOrder(1)
  local fadeOut = group:CreateAnimation("Alpha")
  fadeOut:SetFromAlpha(1)
  fadeOut:SetToAlpha(0)
  fadeOut:SetOrder(2)
  local function Again()
    if not glow:IsShown() then return end
    local size = random(8, 16)
    spark:SetSize(size, size)
    spark:SetVertexColor(tint[1], tint[2], tint[3])
    spark:ClearAllPoints()
    spark:SetPoint("CENTER", glow, "CENTER", random(-24, 24), random(-10, 30))
    local time = 0.35 + random() * 0.5
    fadeIn:SetDuration(time)
    local delay = 0.4 + random() * 1.6
    fadeIn:SetStartDelay(delay)
    rise:SetOffset(0, random(4, 10))
    rise:SetDuration(time)
    rise:SetStartDelay(delay)
    fadeOut:SetDuration(0.4 + random() * 0.5)
    group:Play()
  end
  group:SetScript("OnFinished", Again)
  glow.sparks[i] = { tex = spark, group = group, again = Again }
end

-- A faint ring spreading out from the spot now and then.
glow.ring = glow:CreateTexture(nil, "BACKGROUND")
glow.ring:SetTexture("Interface\\Cooldown\\ping4")
glow.ring:SetBlendMode("ADD")
glow.ring:SetPoint("CENTER", 0, -6)
glow.ring:SetSize(50, 20)
glow.ring:SetAlpha(0)
local ripple = glow.ring:CreateAnimationGroup()
ripple:SetLooping("REPEAT")
local spread = ripple:CreateAnimation("Scale")
if spread.SetScaleFrom then
  spread:SetScaleFrom(0.5, 0.5)
  spread:SetScaleTo(1.6, 1.6)
else
  spread:SetScale(3.2, 3.2)
end
spread:SetDuration(1.6)
local ringIn = ripple:CreateAnimation("Alpha")
ringIn:SetFromAlpha(0)
ringIn:SetToAlpha(0.45)
ringIn:SetDuration(0.3)
local ringOut = ripple:CreateAnimation("Alpha")
ringOut:SetFromAlpha(0.45)
ringOut:SetToAlpha(0)
ringOut:SetStartDelay(0.3)
ringOut:SetDuration(1.3)
local ringPause = ripple:CreateAnimation("Alpha")
ringPause:SetFromAlpha(0)
ringPause:SetToAlpha(0)
ringPause:SetStartDelay(1.6)
ringPause:SetDuration(2)


local function SetTint(name)
  tint = TINT[name and ns.Category(name) or "herb"] or TINT.herb
  glow.core:SetVertexColor(tint[1], tint[2], tint[3])
  glow.ring:SetVertexColor(tint[1], tint[2], tint[3])
end

local function Animate()
  breathe:Stop()
  ripple:Stop()
  for _, spark in ipairs(glow.sparks) do
    spark.group:Stop()
    spark.tex:SetAlpha(0)
  end
  glow.ring:SetAlpha(0)
  if not glow:IsShown() or (ns.db and ns.db.shineAnim == false) then return end
  breathe:Play()
  ripple:Play()
  for _, spark in ipairs(glow.sparks) do spark.again() end
end

glow:SetScript("OnShow", function()
  SetTint(ns.MarkedName())
  Animate()
end)
glow:SetScript("OnHide", function()
  breathe:Stop()
  ripple:Stop()
  for _, spark in ipairs(glow.sparks) do
    spark.group:Stop()
    spark.tex:SetAlpha(0)
  end
end)

local navFrame
local function NavFrame()
  if not navFrame and C_Navigation and C_Navigation.GetFrame then navFrame = C_Navigation.GetFrame() end
  return navFrame
end

local function IsStillMineWaypoint()
  return C_Map.HasUserWaypoint() and SamePoint(C_Map.GetUserWaypoint())
end

local function CheckNavVisible()
  return C_SuperTrack.IsSuperTrackingUserWaypoint()
    and C_Navigation.HasValidScreenPosition()
    and not C_Navigation.WasClampedToScreen()
end

local watch = CreateFrame("Frame")
watch:RegisterEvent("NAVIGATION_FRAME_CREATED")
watch:RegisterEvent("NAVIGATION_FRAME_DESTROYED")
watch:RegisterEvent("USER_WAYPOINT_UPDATED")
watch:SetScript("OnEvent", function(_, event)
  if event == "NAVIGATION_FRAME_DESTROYED" then
    navFrame = nil
    glow:ClearAllPoints()
    glow:Hide()
  elseif event == "NAVIGATION_FRAME_CREATED" then
    navFrame = nil
  elseif event == "USER_WAYPOINT_UPDATED" and mine then
    -- Someone else (you, or another addon) moved the map pin.
    local ok, still = pcall(IsStillMineWaypoint)
    if ok and not still then
      mine = nil
      -- Leave their pin alone; ours comes back once theirs is gone.
      if want then want.user = false end
    end
  end
end)

-- 1.9.2: a fishing pool gets the close-up glow (Glow.lua) instead of the
-- star, in teal and in your glow style.
local pooled = false
local function Unpool()
  if pooled and ns.GlowOnPool then ns.GlowOnPool(nil) end
  pooled = false
end

local wait, rangeWait = 0, 0
watch:SetScript("OnUpdate", function(_, elapsed)
  wait = wait - elapsed
  rangeWait = rangeWait - elapsed
  if rangeWait <= 0 then
    rangeWait = 0.5
    if want then CheckRange() end
  end
  if wait > 0 and not poke then return end
  poke = false
  -- The sparkle sits on the game's marker, which follows the spot by
  -- itself; this only checks now and then whether it should show.
  if not mine and not glow:IsShown() then
    Unpool()
    wait = 0.5
    return
  end
  wait = 0.1
  local show = false
  local nav = mine and NavFrame()
  if nav then
    local ok, vis = pcall(CheckNavVisible)
    if ok then show = vis end
  end
  local onPool = false
  if show then
    if select(2, glow:GetPoint(1)) ~= nav then
      glow:ClearAllPoints()
      glow:SetPoint("CENTER", nav, "CENTER")
    end
    -- Dimmer when something is in the way.
    local ok, state = pcall(C_Navigation.GetTargetState)
    local occluded = ok and Enum and Enum.NavigationState and state == Enum.NavigationState.Occluded
    glow:SetAlpha(occluded and 0.3 or 0.5)
    local name = ns.MarkedName()
    if name ~= glow.name then
      glow.name = name
      SetTint(name)
    end
    if name and ns.Category(name) == "fish" and ns.GlowOnPool then
      onPool = ns.GlowOnPool(nav, name, occluded and true or false) == true
    end
  end
  if onPool then pooled = true else Unpool() end
  glow:SetShown(show and not onPool)
end)

-- Setting turned off or on while the arrow is showing.
-- Range slider or "Sparkle moves" changed.
function ns.SparkleChanged()
  Animate()
  if want then CheckRange() end
end

function ns.WorldMarkChanged()
  if not ns.db.worldMark then
    auto = nil
    ns.UnmarkInWorld()
  elseif ns.RemarkTarget then
    ns.RemarkTarget()
  end
end

---------------------------------------------------------------------------
-- Shine nearby nodes
---------------------------------------------------------------------------

-- With "Sparkle the nearest node" on, the sparkle goes by itself to the
-- closest node of the kinds you picked, as soon as it shows on the minimap,
-- and moves on to the next one once it's gathered. The game only lets
-- addons put one marker in the world at a time, so it is always the nearest
-- one. A node you click, or a farming route, comes first.

local KEEP = 10 -- yards a new node must be closer by before the sparkle jumps to it

function ns.MarkedName()
  return (ns.TargetName and ns.TargetName()) or (auto and auto.name)
end

-- 1.9.2: with the close-up glow on (and Fishing pools ticked on its tab),
-- the nearest fishing pool is marked by itself too, so it can glow.
local function PoolGlow()
  local db = ns.db
  return db and db.glow and db.worldMark and not (db.glowKinds and db.glowKinds.fish == false) and true or false
end

local function Wanted(name)
  local category = ns.Category(name)
  if not category or not ns.IsDrawn(name) then return false end
  if category == "fish" and PoolGlow() then return true end
  return ns.db.autoShine and ns.db.shine[category] and true or false
end

-- Nodes in range now: what the scanner reads off the minimap (Forever), or
-- saved spots within the minimap's reach. Checked 4 times a second, so the
-- list and its entries are reused rather than made anew each time.
local list, pool = {}, {}
local function Add(n, x, y, name)
  local node = pool[n]
  if not node then node = {}; pool[n] = node end
  node.x, node.y, node.name = x, y, name
  list[n] = node
  return n
end

local function Nearby(continent, px, py)
  local n = 0
  if ns.HasLiveDots and ns.HasLiveDots() then
    if ns.liveContinent == continent and ns.liveDots then
      local r2 = Range() ^ 2
      for _, dot in ipairs(ns.liveDots) do
        if Wanted(dot.name) and (dot.x - px) ^ 2 + (dot.y - py) ^ 2 <= r2 then
          n = Add(n + 1, dot.x, dot.y, dot.name)
        end
      end
    end
  else
    local radius, cell = math.min(ns.MinimapRadius(), Range()), ns.CELL
    local r2 = radius * radius
    local cells = ns.db.spots[continent]
    if cells then
      for i = math.floor((px - radius) / cell), math.floor((px + radius) / cell) do
        for j = math.floor((py - radius) / cell), math.floor((py + radius) / cell) do
          local spots = cells[i .. ":" .. j]
          if spots then
            for _, spot in ipairs(spots) do
              local name = ns.ShownName(spot)
              if name and Wanted(name) and (spot.x - px) ^ 2 + (spot.y - py) ^ 2 <= r2 then
                n = Add(n + 1, spot.x, spot.y, name)
              end
            end
          end
        end
      end
    end
  end
  for i = n + 1, #list do list[i] = nil end
  return list
end

local function StopAuto()
  if auto then
    auto = nil
    if not (ns.TargetName and ns.TargetName()) then ns.UnmarkInWorld() end
  end
end

local lastAutoContinent, lastAutoX, lastAutoY, lastAutoRange, lastAutoScans, lastAutoRadius, lastAutoPoolGlow, lastAutoHasLive
local autoDirty = true

local function UpdateAuto()
  local db = ns.db
  if not db or not (db.autoShine or PoolGlow()) or not db.worldMark or (ns.TargetName and ns.TargetName()) then
    if auto and ns.TargetName and ns.TargetName() then auto = nil else StopAuto() end
    lastAutoContinent = nil
    return
  end
  local continent, px, py = ns.PlayerWorldPos()
  if not continent then
    StopAuto()
    lastAutoContinent = nil
    return
  end
  local range = Range()
  local scans = ns.liveScans
  local minimapRadius = ns.MinimapRadius()
  local poolGlow = PoolGlow()
  local hasLive = ns.HasLiveDots and ns.HasLiveDots() or false
  if not autoDirty and lastAutoContinent == continent and lastAutoRange == range and lastAutoScans == scans
      and lastAutoRadius == minimapRadius and lastAutoPoolGlow == poolGlow and lastAutoHasLive == hasLive
      and (not auto or want) and lastAutoX and (lastAutoX - px) ^ 2 + (lastAutoY - py) ^ 2 < 1 then
    return
  end
  autoDirty = false
  lastAutoContinent, lastAutoX, lastAutoY, lastAutoRange, lastAutoScans, lastAutoRadius, lastAutoPoolGlow, lastAutoHasLive =
    continent, px, py, range, scans, minimapRadius, poolGlow, hasLive
  local best, bestDist, current
  for _, node in ipairs(Nearby(continent, px, py)) do
    local d = (node.x - px) ^ 2 + (node.y - py) ^ 2
    if not bestDist or d < bestDist then best, bestDist = node, d end
    if auto and auto.continent == continent and (node.x - auto.x) ^ 2 + (node.y - auto.y) ^ 2 < 225 then
      current = node
    end
  end
  if not best then StopAuto() return end
  -- Stay on the node you're heading to unless another is clearly closer.
  if current and math.sqrt((current.x - px) ^ 2 + (current.y - py) ^ 2) - math.sqrt(bestDist) < KEEP then
    if not want then ns.MarkInWorld(continent, auto.x, auto.y) end
    return
  end
  auto = { continent = continent, x = best.x, y = best.y, name = best.name }
  ns.MarkInWorld(continent, best.x, best.y)
end

local autoWait = 0
local autoFrame = CreateFrame("Frame")
autoFrame:SetScript("OnUpdate", function(_, elapsed)
  autoWait = autoWait - elapsed
  if autoWait > 0 then return end
  if not ns.db or not (ns.db.autoShine or PoolGlow()) then
    autoWait = 1
    if auto then UpdateAuto() end
    return
  end
  autoWait = 0.25
  UpdateAuto()
end)

function ns.ShineChanged()
  autoWait = 0
  autoDirty = true
  if not ns.db.autoShine and not PoolGlow() then StopAuto() end
end

-- Key Bindings > AddOns > Gather Labels.
BINDING_HEADER_GATHERLABELS = "Gather Labels"
BINDING_NAME_GATHERLABELS_SHINE = "Sparkle the nearest node on/off"

function GatherLabels_ToggleShine()
  if ns.db then ns.ToggleShine() end
end

function ns.ToggleShine()
  ns.Set("autoShine", not ns.db.autoShine)
  ns.Print("Sparkle on the nearest node " .. (ns.db.autoShine and "on." or "off."))
end
