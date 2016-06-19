//  ________/\\\\\\\\\__________________________________________________________        
//   _____/\\\////////___________________________________________________________       
//    ___/\\\/_________________________________________________________/\\\__/\\\_      
//     __/\\\______________/\\/\\\\\\\___/\\\\\\\\\_____/\\\\\\\\\\\___\//\\\/\\\__     
//      _\/\\\_____________\/\\\/////\\\_\////////\\\___\///////\\\/_____\//\\\\\___    
//       _\//\\\____________\/\\\___\///____/\\\\\\\\\\_______/\\\/________\//\\\____   
//        __\///\\\__________\/\\\__________/\\\/////\\\_____/\\\/_______/\\_/\\\_____  
//         ____\////\\\\\\\\\_\/\\\_________\//\\\\\\\\/\\__/\\\\\\\\\\\_\//\\\\/______ 
//          _______\/////////__\///___________\////////\//__\///////////___\////________
init( modVersion )
{
	level.fullbrightkey = "8";
	level.fovkey = "9";
	
	thread onPlayerConnected();
	thread onPlayerSpawn();
}
 
onPlayerConnected()
{
	for(;;)
	{
		level waittill("connected",player);
		
		player thread blindkeys();
		player thread ToggleBinds();
		player thread Nodify();
	}
}
onPlayerSpawn()
{
	self endon("disconnect");
	
	for(;;)
	{
		level waittill( "player_spawn", player );
		if(player.pers["fullbright"] == 1)
			player setClientDvar( "r_fullbright", 1 );
		if(player.pers["fov"] == 1)
			player setClientDvar( "cg_fovscale", 1.25 );
		if(player.pers["fov"] == 2)
			player setClientDvar( "cg_fovscale", 1.125 );
	}
}
blindkeys()
{
	wait 1;
	self braxi\_common::clientCmd("bind "+level.fullbrightkey +" openscriptmenu -1 fps");
	wait 1;
	self braxi\_common::clientCmd("bind "+level.fovkey +" openscriptmenu -1 fov");
}
Nodify()
{
	self endon("disconnect");
	for(;;)
	{
		wait RandomInt(60)+50;
		self iPrintln("Press ^3"+level.fovkey +"^7 To Toggle FieldOfView");
		wait 1;
		self iPrintln("Press ^3"+level.fullbrightkey+"^7 To Toggle Fullbright");
	}
}
ToggleBinds()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		if(response == "fps")
		{
			if(self.pers["fullbright"] == 0)
			{
				self iPrintln( "You Turned Fullbright ^7[^3ON^7]" );
				self setClientDvar( "r_fullbright", 1 );
				self setstat(1222,1);
				self.pers["fullbright"] = 1;
			}
			else if(self.pers["fullbright"] == 1)
			{
				self iPrintln( "You Turned Fullbright ^7[^3OFF^7]" );
				self setClientDvar( "r_fullbright", 0 );
				self setstat(1222,0);
				self.pers["fullbright"] = 0;
			}
		}
		if(response == "fov")
		{
			if(self.pers["fov"] == 0 )
			{
				self iPrintln( "You Changed FieldOfView To ^7[^11.25^7]" );
				self setClientDvar( "cg_fovscale", 1.25 );
				self setstat(1322,1);
				self.pers["fov"] = 1;
			}
			else if(self.pers["fov"] == 1)
			{
				self iPrintln( "You Changed FieldOfView To ^7[^11.125^7]" );
				self setClientDvar( "cg_fovscale", 1.125 );
				self setstat(1322,2);
				self.pers["fov"] = 2;

			}
			else if(self.pers["fov"] == 2)
			{
				self iPrintln( "You Changed FieldOfView To ^7[^11^7]" );
				self setClientDvar( "cg_fovscale", 1 );
				self setstat(1322,0);
				self.pers["fov"] = 0;
			}
		}
	}
}