
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
    uint   earlyRoom : 0;
    uint    mainRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x2D0, 0x28, 0x0;
    uint    lateRoom : 0;
    int   enemyCount : 0;
}

start
{
    return old.mainRoom == 0 && current.mainRoom != 0;
}

split
{
    bool devotion = current.mainRoom == 0x00 && current.earlyRoom == 0x00 && current.enemyCount == 0 && old.enemyCount == 1 && settings["devotion"];
    bool emery = current.lateRoom == 0x00 && old.lateRoom != 0x00 && settings["emery"];

    return devotion || emery;
}

isLoading
{
    return !current.isPlaying || current.mainRoom == 0;
}

startup
{
    settings.Add("devotion", false, "Defeat Devotion Incarnate");
    settings.Add("emery", false, "Reach Sentinel of the Emery");
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
