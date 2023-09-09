
state("Blasphemous 2")
{
	bool isPlaying : "GameAssembly.dll", 0x0336A6F0, 0xB8, 0xE0, 0x30, 0x0310, 0x18, 0x0170;
}

startup
{
	print("Startup for BlasII");
}

isLoading
{
	return !current.isPlaying;
}