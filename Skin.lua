local ADDON, ns = ...

-- The shared look of SlimyTaco's addons.
--
-- Windows use the game's own framed window with a round portrait, so on
-- WoW Forever they get Forever's classic frame art and on Retail the Retail
-- art. Behind everything is dark wood: on Forever the same backdrop as the
-- game's Character and Skills window, on Retail a dark brown wash in the
-- same colours. Inside: gold section headings on a dark bar, warm grey help text,
-- a tooltip on every setting, and the game's own buttons, ticks, sliders and
-- tabs. Everything is built once, the first time a window opens. Nothing here
-- runs on a timer or every frame.

local S = {}
ns.Skin = S

S.GOLD = { 1, 0.82, 0 }
S.HELP = { 0.72, 0.67, 0.56 }   -- warm grey, easier on the eye than plain grey
S.EDGE = { 0.62, 0.5, 0.28 }    -- old brass, for plates and boxes

local GetMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata

function S.Version()
  local ok, v = pcall(GetMeta, ADDON, "Version")
  return ok and v or ""
end

-- "[icon] Addon Name:" at the start of chat lines, the same for every addon.
function S.Prefix(title, icon)
  return "|T" .. icon .. ":14:14:0:0:64:64:5:59:5:59|t |cffffd100" .. title .. ":|r "
end

local function Sound(kit)
  if PlaySound and SOUNDKIT and SOUNDKIT[kit] then PlaySound(SOUNDKIT[kit]) end
end
S.Sound = Sound

function S.Label(parent, text, font)
  local fs = parent:CreateFontString(nil, "OVERLAY", font or "GameFontHighlight")
  fs:SetJustifyH("LEFT")
  fs:SetText(text or "")
  return fs
end

function S.Help(parent, text, width)
  local fs = S.Label(parent, text, "GameFontHighlightSmall")
  fs:SetTextColor(S.HELP[1], S.HELP[2], S.HELP[3])
  if width then
    fs:SetWidth(width)
    fs:SetWordWrap(true)
  end
  return fs
end

local function Tip(owner, title, text)
  if not title then return end
  owner:HookScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(title, 1, 1, 1)
    if text then GameTooltip:AddLine(text, nil, nil, nil, true) end
    GameTooltip:Show()
  end)
  owner:HookScript("OnLeave", GameTooltip_Hide or function() GameTooltip:Hide() end)
end
S.Tip = Tip

------------------------------------------------------------------------
-- Dark wood
------------------------------------------------------------------------

local function HasAtlas(name)
  return C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(name) ~= nil
end
S.HasAtlas = HasAtlas

-- Colours picked from Forever's Skills window, used where its art is missing.
S.WOOD = {
  pane  = { atlas = "UI-Character-Info-General-BG", top = { 0.25, 0.2, 0.16 }, bottom = { 0.07, 0.055, 0.035 } },
  inset = { atlas = "UI-Character-Info-Stat-BG", top = { 0.21, 0.155, 0.115 }, bottom = { 0.05, 0.04, 0.03 } },
}
S.BAR = { 0.2, 0.14, 0.1 }       -- section heading bar
S.TRIM = { 0.41, 0.28, 0.15 }    -- thin gold-brown edges

local WHITE = "Interface\\Buttons\\WHITE8X8"

local function Gradient(t, top, bottom, a)
  t:SetTexture(WHITE)
  if CreateColor and t.SetGradient then
    t:SetVertexColor(1, 1, 1, 1)
    t:SetGradient("VERTICAL", CreateColor(bottom[1], bottom[2], bottom[3], a or 1),
      CreateColor(top[1], top[2], top[3], a or 1))
  else
    t:SetVertexColor((top[1] + bottom[1]) / 2, (top[2] + bottom[2]) / 2, (top[3] + bottom[3]) / 2, a or 1)
  end
end

