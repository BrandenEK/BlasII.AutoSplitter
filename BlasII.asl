state("Blasphemous 2", "Unknown")
{
    bool           isPlaying : 0;
    uint           earlyRoom : 0;
    uint            mainRoom : 0;
    uint            lateRoom : 0;
    int           bossHealth : 0;
    int         lesmesHealth : 0;
    int        infantaHealth : 0;
    int         playerHealth : 0;
    bool       isInputLocked : 0;
    float    playerPositionX : 0;
}

state("Blasphemous 2", "1.0.5")
{
    bool           isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8,  0xE0,  0x30,  0x190;
    uint           earlyRoom : "GameAssembly.dll", 0x336A6F0, 0xB8,  0x270, 0x20,  0x14;
    uint            mainRoom : "GameAssembly.dll", 0x336A6F0, 0xB8,  0x2D0, 0x28,  0x0;
    uint            lateRoom : "GameAssembly.dll", 0x336A6F0, 0xB8,  0x3C8, 0x150, 0x70;
    int           bossHealth : "GameAssembly.dll", 0x336A6F0, 0xB8,  0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8,  0x58,  0x40,  0x38,  0x30;
    int         lesmesHealth : "GameAssembly.dll", 0x336A6F0, 0xB8,  0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8,  0x58,  0x40,  0x38,  0x50;
    int        infantaHealth : "GameAssembly.dll", 0x336A6F0, 0xB8,  0x40,  0x80,  0x6A8, 0x210, 0x478, 0xB8,  0x58,  0x40,  0x38,  0x70;
    int         playerHealth : "GameAssembly.dll", 0x336A6F0, 0xB8,  0x1E8, 0x18,  0x20,  0x30,  0x90,  0x18,  0x120, 0x98;
    bool       isInputLocked : "GameAssembly.dll", 0x336A6F0, 0xB8,  0x468, 0xB0, 0x78;
    float    playerPositionX : "GameAssembly.dll", 0x336A6F0, 0xB8,  0xE0,  0x38,  0x60,  0x48,  0xDC;
}

state("Blasphemous 2", "1.1.0")
{
    bool           isPlaying : "GameAssembly.dll", 0x33A63D8, 0xB8, 0xE0,  0x30,  0x190;
    uint           earlyRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x268, 0x20,  0x14;
    uint            mainRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x2C8, 0x28,  0x0;
    uint            lateRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x3C0, 0x150, 0x70;
    int           bossHealth : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x1C0, 0x0,   0x438, 0xA8,  0xA30, 0x0,   0x7C8, 0x40,  0x38,  0x30;
    int         lesmesHealth : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x1C0, 0x0,   0x438, 0xA8,  0xA30, 0x0,   0x7C8, 0x40,  0x38,  0x50;
    int        infantaHealth : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x1C0, 0x0,   0x438, 0xA8,  0xA30, 0x0,   0x7C8, 0x40,  0x38,  0x70;
    int         playerHealth : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x268, 0x38,  0x208, 0x2B8, 0x1C0, 0x148;
    bool       isInputLocked : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x10,  0x78;
    float    playerPositionX : "GameAssembly.dll", 0x33A63D8, 0xB8, 0xE0,  0x38,  0x68,  0xE4;
}

start
{
    // Menu - 0x00, Spawn - 0x4D00F498, Weapon - 0x9AB9D550
    uint oldRoom = (uint)(settings["wstart"] ? 0x4D00F498 : 0);
    uint newRoom = (uint)(settings["wstart"] ? 0x9AB9D550 : 0x4D00F498);

    return old.mainRoom == oldRoom && current.mainRoom == newRoom;
}

onStart
{
    vars.bossSplits.Clear();
    vars.abilitySplits.Clear();
    vars.weaponSplits.Clear();
    vars.roomSplits.Clear();

    vars.shopsUsed.Clear();
    vars.isPhaseTwo = false;
}

