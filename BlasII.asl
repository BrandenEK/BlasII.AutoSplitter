
state("Blasphemous 2", "Unknown")
{
    bool   isPlaying : 0;
    uint   mainRoom1 : 0;
    uint   mainRoom2 : 0;
    float bossDeath1 : 0;
    float bossDeath2 : 0;
    float bossDeath3 : 0;
}

state("Blasphemous 2", "1.0.5")
{
    bool   isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0, 0x30, 0x190;
    uint   mainRoom1 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x2D0, 0x28, 0x0;
    uint   mainRoom2 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x538, 0x30, 0x0;
    float bossDeath1 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x28;
    float bossDeath2 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x2C;
    float bossDeath3 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x30;
}

state("Blasphemous 2", "1.1.0")
{
    bool   isPlaying : "GameAssembly.dll", 0x33A63D8, 0xB8, 0xE0, 0x30, 0x190;
    uint   mainRoom1 : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x2C8, 0x28, 0x0;
    uint   mainRoom2 : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x540, 0x30, 0x0;
    float bossDeath1 : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x150, 0x28;
    float bossDeath2 : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x150, 0x2C;
    float bossDeath3 : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x150, 0x30;
}

state("Blasphemous 2", "2.1.1")
{
    bool   isPlaying : "GameAssembly.dll", 0x39C4120, 0xB8, 0xF8, 0x30, 0x190;
    uint   mainRoom1 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x340, 0x28, 0x0;
    uint   mainRoom2 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x5C8, 0x30, 0x0;
    float bossDeath1 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x28;
    float bossDeath2 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x2C;
    float bossDeath3 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x30;
    
    bool  inputBlocked : "GameAssembly.dll", 0x39C4120, 0xB8, 0x10, 0x78;
    float    positionX : "GameAssembly.dll", 0x39C4120, 0xB8, 0x5D0, 0x60, 0x00;
    float    positionY : "GameAssembly.dll", 0x39C4120, 0xB8, 0x5D0, 0x60, 0x04;
}

state("Blasphemous 2", "2.2.0")
{
    bool   isPlaying : "GameAssembly.dll", 0x039F3C38, 0xB8, 0xF8, 0x30, 0x190;
    uint   mainRoom1 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x340, 0x28, 0x0;
    uint   mainRoom2 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x5C8, 0x30, 0x0;
    float bossDeath1 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x180, 0x28;
    float bossDeath2 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x180, 0x2C;
    float bossDeath3 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x180, 0x30;
    bool  inputBlocked : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x10, 0x78;
    int   enemyCount : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x478, 0x18, 0x30;
}

start
{
    uint oldRoom = Math.Max(old.mainRoom1, old.mainRoom2);
    uint currentRoom = Math.Max(current.mainRoom1, current.mainRoom2);

    if (oldRoom == currentRoom)
        return false;
    
    return settings["time_file"] && oldRoom == 0x00
        || settings["time_weapon"] && currentRoom == 0x9AB9D550
        || settings["time_penitence1"] && currentRoom == 0xEFA86932
        || settings["time_penitence2"] && oldRoom == 0xEFA86932;
}

onStart
{
    print("Resetting cleared splits");
    vars.bossSplits.Clear();
    vars.roomSplits.Clear();
}

split
{
    uint oldRoom = Math.Max(old.mainRoom1, old.mainRoom2);
    uint currentRoom = Math.Max(current.mainRoom1, current.mainRoom2);

    if (current.enemyCount != old.enemyCount)
        print("Enemy different");
    if (!old.inputBlocked && current.inputBlocked)
        print("Input different");
    if (current.enemyCount != old.enemyCount && !old.inputBlocked && current.inputBlocked)
        print("Enemy and input same time");

    // Bosses

    if (old.bossDeath1 != current.bossDeath1 || old.bossDeath2 != current.bossDeath2 || old.bossDeath3 != current.bossDeath3)
    {
        if (settings["B_" + currentRoom] && !vars.bossSplits.Contains(currentRoom))
        {
            print("Splitting on boss: " + currentRoom);
            vars.bossSplits.Add(currentRoom);
            return true;
        }
    }

    // Rooms

    if (oldRoom != currentRoom)
    {
        if (settings["R_" + currentRoom] && !vars.roomSplits.Contains(currentRoom))
        {
            print("Splitting on room: " + currentRoom);
            vars.roomSplits.Add(currentRoom);
            return true;
        }
    }

    return false;
}

