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
    bool isInputLocked : 0;
    bool  isItemPickUp : 0;
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
    bool isInputLocked : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x510, 0x198, 0x78;
    bool  isItemPickUp : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x3C8, 0x38,  0xA8,  0x18,  0x258, 0x70;
    //float characterPositionX: "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0,  0x38,  0x60,  0x148, 0x274; //not implemented
    //float characterPositionY: "GameAssembly.dll", 0x336A6F0, 0xB8, 0xB8,  0x10,  0x150, 0x288, 0xDC;

}

state("Blasphemous 2", "1.1.0")
{
    bool     isPlaying : "GameAssembly.dll", 0x33A63D8, 0xB8, 0xE0,  0x30,  0x190;
    uint     earlyRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x268, 0x20,  0x14;
    uint      mainRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x2C8, 0x28,  0x0;
    uint      lateRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x3C0, 0x150, 0x70;
    int     enemyCount : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x4F0, 0x1E8, 0x10;
    int     bossHealth : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x1C0, 0x0,   0x438, 0xA8, 0xA30, 0x0, 0x7C8, 0x40, 0x38, 0x30;
    int   lesmesHealth : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x1C0, 0x0,   0x438, 0xA8, 0xA30, 0x0, 0x7C8, 0x40, 0x38, 0x50;
    int  infantaHealth : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x1C0, 0x0,   0x438, 0xA8, 0xA30, 0x0, 0x7C8, 0x40, 0x38, 0x70;
    bool isInputLocked : 0;
    bool  isItemPickUp : 0;
}

start
{
    if (old.mainRoom == 0 && current.mainRoom != 0)
    {
        vars.bossesKilled.Clear();
        vars.roomsEntered.Clear();
        vars.itemsAcquired.Clear();
        vars.abilitiesAcquired.Clear();
        vars.isPhaseTwo = false;
        return true;
    }
}

split
{
    if (settings["B_" + current.mainRoom] && !vars.bossesKilled.Contains(current.mainRoom))
    {
        // Check if any bosses were just killed
        bool standard = current.bossHealth == 0 && old.bossHealth != 0 && current.mainRoom == current.earlyRoom && current.mainRoom != 0x07B20A5A;
        bool eviterno = current.bossHealth == 0 && old.bossHealth != 0 && current.mainRoom == 0x9AB9D533 && current.earlyRoom == 0x9AB9D533;
        bool devotion = current.bossHealth == 0 && old.bossHealth != 0 && current.mainRoom == 0x9AB9D532 && current.earlyRoom == 0x9AB9D533;
        bool lesmes = current.lesmesHealth == 0 && current.infantaHealth == 0 && (old.lesmesHealth != 0 || old.infantaHealth != 0) && current.mainRoom == current.earlyRoom;

        // If it was eviterno phase 1, change the flag but dont split
        if (eviterno && !vars.isPhaseTwo)
        {
            vars.isPhaseTwo = true;
            return false;
        }

        // If it was a real boss, split
        if (standard || eviterno && vars.isPhaseTwo || devotion || lesmes)
        {
            vars.bossesKilled.Add(current.mainRoom);
            return true;
        }
    }

    if (current.mainRoom != old.mainRoom)
    {
        // Whenever changing rooms, reset the phase flag
        vars.isPhaseTwo = false;

        // Ensure that it was a valid room that was entered
        if (settings["R_" + current.mainRoom] && !vars.roomsEntered.Contains(current.mainRoom))
        {
            vars.roomsEntered.Add(current.mainRoom);
            return true;
        }
    }

    if (current.mainRoom == current.lateRoom && isItemPickUp && settings["I_" + current.mainRoom] && !vars.itemAcquired.Contains(current.mainRoom))
    {
        vars.itemsAcquired.Add(current.mainRoom);
        return true;
    }

    if (current.mainRoom == current.lateRoom && isInputLocked && settings["A_" + current.mainRoom] && !vars.abilitiesAcquired.Contains(current.mainRoom))
    {
        vars.abilitiesAcquired.Add(current.mainRoom);
        return true;
    }

    return false;
}

isLoading
{
    return !current.isPlaying || current.mainRoom == 0;
}

startup
{
    print("BlasII initialization");
    
    vars.bossesKilled = new List<uint>();
    vars.roomsEntered = new List<uint>();
    vars.itemsAcquired = new List<uint>();
    vars.abilitiesAcquired = new List<uint>();
    vars.isPhaseTwo = false;
    
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
        { 0x9AB9D533, "Eviterno" },
        { 0x9AB9D532, "Devotion Incarnate" },
    };
    print("Loaded " + bossSplits.Count + " bosses");
    
    var roomSplits = new Dictionary<uint, string>()
    {
        { 0x4D00F491, "Faceless One room" },
        { 0x4D00F471, "Sacred Entombments teleporter" },
        { 0x07B20B3D, "Radames room" },
        { 0xAA597F36, "Orospina room" },
        { 0xAA597EF5, "Crown of Towers teleporter" },
        { 0x07B20A5A, "Lesmes room" },
        { 0x5DD4E45B, "Afilaor room" },
        { 0x9AB9D54C, "Dove room"},
        { 0xF8126136, "Benedicta room" },
        { 0xF8126154, "Odon room" },
        { 0x556AEC39, "Sinodo room" },
        { 0x556AEC59, "Svsona room" },
        { 0xF8126090, "Crimson Rains" },
        { 0x9AB9D533, "Eviterno room" },
        { 0x9AB9D532, "Devotion Incarnate room" },
    };
    print("Loaded " + roomSplits.Count + " rooms");

    var itemSplits = new Dictionary<list<int>, string>()
    {
        { 0x00000000, "item"}
    }
    print("Loaded " + itemSplits.Count + " items");

    var abilitiesSplits = new Dictionary<list<int>, string>()
    {
        { 0xF8126038, "Ivy of ascension (Wall jump)"},
        { 0x5DD4E457, "Passage of ash (Double jump)"},
        { 0x07B20A53, "Mercy of the wind (Air dash)"},
        { 0xF81260D5, "Scion's protection (Ring grab)"},
        { 0x07B20B3B, "Veredicto"},
        { 0x9AB9D5EC, "Veredicto Sunken Cathedral upgrade"},
        { 0xF8126191, "Veredicto Elevated Temples upgrade"},
        { 0xEFA86829, "Ruego"},
        { 0x007C58FA, "Ruego Mother of Mothers upgrade"},
        { 0x07B20A62, "Ruego Crown of Towers upgrade"},
        { 0x4D00F3CA, "Sarmiento & Cantella"},
        { 0xE008BF66, "S&C Elevated Temples upgrade"},
        { 0xEFA8688A, "S&C Choir of Thorns upgrade"},
    }
    print("Loaded " + abilitySplits.Count + " abilities");
    
    // Add header settings
    settings.Add("bosses", true, "Bosses");
    settings.Add("rooms", true, "Rooms");
    settings.Add("items", true, "Items");
    settings.Add("abilities", true, "Abilities/Weapons");

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

    //add items settings
    settings.CurrentDefaultParent = "items";
    foreach (var item in itemSplits)
    {
        settings.Add("I_" + item.Key, false, item.Value);
    }

    //add items settings
    settings.CurrentDefaultParent = "abilities";
    foreach (var ability in abilitySplits)
    {
        settings.Add("A_" + ability.Key, false, ability.Value);
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
