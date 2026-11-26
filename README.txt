GATHER LABELS - World of Warcraft addon
========================================

Tired of seeing a yellow dot on the minimap and having to hover over it to
find out which herb or ore it is? Gather Labels puts the node's own icon,
and its name, right on top of the dot. It does the same for fishing pools
and treasure chests. Choose which ones you want to see.

Click any icon and an arrow on your screen points you to it, and the node
sparkles in the world so you can spot it from far away. Once you've
seen enough spots in a zone, start a farming route: Gather Labels works out
a short loop through all of them and the arrow leads you from one to the
next. A small panel tracks your gathering session: nodes, loot, nodes per
hour and gold per hour. Hover any icon to see the skill it needs.


HOW IT WORKS
------------

WoW Forever (and Retail from patch 12.1.7): no hovering at all. The game lets addons ask what is at any
point of the minimap, so Gather Labels checks spots all over the minimap
a few times a second and puts an icon on every herb and ore dot it finds.
Find Herbs or Find Minerals must be on. It only sees as far as your
minimap, so zoom out to see farther. It pauses during combat.

Every other game version (Classic Era, Hardcore, Anniversary, Retail
before 12.1.7 and so on) doesn't let addons do that, so there Gather Labels learns spots
instead, as described below. WoW Forever saves spots this way too.


The game doesn't tell addons where the tracking dots are or what they are.
What never changes is where herbs and ore spawn: each node always appears
on one of a fixed set of spots. So Gather Labels remembers those spots and
draws the right icon there.

A spot is learned when you:
  - hover its dot on the minimap once (the game names it in the tooltip), or
  - gather the node (this also learns herbs and ores from any expansion,
    even ones Gather Labels has never heard of).

After that, the icon stays on that spot for good. Spots are saved for all
your characters, so learning them on one character helps the others too.