-- Paints one texture as wood. kind = "pane" (window) or "inset" (darker well).
function S.PaintWood(t, kind)
  local w = S.WOOD[kind or "pane"] or S.WOOD.pane
  if t.SetHorizTile then t:SetHorizTile(false); t:SetVertTile(false) end
  if HasAtlas(w.atlas) and pcall(t.SetAtlas, t, w.atlas) then
    t:SetVertexColor(1, 1, 1, 1)
    t:SetTexCoord(0, 1, 0, 1)
  else
    Gradient(t, w.top, w.bottom)
  end
  t.isWood = true
  return t
end

-- Lays wood behind a frame's content. area = the region it covers (the old
-- backdrop texture, which is hidden), or nil to fill the frame.
-- Returns the texture as f.wood. Calling it again does nothing.
function S.Wood(f, area, kind)
  if f.wood then return f.wood end
  local t = f:CreateTexture(nil, "BACKGROUND", nil, -6)
  if area then
    t:SetAllPoints(area)
    if area.Hide and area ~= f then area:Hide() end
  else
    t:SetAllPoints()
  end
  S.PaintWood(t, kind)
  f.wood = t
  return t
end

-- A one-pixel gold-brown line round a frame (or round region, a texture on
-- that frame), for panes inside a window.
local function Trim(f, alpha, layer, region)
  region = region or f
  local r, g, b = S.TRIM[1], S.TRIM[2], S.TRIM[3]
  local lines = {}
  for i = 1, 4 do
    local l = f:CreateTexture(nil, layer or "BORDER", nil, 1)
    l:SetColorTexture(r, g, b, alpha or 0.7)
    lines[i] = l
  end
  lines[1]:SetPoint("TOPLEFT", region); lines[1]:SetPoint("TOPRIGHT", region); lines[1]:SetHeight(1)
  lines[2]:SetPoint("BOTTOMLEFT", region); lines[2]:SetPoint("BOTTOMRIGHT", region); lines[2]:SetHeight(1)
  lines[3]:SetPoint("TOPLEFT", region); lines[3]:SetPoint("BOTTOMLEFT", region); lines[3]:SetWidth(1)
  lines[4]:SetPoint("TOPRIGHT", region); lines[4]:SetPoint("BOTTOMRIGHT", region); lines[4]:SetWidth(1)
  return lines
end

function S.Trim(f, alpha, layer)
  if not f.trim then f.trim = Trim(f, alpha, layer) end
  return f.trim
end

-- Turns a framed window's backdrop and inset into wood. Safe to call on any
-- frame; parts it doesn't find are skipped.
function S.WoodWindow(f)
  if f.woodDone then return end
  f.woodDone = true
  S.Wood(f, f.Bg or f.bg or nil)
  local inset = f.Inset
  if inset then
    local bg = inset.Bg or inset.bg
    local t = inset:CreateTexture(nil, "BACKGROUND", nil, -5)
    if bg then
      t:SetAllPoints(bg)
      bg:Hide()
    else
      t:SetPoint("TOPLEFT", 2, -2)
      t:SetPoint("BOTTOMRIGHT", -2, 2)
    end
    S.PaintWood(t, "inset")
    inset.wood = t
    S.Trim(inset, 0.6, "BACKGROUND")
  end
end

------------------------------------------------------------------------
-- Window
------------------------------------------------------------------------

