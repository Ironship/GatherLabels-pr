local _, ns = ...

-- Every herb and ore node the addon knows by name. The item is what the node
-- gives you; its icon is the one drawn on the minimap. exp is the expansion
-- the node comes from (0 Classic, 1 Burning Crusade, 2 Wrath), so the
-- settings only list nodes that exist in the game version you're playing.
-- Newer expansions (Retail) are listed by the name of what they give: in the
-- world they come as "Rich ...", "Lush ...", "... Deposit" and so on, and all
-- of those count as the one name. Their icon is learned from your first loot.
-- Nodes not listed at all are learned the first time you gather them;
-- WoW Forever additions below are gated by ns.IS_FOREVER.

local function IsForeverClient()
  if not GetBuildInfo then return false end
  local ok, version, _, _, toc = pcall(GetBuildInfo)
  if not ok then return false end
  if type(toc) == "number" and toc >= 16000 and toc < 17000 then return true end
  if type(version) == "string" then
    local major, minor = version:match("^(%d+)%.(%d+)")
    if tonumber(major) == 1 and (tonumber(minor) or 0) >= 60 then return true end
  end
  return false
end
ns.IS_FOREVER = IsForeverClient()

ns.CATEGORIES = {
  { key = "herb", label = "Herbs", fallbackIcon = "Interface\\Icons\\INV_Misc_Flower_02" },
  { key = "ore", label = "Ore", fallbackIcon = "Interface\\Icons\\INV_Ore_Copper_01" },
  { key = "fish", label = "Fishing", fallbackIcon = "Interface\\Icons\\INV_Misc_Fish_02" },
  { key = "treasure", label = "Treasure", fallbackIcon = "Interface\\Icons\\INV_Box_02" },
}

local HERBS = {
  { "Peacebloom", 2447 }, { "Silverleaf", 765 }, { "Earthroot", 2449 },
  { "Mageroyal", 785 }, { "Briarthorn", 2450 }, { "Stranglekelp", 3820 },
  { "Bruiseweed", 2453 }, { "Wild Steelbloom", 3355 }, { "Grave Moss", 3369 },
  { "Kingsblood", 3356 }, { "Liferoot", 3357 }, { "Fadeleaf", 3818 },
  { "Goldthorn", 3821 }, { "Khadgar's Whisker", 3358 }, { "Wintersbite", 3819 },
  { "Firebloom", 4625 }, { "Purple Lotus", 8831 }, { "Arthas' Tears", 8836 },
  { "Sungrass", 8838 }, { "Blindweed", 8839 }, { "Ghost Mushroom", 8845 },
  { "Gromsblood", 8846 }, { "Golden Sansam", 13464 }, { "Dreamfoil", 13463 },
  { "Mountain Silversage", 13465 }, { "Plaguebloom", 13466 }, { "Icecap", 13467 },
  { "Black Lotus", 13468 },
  { "Felweed", 22785, 1 }, { "Dreaming Glory", 22786, 1 }, { "Ragveil", 22787, 1 },
  { "Flame Cap", 22788, 1 }, { "Terocone", 22789, 1 }, { "Ancient Lichen", 22790, 1 },
  { "Netherbloom", 22791, 1 }, { "Nightmare Vine", 22792, 1 }, { "Mana Thistle", 22793, 1 },
  { "Fel Lotus", 22794, 1 },
  { "Goldclover", 36901, 2 }, { "Adder's Tongue", 36903, 2 }, { "Tiger Lily", 36904, 2 },
  { "Lichbloom", 36905, 2 }, { "Icethorn", 36906, 2 }, { "Talandra's Rose", 36907, 2 },
  { "Frost Lotus", 36908, 2 },
}

