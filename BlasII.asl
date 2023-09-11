
state("Blasphemous 2", "1.0.5")
{
	bool isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0, 0x30, 0x190;
	uint earlyRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x270, 0x20, 0x14;
	uint  mainRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x2D0, 0x28, 0x0;
	uint  lateRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x3C8, 0x150, 0x70;
}

start
{
    return false;

    return current.roomHash == 0 && old.isPlaying && !current.isPlaying;
}

split
{
    return false;
    
    bool beatBoss = current.enemyCount == 0 && old.enemyCount > 0 && vars.bossRooms.ContainsKey(current.roomHash) && settings["b" + vars.bossRooms[current.roomHash]];
    return beatBoss;
}

isLoading
{
	//print("Main: " + current.mainRoom + ", Early: " + current.earlyRoom + ", Late: " + current.lateRoom);
	print("Is loading: " + !current.isPlaying);
	return !current.isPlaying || current.mainRoom == 0;
	
    return current.mainRoom == 0 || current.lateRoom != current.mainRoom;
}

startup
{
    print("==========");
    print("BlasII initialization");
    print("==========");
    
    vars.bossRooms = new Dictionary<uint, string>()
    {
        { 0x4D00F491, "Faceless One" },
        { 0x07B20B3D, "Radames" },
        { 0xAA597F36, "Orospina" },
        { 0x07B20A5A, "Lesmes" },
        { 0x5DD4E45B, "Afilaor" },
        { 0xF8126136, "Benedicta" },
        { 0xF8126154, "Odon" },
        { 0x556AEC39, "Sinodo" },
        { 0x556AEC59, "Svsona" },
        { 0x9AB9D533, "Eviterno" },
        { 0x9AB9D532, "Devotion Incarnate" },
    };
    
    // Add boss header
    settings.Add("bosses", true, "Bosses (Not implemented yet)");
    settings.CurrentDefaultParent = "bosses";
    
    // Add all bosses
    foreach (string boss in vars.bossRooms.Values)
    {
        settings.Add("b" + boss, false, boss);
    }
}

init
{   
    ProcessModuleCollection col = game.Modules;
    long size = 0;
    
    for (int i = 0; i < col.Count; i++)
    {
        if (col[i].ModuleName == "GameAssembly.dll")
        {
            print("==========");
            print("GameAssembly.dll size: " + col[i].ModuleMemorySize);
            print("==========");
            
            size = col[i].ModuleMemorySize;
        }
    }
    if (size == 0)
    {
        print("==========");
        print("GameAssembly.dll not found!");
        print("==========");
    }
    
    switch (size)
    {
        case 62201856:
            version = "1.0.5"; break;
        default:
            version = "Unknown"; break;
    }
}
