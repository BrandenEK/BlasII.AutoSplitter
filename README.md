# Development notes

## Variables needed per version:

### isPlaying (A80)
Should be 1 while in game and on the menu, 0 while loading.  Prie Dieu animation is included in load.

### mainRoom
Go back and forth between some of these known room values. It should be the first and second one.  One is zeroed in Z1045 and the other is zeroed in Z2501.
- City: 0x4D00F414
- Left: 0x4D00F4B1
- Right: 0x4D00F411
- Menu: 0x00

### bossDeath
After defeating certain bosses, a color will be set and preserved until the next boss defeat.  Search for r, g, or b.
- Chiseled One: (0.063, 0.059, 0.090)
- Radames: (0.063, 0.035, 0.071)
- Orospina: (0.063, 0.047, 0.071)
- Lesmes: (0.075, 0.082, 0.122)