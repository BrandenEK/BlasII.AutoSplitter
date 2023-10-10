
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
    bool   isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0,  0x30,  0x190;
    uint   earlyRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x270, 0x20,  0x14;
    uint    mainRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x2D0, 0x28,  0x0;
    uint    lateRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x3C8, 0x150, 0x70;
    int   enemyCount : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x4E8, 0x178, 0x80;
    int       bossHP : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8, 0x58, 0x40, 0x38, 0x30;
    int     lesmesHP : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8, 0x58, 0x40, 0x38, 0x50;
    int    infantaHP : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8, 0x58, 0x40, 0x38, 0x70;
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
    bool afilaor = current.mainRoom == 0x5DD4E45B && current.earlyRoom == 0x5DD4E45B && current.bossHP == 0 && old.bossHP != 0 && settings["afilaor"];

    if (current.mainRoom == 0x4D00F491 && old.mainRoom != 0x4D00F491 && settings["faceless_entry"] && !vars.roomsEntered.Contains("faceless")) { vars.roomsEntered.Add("faceless"); return true; }
    bool faceless = current.mainRoom == 0x4D00F491 && current.earlyRoom == 0x4D00F491 && current.bossHP == 0 && old.bossHP != 0 && settings["faceless"];

    if (current.mainRoom == 0x07B20B3D && old.mainRoom != 0x07B20B3D && settings["radames_entry"] && !vars.roomsEntered.Contains("radames")) { vars.roomsEntered.Add("radames"); return true; }
    bool radames = current.mainRoom == 0x07B20B3D && current.earlyRoom == 0x07B20B3D && current.lateRoom == 0x07B20B3D && current.bossHP == 0 && old.bossHP != 0 && settings["radames"];

    if (current.mainRoom == 0xAA597F36 && old.mainRoom != 0xAA597F36 && settings["orospina_entry"] && !vars.roomsEntered.Contains("orospina")) { vars.roomsEntered.Add("orospina"); return true; }
    bool orospina = current.mainRoom == 0xAA597F36 && current.earlyRoom == 0xAA597F36 && current.lateRoom == 0xAA597F36 && current.bossHP == 0 && old.bossHP != 0 && settings["orospina"];

    if (current.mainRoom == 0x07B20A5A && old.mainRoom != 0x07B20A5A && settings["lesmes_entry"] && !vars.roomsEntered.Contains("lesmes")) { vars.roomsEntered.Add("lesmes"); return true; }
    bool lesmes = current.mainRoom == 0x07B20A5A && current.earlyRoom == 0x07B20A5A && current.lateRoom == 0x07B20A5A && current.lesmesHP == 0 && current.infantaHP == 0 && (old.lesmesHP != 0 || old.infantaHP != 0) && settings["lesmes"];

    if (current.mainRoom == 0xF8126136 && old.mainRoom != 0xF8126136 && settings["benedicta_entry"] && !vars.roomsEntered.Contains("benedicta")) { vars.roomsEntered.Add("benedicta"); return true; }
    bool benedicta = current.mainRoom == 0xF8126136 && current.earlyRoom == 0xF8126136 && current.bossHP == 0 && old.bossHP != 0 && settings["benedicta"];

    if (current.mainRoom == 0xF8126154 && old.mainRoom != 0xF8126154 && settings["odon_entry"] && !vars.roomsEntered.Contains("odon")) { vars.roomsEntered.Add("odon"); return true; }
    bool odon = current.mainRoom == 0xF8126154 && current.earlyRoom == 0xF8126154 && current.lateRoom == 0xF8126154 && current.bossHP == 0 && old.bossHP != 0 && settings["odon"];

    if (current.mainRoom == 0x556AEC39 && old.mainRoom != 0x556AEC39 && settings["sinodo_entry"] && !vars.roomsEntered.Contains("sinodo")) { vars.roomsEntered.Add("sinodo"); return true; }
    bool sinodo = current.mainRoom == 0x556AEC39 && current.earlyRoom == 0x556AEC39 && current.lateRoom == 0x556AEC39 && current.bossHP == 0 && old.bossHP != 0 && settings["sinodo"];

    if (current.mainRoom == 0x556AEC59 && old.mainRoom != 0x556AEC59 && settings["susona_entry"] && !vars.roomsEntered.Contains("susona")) { vars.roomsEntered.Add("susona"); return true; }
    bool susona = current.mainRoom == 0x556AEC59 && current.earlyRoom == 0x556AEC59 && current.lateRoom == 0x556AEC59 && current.bossHP == 0 && old.bossHP != 0 && settings["susona"];

    if (current.mainRoom == 0x9AB9D533 && old.mainRoom != 0x9AB9D533 && settings["eviterno_entry"] && !vars.roomsEntered.Contains("eviterno")) { vars.roomsEntered.Add("eviterno"); return true; }
    if (current.mainRoom == 0x9AB9D533 && current.earlyRoom == 0x9AB9D533 && current.lateRoom == 0x9AB9D533 && current.bossHP == 0 && old.bossHP != 0 && settings["eviterno_p1"]) { vars.eviternoP1 = true; return true; }
    bool eviterno = current.mainRoom == 0x9AB9D533 && current.earlyRoom == 0x9AB9D533 && current.lateRoom == 0x9AB9D533 && current.bossHP == 0 && old.bossHP != 0 && settings["eviterno"] && vars.eviternoP1;

    if (current.mainRoom == 0x9AB9D532 && old.mainRoom != 0x9AB9D532 && settings["devotion_entry"] && !vars.roomsEntered.Contains("devotion")) { vars.roomsEntered.Add("devotion"); return true; }
    bool devotion = current.mainRoom == 0x9AB9D532 && current.earlyRoom == 0x9AB9D533 && current.lateRoom == 0x9AB9D532 && current.bossHP == 0 && old.bossHP != 0 && settings["devotion"];

    return afilaor || faceless || radames || orospina || lesmes || benedicta || odon || sinodo || susona || eviterno || devotion;
}

