## version 1.28
- Many updates to the campaign, such as more starting miners, new messages, startign walls & tips
- Added Main Menu screen and difficulties.
- New heal & stun effects.
- Castle Archers & Deads now wear diffrent armor from normal units.
- New post Game screen.
- Added statue skins.
- Updates to Team AI regarding Giants.
- Many balanced changes:
  - Cleric's now official name is Meric.
  - Meric's damage increase from 5 to 8.
  - Meric's health decrese from 200 to 180.
  - Heal now costs 0 mana.
  - Heal amount decreased from 22 to 20.
  - Reap now costs 0 mana.
  - Reap lasts for 100 frames(3.3s) instead of 150 frames(5s).
  - Shadowrath's weapon reach decrease from 120 to 100.
  - Electric wall area increase from 50 to 75(a 50% increase!).
  - 

## version 1.27
- Replaced campaign "Scroll" with new desctription and text holder.
- Fixed bug where Swordwrath don't have double attack speed while using rage.

## version 1.26
- Updated campaign to have Albowtross in last level.
- Titles are now shown in level "scroll".
- Deads will now attempt to shoot target even if far away.
- Added weapon reach.
- Ranged units will not try to aim anymoe if no unit is in range.
- Added descriptions to these techs:
  - Statue Health(resilience)
  - Miner Tower
  - Giant Growth II
- Fixed many descripts of other techs.
- The "Dark Knight" is officially named "Jugger Knight".

## version 1.25
- Replaced Battlefield and Economy buttons with Garrison and Ungarrison buttons.
- Dead units can't be poisoned anymore.
- Fixed spearton finisher animation movements.
- Archidons now take 10 frames(0.33s) less to load a bow.
- Fixed bug introduced in last update where units push each other instead of attacking.
- Walls & Towers can't be built past middle of the map.

## version 1.24
- Added 20s cooldown to building walls(per miner)
- Now units can catch up to other units.
- Walls are now able to take damage and be destroyed while being built.

## version 1.23
- When mismatching versions, the game does not automatically refresh page anymore(web only)
- Made crawler hitbox have bigger hieght so Castle Units have easier time hitting them.
- Bombers now can catch up to units. 

## version 1.22
- Albowtross mana cost  decrease from 250 mana to 200 mana.
- Added measures to prevent animation skipping to get more damage from certain units:
  - Crawlers, Giants, Juggerknights, Medusas, Shadowrath, Speartons and Swordwrath.
- Added dust effect when jugg uses Charge.
- Fixed bug where ranged units(archidons and E. Giants) would not hit their targets.

## version 1.21
- Fix bug that occurs when meric tries to heal.
- Removed "WINGIDON_SPEED" upgrade from Eclipsor(completely this time).
- Changed width of wall from 50 to 15.
- Updated attacking logic of Unit Ai.

## version 1.20
- Added sounds to all these actions:
  - Right clicking to attack a unit.
  - Garrisoning a unit.
  - Ungarrisoning a unit.
  - Holding a unit.
  - Right clicking to move a unit.
  - Making a unit stand.
  - Capturing centre tower.
  - Clicking on lobby, armory, leaderboard or profile buttons.
  - Selecting an empire before playing a match.
  - When a match is found.
  - When entering the lobby.
  - When starting matchmaking.
  - When unlocking a unit(in campaign).
  - When an E. giant's boulder hits a unit.
  - When hell fist hits the ground and when the fist comes out.
  - When using reaper spell of Marrowkai.
  - When usin electric wall of Magikill.
  - When hovering over structure.
  - When statues get destroyed.
  - When making units.
  - When failing to make a unit.
  - When made unit is ready.
  - When Towerspawn unit spawns.
  - When an Archidon's arrow is ready, and when they launch an arrow.
  - When a crawler dies.
  - When a giant first enters the battlefield.
  - When a magikill casts Acid Spray.
  - When a magikill dies.
  - When medusa dies.
  - When building a wall.
  - When building a chaos tower.
  - When healing and curing by a meric.
  - When using Rage.
  - When hitting an armored or non armored unit.
- When equipping a skin.
- Added logic to UnitAi when attacking walls.
- Fixed bug where units double cure.
- Better logic for when playing sounds.
- Reason is now given when not able to build units.
- Added new cursors.
- Using a directory instead of array to track poisoned units.

## version 1.19
- Added "Miner Hustle" upgrade.(Both values are the same for Eminers and normal miners)
  - Miner damage 2.5 to 4
  - Miner damage to armor 1.5 to 2
  - Miner health 100 to 65
  - Miner upgraded health is 90
- Campaign now checks if on last level.
  - And added "finished game" screen.
- Some Tutorial level messages are changed.
  - And can now also compliment the player.
- You can now see newly unlock units after levels.
- Added a best time tracker for levels.
- The center tower now takes longer time to control.
- Statues now have an animation when losing, and you do not instantly see the post game screen.

## version 1.18
- You can now toggle music on and off in lobby.
- Buddy list now cleans up when closed.
- Players cannot use images in chat anymore.

## version 1.17
- Modifications to armory screen items.
- Now if FPS is very low, the game will automatically change size(only on web).
- Screen can't go out of bounds anymore.

## version 1.16
- New Halloween map!

## version 1.15
- Changed low performance check from using FPS to using skips in frames.

## version 1.14
- Registering now checks if the used email is available.
- While in-game, if FPS is low enough, resolution is automatically changed.
  - added low quality fogOfWar.
  - background will not have parallex effect if on low resolution.
- Removed 4th Castle Archer & Dead.
- Game shows correct profile of unit selected with selecting a group of diffrent units.
- Added error mode in Post Game Screen.
- Removed "WINGIDON_SPEED" upgrade from Eclipsor.
- Fixed mispelling "Blazing Blots".

## version 1.13
- Changed debugTeamB from Order to Chaos
- Unit attacking when right clicking now checks if unit is targetable before proceeding with attack.
- Unit targeting now checks if targeted unit is null and finds another unit *if* null.
- MinerAi now reserves spot in Gold Mine instead of getting a spot.
- When selecting chaos and person does not have membership, it shows a text saying he does not have it, instead of showing payment screen.
- When entering game inside game, it does not contain text in the username text field.
- Joining a match now logs you out of the server.
- Fixed error where non-member player is shown to have membership when in profile.
- TowerSpawn 2's effect when spawning a giant now has the correct size.
- Enslaved Giant now has his own profile, not the shadowrath's.
- Fixed mispell when opponent times out in race selection screen.
- Registering a new account is now done by a seperate class.
- When playing in "singleplayerGameScreen" both teams have 10,000 gold and mana.

## version 1.12
[no notable change]

## version 1.11
[we do not have version 1.10 to document changed.]