The icons mark where a node CAN spawn. The game's yellow dot still tells
you a node is there right now. Together: dot plus icon means "that herb is
there now"; an icon with no dot under it means someone already picked it
(or it hasn't respawned yet).

Some spots can spawn different nodes (for example copper or tin). The icon
shows the one you saw there last. Hover the icon to see everything that
has spawned there.


FISHING POOLS AND TREASURE
--------------------------

Fishing pools show on the minimap when Find Fish is on, and chests when
Find Treasure is on (Dwarves). Gather Labels labels them like herbs and ore.
Without those, it still learns a pool when you hover it in the world (it
assumes the pool is about 15 yards in front of you, where you'd fish from)
and a chest when you open it.


ABOVE, BELOW AND CAVES
----------------------

WoW Forever: when a node is well above or below you (up a cliff, down in
a ravine, under water), the game marks its dot with a small up or down
arrow. Gather Labels shows that arrow on the corner of the icon, and the
on-screen arrow says "above you" or "below you".

Nodes in a cave or building get a brown frame around their icon and
"(cave)" after their name. On Forever this comes straight from the minimap
(it shows those dots grey when you're outside). On other versions, a spot
is marked as a cave once you gather it while indoors.
The game only gives addons "above" or "below", not how many yards.


THE ARROW AND THE SPARKLE
-------------------------

Click an icon on the minimap. An arrow near the top of your screen points
to it, with its name and how many yards away it is. It disappears when you
get there. Drag the arrow to move it; right-click it to hide it.

Once you are near the node (50 yards by default, change it with "Sparkle
only closer than" in Settings), it also sparkles in the world: a small,
see-through twinkling star over it, so it doesn't get in your face from
across the zone. Farther away, the arrow still points the way. The
stars are green for herbs, icy blue for ore, aqua for fishing pools and
gold for chests. It uses the game's own map pin (the one you get by placing a pin on
the world map), so the game's distance marker shows up with it, and it
replaces any map pin you had placed. When you get there or hide the
arrow, the pin is removed (a pin you placed yourself afterwards is left
alone). Turn it off in Settings if you'd rather not have it.
The game doesn't let addons make the plant or vein itself glow, so the
sparkle marks its spot. The game places the pin at ground level, so for a
node high on a cliff or deep in a cave it may sit a little above or below.

SPARKLE THE NEAREST NODE BY ITSELF
----------------------------------

Turn on "Sparkle the nearest node by itself" in Settings, Shift-click the
minimap button, bind a key (Key Bindings > AddOns > Gather Labels), or type
/glabels shine. Then, without clicking anything, the closest node shines
as soon as it shows on your minimap. Gather it and the sparkle moves on to
the next closest. Only nodes within the "Sparkle only closer than" range
shine, and it never takes over a map pin you (or another addon) placed.
Tick which kinds shine (Herbs, Ore, Fishing, Chests),
for example only Herbs when you're farming herbs.

The game only lets addons put one marker in the world at a time, so one
node shines at a time: always the nearest one. A node you click, or the
farming route, comes first. While it's on, it uses the game's map pin.


CLOSE-UP GLOW
-------------

Walk up to a herb, a vein, a chest or your fishing bobber and it lights up
in its own colour: green herbs, copper ore, blue chests, teal fishing
pools, a red bobber. Only the one node the game picks in front of you
glows (from up to 15 yards). The light is dim while it's still out of
reach, flashes the moment you can gather it, and turns grey when you
can't (your skill is too low, or the game refuses it for now). Its name
shows under it in the game's skill colour.

Everything is on the Glow tab: on/off, five styles (Halo, Beacon,
Sparkle, Ground ring, Embers), size, height, brightness, how far away it
starts, moving or still, the flash, the name, hiding the game's small
icon, hide in combat, hide in dungeons, only herbs and ore you can
gather, and which kinds glow. Nodes unticked in the Herbs and Ore lists
never glow. Preview shows it in the middle of your screen.

While the glow is on, Gather Labels switches on the game's own settings
for clicking objects near you (soft targeting for objects and their name
plates). They're put back when the glow is off and when you log out.
If Lueur is installed and on, Gather Labels leaves the glow to it.


SKILL LEVELS
------------

Hover an icon on the minimap, or a herb or vein in the world, to see the
skill it needs and yours, for example "Requires Herbalism 125 (you have
110)". The colours are the game's:
  red     your skill is too low
  orange  always gives a skill point
  yellow  usually gives a skill point
  green   sometimes gives a skill point
  grey    no more skill points
Names next to the icons and in the Settings lists use the same colours.

"Hide nodes my skill is too low for" (Settings, off by default) leaves the
red ones off the minimap and out of the farming route. They come back by
themselves as your skill goes up. If you don't have Herbalism or Mining at
all, every herb or ore counts as too low.
Skill levels are built in for every Classic, Burning Crusade and Wrath herb
and ore. Fishing pools and chests have none. On Retail skill levels are not
shown and the "Hide nodes my skill is too low for" setting isn't there.


SESSION TRACKER
---------------

A small panel (on the right of your screen; drag it anywhere) shows:
  - how long you've been gathering (from your first node),
  - how many nodes you've gathered, and how many an hour,
  - fish caught,
  - what it's worth in total and per hour, and
  - what you looted, most first.
Mining the same vein more than once counts as one node. The session
carries on across logins until you click Reset. The value uses auction
prices if you have Auctionator or TradeSkillMaster, otherwise what a vendor
pays. Turn the panel on or off in Settings, or with /glabels session.


FARMING ROUTE
-------------

Click "Start farming route" in Settings, or type /glabels route. Gather
Labels takes every saved spot in your zone (only the nodes ticked in
Settings), finds a short loop through them, and:
  - draws the loop on the minimap (the leg you're on is brighter),
  - points the arrow at the next stop, showing "stop 3 of 25",
  - moves on to the next stop as soon as you reach one.
On WoW Forever it also skips a stop when you're close and there's no dot
there, because someone already picked it.
The more spots you've seen in a zone, the better the route. Untick nodes
you don't want before starting, or tick "Hide nodes my skill is too low
for".
Stop it with the button, by right-clicking the arrow, or /glabels stop.


GAME VERSIONS
-------------

One download works on every version: WoW Forever, Retail, Classic Era
(including Hardcore), Burning Crusade Anniversary, Titan Reforged and Mists
of Pandaria Classic.

What works where:
  - WoW Forever: everything. Dots are read straight off the minimap with no
    hovering, and skill levels are shown.
  - Retail: everything except skill levels (Retail has a separate skill
    for each expansion and most nodes need none). Retail patch 12.1.7 adds
    what's needed to read the minimap by itself, so from that patch the
    dots are read with no hovering there too. Before it, hover a dot once,
    or gather the node, and its icon stays on the minimap for good.
  - Classic versions: everything except reading the minimap by itself.

The built-in list covers every Classic, Burning Crusade and Wrath herb and
ore (in English), and on Retail the herbs and ores of every expansion from
Cataclysm to Midnight. Retail nodes come in many forms ("Lush Mycobloom",
"Rich Bismuth Deposit"); each one counts as its plain name. Their icon
appears the first time you loot one. Anything not listed, such as new nodes
in WoW Forever, is learned the first time you gather it. On non-English
game clients, gathering learns every node (hovering only recognises the
English names).

Icons are not shown inside dungeons and raids, because the game doesn't
give addons your position there.


INSTALLATION GUIDE
------------------

1. Close World of Warcraft completely.

2. Unzip GatherLabels.zip.
   Windows: right-click GatherLabels.zip and choose "Extract All".
   Mac: double-click GatherLabels.zip.
   You should now have a folder named "GatherLabels". Inside it you should
   see GatherLabels.toc, Skin.lua, Nodes.lua, Core.lua, Skill.lua, Scan.lua,
   Pins.lua, Route.lua, Mark.lua, Tracker.lua, Window.lua, Minimap.lua,
   Bindings.xml and this README.txt.

3. Find your game's AddOns folder.
   Windows: C:\Program Files (x86)\World of Warcraft\<game folder>\Interface\AddOns\
   Mac:     /Applications/World of Warcraft/<game folder>/Interface/AddOns/

   <game folder> depends on the version you play:
     WoW Forever  ->  the folder the Battle.net app made for Forever
                      (during the beta it is _classic_beta_)
     Retail       ->  _retail_
     Classic Era  ->  _classic_era_
     Mists Classic -> _classic_

   Tip: in the Battle.net app, pick the game version, click the gear icon
   next to Play, and choose "Show in Explorer" (Windows) or "Show in
   Finder" (Mac). That opens the right World of Warcraft folder.

   If the "Interface" or "AddOns" folder doesn't exist yet, create it.

4. Move the whole "GatherLabels" folder into AddOns. The result should
   look like:
   ...\Interface\AddOns\GatherLabels\GatherLabels.toc
   (Not ...\AddOns\GatherLabels\GatherLabels\GatherLabels.toc. If you see
   two GatherLabels folders inside each other, move the inner one up a
   level.)

5. Start the game. On the character select screen, click "AddOns" in the
   bottom left and make sure "Gather Labels" is ticked.
   If it says "Out of date", tick "Load out of date AddOns" at the top.

6. Log in, turn on Find Herbs or Find Minerals as usual, and hover a few
   yellow dots. Their icons appear and stay.

To uninstall, delete the GatherLabels folder from AddOns.
To update, close the game and replace the GatherLabels folder with the new
one. Your settings and saved spots are kept.


SETTINGS
--------

Click the Gather Labels button on the edge of your minimap (the flower
icon), or type /glabels. Every change is saved as soon as you click it.
The window has three tabs at the bottom: Settings, Herbs and Ore, and
Fishing and Treasure (tick or untick each node there). Hover a setting for
a short explanation.
  Minimap button: left-click opens Settings, right-click turns the icons
  on or off, Shift-click turns the sparkle on the nearest node on or off,
  and you can drag it to move it around the minimap. On Retail,
  Gather Labels is also in the minimap's addon menu.

  - Show herb and ore icons on the minimap: the main on/off switch.
  - Show names next to the icons: on by default. Turn it off for a cleaner
    minimap with just the icons.
  - Learn a spot when I hover its dot on the minimap: on by default.
  - Show minimap button.
  - Icon size: 10 to 24.
  - WoW Forever only:
      Read the dots straight off the minimap: on by default.
      Also show saved spots with no dot right now: off by default. Turn it
      on to see, faded, where nodes can spawn even when nothing is there.
      Scan detail: lightest, normal or most exact. Higher uses more CPU.
  - Hide nodes my skill is too low for: off by default. Not on Retail.
  - Sparkle in the world on the node the arrow points to: on by default.
  - Show the gathering session tracker: on by default.
  - Sparkle the nearest node by itself: off by default, with Herbs, Ore,
    Fishing and Chests to pick which kinds shine.
  - Sparkle only closer than: 50 yards by default (20 to 150).
  - Sparkle moves: on by default. Off gives a still star.
  - Node lists: untick anything you don't want to see. The number after a
    herb or ore is the skill it needs, coloured against yours. "All" and
    "None" tick or untick a whole list. Each line shows how many spots
    you've saved for that node. Scroll with the mouse wheel.
  - Herbs and Ore / Fishing and Treasure: switch between the two pairs of
    lists.
  - Start farming route / Stop farming route.
  - Forget all spots: deletes every saved spot (asks first).


CHAT COMMANDS
-------------

/glabels                 Open or close Settings
/glabels on  /  off      Show or hide the icons
/glabels minimap         Show or hide the minimap button
/glabels route           Start a farming route in this zone
/glabels stop            Stop the farming route
/glabels shine           Turn the sparkle on the nearest node on or off
/glabels glow            Turn the close-up glow on or off
/glabels glow test       Show the glow in the middle of the screen
/glabels glow debug      Say what the glow sees in front of you
/glabels session         Show or hide the session tracker
/glabels reset           Start a new gathering session
/glabels help            List these commands
/glabels scantest        WoW Forever: run one scan each way and print what
                         it found (for troubleshooting)
/glabels scanmode direct|move
                         WoW Forever: how the scan asks the minimap. Use
                         "move" only if scantest finds dots that way and
                         not with "direct".

/gatherlabels works too.
