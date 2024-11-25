
state("Blasphemous 2", "Unknown")
{
    bool   isPlaying : 0;
    uint    mainRoom : 0;
    float bossDeath1 : 0;
    float bossDeath2 : 0;
    float bossDeath3 : 0;
}

state("Blasphemous 2", "1.0.5")
{
    bool   isPlaying : "GameAssembly.dll", 0x336A6F0, 0xB8, 0xE0, 0x30, 0x190;
    uint    mainRoom : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x538, 0x30, 0x0;
    float bossDeath1 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x28;
    float bossDeath2 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x2C;
    float bossDeath3 : "GameAssembly.dll", 0x336A6F0, 0xB8, 0x150, 0x30;
}

state("Blasphemous 2", "1.1.0")
{
    bool   isPlaying : "GameAssembly.dll", 0x33A63D8, 0xB8, 0xE0, 0x30, 0x190;
    uint    mainRoom : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x3C0, 0x250, 0x30, 0x0;
    float bossDeath1 : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x150, 0x28;
    float bossDeath2 : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x150, 0x2C;
    float bossDeath3 : "GameAssembly.dll", 0x33A63D8, 0xB8, 0x150, 0x30;
}

state("Blasphemous 2", "2.1.1")
{
    bool   isPlaying : "GameAssembly.dll", 0x39C4120, 0xB8, 0xF8, 0x30, 0x190;
    uint    mainRoom : "GameAssembly.dll", 0x39C4120, 0xB8, 0x5C8, 0x30, 0x0;
    float bossDeath1 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x28;
    float bossDeath2 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x2C;
    float bossDeath3 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x30;
}

start
{
    // Menu - 0x00, Spawn - 0x4D00F498, Weapon - 0x9AB9D550
    uint oldRoom = (uint)(settings["wstart"] ? 0x4D00F498 : 0);

    return old.mainRoom == oldRoom && current.mainRoom != oldRoom;
}

onStart
{
    print("Resetting cleared splits");
    vars.bossSplits.Clear();
    vars.roomSplits.Clear();
}

split
{
    // Bosses

    if (old.bossDeath1 != current.bossDeath1 || old.bossDeath2 != current.bossDeath2 || old.bossDeath3 != current.bossDeath3)
    {
        if (settings["B_" + current.mainRoom] && !vars.bossSplits.Contains(current.mainRoom))
        {
            print("Splitting on boss: " + current.mainRoom);
            vars.bossSplits.Add(current.mainRoom);
            return true;
        }
    }

    // Rooms

    if (old.mainRoom != current.mainRoom)
    {
        if (settings["R_" + current.mainRoom] && !vars.roomSplits.Contains(current.mainRoom))
        {
            print("Splitting on room: " + current.mainRoom);
            vars.roomSplits.Add(current.mainRoom);
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
    // General

    settings.Add("general", true, "General");
    settings.Add("wstart", true, "Start timer on Weapon Select room", "general");

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
        //{ 0x9AB9D533, "Eviterno, First of the Penitents" },
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
        { 0x4D00F491, "Z01:Faceless One room" },
        { 0x07B20B3D, "Z04:Radames room" },
        { 0xAA597F36, "Z07:Orospina room" },
        { 0x07B20A5A, "Z09:Lesmes room" },
        { 0x5DD4E45B, "Z23:Afilaor room" },
        { 0xF8126136, "Z11:Benedicta room" },
        { 0xF8126154, "Z12:Odon room" },
        { 0x556AEC39, "Z16:Sinodo room" },
        { 0x556AEC59, "Z13:Svsona room" },
        { 0x9AB9D533, "Z18:Eviterno room" },
        { 0x9AB9D532, "Z18:Devotion Incarnate room" },
        { 0x45CB41B1, "Z27:Sor room" },
        { 0xA323CD29, "Z28:Asterion room" }
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
        default:        version = "Unknown";  break;
    }
}