-- Closes a frame on Escape out of combat without inserting into UISpecialFrames
-- (UISpecialFrames taints CloseSpecialWindows / FrameControlsManager in Gamepad Mode).
local function AttachCloseOnEscape(f)
  if type(f) ~= "table" or type(f.EnableKeyboard) ~= "function" then return end
  local function inCombat() return InCombatLockdown and InCombatLockdown() == true end
  local function syncKeys()
    if inCombat() then
      pcall(f.EnableKeyboard, f, false)
    elseif f:IsShown() then
      pcall(f.EnableKeyboard, f, true)
      if type(f.SetPropagateKeyboardInput) == "function" then
        pcall(f.SetPropagateKeyboardInput, f, true)
      end
    end
  end
  f:HookScript("OnShow", syncKeys)
  f:HookScript("OnHide", function()
    if not inCombat() then pcall(f.EnableKeyboard, f, false) end
  end)
  f:HookScript("OnKeyDown", function(self, key)
    if inCombat() then return end
    if key == "ESCAPE" then
      if GetCurrentKeyBoardFocus and GetCurrentKeyBoardFocus() then
        if type(self.SetPropagateKeyboardInput) == "function" then
          pcall(self.SetPropagateKeyboardInput, self, true)
        end
        return
      end
      if type(self.SetPropagateKeyboardInput) == "function" then
        pcall(self.SetPropagateKeyboardInput, self, false)
      end
      Sound("IG_MAINMENU_CLOSE")
      self:Hide()
    elseif type(self.SetPropagateKeyboardInput) == "function" then
      pcall(self.SetPropagateKeyboardInput, self, true)
    end
  end)
  local watcher = CreateFrame("Frame", nil, f)
  pcall(watcher.RegisterEvent, watcher, "PLAYER_REGEN_DISABLED")
  pcall(watcher.RegisterEvent, watcher, "PLAYER_REGEN_ENABLED")
  watcher:SetScript("OnEvent", syncKeys)
  syncKeys()
end
S.CloseOnEscape = AttachCloseOnEscape

-- o = { name, title, icon, width, height, strata }
-- Returns the frame with:
--   f.Inset   the dark content area (from 60 px down to the bottom bar)
--   f.attic   the strip right of the portrait, above the inset
--   f.footer  version and author, on the bottom bar at the left
function S.Window(o)
  local ok, f = pcall(CreateFrame, "Frame", o.name, UIParent, "ButtonFrameTemplate")
  if ok and f and f.Inset then
    if f.SetTitle then f:SetTitle(o.title) end
    if f.SetPortraitToAsset then pcall(f.SetPortraitToAsset, f, o.icon) end
  else
    -- Older game versions: the plain framed window.
    f = CreateFrame("Frame", o.name, UIParent, "BasicFrameTemplateWithInset")
    local t = S.Label(f, o.title, "GameFontNormal")
    t:SetPoint("TOP", 0, -5)
    f.Inset = CreateFrame("Frame", nil, f)
    f.Inset:SetPoint("TOPLEFT", 8, -60)
    f.Inset:SetPoint("BOTTOMRIGHT", -8, 28)
  end
  S.WoodWindow(f)
  f:SetSize(o.width, o.height)
  f:SetPoint("CENTER")
  f:SetFrameStrata(o.strata or "DIALOG")
  f:SetToplevel(true)
  f:SetClampedToScreen(true)
  f:SetMovable(true)
  f:EnableMouse(true)
  f:RegisterForDrag("LeftButton")
  f:SetScript("OnDragStart", f.StartMoving)
  f:SetScript("OnDragStop", f.StopMovingOrSizing)
  f:Hide()
  -- Call f:Hide() directly instead of Blizzard's HideParentPanel/HideUIPanel or UISpecialFrames,
  -- which register the frame with FrameControlsManager and trigger SetPreferredGamepadInteractTarget taint.
  local closeBtn = f.CloseButton or (o.name and _G[o.name .. "CloseButton"])
  if closeBtn then
    closeBtn:SetScript("OnClick", function()
      Sound("IG_MAINMENU_CLOSE")
      f:Hide()
    end)
  end
  AttachCloseOnEscape(f)

  f.attic = CreateFrame("Frame", nil, f)
  f.attic:SetPoint("TOPLEFT", 62, -24)
  f.attic:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -10, -58)

  f.footer = S.Label(f, "Version " .. S.Version() .. "  \194\183  by SlimyTaco", "GameFontDisableSmall")
  f.footer:SetPoint("BOTTOMLEFT", 14, 8)
  return f
