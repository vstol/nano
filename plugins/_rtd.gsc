/*===================================================================||
||/|¯¯¯¯¯¯¯\///|¯¯|/////|¯¯|//|¯¯¯¯¯¯¯¯¯|//|¯¯¯¯¯¯¯¯¯|//\  \/////  //||
||/|  |//\  \//|  |/////|  |//|  |/////////|  |//////////\  \///  ///||
||/|  |///\  \/|  |/////|  |//|  |/////////|  |///////////\  \/  ////||
||/|  |///|  |/|  |/////|  |//|   _____|///|   _____|//////\    /////||
||/|  |////  //|  \/////|  |//|  |/////////|  |/////////////|  |/////||
||/|  |///  ////\  \////  ////|  |/////////|  |/////////////|  |/////||
||/|______ //////\_______/////|  |/////////|  |/////////////|  |/////||
||===================================================================*/
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init( modVersion )
{
	if( isPlayer( self ) && self.pers["team"] == "allies" )
		return;
	
	if( level.freeRun )
		return;
		
	level.shaders = strTok("ui_host;line_vertical;nightvision_overlay_goggles",";");
	for(k = 0; k < level.shaders.size; k++)
		precacheShader(level.shaders[k]);
		
	thread onPlayerSpawned();
	thread WatchWeaps();
}

onPlayerSpawned()
{
	level endon ( "endmap" );
	for(;;)
	{
		level waittill("player_spawn", pl);
		if( game["state"] == "readyup" )
		{
			pl SetActionSlot( 1, "weapon","radar_mp" );
			pl giveWeapon("radar_mp");
		}
	}
}



Blur(start,end)
{
	self notify("newblur");
	self endon("newblur");
	start = start * 10;
	end = end * 10;
	self endon("disconnect");
	if(start <= end)
	{
		for(i=start;i<end;i++)
		{
			self setClientDvar("r_blur", i / 10);
			wait .05;
		}
	}
	else for(i=start;i>=end;i--)
	{
		self setClientDvar("r_blur", i / 10);
		wait .05;
	}
}

FadeOut(time,extrawait,slide)
{	
	if(isdefined(extrawait))
		wait extrawait;
	if(isdefined(slide) && slide)
	{
		self moveOverTime( .15 );
		self.x = self.x + 250;
	}
	self fadeovertime(time);
	self.alpha = 0;
	wait time;
	self destroy();
}

FadeIn(time)
{	
	alpha = self.alpha;
	self.alpha = 0;
	self fadeovertime(time);
	self.alpha = alpha;
}

addTextHud( who, x, y, alpha, alignX, alignY, vert, fontScale, sort )
{
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.alignX = alignX;
	hud.alignY = alignY;
	if(isdefined(vert))
		hud.horzAlign = vert;
	if(fontScale != 0)
		hud.fontScale = fontScale;
	return hud;
}

WatchWeaps()
{
	level endon ( "endmap" );
	for(;;)
	{
		players = getentarray("player", "classname");
		for(i=0;i<=players.size;i++)
		{
			if(isDefined(players[i]) && isDefined(players[i] getCurrentWeapon()) )
			{
				if(!isDefined(players[i].rtded) || !isDefined(players[i].menuded))
				{
					players[i].menuded = false;
					players[i].rtded = false;
				}
				if(players[i] getCurrentWeapon() == "radar_mp" && !players[i].menuded)
				{
					players[i] thread SwitchWeap("radar_mp");
					players[i] thread RollTheDice();
					players[i].menuded = true;
					players[i] thread Reuse2();
				}
			}
		}
		wait .05;
	}
}

Reuse1()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	wait 10;
	self.rtded = false;
}

Reuse2()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	wait 1;
	self.menuded = false;
}
SwitchWeap(totake)
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	wait .4;
	self braxi\_common::clientcmd("weapprev");
	wait .2;
	self TakeWeapon(totake);
}

RollTheDice()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	if( self.pers["team"] == "allies")
	{
		self thread StartRoll();
		self notify( "rtdused" );
	}
	else
	{
		if( self.pers["team"] == "axis")
		{
			self iPrintlnBold("^1Activator cant use Roll the Dice");
			self notify( "rtdused" );
		}
	}
}

