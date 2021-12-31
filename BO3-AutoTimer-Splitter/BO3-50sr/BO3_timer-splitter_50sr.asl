state("BlackOps3") 
{
	int levelTime : 0xA56EFD8;
	int round : 0xA55DDEC;
	string13 currentMap : 0x179E1840;
}

reset
{
    if(current.round_counter == 0 && old.round_counter != 0 || current.map_name.Equals("core_frontend")) return true;
    return false;
}

update
{
	if(old.round == 0 && current.round == 1)
	{
		game.WriteValue<UInt16>((IntPtr)vars.addr, (UInt16)current.levelTime);
		vars.fixedOffset = current.levelTime;
	}
	
	vars.trueTime = current.levelTime - vars.fixedOffset;
}

split
{
	if(current.round == vars.round_splits[vars.split_index])
	{
		vars.split_index++;
		return true;
	}
}

gameTime
{
	string[] arrayMaps = {"zm_zod", "zm_factory", "zm_castle", "zm_island", 
		"zm_stalingrad", "zm_genesis", "zm_prototype", "zm_asylum", "zm_sumpf", 
		"zm_theater", "zm_cosmodrome", "zm_temple", "zm_moon", "zm_tomb"};

	if(Array.IndexOf(arrayMaps, current.currentMap) == -1 || current.round == 0)
	{
		return TimeSpan.Zero;
	}

	return new TimeSpan(0, 0, 0, 0, vars.trueTime * 50);
}

init
{
	refreshRate = 100;
	vars.addr = game.MainModule.BaseAddress + 0xA55DEB0;
	vars.fixedOffset = game.ReadValue<UInt16>((IntPtr)vars.addr);
	vars.round_splits = new int[] {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50};
    vars.split_index = 0;
}

start
{
	if(current.round == 0)
    {
        vars.split_index = 0;
    }

	return true;
}

isLoading
{
	return true;
}