end

-- Gold heading on a dark bar with a thin gold-brown edge, like the game's
-- Skills window. The bar runs to the end of h.rule, so setting the rule's
-- width (as before) still sets how long the bar is.
function S.Header(parent, text, x, y, width)
  local h = S.Label(parent, text, "GameFontNormal")
  h:SetPoint("TOPLEFT", x, y)
  local rule = parent:CreateTexture(nil, "ARTWORK")
  rule:SetHeight(1)
  rule:SetPoint("LEFT", h, "RIGHT", 8, 0)
  rule:SetWidth(math.max(12, (width or 200) - h:GetStringWidth() - 8))
  rule:SetColorTexture(1, 1, 1, 1)
  if CreateColor and rule.SetGradient then
    rule:SetGradient("HORIZONTAL", CreateColor(S.GOLD[1], S.GOLD[2], S.GOLD[3], 0.55),
      CreateColor(S.GOLD[1], S.GOLD[2], S.GOLD[3], 0))
  else
    rule:SetVertexColor(S.GOLD[1], S.GOLD[2], S.GOLD[3], 0.3)
  end
  rule:SetAlpha(0) -- kept only to measure the bar
  h.rule = rule

  -- Drawn on the parent itself, under the heading's words.
  local fill = parent:CreateTexture(nil, "BACKGROUND", nil, 3)
  fill:SetPoint("TOPLEFT", h, "TOPLEFT", -6, 4)
  fill:SetPoint("BOTTOMRIGHT", rule, "RIGHT", 0, -math.floor((h:GetStringHeight() or 12) / 2 + 0.5) - 4)
  fill:SetColorTexture(1, 1, 1, 1)
  if CreateColor and fill.SetGradient then
    fill:SetGradient("VERTICAL", CreateColor(S.BAR[1] * 0.7, S.BAR[2] * 0.7, S.BAR[3] * 0.7, 0.9),
      CreateColor(S.BAR[1], S.BAR[2], S.BAR[3], 0.9))
  else
    fill:SetVertexColor(S.BAR[1], S.BAR[2], S.BAR[3], 0.9)
  end
  h.bar = fill
  h.barTrim = Trim(parent, 0.75, "BORDER", fill)
  -- The bar is drawn on the parent, so it hides and shows with the words.
  local parts = { fill, unpack(h.barTrim) }
  local function Follow(on)
    for i = 1, #parts do parts[i]:SetShown(on) end
  end
  local hide, show, setShown = h.Hide, h.Show, h.SetShown
  function h:Hide() hide(self); Follow(false) end
  function h:Show() show(self); Follow(true) end
  function h:SetShown(on) setShown(self, on); Follow(on and true or false) end
  return h
end

-- Thin vertical divider between two columns.
function S.Divider(parent, x, top, height)
  local d = parent:CreateTexture(nil, "ARTWORK")
  d:SetColorTexture(S.EDGE[1], S.EDGE[2], S.EDGE[3], 0.35)
  d:SetPoint("TOPLEFT", x, top)
  d:SetSize(1, height)
  return d
end

------------------------------------------------------------------------
-- Controls
------------------------------------------------------------------------

function S.Button(parent, text, width, tipTitle, tip)
  local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  b:SetSize(width or 110, 22)
  b:SetText(text)
  Tip(b, tipTitle, tip)
  return b
end

-- A tick with its label, an optional line of help under it, and a tooltip.
-- c.height tells a stack how much room it takes.
function S.Check(parent, text, help, onClick, tip)
  local c = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  c:SetSize(24, 24)
  if c.Text then c.Text:SetText("") end
  local fs = S.Label(c, text)
  fs:SetPoint("LEFT", c, "RIGHT", 3, 1)
  c.label = fs
  c:SetHitRectInsets(0, -(fs:GetStringWidth() + 6), 0, 0) -- the words are clickable too
  c.height = 26
  if help then
    c.help = S.Help(c, help)
    c.help:SetPoint("TOPLEFT", fs, "BOTTOMLEFT", 0, -2)
    c.height = 40
  end
  Tip(c, tip and text, tip)
  c:SetScript("OnClick", function(self)
    local on = self:GetChecked() and true or false
    Sound(on and "IG_MAINMENU_OPTION_CHECKBOX_ON" or "IG_MAINMENU_OPTION_CHECKBOX_OFF")
    onClick(on)
  end)
  return c
