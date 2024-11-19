
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
    int   enemyCount : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x4E8, 0x178, 0x80;
}

state("Blasphemous 2", "1.1.0")
{
    bool   isPlaying : "GameAssembly.dll", 0x33A63D8, 0xB8, 0xE0, 0x30, 0x190;
    uint   earlyRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x268, 0x20, 0x14;
    uint    mainRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x2C8, 0x28, 0x0;
    uint    lateRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x3C0, 0x150, 0x70;
    int   enemyCount : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x4F0, 0x1E8, 0x10;
}

start
{
    // Menu - 0x00, Spawn - 0x4D00F498, Weapon - 0x9AB9D550
    uint oldRoom = (uint)(settings["wstart"] ? 0x4D00F498 : 0);

    return old.mainRoom == oldRoom && current.mainRoom != oldRoom;
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
    settings.Add("general", true, "General");
    settings.Add("wstart", true, "Start timer on Weapon Select room", "general");

    settings.Add("full", true, "Any% Ending");
    settings.Add("devotion", false, "Defeat Devotion Incarnate", "full");
    
    settings.Add("level", true, "Afilaor% Ending");
    settings.Add("emery", false, "Reach Sentinel of the Emery", "level");
    settings.Add("afilaor", false, "Defeat Afilaor", "level");
    
    // Change timing method to game time (Not my own, taken from another autosplitter)
    if (timer.CurrentTimingMethod == TimingMethod.GameTime)
        return;
    var timingMessage = MessageBox.Show (
        "This game uses Time without Loads (Game Time) as the main timing method.\n"+
        "LiveSplit is currently set to show Real Time (RTA).\n"+
        "Would you like to set the timing method to Game Time?",
        "LiveSplit | Blasphemous II",
        MessageBoxButtons.YesNo, MessageBoxIcon.Question
    );
    if (timingMessage == DialogResult.Yes)
        timer.CurrentTimingMethod = TimingMethod.GameTime;
}

init
{   
    int size = modules.First(x => x.ModuleName == "GameAssembly.dll").ModuleMemorySize;
    print("BlasII module size: " + size);
    
    switch (size)
    {
        case 62201856:  version = "1.0.5";    break;
        case 62459904:  version = "1.1.0";    break;
        default:        version = "Unknown";  break;
    }
}
