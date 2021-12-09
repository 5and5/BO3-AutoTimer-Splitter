state("BlackOps3") 
{
	int levelTime : 0xA56EFD8;
	int round : 0xA55DDEC;
	string13 currentMap : 0x179E1840;
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
	vars.round_splits = new int[] {2, 5, 10, 15, 20, 25, 30, 50, 70, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 255};
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