end

-- Puts the shown controls one under the other with no gaps for hidden ones.
-- Returns the y under the last one.
function S.Stack(list, x, y)
  for _, c in ipairs(list) do
    if c:IsShown() then
      c:ClearAllPoints()
      c:SetPoint("TOPLEFT", x, y)
      y = y - (c.height or 26)
    end
  end
  return y
end

-- The game's slider, with the setting's name on the left above it, the
-- current value in gold on the right, and the ends under it.
-- format(v) -> text of the value; onValue(v) when the player moves it.
-- s:Sync(v) shows a value without calling onValue.
function S.Slider(parent, text, width, minV, maxV, step, format, onValue)
  local ok, s = pcall(CreateFrame, "Slider", nil, parent, "UISliderTemplate")
  if not ok or not s then
    s = CreateFrame("Slider", nil, parent)
    s:SetOrientation("HORIZONTAL")
    s:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    local track = s:CreateTexture(nil, "BACKGROUND")
    track:SetColorTexture(0.25, 0.2, 0.1, 1)
    track:SetPoint("LEFT")
    track:SetPoint("RIGHT")
    track:SetHeight(6)
  end
  s:SetSize(width, 17)
  s:SetMinMaxValues(minV, maxV)
  s:SetValueStep(step)
  if s.SetObeyStepOnDrag then s:SetObeyStepOnDrag(true) end
  s.height = 52

  s.title = S.Label(s, text)
  s.title:SetPoint("BOTTOMLEFT", s, "TOPLEFT", 2, 5)
  s.value = S.Label(s, "", "GameFontNormal")
  s.value:SetJustifyH("RIGHT")
  s.value:SetPoint("BOTTOMRIGHT", s, "TOPRIGHT", -2, 5)
  s.low = S.Help(s, format(minV))
  s.low:SetPoint("TOPLEFT", s, "BOTTOMLEFT", 2, -1)
  s.high = S.Help(s, format(maxV))
  s.high:SetJustifyH("RIGHT")
  s.high:SetPoint("TOPRIGHT", s, "BOTTOMRIGHT", -2, -1)

  local function Round(v) return math.floor((v - minV) / step + 0.5) * step + minV end
  s:SetScript("OnValueChanged", function(self, v)
    v = Round(v)
    self.value:SetText(format(v))
    if not self.syncing then onValue(v) end
  end)
  function s:Sync(v)
    self.syncing = true
    self:SetValue(v)
    self.syncing = false
    self.value:SetText(format(Round(v)))
  end
  return s
end

-- Text box with a hint shown while it's empty. Enter calls onEnter(text).
function S.Input(parent, width, hint, onEnter)
  local e = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
  e:SetSize(width, 20)
  e:SetAutoFocus(false)
  e:SetMaxLetters(60)
  local placeholder = S.Help(e, hint)
  placeholder:SetPoint("LEFT", 2, 0)
  local function UpdateHint() placeholder:SetShown(e:GetText() == "" and not e:HasFocus()) end
  e:SetScript("OnEditFocusGained", UpdateHint)
  e:SetScript("OnEditFocusLost", UpdateHint)
  e:SetScript("OnTextChanged", UpdateHint)
  e:SetScript("OnEscapePressed", e.ClearFocus)
  e:SetScript("OnEnterPressed", function(self)
    local text = self:GetText()
    if text ~= "" then onEnter(text) end
    self:SetText("")
  end)
  e.Submit = function() e:GetScript("OnEnterPressed")(e) end
  return e
