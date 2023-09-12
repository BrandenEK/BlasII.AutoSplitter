
state("Blasphemous 2", "Unknown")
{
    bool   isPlaying : 0;
    uint    roomHash : 0;
}

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
    int size = modules.First().ModuleMemorySize;
    print("BlasII module size: " + size);
    
    switch (size)
    {
        case 675840:   version = "1.0.5";     break;
        default:       version = "Unknown";   break;
    }
}
