state("BlackOps3") 
{
	int tick : 0xA56EFD8;
	int round : 0xA55DDEC;
	string13 currentMap : 0x179E1840;
}

update
{
	if(old.round == 0 && current.round == 1)
	{
		game.WriteValue<UInt16>((IntPtr)vars.addr, (UInt16)current.tick);
		vars.fixedOffset = current.tick;
	}

	vars.trueTime = current.tick / 100;

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
}

start
{
	return true;
}

isLoading
{
	return true;
}