end

------------------------------------------------------------------------
-- Boxes and plates
------------------------------------------------------------------------

local BOX = {
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 12,
  insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

-- A dark well with a thin brass edge, for lists and logs.
function S.Box(parent)
  local ok, box = pcall(CreateFrame, "Frame", nil, parent, "BackdropTemplate")
  if not ok or not box then box = CreateFrame("Frame", nil, parent) end
  if box.SetBackdrop then
    box:SetBackdrop(BOX)
    box:SetBackdropColor(0.05, 0.035, 0.025, 0.72)
    box:SetBackdropBorderColor(S.EDGE[1], S.EDGE[2], S.EDGE[3], 0.8)
  else
    local bg = box:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.05, 0.035, 0.025, 0.72)
  end
  return box
end

local PLATE = {
  bgFile = WHITE,
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
  edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

-- Dark wood with a gold edge, for small panels that float on screen.
function S.Plate(f)
  if f.SetBackdrop then
    f:SetBackdrop(PLATE)
    f:SetBackdropColor(0.06, 0.045, 0.03, 0.95)
  end
  if not f.wood then
    local t = f:CreateTexture(nil, "BACKGROUND", nil, -7)
    t:SetPoint("TOPLEFT", 4, -4)
    t:SetPoint("BOTTOMRIGHT", -4, 4)
    S.PaintWood(t, "pane")
    f.wood = t
  end
end

------------------------------------------------------------------------
-- Tabs under a window
------------------------------------------------------------------------

-- labels = { "Hidden Messages", "Settings" }; onSelect(index).
-- S.SelectTab(frame, index) marks one as chosen.
function S.Tabs(frame, labels, onSelect)
  frame.skinTabs = {}
  local real = PanelTemplates_SetNumTabs and PanelTemplates_SetTab and frame:GetName()
  for i, text in ipairs(labels) do
    local tab
    if real then
      local ok, t = pcall(CreateFrame, "Button", frame:GetName() .. "Tab" .. i, frame, "PanelTabButtonTemplate")
      if ok and t then tab = t else real = false end
    end
    if not tab then
      tab = S.Button(frame, text, 130)
      if i > 1 then tab:SetPoint("LEFT", frame.skinTabs[i - 1], "RIGHT", 4, 0) end
    end
    tab:SetID(i)
    tab:SetText(text)
    tab:SetScript("OnClick", function()
      Sound("IG_CHARACTER_INFO_TAB")
      onSelect(i)
    end)
    if i == 1 then tab:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 12, 2) end
    frame.skinTabs[i] = tab
  end
  frame.realTabs = real and true or false
  if frame.realTabs then
    frame.Tabs = frame.Tabs or frame.skinTabs
    PanelTemplates_SetNumTabs(frame, #labels)
  end
end

function S.SelectTab(frame, index)
  if frame.realTabs then
    PanelTemplates_SetTab(frame, index)
  else
    for i, tab in ipairs(frame.skinTabs) do
      if i == index then tab:LockHighlight() else tab:UnlockHighlight() end
    end
  end
end

------------------------------------------------------------------------
-- Tooltip for a button: the addon's name and version, then one line per
-- mouse action, keys on the left and what they do on the right.
-- lines = { { "Left-click", "Settings" }, ... }
------------------------------------------------------------------------
function S.ClickTip(owner, title, lines, anchor)
  GameTooltip:SetOwner(owner, anchor or "ANCHOR_LEFT")
  GameTooltip:AddDoubleLine(title, S.Version(), S.GOLD[1], S.GOLD[2], S.GOLD[3], 0.5, 0.5, 0.5)
  for _, l in ipairs(lines) do
    GameTooltip:AddDoubleLine(l[1], l[2], S.HELP[1], S.HELP[2], S.HELP[3], 1, 1, 1)
  end
  GameTooltip:Show()
end
