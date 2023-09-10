
state("Blasphemous 2", "1.0.5")
{
    bool isPlaying : "GameAssembly.dll", 0x03596918, 0x03D0, 0x07F0, 0x28, 0x0720;
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
}

isLoading
{
    return false;
    //return !current.isPlaying || current.roomHash == 0;
}

startup
{
    print("==========");
    print("BlasII initialization");
    print("==========");
    
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
