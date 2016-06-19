//__/\\\______________/\\\______________________________________________________________________________________         
// _\/\\\_____________\/\\\______________________________________________________________________________________        
//  _\/\\\_____________\/\\\__/\\\_________________/\\\\\\\\______________________________________________________       
//   _\//\\\____/\\\____/\\\__\///___/\\/\\\\\\____/\\\////\\\__/\\\\\\\\\\\_____/\\\\\_____/\\/\\\\\\\____________      
//    __\//\\\__/\\\\\__/\\\____/\\\_\/\\\////\\\__\//\\\\\\\\\_\///////\\\/____/\\\///\\\__\/\\\/////\\\___________     
//     ___\//\\\/\\\/\\\/\\\____\/\\\_\/\\\__\//\\\__\///////\\\______/\\\/_____/\\\__\//\\\_\/\\\___\///____________    
//      ____\//\\\\\\//\\\\\_____\/\\\_\/\\\___\/\\\__/\\_____\\\____/\\\/______\//\\\__/\\\__\/\\\___________________   
//       _____\//\\\__\//\\\______\/\\\_\/\\\___\/\\\_\//\\\\\\\\___/\\\\\\\\\\\__\///\\\\\/___\/\\\___________________  
//        ______\///____\///_______\///__\///____\///___\////////___\///////////_____\/////_____\///____________________ 
//AND
//  ________/\\\\\\\\\__________________________________________________________        
//   _____/\\\////////___________________________________________________________       
//    ___/\\\/_________________________________________________________/\\\__/\\\_      
//     __/\\\______________/\\/\\\\\\\___/\\\\\\\\\_____/\\\\\\\\\\\___\//\\\/\\\__     
//      _\/\\\_____________\/\\\/////\\\_\////////\\\___\///////\\\/_____\//\\\\\___    
//       _\//\\\____________\/\\\___\///____/\\\\\\\\\\_______/\\\/________\//\\\____   
//        __\///\\\__________\/\\\__________/\\\/////\\\_____/\\\/_______/\\_/\\\_____  
//         ____\////\\\\\\\\\_\/\\\_________\//\\\\\\\\/\\__/\\\\\\\\\\\_\//\\\\/______ 
//          _______\/////////__\///___________\////////\//__\///////////___\////________

init()
{
	for(;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawn();
		
	}
}

onPlayerSpawn()
{
	
	for(;;)
	{
		level waittill( "player_spawn", player );
		player thread watchghost();
	}
}

watchghost()
{
	self endon("disconnect");
	
	for(;;)
	{
		if(!self.ghost)
			self show();
		else if(self.ghost)
		{
			if(self.pers["team"] == "axis" )
			{
				self show();
				self suicide();
				iprintlnbold( "^1" + self.name + "Can Not Be Activator While In Ghost Mode" );
			}
		}
		wait 3;
	}
}



ghostrun_spawnPlayer()
{
	if( game["state"] == "endmap" ) 
		return;
	
	self.team = self.pers["team"];
	self.sessionteam = self.team;
	self.sessionstate = "playing";
	self.spectatorclient=-0;
	self.killcamentity=-0;
	self.archivetime=0;
	self.psoffsettime=0;
	self.statusicon = "";

	if(self getStat( 764 ) == 1)
		self.statusicon = "hudicon_opfor";
		
	if(self getStat( 764 ) == 2)
		self.statusicon = "hudicon_american";	
	
	self braxi\_teams::setPlayerModel();
	
	spawnPoint = level.spawn[self.pers["team"]][randomInt(level.spawn[self.pers["team"]].size)];
	self spawn(  spawnPoint.origin, spawnPoint.angles );
	
	self SetActionSlot( 1, "nightvision" );
	self.pers["weapon"] = "deserteagle_mp";

	self giveWeapon("knife_mp");
	self giveWeapon( self.pers["weapon"] );
	self setSpawnWeapon( self.pers["weapon"] );
	self giveMaxAmmo( self.pers["weapon"] );
	self setViewModel( "viewmodel_hands_zombie" );

	self thread braxi\_teams::setHealth();
	self thread braxi\_teams::setSpeed();
	self thread braxi\_mod::afterFirstFrame();
	self notify( "spawned_player" );
	level notify( "player_spawn", self );
	self.ghost=true;
	self hide();
	self.statusicon = "hud_status_dead";
}