//  ________/\\\\\\\\\__________________________________________________________        
//   _____/\\\////////___________________________________________________________       
//    ___/\\\/_________________________________________________________/\\\__/\\\_      
//     __/\\\______________/\\/\\\\\\\___/\\\\\\\\\_____/\\\\\\\\\\\___\//\\\/\\\__     
//      _\/\\\_____________\/\\\/////\\\_\////////\\\___\///////\\\/_____\//\\\\\___    
//       _\//\\\____________\/\\\___\///____/\\\\\\\\\\_______/\\\/________\//\\\____   
//        __\///\\\__________\/\\\__________/\\\/////\\\_____/\\\/_______/\\_/\\\_____  
//         ____\////\\\\\\\\\_\/\\\_________\//\\\\\\\\/\\__/\\\\\\\\\\\_\//\\\\/______ 
//          _______\/////////__\///___________\////////\//__\///////////___\////________
#include braxi\_common;
init()
{      
	level thread onPlayerConnect();
}
onPlayerConnect()
{
	level endon ( "endmap" );
	for(;;)
	{
		level waittill( "connecting", player );
		player thread onPlayerSpawned();      
	}
}
onPlayerSpawned()
{
	level endon ( "endmap" );
	for(;;)
	{
		level waittill( "player_spawn" );
		{
			self.monkeyinuse = false;
			self thread monkey();
		}
	}
}
monkey()
{
	level endon ( "endmap" );
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("grenade_fire", monkey, weaponName);
		if(weaponName == "monkey_mp")
			monkey DeleteAfterThrow();
		self takeWeapon( "monkey_mp" );
		if(!isDefined(self.pers["canvip"]))
		{
			self takeWeapon( self.pers["weapon"] );
			self giveWeapon( self.pers["weapon"] );
			self switchToWeapon( self.pers["weapon"] );
		}
		else if(isDefined(self.pers["canvip"]))
		{
			self takeAllWeapons();
			self thread plugins\vip\_vip::vip_weapons();
		}
		else
		{
			self takeWeapon( self.pers["weapon"] );
			self giveWeapon( self.pers["weapon"] );
			self switchToWeapon( self.pers["weapon"] );
		}
	}
}
DeleteAfterThrow()
{
	level endon ( "endmap" );
	self endon("disconnect");
	self endon( "end_monkey" );
	
	waitTillNotMoving();
	thread dance(self.origin,self.angels);
	if(isDefined(self))
		self delete();
}
dance(ori,angel)
{
	level endon ( "endmap" );
	self endon("disconnect");
	self endon( "end_monkey" );

	monk = spawn("script_model", ori); 
	monk.angels = angel;
	monk SetModel("monkey_bomb_waw");
	monk thread calculatePosition();
	monk thread move();
	for(;;)
	{
		monk.monkeyinuse = true;
		monk thread SoundOnOrigin("monkey_throw",monk.origin);
		wait 1;
		monk thread SoundOnOrigin("monkey_land_vox",monk.origin);
		wait 1;
		for(i=0;i<2;i++)
		{
			monk thread SoundOnOrigin("monkey_raise_vox_plr",monk.origin);
			monk rotateyaw (360,0.5);
			wait 0.5;
			monk Vibrate( monk.origin+(0,0,50), 20, 0.2, 0.5 );
			wait 0.5;
			monk rotateyaw (360,0.5);
			wait 0.5;
			monk Vibrate( monk.origin+(0,0,50), 20, 0.2, 0.5 );
			wait 0.5;
		}
		for(i=0;i<2;i++)
		{
			monk thread SoundOnOrigin("monkey_explo_vox",monk.origin);
			monk rotateyaw (360,0.5);
			wait 0.5;
			monk Vibrate( monk.origin+(0,0,50), 20, 0.2, 0.5 );
			wait 0.5;
			monk rotateyaw (360,0.5);
			wait 0.5;
			monk Vibrate( monk.origin+(0,0,50), 20, 0.2, 0.5 );
			wait 0.5;
			
		}
		playFx(level.chopper_fx["explode"]["medium"],monk.origin);
		self notify("explode_monkey");
		earthquake(1,1.2,monk.origin,400);
		wait .2;
		monk thread SoundOnOrigin("exp_suitcase_bomb_main",monk.origin);
		RadiusDamage(monk.origin,200,100,25,monk);
		monk delete();
		self.monkeyinuse = false;
		self notify( "end_monkey" );
	}
}
move()
{
	level endon ( "endmap" );
	self endon("disconnect");
	self endon( "end_monkey" );
	
	for(;;)
	{
		player = getEntArray( "player", "classname" );
		for(i=0;i<player.size;i++)
		{
			if(distance( self.origin, player[i].origin ) < 300)
			{
				self MoveTo( player[i].origin, 1, .05, .05 );
			}
		}
		wait 1;
	}
}
calculatePosition()
{
	level endon ( "endmap" );
	self endon("disconnect");
	self endon( "end_monkey" );
	
	wait 0.05;
	self waittill("explode_monkey");
	players = getEntArray( "player", "classname" );
	for(i=0;i<players.size;i++)
	{
		if(distance( self.origin, players[i].origin ) < 300)
		{
			PlayFX( level.fx_extrablood, players[i].origin+(0,0,32) );
			players[i] thread braxi\_mod::AddBloodHud();
		}						
	}
}
SoundOnOrigin(alias,origin)
{
	self endon("disconnect");
	self endon( "end_monkey" );
	
	soundPlayer = spawn( "script_origin", origin );
	soundPlayer playsound( alias );
	wait 3;
	soundPlayer delete();
}