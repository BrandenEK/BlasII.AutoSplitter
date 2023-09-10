# Development notes

## Variables need per version:

### isPlaying
Start on mainmenu with a value of 1.  After selecting file, search for 0 while loading.  Once in game, search for 0 during first scene transition.  Make sure to get a few quit-outs and at least one death in the search.  Should be 0x40 bytes past a similar value, but that one stops after dying.

### roomHash
Go back and forth between some of these known room values.
- City: 0x4D00F414
- Left: 0x4D00F4B1
- Right: 0x4D00F411