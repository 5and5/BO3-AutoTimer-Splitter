state("blackops3")
{
    int level_time : 0xA56EFD8;
    byte round_counter : 0xA55DDEC;
    byte is_paused : 0x3480E08; // No clue if this is actually the pause variable, but it seems to work as if it is
    string13 map_name : 0x9992123;
}

startup
{
    refreshRate = 100;
    vars.update_time = 1;
}

start
{
    if(current.round_counter == 0) vars.update_time = 1;
	if(current.round_counter != 0) return true;
}

gameTime
{
    if(vars.update_time == 1) 
    {
        vars.update_time = 0;
        return new TimeSpan(0, 0, 0, 0, current.level_time * 50);
    }
}

isLoading
{
    if(current.is_paused == 1)
    {
        vars.update_time = 1;
        return true;
    }
    return false;
}