local ORES = {
  { "Copper Vein", 2770 }, { "Tin Vein", 2771 }, { "Silver Vein", 2775 },
  { "Iron Deposit", 2772 }, { "Gold Vein", 2776 }, { "Mithril Deposit", 3858 },
  { "Truesilver Deposit", 7911 }, { "Small Thorium Vein", 10620 },
  { "Rich Thorium Vein", 10620 }, { "Dark Iron Deposit", 11370 },
  { "Incendicite Mineral Vein", 3340 }, { "Lesser Bloodstone Deposit", 4278 },
  { "Indurium Mineral Vein", 5833 }, { "Hakkari Thorium Vein", 10620 },
  { "Ooze Covered Silver Vein", 2775 }, { "Ooze Covered Gold Vein", 2776 },
  { "Ooze Covered Mithril Deposit", 3858 }, { "Ooze Covered Truesilver Deposit", 7911 },
  { "Ooze Covered Thorium Vein", 10620 }, { "Ooze Covered Rich Thorium Vein", 10620 },
  { "Small Obsidian Chunk", 11370 }, { "Large Obsidian Chunk", 11370 },
  { "Fel Iron Deposit", 23424, 1 }, { "Adamantite Deposit", 23425, 1 },
  { "Rich Adamantite Deposit", 23425, 1 }, { "Khorium Vein", 23426, 1 },
  { "Nethercite Deposit", 32464, 1 },
  { "Cobalt Deposit", 36909, 2 }, { "Rich Cobalt Deposit", 36909, 2 },
  { "Saronite Deposit", 36912, 2 }, { "Rich Saronite Deposit", 36912, 2 },
  { "Pure Saronite Deposit", 36912, 2 }, { "Titanium Vein", 36910, 2 },
}

