
state("Blasphemous 2", "1.0.5")
{
    bool isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0, 0x30, 0x190;
    uint  roomHash : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x2D0, 0x28, 0x0;
}

start
{
    return old.roomHash == 0 && current.roomHash != 0;
}

split
{
    bool boss = false && settings["B_" + current.roomHash];
    bool room = current.roomHash != old.roomHash && false && settings["R_" + current.roomHash];
    
    return boss || room;
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
    
    var bossSplits = new Dictionary<uint, string>()
    {
        //{ 0x4D00F491, "Faceless One" },
        //{ 0x07B20B3D, "Radames" },
        //{ 0xAA597F36, "Orospina" },
        //{ 0x07B20A5A, "Lesmes" },
        //{ 0x5DD4E45B, "Afilaor" },
        //{ 0xF8126136, "Benedicta" },
        //{ 0xF8126154, "Odon" },
        //{ 0x556AEC39, "Sinodo" },
        //{ 0x556AEC59, "Svsona" },
        //{ 0x9AB9D533, "Eviterno" },
        //{ 0x9AB9D532, "Devotion Incarnate" },
    };
    print("Loaded " + bossSplits.Count + " bosses");
    
    var roomSplits = new Dictionary<uint, string>()
    {
        //{ 0x00, "Crimson Rains" },
    };
    print("Loaded " + roomSplits.Count + " rooms");
    
    // Add headers
    settings.Add("bosses", true, "Bosses");
    settings.Add("rooms", true, "Rooms");
    
    // Add bosses
    settings.CurrentDefaultParent = "bosses";
    foreach (var boss in bossSplits)
    {
        settings.Add("B_" + boss.Key, false, boss.Value);
    }
    
    // Add rooms
    settings.CurrentDefaultParent = "rooms";
    foreach (var room in roomSplits)
    {
        settings.Add("R_" + room.Key, false, room.Value);
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