isLoading
{
    return !current.isPlaying || current.mainRoom == 0;
}

startup
{

    settings.Add("bosses", true, "Boss Splits");
    settings.Add("faceless_entry", false, "Reach The Faceless One", "bosses");
    settings.Add("faceless", false, "Defeat The Faceless One", "bosses");
    settings.Add("radames_entry", false, "Reach Radames", "bosses");
    settings.Add("radames", false, "Defeat Radames", "bosses");
    settings.Add("lesmes_entry", false, "Reach Lesmes & Infanta", "bosses");
    settings.Add("lesmes", false, "Defeat Lesmes & Infanta", "bosses");
    settings.Add("orospina_entry", false, "Reach Orospina", "bosses");
    settings.Add("orospina", false, "Defeat Orospina", "bosses");
    settings.Add("benedicta_entry", false, "Reach Benedicta", "bosses");
    settings.Add("benedicta", false, "Defeat Benedicta", "bosses");
    settings.Add("odon_entry", false, "Reach Odon", "bosses");
    settings.Add("odon", false, "Defeat Odon", "bosses");
    settings.Add("sinodo_entry", false, "Reach Sinodo", "bosses");
    settings.Add("sinodo", false, "Defeat Sinodo", "bosses");
    settings.Add("susona_entry", false, "Reach Susona", "bosses");
    settings.Add("susona", false, "Defeat Susona", "bosses");
    settings.Add("eviterno_entry", false, "Reach Eviterno", "bosses");
    settings.Add("eviterno_p1", false, "Defeat Eviterno phase 1","bosses");
    settings.Add("eviterno", false, "Defeat Eviterno", "bosses");
    settings.Add("devotion_entry", false, "Reach Devotion", "bosses");

    settings.Add("full", true, "Any% Ending");
    settings.Add("devotion", false, "Defeat Devotion Incarnate", "full");
    
    settings.Add("level", true, "Afilaor% Ending");
    settings.Add("emery", false, "Reach Sentinel of the Emery", "level");
    settings.Add("afilaor", false, "Defeat Afilaor", "level");
    

    vars.roomsEntered = new List<string>();
    vars.eviternoP1 = new bool();

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
