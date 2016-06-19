//__/\\\______________/\\\______________________________________________________________________________________         
// _\/\\\_____________\/\\\______________________________________________________________________________________        
//  _\/\\\_____________\/\\\__/\\\_________________/\\\\\\\\______________________________________________________       
//   _\//\\\____/\\\____/\\\__\///___/\\/\\\\\\____/\\\////\\\__/\\\\\\\\\\\_____/\\\\\_____/\\/\\\\\\\____________      
//    __\//\\\__/\\\\\__/\\\____/\\\_\/\\\////\\\__\//\\\\\\\\\_\///////\\\/____/\\\///\\\__\/\\\/////\\\___________     
//     ___\//\\\/\\\/\\\/\\\____\/\\\_\/\\\__\//\\\__\///////\\\______/\\\/_____/\\\__\//\\\_\/\\\___\///____________    
//      ____\//\\\\\\//\\\\\_____\/\\\_\/\\\___\/\\\__/\\_____\\\____/\\\/______\//\\\__/\\\__\/\\\___________________   
//       _____\//\\\__\//\\\______\/\\\_\/\\\___\/\\\_\//\\\\\\\\___/\\\\\\\\\\\__\///\\\\\/___\/\\\___________________  
//        ______\///____\///_______\///__\///____\///___\////////___\///////////_____\/////_____\///____________________ 

#include braxi\_common;

init( version )
{
		
	//general
	level.shaders = strTok("ui_host;line_vertical;nightvision_overlay_goggles",";");
	for(k = 0; k < level.shaders.size; k++)
		precacheShader(level.shaders[k]);
		
	thread setupSpawnSpots();
	
	//activator shop
	level.cirleactishopfx = loadfx ("misc/ui_flagbase_black");	
	thread ActivatorCircleShop();
	
	//global starts
	for(;;)
	{	 
		level waittill("connected", player);
		player thread Credits();
		player thread shopacti();
		player thread watchkills();
		player thread updatepointhud();
	}
}

Credits()
{
	self endon("disconnect");
	
	while(1)
	{
		if((self getStat(1338))<255)
		{
			win=1;
			current=self getstat(1338);
			if((current+win)>255)
			newamount=255;
			else
			newamount=(current+win);
			self setstat(1338,newamount);
			self notify("updateCreditsTotal");
		}
		if((self getStat(1338))>255)
		{
			current=self getstat(1338);
			win=(current-255);
			newamount=(current-win);
			self setstat(1338,newamount);
			self notify("updateCreditsTotal");
		}
		wait 60;
	}	
}

