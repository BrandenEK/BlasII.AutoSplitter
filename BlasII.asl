
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
    float bossDeath1 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x28;
    float bossDeath2 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x2C;
    float bossDeath3 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x30;
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
    return old.mainRoom == 0 && current.mainRoom != 0;
}

onStart
{
    print("Resetting cleared splits");
    vars.bossSplits.Clear();
}

split
{
    // Bosses

    if (settings["B_" + current.mainRoom] && !vars.bossSplits.Contains(current.mainRoom))
    {
        if (old.bossDeath1 != current.bossDeath1 || old.bossDeath2 != current.bossDeath2 || old.bossDeath3 != current.bossDeath3)
        {
            print("Splitting on boss: " + current.mainRoom);
            return true;
        }
    }
    bool emery = current.mainRoom == 0x5DD4E45B && old.mainRoom != 0x5DD4E45B && settings["emery"];

    return false;
}

isLoading
{
    return !current.isPlaying || current.mainRoom == 0;
}

startup
{
    // Bosses

    var bossSettings = new Dictionary<uint, string>()
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
        //{ 0x9AB9D533, "Eviterno" },
        { 0x9AB9D532, "Devotion Incarnate" }
    };
    print("Loaded " + bossSettings.Count + " bosses");
    vars.bossSplits = new List<uint>();

    settings.Add("bosses", true, "Bosses");
    foreach (var boss in bossSettings)
    {
        settings.Add("B_" + boss.Key, false, boss.Value, "bosses");
    }

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
