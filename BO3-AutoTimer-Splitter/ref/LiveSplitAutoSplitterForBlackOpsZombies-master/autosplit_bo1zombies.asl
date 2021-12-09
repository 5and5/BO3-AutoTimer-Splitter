state("BlackOps")
{
	int scene_state : 0x896268;
	int game_paused : 0x8902B4;
	int timer : 0x2F08A30;
	int menu_state : 0x4212FEC;
	int magic_level : 0x1656994;
	byte dead : 0x1808D34;
}

state("BGamerT5")
{
	int scene_state : 0x896268;
	int game_paused : 0x8902B4;
	int timer : 0x2F08A30;
	int menu_state : 0x4212FEC;
	int magic_level : 0x1656994;
	byte dead : 0x1808D34;
}

startup
{
	settings.Add("Rounds", true, "Rounds");
	settings.Add("Level2", true, "Split on level 2", "Rounds");
	settings.Add("Level15", true, "Split on level 15", "Rounds");
	settings.Add("Level20", true, "Split on level 20", "Rounds");
	settings.Add("Level30", true, "Split on level 30", "Rounds");
	settings.Add("Level40", true, "Split on level 40", "Rounds");
	settings.Add("Level50", true, "Split on level 50", "Rounds");
	settings.Add("Level70", true, "Split on level 70", "Rounds");
	settings.Add("Level100", true, "Split on level 100", "Rounds");
	settings.Add("Level110", true, "Split on level 110", "Rounds");
	settings.Add("Level120", true, "Split on level 120", "Rounds");
	settings.Add("Level130", true, "Split on level 130", "Rounds");
	settings.Add("Level140", true, "Split on level 140", "Rounds");
	settings.Add("Level150", true, "Split on level 150", "Rounds");
	settings.Add("Level160", true, "Split on level 160", "Rounds");
	settings.Add("Level163", true, "Split on level 163", "Rounds");
	settings.Add("Level170", true, "Split on level 170", "Rounds");
	settings.Add("Level180", true, "Split on level 180", "Rounds");
	settings.Add("Level190", true, "Split on level 190", "Rounds");
	settings.Add("Level200", true, "Split on level 200", "Rounds");
	settings.Add("Level210", true, "Split on level 210", "Rounds");
	settings.Add("Level220", true, "Split on level 220", "Rounds");
	settings.Add("Level230", true, "Split on level 230", "Rounds");
	settings.Add("Level240", true, "Split on level 240", "Rounds");
	settings.Add("Level250", true, "Split on level 250", "Rounds");
	settings.Add("Level260", true, "Split on level 260", "Rounds");

    vars.timerModel = new TimerModel { CurrentState = timer };
	vars.is_paused = (vars.timerModel.CurrentState.CurrentPhase == TimerPhase.Paused);
	vars.did_reset = false;
	vars.timer_started = (vars.timerModel.CurrentState.CurrentPhase != TimerPhase.NotRunning);
	vars.timer_value = 0;
	vars.timer_pause_length = 0;
	
	vars.current_level = 1;
	vars.last_level_split = 1;
	
	vars.start_times = new List<Tuple<int, int>>
	{
      new Tuple<int, int>(5, 190),		// kino
      new Tuple<int, int>(10, 190),		// five
      new Tuple<int, int>(15, 50),		// dead ops
	  new Tuple<int, int>(20, 580),		// ascension
	  new Tuple<int, int>(28, 190),		// call of the dead
	  new Tuple<int, int>(44, 190),		// shangri la
	  new Tuple<int, int>(76, 195),		// moon
	  new Tuple<int, int>(108, 195),	// nacht der untoten  
	  new Tuple<int, int>(140, 200),	// verruckt
	  new Tuple<int, int>(172, 198),	// shi no numa
	  new Tuple<int, int>(204, 195),	// der riese
	  
	};
	  //new Tuple<int, int>(?, ?),	// call of the dead
	  //new Tuple<int, int>(?, ?),	// shangri la
	  //TODO call of the dead and shangri la not done yet
}

start
{
	if (current.menu_state != 0) return false;
	
	foreach(Tuple<int, int> item in vars.start_times)
	{
		if (current.scene_state == item.Item1)
		{
			if (vars.timer_value > item.Item2) 
			{
				vars.skipped_first = false;
				vars.timer_started = true;
				vars.current_level = 1;
				vars.last_level_split = 1;
				vars.level_change_stamp = 0;
					
				return true;
			}
		}
	}
	
	return false;
}

split
{
	if (vars.timer_started)
	{
		if (vars.current_level != vars.last_level_split)
		{
			int diff = vars.timer_value - vars.level_change_stamp;
			
			// wait untill level appears on screen
			if (diff > 55)
			{
				print(vars.current_level.ToString() + " --- " + vars.last_level_split.ToString());
				vars.last_level_split = vars.current_level;
				
				int lvl_to_check = vars.current_level;
				
				if (settings["Rounds"]) 
				{  
					string toCheck = "Level"+lvl_to_check.ToString();
					if (settings[toCheck]) 
					return true;
				}
			}
		}
	}
	
	return false;
}

reset
{
	if (!vars.did_reset && current.timer < 100)
	{
		vars.timer_started = false;
		vars.did_reset = true;
		vars.timer_value = 0;
		vars.timer_pause_length = 0;
		vars.current_level = 1;
		vars.last_level_split = 1;
		return true;
	}
	if (current.timer >= 100)
		vars.did_reset = false;
	return false;
}

update
{	
	if (current.game_paused == 4 && !vars.is_paused) {
		vars.is_paused = true;
			
		if (vars.timer_started)
			vars.timerModel.Pause();
	}
	else if (current.game_paused != 4 && vars.is_paused)
	{
			vars.is_paused = false;
			
		if (vars.timer_started)
			vars.timerModel.Pause();
	}
	
	
	if (old.dead != 0 && current.dead == 0)
	{
		if (vars.timer_started)
			vars.timerModel.Pause();
		//vars.timer_started = false;
	}
	
	if (old.magic_level == 2000 && current.magic_level == 500)
	{
		if (vars.skipped_first)
		{
			vars.current_level++;
			vars.level_change_stamp = vars.timer_value;
		}
		else
		{
			vars.skipped_first = true;
		}
	}
	
	// we have our own timer that is basically the ingame timer that pauses when the player pauses the game
	// we do this so the player can pause the game when spawning in and the timer hasnt started yet.
	if (!vars.is_paused)
	{
		vars.timer_value = current.timer - vars.timer_pause_length;
	}
	else
	{
		vars.timer_pause_length = current.timer - vars.timer_value;
	}
	
	//print(vars.timer_value.ToString());
	
	return true;
}