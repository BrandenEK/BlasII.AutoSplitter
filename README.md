# Development notes

## Variables needed per version:

### isPlaying (A80)
Should be 1 while in game and on the menu, 0 while loading.  Prie Dieu animation is included in load.  There are 3 different roomHashes (Early, main, and late).  Get this value by searching for 0 while in between early and late changing.

### earlyRoom (DE4)
First find the main room hash.  There should be five consistent addresses, this one will be locked when teleporting with a prie dieu.

### roomHash
Go back and forth between some of these known room values. It should be the first one.
- City: 0x4D00F414
- Left: 0x4D00F4B1
- Right: 0x4D00F411
- Menu: 0x00

### lateRoom
First find the main room hash.  There should be five consistent addresses, this one will be locked when using a ladder to change scenes.

### enemyCount
Start in Profundo Lamento to narrow it down to about fifteen enemy counts.  Then enter the Chiseled One boss fight.  It should be 0 at first, and should only change to 1 once his wheel hits the ground.  There will be two addresses, use the second one.

### bossHP
Go to The Faceless One (tutorial boss), value should be 500 and decreasing with each hit.
Pointers are quite long, find 6-7 offsets long pointers with the right base adress then search for longer pointers by fixing the last 4/5 offests so it's fast enough.

### infantaHP
Add Ox20 to the last offset of bossHP

### lesmesHP
Add Ox40 to the last offset of bossHP