-- Fishing pools show on the minimap with Find Fish; the item is the fish they
-- give (0 = no single fish, the category's icon is used).
local FISH = {
  -- Classic (0)
  { "Floating Wreckage", 0 }, { "Floating Debris", 0 }, { "Oil Spill", 0 },
  { "Schooner Wreckage", 0 }, { "Waterlogged Wreckage", 0 }, { "Bloodsail Wreckage", 0 },
  { "Muddy Churning Waters", 0 }, { "Muddy Churning Water", 0 },
  { "Patch of Elemental Water", 7070 }, { "School of Deviate Fish", 6522 },
  { "Oily Blackmouth School", 6358 }, { "Firefin Snapper School", 6359 },
  { "Sagefish School", 21071 }, { "Greater Sagefish School", 21153 },
  { "Stonescale Eel Swarm", 13422 }, { "School of Tastyfish", 19807 },
  -- Burning Crusade (1)
  { "Highland Mixed School", 0, 1 }, { "Brackish Mixed School", 0, 1 },
  { "Pure Water", 22578, 1 }, { "Steam Pump Flotsam", 0, 1 },
  { "Bluefish School", 27437, 1 }, { "Feltail School", 27425, 1 },
  { "Mudfish School", 27435, 1 }, { "School of Darter", 27438, 1 },
  { "Sporefish School", 27429, 1 },
  -- Wrath of the Lich King (2)
  { "Borean Man O' War School", 41805, 2 }, { "Deep Sea Monsterbelly School", 41800, 2 },
  { "Dragonfin Angelfish School", 41807, 2 }, { "Fangtooth Herring School", 41810, 2 },
  { "Glacial Salmon School", 41809, 2 }, { "Glassfin Minnow School", 41814, 2 },
  { "Imperial Manta Ray School", 41802, 2 }, { "Moonglow Cuttlefish School", 41801, 2 },
  { "Musselback Sculpin School", 41806, 2 }, { "Nettlefish School", 41813, 2 },
  { "Mixed Ocean School", 0, 2 }, { "Strange Pool", 0, 2 },
  -- Cataclysm (3)
  { "Albino Cavefish School", 53065, 3 }, { "Algaefin Rockfish School", 53071, 3 },
  { "Blackbelly Mudfish School", 53066, 3 }, { "Deepsea Sagefish School", 53072, 3 },
  { "Fathom Eel Swarm", 53070, 3 }, { "Highland Guppy School", 53064, 3 },
  { "Mountain Trout School", 53063, 3 }, { "Pool of Fire", 52325, 3 },
  { "Shipwreck Debris", 0, 3 },
  -- Mists of Pandaria (4)
  { "Emperor Salmon School", 74859, 4 }, { "Giant Mantis Shrimp Swarm", 74857, 4 },
  { "Golden Carp School", 74866, 4 }, { "Jade Lungfish School", 74856, 4 },
  { "Jewel Danio School", 74863, 4 }, { "Krasarang Paddlefish School", 74865, 4 },
  { "Redbelly Mandarin School", 74860, 4 }, { "Reef Octopus Swarm", 74864, 4 },
  { "Spinefish School", 83064, 4 }, { "Tiger Gourami School", 74861, 4 },
  { "Floating Shipwreck Debris", 0, 4 },
  -- Warlords of Draenor (5)
  { "Abyssal Gulper School", 111664, 5 }, { "Oily Abyssal Gulper School", 111664, 5 },
  { "Blackwater Whiptail School", 111663, 5 }, { "Blind Lake Sturgeon School", 111667, 5 },
  { "Fat Sleeper School", 111668, 5 }, { "Fire Ammonite School", 111666, 5 },
  { "Jawless Skulker School", 111669, 5 }, { "Sea Scorpion School", 111665, 5 },
  { "Oily Sea Scorpion School", 111665, 5 }, { "Savage Piranha Pool", 118565, 5 },
  { "Felmouth Frenzy School", 127991, 5 },
  -- Legion (6)
  { "Black Barracuda School", 124112, 6 }, { "Cursed Queenfish School", 124107, 6 },
  { "Runescale Koi School", 124111, 6 }, { "Fever of Stormrays", 124110, 6 },
  { "Highmountain Salmon School", 124109, 6 }, { "Mossgill Perch School", 124108, 6 },
  -- Battle for Azeroth (7)
  { "Frenzied Fangtooth School", 152545, 7 }, { "Great Sea Catfish School", 152547, 7 },
  { "Lane Snapper School", 152546, 7 }, { "Rasboralus School", 0, 7 },
  { "Redtail Loach School", 152549, 7 }, { "Sand Shifter School", 152543, 7 },
  { "Slimy Mackerel School", 152544, 7 }, { "Tiragarde Perch School", 152548, 7 },
  { "U'taka School", 0, 7 }, { "Mauve Stinger School", 168646, 7 },
  { "Viper Fish School", 168302, 7 }, { "Ionized Minnows", 167562, 7 },
  { "Sentry Fish School", 0, 7 },
  -- Shadowlands (8)
  { "Iridescent Amberjack School", 173033, 8 }, { "Pocked Bonefish School", 173035, 8 },
  { "Silvergill Pike School", 173034, 8 }, { "Elysian Thade School", 173037, 8 },
  { "Lost Sole School", 173032, 8 }, { "Spinefin Piranha School", 173036, 8 },
  { "Precursor Placoderm School", 187702, 8 },
  -- Dragonflight (9)
  { "Islefin Dorado Pool", 194970, 9 }, { "Shimmering Treasure Pool", 0, 9 },
  { "Temporal Dragonhead Pool", 194969, 9 }, { "Thousandbite Piranha Swarm", 194966, 9 },
  { "Aileron Seamoth School", 194967, 9 }, { "Cerulean Spinefish School", 194968, 9 },
  { "Rimefin Tuna Pool", 199345, 9 }, { "Magma Thresher Pool", 199344, 9 },
  { "Prismatic Leaper School", 200061, 9 },
  -- The War Within (10)
  { "Calm Surfacing Ripple", 0, 10 }, { "River Bass Pool", 0, 10 },
  { "Glimmerpool", 0, 10 }, { "Bloody Perch Swarm", 0, 10 },
  { "Swarm of Slum Sharks", 0, 10 }, { "Blood in the Water", 0, 10 },
  { "Festering Rotpool", 0, 10 }, { "Infused Ichor Spill", 0, 10 },
  { "Stargazer Swarm", 0, 10 }, { "Anglerseeker Torrent", 0, 10 },
  { "Royal Ripple", 0, 10 }, { "Shore Treasure", 0, 10 },
  { "Floating Deep Treasure", 0, 10 },
  -- Midnight (11)
  { "Bloom Swarm", 0, 11 }, { "Blossoming Torrent", 0, 11 },
  { "Bubbling Bloom", 0, 11 }, { "Hunter Surge", 0, 11 },
  { "Lashing Waves", 0, 11 }, { "Obscured School", 0, 11 },
  { "Salmon Pool", 0, 11 }, { "Song Swarm", 0, 11 },
  { "Sunbath School", 0, 11 }, { "Sunwell Swarm", 0, 11 },
  { "Surface Ripple", 0, 11 }, { "Careless Cargo", 0, 11 },
  { "Lost Treasures", 0, 11 }, { "Viscous Void", 0, 11 },
  { "Abyssal Swirl", 0, 11 }, { "Blighted Venom Pool", 0, 11 },
  { "Bubbling Beryl", 0, 11 }, { "Cursed Oddity", 0, 11 },
  { "Grisly Cod Pool", 0, 11 }, { "Torrential Gorgerswarm", 0, 11 },
  { "Vile Venom", 0, 11 }, { "Viscous Venom", 0, 11 },
  { "Willow Sea", 0, 11 },
}

-- Chests show on the minimap with Find Treasure (Dwarves) and can be learned
-- by opening them.
local TREASURE = {
  { "Battered Chest", 0 }, { "Tattered Chest", 0 }, { "Solid Chest", 0 },
  { "Large Battered Chest", 0 }, { "Large Solid Chest", 0 }, { "Large Iron Bound Chest", 0 },
  { "Large Mithril Bound Chest", 0 }, { "Mithril Bound Chest", 0 },
  { "Dented Chest", 0 }, { "Alliance Strongbox", 0 },
  { "Practice Lockbox", 0 }, { "Buccaneer's Strongbox", 0 },
  { "Battered Footlocker", 0 }, { "Waterlogged Footlocker", 0 },
  { "Dented Footlocker", 0 }, { "Mossy Footlocker", 0 },
  { "Scarlet Footlocker", 0 }, { "Un'Goro Dirt Pile", 0 }, { "Giant Clam", 0 },
}

-- WoW Forever custom nodes (registered only when running on a Forever client).
local FOREVER_HERBS = {
  { "Stunted Silverleaf", 765 }, { "Wilted Peacebloom", 2447 }, { "Nightmare Moss", 3369 },
  { "Dreamroot", 2449 }, { "Moonroot", 13463 }, { "Star Lotus", 13468 },
  { "Hyjal Silphium", 2447 }, { "Tomb Weed", 3369 }, { "Demonsage", 13465 },
}
local FOREVER_ORES = {
  { "Weak Copper Vein", 2770 }, { "Poor Copper Vein", 2770 },
  { "Chunk of Amber", 2770 }, { "Large Chunk of Amber", 2770 },
  { "Cold Iron Deposit", 2772 }, { "Fool's Gold Vein", 2776 },
  { "Starsilver Vein", 7911 }, { "Greater Moonstone Formation", 2775 },
  { "Heavy Thorium Vein", 10620 },
}

-- Herbalism or Mining skill needed to gather each node.
local SKILL = {
  ["Peacebloom"] = 1, ["Silverleaf"] = 1, ["Earthroot"] = 15, ["Mageroyal"] = 50,
  ["Stunted Silverleaf"] = 1, ["Wilted Peacebloom"] = 1, ["Nightmare Moss"] = 125,
  ["Dreamroot"] = 205, ["Moonroot"] = 250, ["Star Lotus"] = 250,
  ["Hyjal Silphium"] = 1, ["Tomb Weed"] = 1, ["Demonsage"] = 300,
  ["Briarthorn"] = 70, ["Stranglekelp"] = 85, ["Bruiseweed"] = 100, ["Wild Steelbloom"] = 115,
  ["Grave Moss"] = 120, ["Kingsblood"] = 125, ["Liferoot"] = 150, ["Fadeleaf"] = 160,
  ["Goldthorn"] = 170, ["Khadgar's Whisker"] = 185, ["Wintersbite"] = 195, ["Firebloom"] = 205,
  ["Purple Lotus"] = 210, ["Arthas' Tears"] = 220, ["Sungrass"] = 230, ["Blindweed"] = 235,
  ["Ghost Mushroom"] = 245, ["Gromsblood"] = 250, ["Golden Sansam"] = 260, ["Dreamfoil"] = 270,
  ["Mountain Silversage"] = 280, ["Plaguebloom"] = 285, ["Icecap"] = 290, ["Black Lotus"] = 300,
  ["Felweed"] = 300, ["Dreaming Glory"] = 315, ["Ragveil"] = 325, ["Terocone"] = 325,
  ["Flame Cap"] = 335, ["Ancient Lichen"] = 340, ["Netherbloom"] = 350, ["Nightmare Vine"] = 365,
  ["Mana Thistle"] = 375,
  ["Goldclover"] = 350, ["Tiger Lily"] = 375, ["Talandra's Rose"] = 385, ["Adder's Tongue"] = 400,
  ["Lichbloom"] = 425, ["Icethorn"] = 435, ["Frost Lotus"] = 450,

  ["Copper Vein"] = 1, ["Tin Vein"] = 65, ["Incendicite Mineral Vein"] = 65, ["Silver Vein"] = 75,
  ["Weak Copper Vein"] = 1, ["Poor Copper Vein"] = 1, ["Chunk of Amber"] = 1, ["Large Chunk of Amber"] = 1,
  ["Cold Iron Deposit"] = 125, ["Fool's Gold Vein"] = 175, ["Starsilver Vein"] = 245,
  ["Greater Moonstone Formation"] = 245, ["Heavy Thorium Vein"] = 300,
  ["Small Obsidian Chunk"] = 305, ["Large Obsidian Chunk"] = 305,
  ["Ooze Covered Silver Vein"] = 75, ["Lesser Bloodstone Deposit"] = 75, ["Iron Deposit"] = 125,
  ["Indurium Mineral Vein"] = 150, ["Gold Vein"] = 155, ["Ooze Covered Gold Vein"] = 155,
  ["Mithril Deposit"] = 175, ["Ooze Covered Mithril Deposit"] = 175, ["Truesilver Deposit"] = 230,
  ["Ooze Covered Truesilver Deposit"] = 230, ["Dark Iron Deposit"] = 230, ["Small Thorium Vein"] = 245,
  ["Ooze Covered Thorium Vein"] = 245, ["Hakkari Thorium Vein"] = 250, ["Rich Thorium Vein"] = 275,
  ["Ooze Covered Rich Thorium Vein"] = 275,
  ["Fel Iron Deposit"] = 300, ["Nethercite Deposit"] = 275, ["Adamantite Deposit"] = 325,
  ["Rich Adamantite Deposit"] = 350, ["Khorium Vein"] = 375,
  ["Cobalt Deposit"] = 350, ["Rich Cobalt Deposit"] = 375, ["Saronite Deposit"] = 400,
  ["Rich Saronite Deposit"] = 425, ["Titanium Vein"] = 450, ["Pure Saronite Deposit"] = 450,
}

-- Retail expansions: { name, expansion }. 3 Cataclysm ... 11 Midnight.
local MODERN_HERBS = {
  { "Cinderbloom", 3 }, { "Stormvine", 3 }, { "Azshara's Veil", 3 }, { "Heartblossom", 3 },
  { "Whiptail", 3 }, { "Twilight Jasmine", 3 },
  { "Green Tea Leaf", 4 }, { "Silkweed", 4 }, { "Rain Poppy", 4 }, { "Snow Lily", 4 },
  { "Fool's Cap", 4 }, { "Golden Lotus", 4 },
  { "Frostweed", 5 }, { "Fireweed", 5 }, { "Gorgrond Flytrap", 5 }, { "Starflower", 5 },
  { "Nagrand Arrowbloom", 5 }, { "Talador Orchid", 5 },
  { "Aethril", 6 }, { "Dreamleaf", 6 }, { "Foxflower", 6 }, { "Fjarnskaggl", 6 }, { "Starlight Rose", 6 },
  { "Riverbud", 7 }, { "Star Moss", 7 }, { "Akunda's Bite", 7 }, { "Winter's Kiss", 7 },
  { "Siren's Pollen", 7 }, { "Sea Stalk", 7 }, { "Anchor Weed", 7 }, { "Zin'anthid", 7 },
  { "Death Blossom", 8 }, { "Rising Glory", 8 }, { "Marrowroot", 8 }, { "Widowbloom", 8 },
  { "Vigil's Torch", 8 }, { "Nightshade", 8 },
  { "Hochenblume", 9 }, { "Saxifrage", 9 }, { "Bubble Poppy", 9 }, { "Writhebark", 9 },
  { "Mycobloom", 10 }, { "Luredrop", 10 }, { "Orbinid", 10 }, { "Blessing Blossom", 10 }, { "Arathor's Spear", 10 },
  { "Tranquility Bloom", 11 }, { "Sanguithorn", 11 }, { "Azeroot", 11 }, { "Argentleaf", 11 }, { "Mana Lily", 11 },
}
local MODERN_ORES = {
  { "Obsidium", 3 }, { "Elementium", 3 }, { "Pyrite", 3 },
  { "Ghost Iron", 4 }, { "Kyparite", 4 }, { "Trillium", 4 },
  { "True Iron", 5 }, { "Blackrock", 5 },
  { "Leystone", 6 }, { "Felslate", 6 },
  { "Monelite", 7 }, { "Storm Silver", 7 }, { "Platinum", 7 }, { "Osmenite", 7 },
  { "Laestrite", 8 }, { "Elethium", 8 }, { "Solenium", 8 }, { "Oxxein", 8 }, { "Phaedrum", 8 }, { "Sinvyr", 8 },
  { "Serevite", 9 }, { "Draconium", 9 }, { "Khaz'gorite", 9 },
  { "Bismuth", 10 }, { "Aqirite", 10 }, { "Ironclaw", 10 },
  { "Refulgent Copper", 11 }, { "Umbral Tin", 11 }, { "Brilliant Silver", 11 },
}

-- ns.NODES[name] = { category, item, exp, skill }; ns.NODE_LIST[category] = names in game order.
ns.NODES, ns.NODE_LIST = {}, { herb = {}, ore = {}, fish = {}, treasure = {} }
for category, list in pairs({ herb = HERBS, ore = ORES, fish = FISH, treasure = TREASURE }) do
  for _, entry in ipairs(list) do
    ns.NODES[entry[1]] = { category = category, item = entry[2], exp = entry[3] or 0, skill = SKILL[entry[1]] }
    table.insert(ns.NODE_LIST[category], entry[1])
  end
end

if ns.IS_FOREVER then
  for category, list in pairs({ herb = FOREVER_HERBS, ore = FOREVER_ORES }) do
    for _, entry in ipairs(list) do
      ns.NODES[entry[1]] = { category = category, item = entry[2], exp = 0, skill = SKILL[entry[1]], forever = true }
      table.insert(ns.NODE_LIST[category], entry[1])
    end
  end
end

-- Item 0: the icon comes from what the node gave you the first time.
ns.MODERN = {}
for category, list in pairs({ herb = MODERN_HERBS, ore = MODERN_ORES }) do
  for _, entry in ipairs(list) do
    ns.NODES[entry[1]] = { category = category, item = 0, exp = entry[2] }
    table.insert(ns.NODE_LIST[category], entry[1])
    ns.MODERN[#ns.MODERN + 1] = entry[1]
  end
end