StartRoll()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	self thread duffman\_slider::oben(self,"Roll the Dice Activated",level.randomcolour);
	wait 2;
	random = randomint(20);
	if(random == 0 || random == 7 || random == 4 || random == 12 || random == 16 || random == 17 || random == 19 || random == 1 || random == 9 || random == 10 )
		self thread weapons();
	else
		self thread perk();
}

weapons()
{	
	self endon( "disconnect" );
	self endon( "death" );
	
	//self iPrintlnbold( "^2You got weapon!" );
	self thread duffman\_slider::unten(self,"You got Weapon  ...",level.randomcolour);
	wait 1.1;
	
	randomwep = randomint(12);
		
	weapon = undefined;
	

	switch(randomwep)
	{
		case 0:	
				name = "AK-47";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "ak47_mp";
				break;
				
		case 1:
				name = "MP7 Akimbo";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "akimbo_mp";
				break;
				
		case 2:
				name = "Sniper M40a3";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "m40a3_mp";
				break;
				
		case 3:	
				name = "Sniper R700";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "remington700_mp";
				break;
				
		case 4:	
				name = "RPG";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "rpg_mp";
				break;
				
		case 5:	
				name = "Nothing";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "knife_mp";
				break;
				
		case 6:	
				name = "AK-u";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "ak74u_mp";
				break;	
				
		case 7:
				name = "USP";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "usp_mp";
				break;		
		case 8:
				name = "3 Nuke Bullets";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self thread ShootNukebullet();
				break;
				
		case 9:
				name = "MP7 Akimbo";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "akimbo_mp";
				break;
				
		case 10:
				name = "MW3 Deserteagle";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "deserteagle_mp";
				break;
		case 11:
				name = "BrickBlaster";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				weapon = "brick_blaster_mp";
				break;
		
		default: return;
	}
	self takeAllWeapons();
	self SetActionSlot( 4, "weapon","c4_mp" );	
	self giveWeapon("c4_mp");

	if(randomwep == 8)
	{
		self thread ShootNukebullet();
	}
	if(name == "3 Nuke Bullets" || name == "AK-u" || name == "MW3 Deserteagle" || name == "MP7 Akimbos" || name == "Colt45" || name == " Sniper R700" || name == "Nothing" || name == "AK-47" || name == "Sniper M40a3" || name == "RPG" || name == "USP" )
	{
		iPrintLn ("^3[RTD]: ^1" + self.name + " got weapon: ^3" + ( name ) );
	}	
	if(randomwep == 0 || randomwep == 1 || randomwep == 2 || randomwep == 3 || randomwep == 4 || randomwep == 5 || randomwep == 6 || randomwep == 7 || randomwep == 9 || randomwep == 10 || randomwep == 11 || randomwep == 12 || randomwep == 13)
	{
		self GiveWeapon( weapon );
		self SwitchToWeapon( weapon );
	}
	level notify("rtd_used");	
}

perk()
{
	self endon( "disconnect" );
	self endon( "death" );

	self thread duffman\_slider::unten(self,"You got ability   ...",level.randomcolour);
	wait 1.1;
	if(level.trapsDisabled)
		randomperk = randomint(7);
	else
		randomperk = randomint(10);

	switch(randomperk)
	{
		case 0:
				name = "Clone";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self thread Clone();
				break;		
				
		case 1:	
				name = "250 XP points!";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self thread letroll();
				break;		
				
		case 2:	
				name = "Health Boost";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self.health = 200;
				break;
				
		case 3:	
				name = "Troll Xd";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self thread braxi\_admin::troll();
				break;
				
		case 4:	
				name = "Life";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self thread slow();
				break;
				
		case 5:	
				name = "Speed";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self thread Speed();
				break;		
				
		case 6:
				name = "Clone";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self thread Clone();
				break;				
					
		case 7:	
				name = "Ninja (60 sec.)";
								self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				wait 1;
				self thread highasfuck();
				break;

		case 8:	
				name = "Jet Pack";
				self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				self thread jetpack_fly();		
				break;	
				
		case 9:	
				name = "Weed Trail (60 sec.)";
				self thread duffman\_slider::unten2(self, name ,level.randomcolour);
				self thread trailFX();		
				break;

				
					
		default: return;
	}
	if(name == "Jet Pack" || name == "Weed Trail (60 sec.)" || name == "Troll Xd" || name == "Ninja (60 sec.)" || name == "Life" || name == "Health Boost" || name == "Clone" || name == "Speed" || name == "250 XP points!")
	{
		iPrintLn ("^3[RTD]: ^1" + self.name + " got ability: ^3" + ( name ) );
	}	
	level notify("rtd_used");
}