//watch kills for credit
watchkills()
{
	self endon("disconnect");
	
	self.startscore = self.pers["kills"];
	self.killcount = 0;
	
	for(;;)
	{
	if(self.killcount != self.pers["kills"] - self.startscore)
		{
		self.killcount = self.pers["kills"] - self.startscore;
		
		win=10;
		current=self getstat(1338);
		if((current+win)>255)
			newamount=255;
		else
			newamount=(current+win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		
		}
		wait 1;
	}
}

//create spots
setupSpawnSpots()
{
	level.spawnx = [];
	level.spots=[];
	level.spawnx["allies"] = getEntArray( "mp_jumper_spawn", "classname" );
	
	level.spawnx["axis"] = getEntArray( "mp_activator_spawn", "classname" );

	if( !level.spawnx["allies"].size )
		level.spawnx["allies"] = getEntArray( "mp_dm_spawn", "classname" );

	for( i = 0; i < level.spawnx["allies"].size; i++ )
	{
		level.spots[i] = Spawn( "script_origin",level.spawnx["allies"][i] getorigin() );
	}
	
	for( i = 0; i < level.spawnx["axis"].size; i++ )
	{
		level.spotsacti[i] = Spawn( "script_origin",level.spawnx["axis"][i] getorigin() );
	}
	

}

//text generators
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

updatepointhud()
{
	self endon("disconnect");
	
	self.points = braxi\_mod::addTextHud( self, 9, -50, 1, "left", "bottom", 1.6 );
	self.points.hidewheninmenu = true;
	self.points.horzAlign = "left";
	self.points.vertAlign = "bottom";
	self.points.glowAlpha = 1;
	self.points.glowColor = level.randomcolour;
	self.points.label = &"Your Credits: ^3 &&1 / 255";	
	self.points.sort = 103;
	
	if(isDefined(self getstat(1338)))
	
		self.points SetValue( self getstat(1338) );
	else
		self.points SetValue( 0 );
	
	
	while(1)
	{		
		if(self getstat(1338)>255)
			self setstat(1338,255);		
		self.points SetValue(self getstat(1338));
		self waittill("updateCreditsTotal");
	}
}

openshopacti_cmd()
{
	self notify("openshop_acti");
}

getColour(points)
{
	if(self getstat(1338) >= points)
		return "^2";
	else
		return "^1";//
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

///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
/////////////////*ACTIVATOR SHOP*//////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////
///////////////////////////////////////////////////////


ActivatorCircleShop()
{
	maxrandom=level.spotsacti.size;
	level.shoprand=RandomInt(maxrandom);
	spawnspot=level.spotsacti[level.shoprand].origin;

	spawn_0 =(spawnspot+(0,0,0));
	spawn_1=(spawnspot+(0,0,25));
	spawn_2=(spawnspot+(0,0,50));

	level waittill("round_started");
	
	circle_0 = spawn("script_model", spawn_0); 
	circle_0.angles=(0,0,0);
	
	circle_1 = spawn("script_model", spawn_1); 
	circle_1.angles=(0,0,0);
	
	circle_2 = spawn("script_model", spawn_2); 
	circle_2.angles=(0,0,0);
	
	circle_0 thread playPlaneFxShopacti();
	circle_1 thread playPlaneFxShopacti();
	circle_2 thread playPlaneFxShopacti();
	
	thread AddGlobalTriggerShopActi(circle_1.origin,circle_1.angels);
	
}

playPlaneFxShopacti()
{
	self endon ( "death" );
	//while(1)
	//{
	PlayFX( level.cirleactishopfx, self.origin);
	//wait 1;
	//}
}

AddGlobalTriggerShopActi(ori,angel)
{
	trigger = spawn( "trigger_radius", ori + ( 0, 0, -40 ), 0, 35, 80 );
	thread AddGlobalTriggerMsgActiv(ori,trigger,"^7Press ^3[[{+activate}]] ^7to use shop!");
	while(1)
	{
		trigger waittill("trigger", player);
		
		if(player usebuttonpressed())
		{
			player notify("openshop_acti");
			wait .05;
		}
		wait 0.05;
	}
}

AddGlobalTriggerMsgActiv(ori,owner,msg)
{
	while(isDefined(owner))
	{
		pl = getentarray("player", "classname");
		for(i=0;i<pl.size;i++)
		{	
			if(!isDefined(pl[i].notified))
				pl[i].notified = false;
			if(distance(pl[i].origin,ori) <= 30 && !pl[i].notified )
			{
				pl[i].notified = true;
				pl[i] maps\mp\_utility::setLowerMessage(msg);
			}
			else if( isDefined(pl[i].notified) && pl[i].notified && distance(pl[i].origin,ori) >= 50)
			{
				pl[i].notified = false;
				pl[i] maps\mp\_utility::clearLowerMessage();
			}
		}
		wait .05;
	}
	pl = getentarray("player", "classname");
	for(i=0;i<pl.size;i++)	
		pl[i] maps\mp\_utility::clearLowerMessage();
}

shopacti()
{
	self endon("disconnect");
	self.openedshop = false;
	for(;;)
	{
		self waittill("openshop_acti");
		while(!self isOnGround())
			wait 0.05;
		self freezecontrols(true);
		functionused = false;
		itemlist = "" + getColour(50) + "Throwing Knifes(3)  ^7(50)\n" + getColour(1) + "Convert to XP Points\n";
		itemsize = strTok(itemlist,"\n");
		//items total = 3
		menu = "main";
			self.menubackground1 = addTextHud( self, 0, 0, .5, "left", "top", undefined , 0, 101 );	
			self.menubackground1.horzAlign = "fullscreen";
			self.menubackground1.vertAlign = "fullscreen";
			self.menubackground1 setShader("black", 640, 480);					
			self.menubackground2 = addTextHud( self, -200, 0, .4, "left", "top", "right",0, 101 );	
			self.menubackground2 setShader("nightvision_overlay_goggles", 400, 650);
			self.menubackground3 = addTextHud( self, -200, 0, .5, "left", "top", "right", 0, 101 );	
			self.menubackground3 setShader("black", 400, 650);			
			self.selection = addTextHud( self, -200, 89, .5, "left", "top", "right", 0, 102 );		
			self.selection setShader("line_vertical", 600, 22);	
			self.icon = addTextHud( self, -190, 93, 1, "left", "top", "right", 0, 104 );		
			self.icon setShader("ui_host", 14, 14);				
			self.menuitems = addTextHud( self, -165, 100, 1, "left", "middle", "right", 1.4, 103 );
			self.menuitems.color = (0,1,1);
			self.menuitems settext(itemlist);
			self.tut = addTextHud( self, -170, 300, 1, "left", "middle", "right" ,1.4, 103 );
			self.tut settext("^7Select: ^3[Right or Left Mouse]^7\nUse: ^3[[{+activate}]]^7\nLeave: ^3[[{+melee}]]");			
			self.menubackground1 thread FadeIn(.4);
			self.menubackground2 thread FadeIn(.4);
			self.menubackground3 thread FadeIn(.4);
			self.menuitems thread FadeIn(.4);
			self.selection thread FadeIn(.4);
			self.icon thread FadeIn(.4);
			self.tut thread FadeIn(.6);
			self.tut thread FadeOut(3,2.5,false);
			self thread Blur(0,3);
			self.openedshop = true;
			self.selected = 0;
			
			self.icon.x = self.icon.x + 250;
			self.selection.x = self.selection.x + 250;
			self.menuitems.x = self.menuitems.x + 250;
		
			self.icon moveOverTime( .3 );
			self.icon.x = self.icon.x - 250;
			self.selection moveOverTime( .3 );
			self.selection.x = self.selection.x - 250;
			self.menuitems MoveOverTime(.3);
			self.menuitems.x = self.menuitems.x - 250;					
			self disableWeapons();	
				wait 1;
			while(!self MeleeButtonPressed() && !functionused)
			{
				if(self attackbuttonpressed())
				{
					self playLocalSound( "mouse_over" );
					if(self.selected == itemsize.size-1)
					{
						self.selected = 0;
					}
					else 
						self.selected++;

					self.selection moveOverTime( .05 );
					if(menu == "selectplayer")
						self.selection.y = 12 + (16.8 * self.selected);
					else
						self.selection.y = 89 + (16.8 * self.selected);					
					self.icon moveOverTime( .05 );
					if(menu == "selectplayer")
						self.icon.y = 13 + (16.8 * self.selected);
					else
						self.icon.y = 93 + (16.8 * self.selected);
					for(k=0;k<7;k++)
					{
						if(!self attackbuttonpressed())
							k = 8;
							
						wait .05;
					}
				}	
				if(self adsbuttonpressed())
				{
					self playLocalSound( "mouse_over" );
					if(self.selected == 0)
					{
						self.selected = itemsize.size-1;
					}
					else 
						self.selected--;

					self.selection moveOverTime( .05 );
					if(menu == "selectplayer")
						self.selection.y = 9 + (16.8 * self.selected);
					else
						self.selection.y = 89 + (16.8 * self.selected);					
					self.icon moveOverTime( .05 );
					if(menu == "selectplayer")
						self.icon.y = 13 + (16.8 * self.selected);
					else
						self.icon.y = 93 + (16.8 * self.selected);
					self braxi\_common::clientCmd("-speed_throw");
					wait .1;
				}
				if(self UseButtonPressed() )
				{
					self playLocalSound( "mouse_over" );
					switch(menu)
					{
						case "main":
							switch(self.selected)
							{
								case 0:
									if(self getstat(1338) >= 50)
									{
										win=50;
										current=self getstat(1338);
										newamount=(current-win);
										self setstat(1338,newamount);
										self notify("updateCreditsTotal");
										self thread plugins\_throwingknife::ThrowKnife();
										self thread plugins\_throwingknife::KnifeForKill();
										self.knifesleft = 3;
										functionused = true;
									}
									else
										self IprintlnBold("^1You have not enough Credits");
									break;
									
								case 2:	
									if(self getstat(1338) >= 1)
									{
										self braxi\_rank::giveRankXP( "", self getstat(1338) );
										self iprintlnbold("+ "+self getstat(1338) +"XP");
										current=self getstat(1338);
										newamount=(current-current);
										self setstat(1338,newamount);
										self notify("updateCreditsTotal");
									}
									else
										self IprintlnBold("^1You have not enough Credits");									
									break;	
								
								
							}
							break;

					}
					self.points SetValue( self getstat(1338) );
					wait .1;
				}
				wait .05;
			}
			self.openedshop = false;
			self enableweapons();
			self freezecontrols(false);
			self braxi\_common::clientcmd("weapprev");
			self thread Blur(2,0);
			self.icon thread FadeOut(.1,0,true);
			self.menuitems thread FadeOut(.1,0,true);
			self.selection thread FadeOut(.1,0,true);
			self.menubackground1 thread FadeOut(.1);
			self.menubackground2 thread FadeOut(.1);
			self.menubackground3 thread FadeOut(.1);
		
		wait .05;
	}
}

matrix_mode()
{
	self endon ( "disconnect" );
	self endon ( "death" );
	while(1)
	{
		self hide();
			wait 0.05;
		self show();
			wait 0.05;
	}
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

jetpack_fly()
{
	self endon("death");
	self endon("disconnect");
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

ghostshop()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("death");
	iprintln("^1" +self.name +"^3 has enabled: ^1Matrix Ghost");
	for(i=0;i<100;i++)
	{
		self hide();
		wait 0.1;
		self show();
		wait 0.1;
	}
}

CustomEmblem() {
	self endon("disconnect");
	self freezeControls(1);
	y = 90;
	offset = 16.8;
	red = self duffman\_common::addTweakbar(-95,y,255/2,0,255,255/15);
	green = self duffman\_common::addTweakbar(-95,y + offset,255/2,0,255,255/15);
	blue = self duffman\_common::addTweakbar(-95,y + offset + offset,255/2,0,255,255/15);
	alpha = self duffman\_common::addTweakbar(-95,y + offset + offset + offset,.5,0,1,.05);
	modes = duffman\_common::array(red,green,blue,alpha);
	current = modes.size-1;
	weap = "ak74u_mp";
	from = self;
	shader = [];
	for(i=0;i<13;i++) {
		shader[i] = duffman\_killcard::hud( self, 0, 150, 1, "center", "top", 1.4 );
		shader[i].horzAlign = "center";
		shader[i].vertAlign = "middle";
		shader[i].sort = 100+i;
	}
	design = from duffman\_killcard::getDesign(0);
	shader[0] SetShader(design[2],design[3],design[4]);
	shader[0].color = design[0];
	shader[0].y = design[6];
	shader[0].alignY = design[5];
	shader[0].alpha = design[1];
	design = from duffman\_killcard::getDesign(1);
	shader[1] SetShader(design[2],design[3],design[4]);
	shader[1].color = design[0];
	shader[1].alpha = design[1];
	shader[1].y = design[6];
	shader[1].alignY = design[5];	
	design = from duffman\_killcard::getDesign(2);
	shader[2] SetShader(design[2],design[3],design[4]);
	shader[2].alpha = design[1];
	shader[2].color = design[0];
	shader[2].y = design[6];
	shader[2].alignY = design[5];
	shader[3] duffman\_killcard::setWeaponIcon(weap);
	shader[3].x = 80;
	shader[3].y = 185;	
	shader[3].alignX = "center";
	shader[3].alignY = "middle";
	shader[4] setText(from.pers["emblem"]);
	shader[4].y = 200;
	shader[4].glowColor = (.4,.4,.4);
	shader[4].glowAlpha = 1;
	shader[5] setValue(self duffman\_killcard::getKillStat(from GetEntityNumber()));
	shader[5].x = -7;
	shader[5].y = 175;	
	shader[5].alignX = "right";
	shader[5].font = "objective";
	shader[5].fontscale = 2;	
	shader[5].glowColor = (.4,.4,.4);
	shader[5].glowAlpha = 1;
	shader[6].label = &"-&&1";
	shader[6] setValue(from duffman\_killcard::getKillStat(self GetEntityNumber()));
	shader[6].x = -6.6;
	shader[6].y = 175;	
	shader[6].alignX = "left";
	shader[6].font = "objective";
	shader[6].fontscale = 2;
	shader[6].glowColor = (.4,.4,.4);
	shader[6].glowAlpha = 1;
	shader[7].label = &"^2K: &&1 ^7-";
	shader[7] setValue(from.pers["kills"]);
	shader[7].x = -31;
	shader[8].label = &"^3A: &&1 ^7-";
	shader[8] setValue(from.pers["assists"]);
	shader[9].label = &"^1D: &&1";
	shader[9] setValue(from.pers["deaths"]);
	shader[9].x = 29;
	shader[10].label = &"^2K/D Ratio: ^7&&1";
	shader[10].alignX = "left";
	shader[10].x = -115;
	shader[10].y = 170;
	if(from.pers[ "deaths" ])
		shader[10] setValue(int( from.pers[ "kills" ] / from.pers[ "deaths" ] * 100 ) / 100);
	else 
		shader[10] setValue(from.pers[ "kills" ]);
	shader[11].label = "ACCURACY";
	shader[11].x = -115;
	shader[11].y = 185;
	shader[11].alignX = "left";
	shader[11] setValue(int(from.pers[ "hits" ] / from.pers[ "shoots" ] * 100));
	
	if(from duffman\_playerstatus::hasPermission("founder"))
		shader[12].label = &"^1Founder";
	else if(from duffman\_playerstatus::hasPermission("leader"))
		shader[12].label = &"^1Leader";
	else if(from duffman\_playerstatus::hasPermission("headadmin"))
		shader[12].label = &"^1Headadmin";
	else if(from duffman\_playerstatus::hasPermission("fullAdmin"))
		shader[12].label = &"^1FullAdmin";
	else if(from duffman\_playerstatus::hasPermission("rookie"))
		shader[12].label = &"^1Rookie";
	else if(from duffman\_playerstatus::hasPermission("member"))
		shader[12].label = &"^1Member";
	else
		shader[12].label = &"";
	shader[12].x = -90;
	shader[12].y = 150;
	
	for(i=0;i<shader.size;i++)
	{
		old = shader[i].y;
		shader[i].y = 300;
		shader[i] MoveOverTime(.3);
		shader[i].y = old;
	}
	//-----------------------
	intro = duffman\_common::addTextHud( self, 100,100, 1, "center", "middle", "center", "middle", 1.6, 99 );
	intro setText("Press ^3[Melee^7/^3Use] ^7to change Values\nPress^3 [Frag]^7 to switch between colormodes\nPress ^3[Attack]^7 to save");
	colors = duffman\_common::addTextHud( self, -160,90, 1, "center", "middle", "center", "middle", 1.4, 99 );
	colors setText("^1Red:\n^2Green:\n^4Blue:\n^7Alpha:");
	while(!self AttackButtonPressed()) {
		shader[0].color = (self.tweakvalue[red].selection/255,self.tweakvalue[green].selection/255,self.tweakvalue[blue].selection/255);
		shader[0].alpha = self.tweakvalue[alpha].selection;
		shader[1].color = (self.tweakvalue[red].selection/255,self.tweakvalue[green].selection/255,self.tweakvalue[blue].selection/255);
		shader[1].alpha = self.tweakvalue[alpha].selection;
		shader[2].color = (self.tweakvalue[red].selection/255,self.tweakvalue[green].selection/255,self.tweakvalue[blue].selection/255);
		shader[2].alpha = self.tweakvalue[alpha].selection/2;
		wait .05;
		if(self FragButtonPressed()) {
			current++;
			if(current >= modes.size)
				current = 0;
			for(i=0;i<self.tweakvalue.size;i++) {
				if(isDefined(self.tweakvalue[i]))
					self.tweakvalue[i].foreground = 0;
			}
			self.tweakvalue[current].foreground = 1;
			while(self FragButtonPressed()) wait .05;
		}
	}
	
	col = (self.tweakvalue[red].selection/255,self.tweakvalue[green].selection/255,self.tweakvalue[blue].selection/255);
	alp = self.tweakvalue[alpha].selection;
	string = "addDesign(\"XXXX\",0,"+col+","+alp+",\"white\",252,72,\"middle\",185);\naddDesign(\"XXXX\",1,"+col+","+alp+",\"nightvision_overlay_goggles\",250,70,\"middle\",185);\naddDesign(\"XXXX\",2,"+col+","+alp/2+",\"white\",250,30,\"middle\",165);";
	filename = ""+randomint(999) +""+ randomint(999)+".theme";
	intro.x = 0;
	intro.y = 0;
	intro setText("Please make a screenshot and send it to DuffMan via Xfire (mani96x)\nPlease note only good themes will be added to the public server\nAdditional info:\n ^5 ^6 ^7 Filename: " + filename + "\n ^5 ^6 ^7 Created by: " + self.name + "\n ^5 ^6 ^7 Guid: " + getSubStr(self getGuid(),24,32));
	colors.x = 100;
	colors.y = 100;
	colors setText("Press ^3[USE] ^7to close without saving\nPress ^3[MELEE] ^7to close and save file");
	while(self useButtonPressed() || self meleebuttonpressed()) wait .05;
	while(!self useButtonPressed() && !self meleebuttonpressed()) wait .05;
	if(self meleebuttonpressed())
		duffman\_common::log("themes/"+filename,string,"write");
	for(i=0;i<shader.size;i++) {
		shader[i] MoveOverTime(.3);
		shader[i].y = 300;
	}
	wait .5;
	for(i=0;i<shader.size;i++) 
		if(isDefined(shader[i])) 
			shader[i] Destroy();
	intro destroy();
	colors destroy();
	self freezeControls(0);
}