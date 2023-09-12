
state("Blasphemous 2", "1.0.5")
{
    bool   isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0, 0x30, 0x190;
    uint    roomHash : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x2D0, 0x28, 0x0;
}

start
{
    return old.roomHash == 0 && current.roomHash != 0;
}

isLoading
{
    return !current.isPlaying || current.roomHash == 0;
}

startup
{
    settings.Add("bosses", true, "Bosses");
    settings.Add("rooms", true, "Rooms");
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
