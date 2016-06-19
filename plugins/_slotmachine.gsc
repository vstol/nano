//__/\\\______________/\\\______________________________________________________________________________________         
// _\/\\\_____________\/\\\______________________________________________________________________________________        
//  _\/\\\_____________\/\\\__/\\\_________________/\\\\\\\\______________________________________________________       
//   _\//\\\____/\\\____/\\\__\///___/\\/\\\\\\____/\\\////\\\__/\\\\\\\\\\\_____/\\\\\_____/\\/\\\\\\\____________      
//    __\//\\\__/\\\\\__/\\\____/\\\_\/\\\////\\\__\//\\\\\\\\\_\///////\\\/____/\\\///\\\__\/\\\/////\\\___________     
//     ___\//\\\/\\\/\\\/\\\____\/\\\_\/\\\__\//\\\__\///////\\\______/\\\/_____/\\\__\//\\\_\/\\\___\///____________    
//      ____\//\\\\\\//\\\\\_____\/\\\_\/\\\___\/\\\__/\\_____\\\____/\\\/______\//\\\__/\\\__\/\\\___________________   
//       _____\//\\\__\//\\\______\/\\\_\/\\\___\/\\\_\//\\\\\\\\___/\\\\\\\\\\\__\///\\\\\/___\/\\\___________________  
//        ______\///____\///_______\///__\///____\///___\////////___\///////////_____\/////_____\///____________________ 
init( version )
{
	//general
	level.shaders = strTok("ui_host;line_vertical;nightvision_overlay_goggles",";");
	for(k = 0; k < level.shaders.size; k++)
		precacheShader(level.shaders[k]);
		
	thread setupSpawnSpots();
	
	//slotmachine	
	level.cirleslotfx = loadfx ("misc/ui_flagbase_silver");
	thread circleSlotMachine();
	
	//global starts
	for(;;)
	{	 
		level waittill("connected", player);
		player thread watchkills();
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
setupSpawnSpots()  {
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

//create slotmachine trigger
circleSlotMachine()
{

maxrandom=level.spots.size;
level.slotmachinerand=RandomInt(maxrandom);

spawnspot=level.spots[level.slotmachinerand].origin;

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
	
	circle_0 thread playPlaneFxSlot();
	circle_1 thread playPlaneFxSlot();
	circle_2 thread playPlaneFxSlot();
	
	thread AddGlobalTriggerSlotMachine(circle_1.origin,circle_1.angels);
	
}

playPlaneFxSlot()
{
	self endon("disconnect");
	self endon ( "death" );
	
	PlayFX( level.cirleslotfx, self.origin);
}

AddGlobalTriggerSlotMachine(ori,angel)
{
	trigger = spawn( "trigger_radius", ori + ( 0, 0, -40 ), 0, 35, 80 );
	thread AddGlobalTriggerMsgSlotMachine(ori,trigger,"^7Press ^3[[{+activate}]] ^7to use slotmachine!");
	while(1)
	{
		trigger waittill("trigger", player);
		
		if(player usebuttonpressed() && (!isDefined(player.openedslot) || !player.openedslot) && player getStat(1338)>=5)
		{
			player thread openSlotMachine();
			wait .05;
		}
		else if(player usebuttonpressed() && (!isDefined(player.openedslot) || !player.openedslot) && player getStat(1338)<5)
		{
			player iprintlnbold("You need atleast 5 credits to open the slot machine");
		}
		wait 0.05;
	}
}

AddGlobalTriggerMsgSlotMachine(ori,owner,msg)
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

///////////////////

printPrize(reward)
{
	self iprintlnbold("You won: " +reward);
}

debug(message)
{
	self iprintln("^6DEBUG^7: " +message);
}


openSlotMachine()
{
	self endon("disconnect");
	self.openedslot=true;
	self.mover = spawn( "script_origin", self.origin );
	self.mover.angles = self.angles;
	
	//slotbackground
	self.SlotmachineBg = newClientHudElem(self);
	self.SlotmachineBg.x = 0;
	self.SlotmachineBg.y = 0;
	self.SlotmachineBg.alignX = "center";
	self.SlotmachineBg.alignY = "middle";
	self.SlotmachineBg.horzAlign = "center";
	self.SlotmachineBg.vertAlign = "middle";
	self.SlotmachineBg.alpha = .75;
	self.SlotmachineBg.sort = 990;
	self.SlotmachineBg.archived = false;
	self.SlotmachineBg setShader("black", 640, 480);
	
	self.SlotmachineBgLine = addTextHud( self, 0, 380, 1, "left", "bottom", "left", 0, 991 );		
	self.SlotmachineBgLine setShader("line_vertical", 640, 22);	
	
	self.SlotmachineBgLineTop = addTextHud( self, 0, 140, 1, "left", "bottom", "left", 0, 991 );		
	self.SlotmachineBgLineTop setShader("line_vertical", 640, 22);
	
	//spin button
	self.slotText = addTextHud( self, 0, 400, 1, "center", "bottom", "center", 1.8, 991 );	
	self.slotText settext( "^7SlotMachine");
	self.slotText.hidewheninmenu = true;
	
	self.spinButtonText = addTextHud( self, 190, 420, 1, "left", "bottom", "left", 1.8, 991 );	
	self.spinButtonText settext( "Spin( 5 Credits)");
	self.spinButtonText.hidewheninmenu = true;
	
	self.spinButton = addTextHud( self, 305, 415, 1, "left", "bottom", "left", 1.4, 991 );	
	self.spinButton settext( "^3[[{+activate}]]");
	self.spinButton.hidewheninmenu = true;
	
	//close button
	self.closeButtonText = addTextHud( self, 570, 465, 1, "left", "bottom", "left", 1.5, 991 );	
	self.closeButtonText settext( "Close");
	self.closeButtonText.hidewheninmenu = true;
	     
	self.closeButton = addTextHud( self, 600, 455, 1, "left", "bottom", "left", 1.4, 991 );	
	self.closeButton settext( "^3[[{+melee}]]");
	self.closeButton.hidewheninmenu = true;
	
	//stock images
	//killerspray = ( "spray" + killer getStat(979) + "_menu" );
	self.slot1 = newClientHudElem(self);
	self.slot1.x = -200;
	self.slot1.y = 0;
	self.slot1.alignX = "center";
	self.slot1.alignY = "middle";
	self.slot1.horzAlign = "center";
	self.slot1.vertAlign = "middle";
	self.slot1.alpha = 1;
	self.slot1.sort = 991;
	self.slot1.archived = false;
	self.slot1 setShader("spray4_menu", 180, 180);
	self.slot1.hidewheninmenu = true;
	
	self.slot2 = newClientHudElem(self);
	self.slot2.x = 0;
	self.slot2.y = 0;
	self.slot2.alignX = "center";
	self.slot2.alignY = "middle";
	self.slot2.horzAlign = "center";
	self.slot2.vertAlign = "middle";
	self.slot2.alpha = 1;
	self.slot2.sort = 991;
	self.slot2.archived = false;
	self.slot2 setShader("spray4_menu", 180, 180);
	self.slot2.hidewheninmenu = true;
	
	self.slot3 = newClientHudElem(self);
	self.slot3.x = 200;
	self.slot3.y = 0;
	self.slot3.alignX = "center";
	self.slot3.alignY = "middle";
	self.slot3.horzAlign = "center";
	self.slot3.vertAlign = "middle";
	self.slot3.alpha = 1;
	self.slot3.sort = 991;
	self.slot3.archived = false;
	self.slot3 setShader("spray4_menu", 180, 180);
	self.slot3.hidewheninmenu = true;
	
	//credits
	self.MyCredits = newClientHudElem(self);	
	self.MyCredits.x = 190;
	self.MyCredits.y = -20;
	self.MyCredits.horzAlign = "left";	
	self.MyCredits.vertAlign = "bottom";
	self.MyCredits.alignX = "left";
	self.MyCredits.alignY = "bottom";
	self.MyCredits.sort = 991;
	self.MyCredits.foreground = 1;
	self.MyCredits.archived = false;
	self.MyCredits.alpha = 1;
	self.MyCredits.fontScale = 2;
	self.MyCredits.hidewheninmenu = false;
	self.MyCredits.glowColor = (1,1,1);
	self.MyCredits.glowAlpha = 0;
	self.MyCredits.color = (1,1,1);
	self.MyCredits.label = &"^7Credits:^1 &&1 / 255";
	
	//Wins
	self.WinAmount = newClientHudElem(self);	
	self.WinAmount.x = 0;
	self.WinAmount.y = 50;
	self.WinAmount.horzAlign = "center";	
	self.WinAmount.vertAlign = "top";
	self.WinAmount.alignX = "center";
	self.WinAmount.alignY = "top";
	self.WinAmount.sort = 991;
	self.WinAmount.foreground = 1;
	self.WinAmount.archived = false;
	self.WinAmount.alpha = 0;
	self.WinAmount.fontScale = 3;
	self.WinAmount.hidewheninmenu = false;
	self.WinAmount.glowColor = (1,1,1);
	self.WinAmount.glowAlpha = 0.6;
	self.WinAmount.color = (1,1,1);
	self.WinAmount.label = &"^7You won:^1 &&1";
	
	/////////buttons
	self thread Spin();
	self thread closeSlotMachine();
		
	while(isDefined(self.MyCredits))
	{		
		self.MyCredits setValue(self getstat(1338));
		wait .05;
		self waittill("updateCreditsTotal");
	}	
}

//slotmachine behaviour
Spin()
{
	self endon("disconnect");
	self endon("end_slotmachine");
	
	self.spinning=false;
		
	wait 1;
	while(1)
	{
		if(self UseButtonPressed() && !self.spinning)
		{
			if(self getstat(1338)>=5)
			{
				self.spinning=true;	
				win=5;
				current=self getstat(1338);
				newamount=(current-win);
				self setstat(1338,newamount);
				self notify("updateCreditsTotal");
				self.WinAmount.alpha = 0;
				
				self thread SpinSlot1();
				self thread SpinSlot2();
				self thread SpinSlot3();
			
				wait 3.2;
				self thread CheckWin();
				wait 1;
				self.spinning=false;
			}
		}
		wait 0.05;
	}
}

//check wins
CheckWin()
{
	self endon("disconnect");
	slot1=self.sprayNum1;
	slot2=self.sprayNum2;
	slot3=self.sprayNum3;
	
	//self debug(slot1+" "+slot2+" "+slot3);
	
	self.winpattern=false;
	
	//check win patterns
	if(slot1==0 && slot2==0 && slot3==0)
	{
		self printPrize("JACKPOT");
		wait 1;
		self printPrize("10000 XP");
		wait 1;
		self printPrize("255 Credits");
				
		current=self getstat(1338);
		win=(255-current);
		if((current+win)>255)
			newamount=255;
		else
			newamount=(current+win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		
		self.WinAmount setvalue(win);
		self.WinAmount.alpha = 1;
		self ForcecloseSlotMachine();
		wait .5;
		jackpotprize();
		self.winpattern=true;
	}
	
	if((slot1==4 && slot2==4 )|| (slot2==4 && slot3==4))
	{
		self printPrize("1000 XP");
		self braxi\_rank::giveRankXP( "", 1000 );
		self.winpattern=true;
		self ForcecloseSlotMachine();
	}
	
	if((slot1==6 && slot2==6 )|| (slot2==6 && slot3==6))
	{
		self printPrize("2000 XP");
		self braxi\_rank::giveRankXP( "", 2000 );
		self.winpattern=true;
		self ForcecloseSlotMachine();
	}

	if((slot1==7 && slot2==7) || (slot2==7 && slot3==7) || (slot1==7 && slot3==7) || (slot1==7 && slot2==7 && slot3==7))
	{
		self printPrize("3000 XP");
		self braxi\_rank::giveRankXP( "", 3000 );
		self.winpattern=true;
		self ForcecloseSlotMachine();
	}
	
	if((slot1==11 && slot2==11) || (slot2==11 && slot3==11) || (slot1==11 && slot3==11) || (slot1==11 && slot2==11 && slot3==11))
	{
		self printPrize("Life");
		self thread braxi\_mod::giveLife();
		self.winpattern=true;
		self ForcecloseSlotMachine();
	}
	
	if(!self.winpattern)
	{
		if( slot1==slot2 || slot2==slot3 )
		{	
			win=25;
			current=self getstat(1338);
			if((current+win)>255)
			newamount=255;
			else
			newamount=(current+win);
			self setstat(1338,newamount);
			self notify("updateCreditsTotal");
			
			self.WinAmount setvalue(25);
			self printPrize("Credits");
			self.WinAmount.alpha = 1;
		}
		
		if(slot1==slot2 && slot1==slot3)
		{	
			win=50;
			current=self getstat(1338);
			if((current+win)>255)
			newamount=255;
			else
			newamount=(current+win);
			self setstat(1338,newamount);
			self notify("updateCreditsTotal");
			
			self.WinAmount setvalue(50);
			self printPrize("Credits");
			self.WinAmount.alpha = 1;
			
		}
	}
}

jackpotprize()
{
	self endon("disconnect");
	self endon("endjackpot");
	level endon( "endround" );
	
	while ( self.pers["score"] <= 10000 )
	{
		self braxi\_rank::giveRankXP( "", 1000 );
		wait 0.2;
		
		if(self.pers["score"] > 10000 )
			self notify("endjackpot");	
	}
}

//spin slots 1-2-3
SpinSlot1()
{
	for(i=0;i<20 && isdefined(self.slot1);i++)
	{
		self.sprayNum1 = randomint(12);
		self.slot1 setShader("spray"+self.sprayNum1+"_menu", 180, 180);				
		wait 0.05;
	}
}

SpinSlot2()
{
	for(i=0;i<40 && isdefined(self.slot2);i++)
	{
		self.sprayNum2 = randomint(12);
		self.slot2 setShader("spray"+self.sprayNum2+"_menu", 180, 180);				
		wait 0.05;
	}
}

SpinSlot3()
{
	for(i=0;i<60 && isdefined(self.slot3);i++)
	{
		self.sprayNum3 = randomint(12);
		self.slot3 setShader("spray"+self.sprayNum3+"_menu", 180, 180);				
		wait 0.05;
	}
}

//destroyer
closeSlotMachine()
{
	//self debug("close");
	self endon("death");
	self endon("end_slotmachine");
	
	while(1)
	{	
	
	if ( self MeleeButtonPressed() )
		{
		self.openedslot=false;
		self unlink();
		
		//background
		self.SlotmachineBg destroy();
		self.SlotmachineBgLine destroy();
		self.SlotmachineBgLineTop destroy();
		self.slotText destroy();
		
		//spinbuttons
		self.spinButton destroy();
		self.spinButtonText destroy();	
		
		//closebuttons
		self.closeButton destroy();
		self.closeButtonText destroy();
		
		//credits
		self.MyCredits destroy();
		self.WinAmount destroy();
		
		//slots
		self.slot1 destroy();
		self.slot2 destroy();
		self.slot3 destroy();
		self notify("end_slotmachine");
		}
	wait 0.05;
	}
}

ForcecloseSlotMachine()
{
	
	//self debug("close");
	self.openedslot=false;
	self unlink();
		
		//background
		self.SlotmachineBg destroy();
		self.SlotmachineBgLine destroy();
		self.SlotmachineBgLineTop destroy();
		self.slotText destroy();
		
		//spinbuttons
		self.spinButton destroy();
		self.spinButtonText destroy();	
		
		//closebuttons
		self.closeButton destroy();
		self.closeButtonText destroy();
		
		//credits
		self.MyCredits destroy();
		self.WinAmount destroy();
		
		//slots
		self.slot1 destroy();
		self.slot2 destroy();
		self.slot3 destroy();
		self notify("end_slotmachine");
		
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