local _, ns = ...

-- Per-zone herbs, ore, fishing pools and fish catches for WoW Forever.
-- Reference only (no spawn coordinates, no minimap pins).
ns.ZONE_DATA = {
  [1411] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot", "Mageroyal" },
    ores = { "Copper Vein" },
    fish = { { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Slitherskin Mackerel", 6303 } },
  },
  [1412] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot" },
    ores = { "Copper Vein" },
    fish = { { "Raw Brilliant Smallfish", 6291 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Mithril Head Trout", 8365 } },
  },
  [1413] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot", "Mageroyal", "Briarthorn", "Stranglekelp", "Bruiseweed", "Wild Steelbloom", "Grave Moss", "Kingsblood" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein" },
    pools = { "Floating Debris", "Oily Blackmouth School", "Sagefish School" },
    fish = { { "Deviate Fish", 6522 }, { "Firefin Snapper", 6359 }, { "Oily Blackmouth", 6358 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Rainbow Fin Albacore", 6361 }, { "Raw Rockscale Cod", 6362 }, { "Raw Slitherskin Mackerel", 6303 }, { "Raw Spotted Yellowtail", 4603 } },
  },
  [1416] = {
    herbs = { "Stranglekelp", "Bruiseweed", "Wild Steelbloom", "Grave Moss", "Kingsblood", "Liferoot", "Fadeleaf", "Goldthorn", "Khadgar's Whisker", "Wintersbite" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    pools = { "Floating Wreckage" },
    fish = { { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Greater Sagefish", 21153 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 } },
  },
  [1417] = {
    herbs = { "Stranglekelp", "Bruiseweed", "Wild Steelbloom", "Grave Moss", "Kingsblood", "Liferoot", "Fadeleaf", "Goldthorn", "Khadgar's Whisker" },
    ores = { "Tin Vein", "Lesser Bloodstone Deposit", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    pools = { "Floating Wreckage" },
    fish = { { "Firefin Snapper", 6359 }, { "Oily Blackmouth", 6358 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Rockscale Cod", 6362 }, { "Raw Spotted Yellowtail", 4603 } },
  },
  [1418] = {
    herbs = { "Wild Steelbloom", "Kingsblood", "Fadeleaf", "Goldthorn", "Khadgar's Whisker", "Firebloom", "Purple Lotus" },
    ores = { "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
  },
  [1419] = {
    herbs = { "Firebloom", "Sungrass", "Gromsblood" },
    ores = { "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein" },
    fish = { { "Deviate Fish", 6522 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1420] = {
    herbs = { "Peacebloom", "Silverleaf", "Tomb Weed", "Earthroot" },
    ores = { "Copper Vein" },
    fish = { { "Lightning Eel", 13757 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Rockscale Cod", 6362 }, { "Raw Slitherskin Mackerel", 6303 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1421] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot", "Mageroyal", "Briarthorn", "Stranglekelp", "Bruiseweed", "Liferoot" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein" },
    pools = { "Floating Debris", "Oily Blackmouth School", "Sagefish School" },
    fish = { { "Deviate Fish", 6522 }, { "Oily Blackmouth", 6358 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Rainbow Fin Albacore", 6361 }, { "Raw Sagefish", 21071 }, { "Raw Slitherskin Mackerel", 6303 } },
  },
  [1422] = {
    herbs = { "Arthas' Tears", "Sungrass", "Dreamfoil", "Mountain Silversage", "Plaguebloom" },
    ores = { "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein", "Rich Thorium Vein" },
    fish = { { "Deviate Fish", 6522 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1423] = {
    herbs = { "Grave Moss", "Arthas' Tears", "Sungrass", "Golden Sansam", "Dreamfoil", "Mountain Silversage", "Plaguebloom", "Black Lotus" },
    ores = { "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein", "Rich Thorium Vein" },
    fish = { { "Darkclaw Lobster", 13888 }, { "Large Raw Mightfish", 13893 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Summer Bass", 13756 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 }, { "Stonescale Eel", 13422 } },
  },
  [1424] = {
    herbs = { "Mageroyal", "Briarthorn", "Stranglekelp", "Bruiseweed", "Wild Steelbloom", "Kingsblood", "Liferoot", "Khadgar's Whisker" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    pools = { "Floating Wreckage", "Oily Blackmouth School", "Sagefish School" },
    fish = { { "Firefin Snapper", 6359 }, { "Oily Blackmouth", 6358 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Rainbow Fin Albacore", 6361 }, { "Raw Sagefish", 21071 } },
  },
  [1425] = {
    herbs = { "Stranglekelp", "Liferoot", "Fadeleaf", "Goldthorn", "Khadgar's Whisker", "Purple Lotus", "Sungrass", "Ghost Mushroom", "Star Lotus", "Golden Sansam" },
    ores = { "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein", "Starsilver Vein" },
    fish = { { "Firefin Snapper", 6359 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Glossy Mightfish", 13754 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Rockscale Cod", 6362 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Summer Bass", 13756 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Winter Squid", 13755 }, { "Stonescale Eel", 13422 } },
  },
  [1426] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot" },
    ores = { "Copper Vein" },
    fish = { { "Raw Brilliant Smallfish", 6291 }, { "Raw Longjaw Mud Snapper", 6289 } },
  },
  [1427] = {
    herbs = { "Firebloom" },
    ores = { "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Dark Iron Deposit", "Truesilver Deposit", "Small Thorium Vein" },
  },
  [1428] = {
    herbs = { "Sungrass", "Golden Sansam", "Dreamfoil", "Mountain Silversage", "Black Lotus" },
    ores = { "Gold Vein", "Mithril Deposit", "Dark Iron Deposit", "Truesilver Deposit", "Small Thorium Vein", "Rich Thorium Vein" },
    fish = { { "Lightning Eel", 13757 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1429] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot" },
    ores = { "Copper Vein" },
    fish = { { "Lightning Eel", 13757 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1430] = {
    fish = { { "Lightning Eel", 13757 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1431] = {
    herbs = { "Mageroyal", "Briarthorn", "Bruiseweed", "Wild Steelbloom", "Grave Moss", "Kingsblood", "Nightmare Moss" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein", "Cold Iron Deposit", "Iron Deposit", "Gold Vein" },
    fish = { { "Lightning Eel", 13757 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1432] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot", "Mageroyal", "Briarthorn", "Bruiseweed" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein" },
    pools = { "Floating Debris", "Oily Blackmouth School", "Sagefish School" },
    fish = { { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Loch Frenzy", 6317 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Sagefish", 21071 } },
  },
  [1433] = {
    herbs = { "Earthroot", "Mageroyal", "Briarthorn", "Bruiseweed" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein" },
    fish = { { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 } },
  },
  [1434] = {
    herbs = { "Stranglekelp", "Wild Steelbloom", "Kingsblood", "Liferoot", "Fadeleaf", "Goldthorn", "Khadgar's Whisker", "Purple Lotus" },
    ores = { "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    pools = { "Floating Wreckage", "Oily Blackmouth School" },
    fish = { { "Firefin Snapper", 6359 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Glossy Mightfish", 13754 }, { "Raw Greater Sagefish", 21153 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Rockscale Cod", 6362 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Summer Bass", 13756 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 }, { "Raw Winter Squid", 13755 }, { "Stonescale Eel", 13422 } },
  },
  [1435] = {
    herbs = { "Stranglekelp", "Kingsblood", "Liferoot", "Fadeleaf", "Goldthorn", "Khadgar's Whisker", "Blindweed" },
    ores = { "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    fish = { { "Firefin Snapper", 6359 }, { "Oily Blackmouth", 6358 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Rockscale Cod", 6362 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Sunscale Salmon", 13760 } },
  },
  [1436] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot", "Mageroyal", "Briarthorn", "Stranglekelp", "Bruiseweed" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein" },
    pools = { "Floating Debris", "Oily Blackmouth School", "Sagefish School" },
    fish = { { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Rainbow Fin Albacore", 6361 }, { "Raw Slitherskin Mackerel", 6303 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1437] = {
    herbs = { "Mageroyal", "Briarthorn", "Stranglekelp", "Bruiseweed", "Wild Steelbloom", "Grave Moss", "Kingsblood", "Liferoot" },
    ores = { "Copper Vein", "Incendicite Mineral Vein", "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein" },
    pools = { "Floating Wreckage", "Oily Blackmouth School" },
    fish = { { "Firefin Snapper", 6359 }, { "Oily Blackmouth", 6358 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Rainbow Fin Albacore", 6361 } },
  },
  [1438] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot", "Mageroyal" },
    ores = { "Chunk of Amber", "Large Chunk of Amber" },
    fish = { { "Raw Brilliant Smallfish", 6291 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Slitherskin Mackerel", 6303 } },
  },
  [1439] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot", "Mageroyal", "Briarthorn", "Stranglekelp", "Bruiseweed" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein" },
    pools = { "Floating Debris", "Oily Blackmouth School", "Sagefish School" },
    fish = { { "Oily Blackmouth", 6358 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Rainbow Fin Albacore", 6361 }, { "Raw Slitherskin Mackerel", 6303 } },
  },
  [1440] = {
    herbs = { "Mageroyal", "Briarthorn", "Stranglekelp", "Bruiseweed", "Wild Steelbloom", "Kingsblood", "Liferoot", "Dreamroot", "Purple Lotus", "Gromsblood" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Fool's Gold Vein" },
    pools = { "Sagefish School" },
    fish = { { "Deviate Fish", 6522 }, { "Firefin Snapper", 6359 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Rainbow Fin Albacore", 6361 }, { "Raw Redgill", 13758 }, { "Raw Sagefish", 21071 }, { "Raw Sunscale Salmon", 13760 } },
  },
  [1441] = {
    herbs = { "Bruiseweed", "Wild Steelbloom", "Kingsblood" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    fish = { { "Deviate Fish", 6522 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Mithril Head Trout", 8365 } },
  },
  [1442] = {
    herbs = { "Mageroyal", "Briarthorn", "Bruiseweed", "Wild Steelbloom", "Kingsblood" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    pools = { "Floating Wreckage", "Oily Blackmouth School", "Sagefish School" },
    fish = { { "Firefin Snapper", 6359 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Sagefish", 21071 } },
  },
  [1443] = {
    herbs = { "Stranglekelp", "Bruiseweed", "Wild Steelbloom", "Grave Moss", "Kingsblood", "Liferoot", "Ghost Mushroom", "Gromsblood" },
    ores = { "Copper Vein", "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    pools = { "Floating Wreckage", "Oily Blackmouth School" },
    fish = { { "Firefin Snapper", 6359 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Rockscale Cod", 6362 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Sunscale Salmon", 13760 } },
  },
  [1444] = {
    herbs = { "Stranglekelp", "Liferoot", "Goldthorn", "Khadgar's Whisker", "Purple Lotus", "Sungrass", "Moonroot", "Golden Sansam" },
    ores = { "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Greater Moonstone Formation", "Small Thorium Vein" },
    pools = { "Floating Wreckage", "Oily Blackmouth School" },
    fish = { { "Firefin Snapper", 6359 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Glossy Mightfish", 13754 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Rockscale Cod", 6362 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Summer Bass", 13756 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 }, { "Raw Winter Squid", 13755 }, { "Stonescale Eel", 13422 } },
  },
  [1445] = {
    herbs = { "Stranglekelp", "Kingsblood", "Liferoot", "Fadeleaf", "Goldthorn", "Khadgar's Whisker" },
    ores = { "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
    pools = { "Floating Wreckage", "Oily Blackmouth School" },
    fish = { { "Deviate Fish", 6522 }, { "Firefin Snapper", 6359 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Rainbow Fin Albacore", 6361 }, { "Raw Rockscale Cod", 6362 }, { "Raw Slitherskin Mackerel", 6303 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1446] = {
    herbs = { "Stranglekelp", "Firebloom", "Purple Lotus" },
    ores = { "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein" },
    pools = { "Floating Wreckage", "Oily Blackmouth School" },
    fish = { { "Deviate Fish", 6522 }, { "Firefin Snapper", 6359 }, { "Oily Blackmouth", 6358 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Glossy Mightfish", 13754 }, { "Raw Redgill", 13758 }, { "Raw Rockscale Cod", 6362 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Summer Bass", 13756 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Winter Squid", 13755 }, { "Stonescale Eel", 13422 } },
  },
  [1447] = {
    herbs = { "Stranglekelp", "Goldthorn", "Khadgar's Whisker", "Purple Lotus", "Sungrass", "Golden Sansam", "Dreamfoil", "Mountain Silversage" },
    ores = { "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Rich Thorium Vein" },
    pools = { "Floating Wreckage", "Oily Blackmouth School" },
    fish = { { "Darkclaw Lobster", 13888 }, { "Deviate Fish", 6522 }, { "Firefin Snapper", 6359 }, { "Large Raw Mightfish", 13893 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Glossy Mightfish", 13754 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Rockscale Cod", 6362 }, { "Raw Spotted Yellowtail", 4603 }, { "Raw Summer Bass", 13756 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Winter Squid", 13755 }, { "Stonescale Eel", 13422 } },
  },
  [1448] = {
    herbs = { "Arthas' Tears", "Sungrass", "Gromsblood", "Golden Sansam", "Dreamfoil", "Mountain Silversage", "Plaguebloom" },
    ores = { "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein" },
    fish = { { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1449] = {
    herbs = { "Sungrass", "Blindweed", "Golden Sansam", "Dreamfoil", "Mountain Silversage" },
    ores = { "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein", "Rich Thorium Vein" },
    fish = { { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 } },
  },
  [1450] = {
    fish = { { "Deviate Fish", 6522 }, { "Lightning Eel", 13757 }, { "Oily Blackmouth", 6358 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Mithril Head Trout", 8365 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 } },
  },
  [1451] = {
    herbs = { "Sungrass", "Golden Sansam", "Dreamfoil", "Mountain Silversage", "Black Lotus" },
    ores = { "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein", "Rich Thorium Vein", "Large Obsidian Chunk", "Small Obsidian Chunk" },
    fish = { { "Deviate Fish", 6522 }, { "Lightning Eel", 13757 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1452] = {
    herbs = { "Mountain Silversage", "Icecap", "Black Lotus" },
    ores = { "Gold Vein", "Mithril Deposit", "Truesilver Deposit", "Small Thorium Vein", "Rich Thorium Vein" },
    fish = { { "Lightning Eel", 13757 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Redgill", 13758 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1453] = {
    herbs = { "Peacebloom", "Silverleaf", "Mageroyal" },
    fish = { { "Lightning Eel", 13757 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1454] = {
    herbs = { "Peacebloom", "Silverleaf" },
    fish = { { "Deviate Fish", 6522 }, { "Lightning Eel", 13757 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Nightfin Snapper", 13759 }, { "Raw Sunscale Salmon", 13760 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [1455] = {
    herbs = { "Peacebloom", "Silverleaf" },
  },
  [1456] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot" },
    ores = { "Copper Vein" },
    fish = { { "Deviate Fish", 6522 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 } },
  },
  [1457] = {
    fish = { { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 } },
  },
  [1458] = {
    fish = { { "Deviate Fish", 6522 }, { "Lightning Eel", 13757 }, { "Raw Brilliant Smallfish", 6291 }, { "Raw Bristle Whisker Catfish", 6308 }, { "Raw Longjaw Mud Snapper", 6289 }, { "Raw Whitescale Salmon", 13889 } },
  },
  [2482] = {
    herbs = { "Hyjal Silphium", "Dreamfoil", "Mountain Silversage", "Black Lotus", "Demonsage" },
    ores = { "Rich Thorium Vein", "Heavy Thorium Vein" },
  },
  [2521] = {
    herbs = { "Peacebloom", "Silverleaf", "Earthroot", "Mageroyal" },
    ores = { "Copper Vein" },
  },
  [2548] = {
    herbs = { "Stranglekelp", "Wild Steelbloom", "Kingsblood", "Liferoot", "Goldthorn", "Khadgar's Whisker" },
    ores = { "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit", "Truesilver Deposit" },
  },
  [2652] = {
    herbs = { "Bruiseweed", "Grave Moss" },
    ores = { "Tin Vein", "Silver Vein", "Iron Deposit", "Gold Vein", "Mithril Deposit" },
  },
}