split
{
    // Bosses

    if (settings["B_" + current.mainRoom] && !vars.bossSplits.Contains(current.mainRoom))
    {
        // Check if any bosses were just killed
        bool standard = current.bossHealth == 0 && old.bossHealth != 0 && current.mainRoom != 0x07B20A5A && old.playerHealth != 0;
        bool eviterno = current.bossHealth == 0 && old.bossHealth != 0 && current.mainRoom == 0x9AB9D533 && old.playerHealth != 0;
        bool lesmes = current.lesmesHealth == 0 && current.infantaHealth == 0 && (old.lesmesHealth != 0 || old.infantaHealth != 0) && current.mainRoom == current.earlyRoom && old.playerHealth != 0;

        // If it was eviterno phase 1, change the flag but dont split
        if (eviterno && !vars.isPhaseTwo)
        {
            vars.isPhaseTwo = true;
            return false;
        }

        // If it was a real boss, split
        if (standard || eviterno && vars.isPhaseTwo || lesmes)
        {
            vars.bossSplits.Add(current.mainRoom);
            return true;
        }
    }

    // Abilities

    if (settings["A_" + current.mainRoom] && current.earlyRoom == old.lateRoom && current.isInputLocked && !vars.abilitySplits.Contains(current.mainRoom))
    {
        vars.abilitySplits.Add(current.mainRoom);
        return true;
    }

    // Weapons

    if (settings["W_" + current.mainRoom] && current.earlyRoom == old.lateRoom && current.isInputLocked && !vars.weaponSplits.Contains(current.mainRoom))
    {
        if(current.mainRoom == 0x07B20A62 && (int) current.playerPositionX < 805)
            return false;

        vars.weaponSplits.Add(current.mainRoom);
        return true;
    }

    // Rooms

    if (current.mainRoom != old.mainRoom)
    {
        // Whenever changing rooms, reset the phase flag
        vars.isPhaseTwo = false;

        // Ensure that it was a valid room that was entered
        if (settings["R_" + current.mainRoom] && !vars.roomSplits.Contains(current.mainRoom))
        {
            vars.roomSplits.Add(current.mainRoom);
            return true;
        }
    }

    // Temp




    if (current.isInputLocked && settings["T_" + current.mainRoom] && !vars.shopsUsed.Contains(current.mainRoom))
    {
        bool standard = current.earlyRoom == old.lateRoom && current.lateRoom != 0x556AEBD6;
        bool patio = current.mainRoom == 0x5DD4E43B && (int) current.playerPositionX < 32;

        if (standard || patio)
        {
            vars.shopsUsed.Add(current.mainRoom);
            return true;
        }
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
    settings.Add("wstart", true, "Start timer on Weapon Select room");
    vars.isPhaseTwo = false;

    // Add header settings
    settings.Add("bosses", true, "Bosses");
    settings.Add("abilities", true, "Abilities");
    settings.Add("weapons", true, "Weapons");
    settings.Add("rooms", true, "Rooms");

    settings.Add("shops", true, "Shops/Teleporters");

    // Bosses

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
        { 0x9AB9D532, "Devotion Incarnate" }
    };
    print("Loaded " + bossSplits.Count + " bosses");
    vars.bossSplits = new List<uint>();

    settings.CurrentDefaultParent = "bosses";
    foreach (var boss in bossSplits)
    {
        settings.Add("B_" + boss.Key, false, boss.Value);
    }

    // Abilities

    var abilitySplits = new Dictionary<uint, string>()
    {
        { 0xF8126038, "Ivy of ascension (Wall jump)" },
        { 0x5DD4E457, "Passage of ash (Double jump)" },
        { 0x07B20A53, "Mercy of the wind (Air dash)" },
        { 0xF81260D5, "Scion's protection (Ring grab)" },
    };
    print("Loaded " + abilitySplits.Count + " abilities");
    vars.abilitySplits = new List<uint>();

    settings.CurrentDefaultParent = "abilities";
    foreach (var ability in abilitySplits)
    {
        settings.Add("A_" + ability.Key, false, ability.Value);
    }

    // Weapons

    var weaponSplits = new Dictionary<uint, string>()
    {
        { 0x07B20B3B, "Veredicto" },
        { 0x9AB9D5EC, "Veredicto - Sunken Cathedral" },
        { 0xF8126191, "Veredicto - Elevated Temples" },
        { 0xEFA86829, "Ruego" },
        { 0x007C58FA, "Ruego - Mother of Mothers" },
        { 0x07B20A62, "Ruego - Crown of Towers" },
        { 0x4D00F3CA, "Sarmiento" },
        { 0xE008BF66, "Sarmiento - Elevated Temples" },
        { 0xEFA8688A, "Sarmiento - Choir of Thorns" }
    };
    print("Loaded " + weaponSplits.Count + " weapons");
    vars.weaponSplits = new List<uint>();

    settings.CurrentDefaultParent = "weapons";
    foreach (var weapon in weaponSplits)
    {
        settings.Add("W_" + weapon.Key, false, weapon.Value);
    }

    // Rooms

    var roomSplits = new Dictionary<uint, string>()
    {
        { 0x4D00F491, "Faceless One room" },
        { 0x07B20B3D, "Radames room" },
        { 0xAA597F36, "Orospina room" },
        { 0x07B20A5A, "Lesmes room" },
        { 0xF8126115, "Mother of Mothers" },
        { 0x5DD4E45B, "Afilaor room" },
        { 0x9AB9D54C, "Dove room"},
        { 0xF8126136, "Benedicta room" },
        { 0xF8126154, "Odon room" },
        { 0x556AEC39, "Sinodo room" },
        { 0x556AEC59, "Svsona room" },
        { 0xF8126090, "Crimson Rains" },
        { 0x9AB9D533, "Eviterno room" },
        { 0x9AB9D532, "Devotion Incarnate room" }
    };
    print("Loaded " + roomSplits.Count + " rooms");
    vars.roomSplits = new List<uint>();

    settings.CurrentDefaultParent = "rooms";
    foreach (var room in roomSplits)
    {
        settings.Add("R_" + room.Key, false, room.Value);
    }

    // temp


    vars.shopsUsed = new List<uint>();

    
    
    

    var shopSplits = new Dictionary<uint, string>()
    {
        { 0xAA597EF5, "Crown of Towers teleporter"},
        { 0x4D00F471, "Sacred Entombments teleporter"},
        { 0xF8126195, "Elevated Temples Teleporter"},
        { 0x81D8A9E6, "City shop"},
        { 0x81D8A9E5, "The Sculptor"},
        { 0x81D8A9E4, "The Confessor"},
        { 0x5DD4E43B, "Forlorn Patio shop"},
    };
    print("Loaded " + shopSplits.Count + " shops/teleporters");

    //add shops settings
    settings.CurrentDefaultParent = "shops";
    foreach (var shop in shopSplits)
    {
        settings.Add("T_" + shop.Key, false, shop.Value);
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
