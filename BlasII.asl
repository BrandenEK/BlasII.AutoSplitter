
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
    bool     isPlaying : "GameAssembly.dll", 0x39C4120, 0xB8, 0xF8, 0x30, 0x190;
    uint     mainRoom1 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x340, 0x28, 0x0;
    uint     mainRoom2 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x5C8, 0x30, 0x0;
    float   bossDeath1 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x28;
    float   bossDeath2 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x2C;
    float   bossDeath3 : "GameAssembly.dll", 0x39C4120, 0xB8, 0x180, 0x30;
    bool  inputBlocked : "GameAssembly.dll", 0x39C4120, 0xB8, 0x10, 0x78;
    float    positionX : "GameAssembly.dll", 0x39C4120, 0xB8, 0x5D0, 0x60, 0x00;
    float    positionY : "GameAssembly.dll", 0x39C4120, 0xB8, 0x5D0, 0x60, 0x04;
}

state("Blasphemous 2", "2.2.0")
{
    bool     isPlaying : "GameAssembly.dll", 0x039F3C38, 0xB8, 0xF8, 0x30, 0x190;
    uint     mainRoom1 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x340, 0x28, 0x0;
    uint     mainRoom2 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x5C8, 0x30, 0x0;
    float   bossDeath1 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x180, 0x28;
    float   bossDeath2 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x180, 0x2C;
    float   bossDeath3 : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x180, 0x30;
    bool  inputBlocked : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x10, 0x78;
    float    positionX : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x5D0, 0x60, 0x00;
    float    positionY : "GameAssembly.dll", 0x039F3C38, 0xB8, 0x5D0, 0x60, 0x04;
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
    vars.positionSplits.Clear();
}

split
{
    uint oldRoom = Math.Max(old.mainRoom1, old.mainRoom2);
    uint currentRoom = Math.Max(current.mainRoom1, current.mainRoom2);
    
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
    
    // Input blocked positions
    
    if (!old.inputBlocked && current.inputBlocked)
    {
        foreach (var tuple in vars.positionInfo)
        {
            if (!settings[tuple.Item1] || vars.positionSplits.Contains(tuple.Item1))
                continue;
            
            if (current.positionX < tuple.Item3 || current.positionX > tuple.Item4 || current.positionY < tuple.Item5 - 0.5f || current.positionY > tuple.Item5 + 0.5f)
                continue;
            
            print("Splitting on position: " + tuple.Item1);
            vars.positionSplits.Add(tuple.Item1);
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
    // Add settings for time start
    settings.Add("time", true, "When to start timer");
    settings.Add("time_file", false, "File select", "time");
    settings.Add("time_weapon", true, "Enter weapon selection", "time");
    settings.Add("time_penitence1", false, "Enter penitence selection", "time");
    settings.Add("time_penitence2", false, "Exit penitence selection", "time");
    
    // Store zone info
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
    
    // Store position info
    var positionInfo = new Tuple<string, string, float, float, float>[]
    {
        // Abilities
        Tuple.Create("A_wallclimb", "Ivy of ascension", 7f, 11f, -48f),
        Tuple.Create("A_doublejump", "Passage of Ash", -152f, -148f, -218f),
        Tuple.Create("A_airdash", "Mercy of the Wind", 686f, 690f, 162f),
        Tuple.Create("A_cherubrings", "Scions' Protection", -744f, -740f, 72f),
        Tuple.Create("A_glasswalk", "Broken Step", 686f, 690f, 62f),
        // Weapons
        Tuple.Create("W_censer1", "Veredicto", -705f, -695f, 152f),
        Tuple.Create("W_censer2", "Veredicto upgrade (Sunken Cathedral)", -433f, -428f, -30f),
        Tuple.Create("W_censer3", "Veredicto upgrade (Elevated Temples)", -73f, -68f, 192f),
        Tuple.Create("W_rosary1", "Ruego Al Alba", 775f, 785f, 122f),
        Tuple.Create("W_rosary2", "Ruego upgrade (Sacred Grounds)", -13f, -8f, -170f),
        Tuple.Create("W_rosary3", "Ruego upgrade (Crown of Towers)", 813f, 818f, 202f),
        Tuple.Create("W_rapier1", "Sarmiento & Centella", 595f, 605f, 0f),
        Tuple.Create("W_rapier2", "Sarmiento upgrade (Choir of Thorns)", 308f, 313f, 93f),
        Tuple.Create("W_rapier3", "Sarmiento upgrade (Elevated Temples)", -32f, -28f, 272f),
        //Tuple.Create("W_meaculpa1", "XXX", 0f, 0f, 0f),
        Tuple.Create("W_meaculpa2", "Mea Culpa ugrade", -633f, -627f, 232f),
    };
    print("Loaded " + positionInfo.Length + " positions");
    vars.positionInfo = positionInfo;
    vars.positionSplits = new List<string>();
    
    // Store room info
    var roomInfo = new Tuple<uint, string, string>[]
    {
        // Boss rooms
        Tuple.Create(0x4D00F491, "B", "Faceless One, Chisel of Oblivion"),
        Tuple.Create(0x07B20B3D, "B", "Great Preceptor Radamés"),
        Tuple.Create(0xAA597F36, "B", "Orospina, Lady Embroiderer"),
        Tuple.Create(0x07B20A5A, "B", "Lesmes & Infanta"),
        Tuple.Create(0x5DD4E45B, "B", "Afilaor, Sentinel of the Emery"),
        Tuple.Create(0xF8126136, "B", "Benedicta of the Endless Orison"),
        Tuple.Create(0xF8126154, "B", "Odón of the Confraternity of Salt"),
        Tuple.Create(0x556AEC39, "B", "Sínodo, Hymn of the Thousand Voices"),
        Tuple.Create(0x556AEC59, "B", "Svsona, Fermosa Fembra"),
        Tuple.Create(0x9AB9D533, "B", "Eviterno, First of the Penitents"),
        Tuple.Create(0x9AB9D532, "B", "Incarnate Devotion"),
        Tuple.Create(0x45CB41B1, "B", "Sor Cautiva del Silencio"),
        Tuple.Create(0x5DD4E3F6, "B", "Brother Asterión (First encounter)"),
        Tuple.Create(0xA323CD29, "B", "Brother Asterión (Second encounter)"),
    };
    print("Loaded " + roomInfo.Length + " rooms");
    vars.roomSplits = new List<uint>();
    
    // Store boss info
    var bossInfo = new Dictionary<uint, string>()
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
    print("Loaded " + bossInfo.Count + " bosses");
    vars.bossSplits = new List<uint>();

    // Add ability settings
    settings.Add("abilities", true, "Abilities");
    foreach (var tuple in positionInfo.Where(x => x.Item1.StartsWith("A")))
        settings.Add(tuple.Item1, false, tuple.Item2, "abilities");
    
    // Add weapon settings
    settings.Add("weapons", true, "Weapons");
    foreach (var tuple in positionInfo.Where(x => x.Item1.StartsWith("W")))
        settings.Add(tuple.Item1, false, tuple.Item2, "weapons");
    
    // Add boss settings
    settings.Add("bosses", true, "Bosses");
    foreach (var boss in bossInfo)
        settings.Add("B_" + boss.Key, false, boss.Value, "bosses");
    
    // Add boss room settings
    settings.Add("bossrooms", true, "Boss rooms");
    foreach (var tuple in roomInfo.Where(x => x.Item2 == "B"))
        settings.Add("R_" + tuple.Item1, false, tuple.Item3, "bossrooms");
    
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
