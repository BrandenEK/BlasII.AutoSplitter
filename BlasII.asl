
state("Blasphemous 2", "1.0.5")
{
    bool isPlaying : "GameAssembly.dll", 0x03596918, 0x03D0, 0x07F0, 0x28, 0x0760;
    uint roomHash : "GameAssembly.dll", 0x0336A6F0, 0xB8, 0x0490, 0x0338, 0x00;
    int enemyCount : "GameAssembly.dll", 0x0336A6F0, 0xB8, 0x0548, 0xC8, 0x80;
}

start
{
    return false;
}

split
{
    return false;
    
    bool beatBoss = current.enemyCount == 0 && old.enemyCount > 0 && vars.bossRooms.ContainsKey(current.roomHash) && settings["b" + vars.bossRooms[current.roomHash]];
    return beatBoss;
}

isLoading
{
    return !current.isPlaying || current.roomHash == 0;
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
