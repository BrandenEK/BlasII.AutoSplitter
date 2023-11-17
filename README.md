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

### bossHealth
Go to The Faceless One (tutorial boss), value should be 500 and decreasing with each hit.
There will be 3 adresses find the 2 with the lowest value and keep the one that resets to 0 upon quitting to main menu
Pointers are quite long, find 6-7 offsets long pointers with the right base adress then search for longer pointers by fixing the last 4/5 offests so it's fast enough.

### infantaHealth
Add Ox20 to the last offset of bossHealth.

### lesmesHealth
Add Ox40 to the last offset of bossHealth.

### playerHealth
Check TPO's Health on the pause menu and search for this value.

### isInputLocked
Bind cheat engine pause process shortcut.
The value is 0 while the game is in focus and TPO can move normally, pause the game before launching scan, unpause click off blasphemous 2 and the value should be 1.

### playerPositionX
Make sure to search for float.
City Prie Dieu coordinate is -130, going to the right increases it
