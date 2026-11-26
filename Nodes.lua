local _, ns = ...

-- Every herb and ore node the addon knows by name. The item is what the node
-- gives you; its icon is the one drawn on the minimap. exp is the expansion
-- the node comes from (0 Classic, 1 Burning Crusade, 2 Wrath), so the
-- settings only list nodes that exist in the game version you're playing.
-- Newer expansions (Retail) are listed by the name of what they give: in the
-- world they come as "Rich ...", "Lush ...", "... Deposit" and so on, and all
-- of those count as the one name. Their icon is learned from your first loot.
-- Nodes not listed at all (WoW Forever additions) are learned the first time
-- you gather them.

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
  { "Floating Wreckage", 0 }, { "Floating Debris", 0 }, { "Oil Spill", 0 },
  { "Schooner Wreckage", 0 }, { "Waterlogged Wreckage", 0 }, { "Bloodsail Wreckage", 0 },
  { "Muddy Churning Waters", 0 }, { "School of Deviate Fish", 6522 },
  { "Oily Blackmouth School", 6358 }, { "Firefin Snapper School", 6359 },
  { "Sagefish School", 21071 }, { "Greater Sagefish School", 21153 },
  { "Stonescale Eel Swarm", 13422 }, { "School of Tastyfish", 19807 },
}

-- Chests show on the minimap with Find Treasure (Dwarves) and can be learned
-- by opening them.
local TREASURE = {
  { "Battered Chest", 0 }, { "Tattered Chest", 0 }, { "Solid Chest", 0 },
  { "Large Battered Chest", 0 }, { "Large Solid Chest", 0 }, { "Large Iron Bound Chest", 0 },
  { "Large Mithril Bound Chest", 0 }, { "Mithril Bound Chest", 0 },
}

-- Herbalism or Mining skill needed to gather each node.
local SKILL = {
  ["Peacebloom"] = 1, ["Silverleaf"] = 1, ["Earthroot"] = 15, ["Mageroyal"] = 50,
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

-- Item 0: the icon comes from what the node gave you the first time.
ns.MODERN = {}
for category, list in pairs({ herb = MODERN_HERBS, ore = MODERN_ORES }) do
  for _, entry in ipairs(list) do
    ns.NODES[entry[1]] = { category = category, item = 0, exp = entry[2] }
    table.insert(ns.NODE_LIST[category], entry[1])
    ns.MODERN[#ns.MODERN + 1] = entry[1]
  end
end