isLoading
{
    uint oldRoom = Math.Max(old.mainRoom1, old.mainRoom2);
    uint currentRoom = Math.Max(current.mainRoom1, current.mainRoom2);

    return !current.isPlaying || currentRoom == 0;
}

startup
{
    // General

    //settings.Add("general", true, "General");

    // Time start
    settings.Add("time", true, "When to start timer");
    settings.Add("time_file", false, "File select", "time");
    settings.Add("time_weapon", true, "Enter weapon selection", "time");
    settings.Add("time_penitence1", false, "Enter penitence selection", "time");
    settings.Add("time_penitence2", false, "Exit penitence selection", "time");

    var zoneNames = new Dictionary<string, string>()
    {
        { "Z01", "Repose of the Silent One" },
        { "Z02", "Ravine of the High Stones" },
        { "Z03", "Aqueduct of the Costales" },
        { "Z04", "Sacred Entombments" },
        { "Z05", "City of the Blessed Name" },
        { "Z06", "Grilles and Ruins" },
        { "Z07", "Palace of the Embroideries" },
        { "Z08", "Choir of Thorns" },
        { "Z09", "Crown of Towers" },
        { "Z10", "Elevated Temples" },
        { "Z11", "Basilica of Absent Faces" },
        { "Z12", "Sunken Cathedral" },
        { "Z13", "Two Moons" },
        { "Z14", "Mother of Mothers" },
        { "Z15", "Dreams of Incense" },
        { "Z16", "The Severed Tower" },
        { "Z17", "Streets of Wakes" },
        { "Z18", "Crimson Rains" },
        { "Z19", "Profundo Lamento" },
        { "Z20", "Sea of Ink" },
        { "Z21", "Labyrinth of Tides" },
        { "Z23", "Beneath Her Sacred Grounds" },
        { "Z24", "Garden of the High Choirs" },
        { "Z25", "Chapel of the Five Doves" },
        { "Z26", "Forlorn Patio" },
        { "Z27", "Icebound Mausoleum" },
        { "Z28", "Santa Vigilia" }
    };

    // Bosses

    var bossSettings = new Dictionary<uint, string>()
    {
        { 0x4D00F491, "Faceless One, Chisel of Oblivion" },
        { 0x07B20B3D, "Great Preceptor Radamés" },
        { 0xAA597F36, "Orospina, Lady Embroiderer" },
        { 0x07B20A5A, "Lesmes & Infanta" },
        { 0x5DD4E45B, "Afilaor, Sentinel of the Emery" },
        { 0xF8126136, "Benedicta of the Endless Orison" },
        { 0xF8126154, "Odón of the Confraternity of Salt" },
        { 0x556AEC39, "Sínodo, Hymn of the Thousand Voices" },
        { 0x556AEC59, "Svsona, Fermosa Fembra" },
        { 0x9AB9D533, "Eviterno doesn't work yet, sorry :(" },
        { 0x9AB9D532, "Incarnate Devotion" },
        { 0x45CB41B1, "Sor Cautiva del Silencio" },
        { 0xA323CD29, "Brother Asterión" }
    };
    print("Loaded " + bossSettings.Count + " bosses");
    vars.bossSplits = new List<uint>();

    settings.Add("bosses", true, "Bosses");
    foreach (var boss in bossSettings)
    {
        settings.Add("B_" + boss.Key, false, boss.Value, "bosses");
    }

    // Rooms

    var roomSettings = new Dictionary<uint, string>()
    {
        { 0x4D00F491, "Z01:Boss room" },
        { 0x07B20B3D, "Z04:Boss room" },
        { 0x4D00F471, "Z04:Teleport room" },
        { 0x07B20B3B, "Z04:Veredicto weapon room" },
        { 0x81D8A9E4, "Z05:Confessor room" },
        { 0x81D8A9E5, "Z05:Sculptor room" },
        { 0x81D8A9E6, "Z05:Shop room" },
        { 0x4D00F418, "Z05:Teleport room" },
        { 0xAA597F36, "Z07:Boss room" },
        { 0x4D00F3CA, "Z07:Sarmiento weapon room" },
        { 0x07B20A94, "Z07:Teleport room" },
        { 0xEFA8688A, "Z08:Sarmiento upgrade room" },
        { 0xEFA86893, "Z08:Teleport room west" },
        { 0x07B20ABA, "Z08:Teleport room center" },
        { 0x07B20AB3, "Z08:Teleport room east" },
        { 0x07B20A53, "Z09:Air dash room" },
        { 0x07B20A5A, "Z09:Boss room" },
        { 0x07B20A62, "Z09:Ruego upgrade room" },
        { 0xEFA86829, "Z09:Ruego weapon room" },
        { 0xAA597EF5, "Z09:Teleport room" },
        { 0xE008BF66, "Z10:Sarmiento upgrade room" },
        { 0xF8126195, "Z10:Teleport room" },
        { 0xF8126191, "Z10:Veredicto upgrade room" },
        { 0xF8126136, "Z11:Boss room" },
        { 0xF8126154, "Z12:Boss room" },
        { 0xF8126155, "Z12:Teleport room" },
        { 0x9AB9D5EC, "Z12:Veredicto upgrade room" },
        { 0x556AEC59, "Z13:Boss room" },
        { 0x556AEC79, "Z14:Teleport room" },
        { 0x9AB9D54C, "Z15:Dove room" },
        { 0x556AEC39, "Z16:Boss room" },
        { 0xF81260D5, "Z16:Cherub ring room" },
        { 0xF81260D3, "Z16:Teleport room" },
        { 0x9AB9D512, "Z17:Teleport room" },
        { 0x9AB9D533, "Z18:Boss room (Eviterno)" },
        { 0x9AB9D532, "Z18:Boss room (Devotion)" },
        { 0x9AB9D526, "Z18:Teleport room" },
        { 0xF8126038, "Z19:Wall climb room" },
        { 0xE872B705, "Z21:Teleport room" },
        { 0x5DD4E45B, "Z23:Boss room" },
        { 0x5DD4E457, "Z23:Double jump room" },
        { 0x007C58FA, "Z23:Ruego upgrade room" },
        { 0x5DD4E462, "Z23:Teleport room" },
        //{ 0x00, "Z25:Dove room" },
        //{ 0x00, "Z26:Shop room" },
        { 0x45CB41B1, "Z27:Boss room" },
        { 0x007C587B, "Z27:Teleport room" },
        { 0x5DD4E3F6, "Z28:Boss room (First)" },
        { 0xA323CD29, "Z28:Boss room (Second)" },
        { 0x5DD4E3F7, "Z28:Teleport room west" },
        { 0xA323CD2C, "Z28:Teleport room east" }
    };
    print("Loaded " + roomSettings.Count + " rooms");
    vars.roomSplits = new List<uint>();

    settings.Add("rooms", true, "Rooms");
    foreach (var zone in zoneNames)
    {
        settings.Add("R_" + zone.Key, true, zone.Value, "rooms");
    }

    foreach (var room in roomSettings)
    {
        string zone = room.Value.Substring(0, room.Value.IndexOf(':'));
        string name = room.Value.Substring(room.Value.IndexOf(':') + 1);

        settings.Add("R_" + room.Key, false, name, "R_" + zone);
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
    bool modded = modules.Any(x => x.ModuleName == "dobby.dll");

    print("BlasII module size: " + size);
    print("BlasII dobby present: " + modded);
    
    switch (size)
    {
        case 62201856:  version = "1.0.5";    break;
        case 62459904:  version = "1.1.0";    break;
        case 69939200:  version = "2.1.1";    break;
        case 70152192:  version = "2.2.0";    break;
        default:        version = "Unknown";  break;
    }
}