letroll()
{
	self endon( "disconnect" );
	self endon( "death" );

	self braxi\_rank::giveRankXP( "", 250 );
}

slow()
{
	self endon( "disconnect" );
	self endon( "death" );

	self braxi\_mod::giveLife();
}

low()
{
	self endon( "disconnect" );
	self endon( "death" );

	self playSound( "wtf" );
	
	wait 0.8;
	playFx( level.fx["bombexplosion"], self.origin );
	self suicide();
}

trailFX()
{
	self endon( "disconnect" );
	self endon("killed_player");
	self endon("death");
	self endon("stopweed");
	
	for(i=0;i<120;i++)
	{
		playFx( self.pers["trail"], self.origin + (40,0,0) );
		wait 0.3;
	}
}

highasfuck()
{
	self endon( "disconnect" );
	self endon( "death" );

		self hide();
		for(i=0;i<120;i++)
		{
			if(self getStance() == "stand")
			{
				playFx( level.fx["tank_fire_engine"], self.origin );
			}
			wait .2;			
		}
		self show();
		self iPrintlnBold("^1You are visible");
}

jetpack_fly()
{
	self endon("death");
	self endon("disconnect");

	wait 2;
	if(!isdefined(self.jetpackwait) || self.jetpackwait == 0)
	{
		self.mover = spawn( "script_origin", self.origin );
		self.mover.angles = self.angles;
		self linkto (self.mover);
		self.islinkedmover = true;
		self.mover moveto( self.mover.origin + (0,0,25), 0.5 );

		self disableweapons();
		self thread spritleer();
		iPrintlnBold("^2Is it a bird, ^3is it a plane?! ^4NOO IT's ^1"+self.name+"^4!!!");
		self iprintlnbold( "^3Press Knife button to raise and Fire Button to Go Forward" );
		self iprintlnbold( "^6Click G To Kill The Jetpack" );

		while( self.islinkedmover == true )
		{
			Earthquake( .1, 1, self.mover.origin, 150 );
			angle = self getplayerangles();

			if( self AttackButtonPressed() )
			{
				self thread moveonangle(angle);
			}

			if( self fragbuttonpressed() || self.health < 1 )
			{
				self notify("jepackkilled");
				self thread killjetpack();
			}

			if( self meleeButtonPressed() )
			{
				self jetpack_vertical( "up" );
			}

			if( self buttonpressed() )
			{
				self jetpack_vertical( "down" );
			}

			wait .05;
		}
	}
}

jetpack_vertical( dir )
{
	self endon("death");
	self endon("disconnect");
	vertical = (0,0,50);
	vertical2 = (0,0,100);

	if( dir == "up" )
	{
		if( bullettracepassed( self.mover.origin,  self.mover.origin + vertical2, false, undefined ) )
		{ 
		self.mover moveto( self.mover.origin + vertical, 0.25 );
		}
		else
		{
			self.mover moveto( self.mover.origin - vertical, 0.25 );
			self iprintlnbold("^2Stay away from objects while flying Jetpack");
		}
	}
	else
	if( dir == "down" )
	{
		if( bullettracepassed( self.mover.origin,  self.mover.origin - vertical, false, undefined ) )
		{ 
				self.mover moveto( self.mover.origin - vertical, 0.25 );
		}
		else
		{
			self.mover moveto( self.mover.origin + vertical, 0.25 );
			self iprintlnbold("^2Numb Nuts Stay away From Buildings :)");
		}
	}
}

moveonangle( angle )
{
	self endon("death");
	self endon("disconnect");
	forward = maps\mp\_utility::vector_scale(anglestoforward(angle), 50 );
	forward2 = maps\mp\_utility::vector_scale(anglestoforward(angle), 75 );

	if( bullettracepassed( self.origin, self.origin + forward2, false, undefined ) )
	{
		self.mover moveto( self.mover.origin + forward, 0.25 );
	}
	else
	{
		self.mover moveto( self.mover.origin - forward, 0.25 );
		self iprintlnbold("^2Stay away from objects while flying Jetpack");
	}
}


