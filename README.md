# Development notes

## Variables needed per version:

### isPlaying
Should be 1 while in game and on the menu, 0 while loading.  Prie Dieu animation is included in load.  There are 3 different roomHashes (Early, main, and late).  Get this value by searching for 0 while in between early and late changing.

### roomHash
Go back and forth between some of these known room values.
- City: 0x4D00F414
- Left: 0x4D00F4B1
- Right: 0x4D00F411
