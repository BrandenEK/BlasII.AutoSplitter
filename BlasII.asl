
state("Blasphemous 2")
{
	bool isPlaying : "GameAssembly.dll", 0x03596918, 0x03D0, 0x07F0, 0x28, 0x0720;
}

startup
{
	print("Startup for BlasII");
}

isLoading
{
	return !current.isPlaying;
}