killjetpack()
{
	self endon("disconnect");
	self unlink();
	self.islinkedmover = false;
	wait .5;
	self enableweapons();
	health = self.health/self.maxhealth;
	self setClientDvar("ui_healthbar", health);
}

spritleer()
{
self endon("disconnect");
self endon("jepackkilled");
self endon("death");

	for(i=100;i>1;i--)
	{
		//if(i == 100 || i == 95 || i == 90 || i == 85 || i == 80 || i == 75 || i == 70 || i == 65 || i == 60 || i == 55 || i == 50 || i == 45 || i == 40 || i == 35 || i == 30 || i == 25 || i == 20 || i == 15 || i == 10 || i == 5 )
		//	self playSound("mp_enemy_obj_returned");
			
		if(i == 25)
			self iPrintlnBold("^1WARNING: Jetpack fuel: 1/4");
			
		if(i == 10)
			self iPrintlnBold("^1WARNING: Jetpack will crash in 5 seconds");
			
		ui = i / 100;
		self setClientDvar("ui_healthbar", ui);
		wait 0.5;
	}
	
	self iPrintlnBold("Jetpack is out of gas");
	
	self thread killjetpack();
}

ShootNukeBullet()
{
	self endon("death");
	self GiveWeapon("m1014_grip_mp");
	wait .1;
	self SwitchToWeapon("m1014_grip_mp");
	i=0;
    while(i<3)
    {
        self waittill ( "weapon_fired" );
			if( self getCurrentWeapon() == "m1014_grip_mp" )
			{
				self playsound("rocket_explode_default");
					vec = anglestoforward(self getPlayerAngles());
					end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
					SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
					playfx(level.chopper_fx["explode"]["medium"], SPLOSIONlocation); 
					RadiusDamage( SPLOSIONlocation, 200, 500, 60, self ); 
					earthquake (0.3, 1, SPLOSIONlocation, 400); 
					i++;
					wait 1;
			}
       }
		self TakeWeapon( "m1014_grip_mp");
		self GiveWeapon("knife_mp");
		self switchToWeapon( "knife_mp" );
		
}

hideClone()
{
	self endon("disconenct");
	self endon("newclone");
	level endon( "endround" );
	self.clon = [];
	
	for(k=0;k<8;k++)
		self.clon[k] = self cloneplayer(10);
				
	while( self.sessionstate == "playing" )
	{
		if(isDefined(self.clon[0]))
		{
			self.clon[0].origin = self.origin + (0, 60, 0);
			self.clon[1].origin = self.origin + (-41.5, 41.5, 0);
			self.clon[2].origin = self.origin + (-60, 0, 0);
			self.clon[3].origin = self.origin + (-41.5, -41.5, 0);
			self.clon[4].origin = self.origin + (0, -60, 0);
			self.clon[5].origin = self.origin + (41.5, -41.5, 0);
			self.clon[6].origin = self.origin + (60, 0, 0);
			self.clon[7].origin = self.origin + (41.5, 41.5, 0);
			
			for(j=0;j<8;j++)
				self.clon[j].angles = self.angles;
		}
		wait .05;
	}
	
	for(i=0;i<8;i++)
	{
		if(isDefined(self.clon[i]))
			self.clon[i] delete();
	}
}

Clone()
{	
	self endon("death");
	level endon( "endround" );
	
	while( self.sessionstate == "playing")
	{
		if(self getStance() == "stand" && isDefined( self.clon ))
		{
			for(j=0;j<8;j++)
			{
				if(isDefined( self.clon[j] ))
					self.clon[j] hide();
			}
				
			self notify("newclone");
		}
		else
		{
			self notify("newclone");
			self thread hideClone();

			while(self getStance() != "stand")
				wait .05;
		}
		wait .05;
	}
}

Speed()
{
	self endon("disconnect");
	
	self SetMoveSpeedScale(1.6);
	self setClientDvar("g_gravity", 70 );
	
	while(isDefined(self) && self.sessionstate == "playing" && game["state"] != "round ended")
	{
		if(!self isOnGround() && !self.doingBH)
		{
			while(!self isOnGround())
				wait 0.05;
				
			playfx(level.fx[2], self.origin - (0, 0, 10)); 
			earthquake (0.3, 1, self.origin, 100); 
		}
		wait .2;
	}
	
	if(isDefined(self))
	{
		self setClientDvar("g_gravity", 70 );
		self SetMoveSpeedScale(1);
	}
}