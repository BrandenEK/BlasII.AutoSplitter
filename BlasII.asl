
state("Blasphemous 2", "Unknown")
{
    bool   isPlaying : 0;
    uint   earlyRoom : 0;
    uint    mainRoom : 0;
    uint    lateRoom : 0;
    int   enemyCount : 0;
}

state("Blasphemous 2", "1.0.5")
{
    bool   isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0, 0x30, 0x190;
    uint   earlyRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x270, 0x20, 0x14;
    uint    mainRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x2D0, 0x28, 0x0;
    uint    lateRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x3C8, 0x150, 0x70;
    int   enemyCount : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x468, 0x1D0;
}

start
{
    return old.mainRoom == 0 && current.mainRoom != 0;
}

split
{
    bool devotion = current.mainRoom == 0x9AB9D532 && current.earlyRoom == 0x9AB9D533 && current.enemyCount == 0 && old.enemyCount == 1 && settings["devotion"];
    bool emery = current.mainRoom == 0x5DD4E45B && old.mainRoom != 0x5DD4E45B && settings["emery"];
    bool afilaor = current.mainRoom == 0x5DD4E45B && current.earlyRoom == 0x5DD4E45B && current.enemyCount == 0 && old.enemyCount == 1 && settings["afilaor"];

    return devotion || emery || afilaor;
}

isLoading
{
    return !current.isPlaying || current.mainRoom == 0;
}

startup
{
    settings.Add("full", true, "Any% Ending");
    settings.Add("devotion", false, "Defeat Devotion Incarnate", "full");
    
    settings.Add("level", true, "Afilaor% Ending");
    settings.Add("emery", false, "Reach Sentinel of the Emery", "level");
    settings.Add("afilaor", false, "Defeat Afilaor", "level");
}

init
{   
    int size = modules.First().ModuleMemorySize;
    print("BlasII module size: " + size);
    
    switch (size)
    {
        case 675840:   version = "1.0.5";     break;
        default:       version = "Unknown";   break;
    }
}
