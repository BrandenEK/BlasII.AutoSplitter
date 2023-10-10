
state("Blasphemous 2", "Unknown")
{
    bool     isPlaying : 0;
    uint     earlyRoom : 0;
    uint      mainRoom : 0;
    uint      lateRoom : 0;
    int     enemyCount : 0;
    int     bossHealth : 0;
    int   lesmesHealth : 0;
    int  infantaHealth : 0;

}

state("Blasphemous 2", "1.0.5")
{
    bool     isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0,  0x30,  0x190;
    uint     earlyRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x270, 0x20,  0x14;
    uint      mainRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x2D0, 0x28,  0x0;
    uint      lateRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x3C8, 0x150, 0x70;
    int     enemyCount : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x4E8, 0x178, 0x80;
    int     bossHealth : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8, 0x58, 0x40, 0x38, 0x30;
    int   lesmesHealth : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8, 0x58, 0x40, 0x38, 0x50;
    int  infantaHealth : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8, 0x58, 0x40, 0x38, 0x70;
}

state("Blasphemous 2", "1.1.0")
{
    bool     isPlaying : "GameAssembly.dll", 0x33A63D8, 0xB8, 0xE0,  0x30, 0x190;
    uint     earlyRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x268, 0x20, 0x14;
    uint      mainRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x2C8, 0x28, 0x0;
    uint      lateRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x3C0, 0x150, 0x70;
    int     enemyCount : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x4F0, 0x1E8, 0x10;
    int     bossHealth : 0;
    int   lesmesHealth : 0;
    int  infantaHealth : 0;
}

start
{
    if (old.mainRoom == 0 && current.mainRoom != 0)
    {
        vars.roomsEntered.Clear(); 
        vars.eviternoP1 = false;
        return true;
    }
}

