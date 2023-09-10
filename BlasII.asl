
state("Blasphemous 2")
{
	bool isPlaying : "GameAssembly.dll", 0x03596918, 0x03D0, 0x07F0, 0x28, 0x0720;
	uint roomHash : "GameAssembly.dll", 0x0336A6F0, 0xB8, 0x0490, 0x0338, 0x00;
	int enemyCount : "GameAssembly.dll", 0x0336A6F0, 0xB8, 0x0548, 0xC8, 0x80;
}

startup
{
	print("Startup for BlasII");
	
	settings.Add("bosses", true, "Bosses (Not implemented yet)");
	settings.Add("BS11", false, "Faceless One", "bosses");
	settings.Add("BS01", false, "Radames", "bosses");
	settings.Add("BS02", false, "Orospina", "bosses");
	settings.Add("BS03", false, "Lesmes", "bosses");
	settings.Add("BS04", false, "Afilaor", "bosses");
	settings.Add("BS05", false, "Benedicta", "bosses");
	settings.Add("BS06", false, "Odon", "bosses");
	settings.Add("BS08", false, "Sinodo", "bosses");
	settings.Add("BS07", false, "Svsona", "bosses");
	settings.Add("BS20", false, "Eviterno", "bosses");
	settings.Add("BS21", false, "Devotion Incarnate", "bosses");
}

isLoading
{
	return false;
	//return !current.isPlaying || current.roomHash == 0;
}