split
{

    if(current.mainRoom == 0x5DD4E45B && old.mainRoom != 0x5DD4E45B && settings["emery"] && !vars.roomsEntered.Contains("emery")){ vars.roomsEntered.Add("emery"); return true; }
    bool afilaor = current.mainRoom == 0x5DD4E45B && current.earlyRoom == 0x5DD4E45B && current.bossHealth == 0 && old.bossHealth != 0 && settings["afilaor"];

    if (current.mainRoom == 0x4D00F491 && old.mainRoom != 0x4D00F491 && settings["faceless_entry"] && !vars.roomsEntered.Contains("faceless")) { vars.roomsEntered.Add("faceless"); return true; }
    bool faceless = current.mainRoom == 0x4D00F491 && current.earlyRoom == 0x4D00F491 && current.bossHealth == 0 && old.bossHealth != 0 && settings["faceless"];

    if (current.mainRoom == 0x07B20B3D && old.mainRoom != 0x07B20B3D && settings["radames_entry"] && !vars.roomsEntered.Contains("radames")) { vars.roomsEntered.Add("radames"); return true; }
    bool radames = current.mainRoom == 0x07B20B3D && current.earlyRoom == 0x07B20B3D && current.lateRoom == 0x07B20B3D && current.bossHealth == 0 && old.bossHealth != 0 && settings["radames"];

    if (current.mainRoom == 0xAA597F36 && old.mainRoom != 0xAA597F36 && settings["orospina_entry"] && !vars.roomsEntered.Contains("orospina")) { vars.roomsEntered.Add("orospina"); return true; }
    bool orospina = current.mainRoom == 0xAA597F36 && current.earlyRoom == 0xAA597F36 && current.lateRoom == 0xAA597F36 && current.bossHealth == 0 && old.bossHealth != 0 && settings["orospina"];

    if (current.mainRoom == 0x07B20A5A && old.mainRoom != 0x07B20A5A && settings["lesmes_entry"] && !vars.roomsEntered.Contains("lesmes")) { vars.roomsEntered.Add("lesmes"); return true; }
    bool lesmes = current.mainRoom == 0x07B20A5A && current.earlyRoom == 0x07B20A5A && current.lateRoom == 0x07B20A5A && current.lesmesHealth == 0 && current.infantaHealth == 0 && (old.lesmesHealth != 0 || old.infantaHealth != 0) && settings["lesmes"];

    if (current.mainRoom == 0xF8126136 && old.mainRoom != 0xF8126136 && settings["benedicta_entry"] && !vars.roomsEntered.Contains("benedicta")) { vars.roomsEntered.Add("benedicta"); return true; }
    bool benedicta = current.mainRoom == 0xF8126136 && current.earlyRoom == 0xF8126136 && current.bossHealth == 0 && old.bossHealth != 0 && settings["benedicta"];

    if (current.mainRoom == 0xF8126154 && old.mainRoom != 0xF8126154 && settings["odon_entry"] && !vars.roomsEntered.Contains("odon")) { vars.roomsEntered.Add("odon"); return true; }
    bool odon = current.mainRoom == 0xF8126154 && current.earlyRoom == 0xF8126154 && current.lateRoom == 0xF8126154 && current.bossHealth == 0 && old.bossHealth != 0 && settings["odon"];

    if (current.mainRoom == 0x556AEC39 && old.mainRoom != 0x556AEC39 && settings["sinodo_entry"] && !vars.roomsEntered.Contains("sinodo")) { vars.roomsEntered.Add("sinodo"); return true; }
    bool sinodo = current.mainRoom == 0x556AEC39 && current.earlyRoom == 0x556AEC39 && current.lateRoom == 0x556AEC39 && current.bossHealth == 0 && old.bossHealth != 0 && settings["sinodo"];

    if (current.mainRoom == 0x556AEC59 && old.mainRoom != 0x556AEC59 && settings["susona_entry"] && !vars.roomsEntered.Contains("susona")) { vars.roomsEntered.Add("susona"); return true; }
    bool susona = current.mainRoom == 0x556AEC59 && current.earlyRoom == 0x556AEC59 && current.lateRoom == 0x556AEC59 && current.bossHealth == 0 && old.bossHealth != 0 && settings["susona"];

    if (current.mainRoom == 0x9AB9D533 && old.mainRoom != 0x9AB9D533 && settings["eviterno_entry"] && !vars.roomsEntered.Contains("eviterno")) { vars.roomsEntered.Add("eviterno"); return true; }
    if (current.mainRoom == 0x9AB9D533 && current.earlyRoom == 0x9AB9D533 && current.lateRoom == 0x9AB9D533 && current.bossHealth == 0 && old.bossHealth != 0 && settings["eviterno_p1"]) { vars.eviternoP1 = true; return true; }
    bool eviterno = current.mainRoom == 0x9AB9D533 && current.earlyRoom == 0x9AB9D533 && current.lateRoom == 0x9AB9D533 && current.bossHealth == 0 && old.bossHealth != 0 && settings["eviterno"] && vars.eviternoP1;

    if (current.mainRoom == 0x9AB9D532 && old.mainRoom != 0x9AB9D532 && settings["devotion_entry"] && !vars.roomsEntered.Contains("devotion")) { vars.roomsEntered.Add("devotion"); return true; }
    bool devotion = current.mainRoom == 0x9AB9D532 && current.earlyRoom == 0x9AB9D533 && current.lateRoom == 0x9AB9D532 && current.bossHealth == 0 && old.bossHealth != 0 && settings["devotion"];

    return afilaor || faceless || radames || orospina || lesmes || benedicta || odon || sinodo || susona || eviterno || devotion;
}

isLoading
{
    return !current.isPlaying || current.mainRoom == 0;
}

startup
{
	print("BlasII initialization");
    
    vars.killedBosses = new List<uint>();
    vars.roomsEntered = new List<uint>();
    
    var bossSplits = new Dictionary<uint, string>()
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
        { 0x9AB9D533, "Eviterno phase 1" },
        { 0x00000000, "Eviterno phase 2" },
        { 0x9AB9D532, "Devotion Incarnate" },
    };
    print("Loaded " + bossSplits.Count + " bosses");
	
	var roomSplits = new Dictionary<uint, string>()
    {
	    { 0x5DD4E45B, "Afilaor room" },
        //{ 0x00, "Crimson Rains" },
    };
    print("Loaded " + roomSplits.Count + " rooms");
	
	// Add header settings
    settings.Add("bosses", true, "Bosses");
    settings.Add("rooms", true, "Rooms");
    
    // Add boss settings
    settings.CurrentDefaultParent = "bosses";
    foreach (var boss in bossSplits)
    {
        settings.Add("B_" + boss.Key, false, boss.Value);
    }
    
    // Add room settings
    settings.CurrentDefaultParent = "rooms";
    foreach (var room in roomSplits)
    {
        settings.Add("R_" + room.Key, false, room.Value);
    }

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
