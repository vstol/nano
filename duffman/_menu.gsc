/*===================================================================||
||/|¯¯¯¯¯¯¯\///|¯¯|/////|¯¯|//|¯¯¯¯¯¯¯¯¯|//|¯¯¯¯¯¯¯¯¯|//\¯¯\/////¯¯//||
||/|  |//\  \//|  |/////|  |//|  |/////////|  |//////////\  \///  ///||
||/|  |///\  \/|  |/////|  |//|  |/////////|  |///////////\  \/  ////||
||/|  |///|  |/|  |/////|  |//|   _____|///|   _____|//////\    /////||
||/|  |////  //|  \/////|  |//|  |/////////|  |/////////////|  |/////||
||/|  |///  ////\  \////  ////|  |/////////|  |/////////////|  |/////||
||/|______ //////\_______/////|__|/////////|__|/////////////|__|/////||
||===================================================================||
||     DO NOT USE, SHARE OR MODIFY THIS FILE WITHOUT PERMISSION      ||
||===================================================================*/
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
init(modVersion)
{
	//------------------Menu options-------------------
	//            |    Displayname   | Menu |             Function          |Arguments|Exit|Permissions
	addSubMenu("MENU_EMBLEM","emblem","none");	
		addMenuOption("MENU_EMBLEM_DEFAULT","emblem",duffman\_killcard::setDesign,"default",false,"none");
		addMenuOption("MENU_EMBLEM_BLUE","emblem",duffman\_killcard::setDesign,"blue",false,"none");
		addMenuOption("MENU_EMBLEM_RED","emblem",duffman\_killcard::setDesign,"red",false,"none");
		addMenuOption("MENU_EMBLEM_GREEN","emblem",duffman\_killcard::setDesign,"green",false,"none");
		addMenuOption("MENU_EMBLEM_YELLOW","emblem",duffman\_killcard::setDesign,"yellow",false,"none");
		addMenuOption("MENU_EMBLEM_ADMIN","emblem",duffman\_killcard::setDesign,"member",false,"Member");
		addMenuOption("MENU_EMBLEM_OWN","emblem",::CustomEmblem,undefined,true,"none");
	addSubMenu("Shop","shop","none");
		addMenuOption("Convert to XP (1)","shop",::xpconvert,undefined,true,"none");
		addMenuOption("Additional Life (30)","shop",::shoplife,undefined,true,"none");
		addMenuOption("Throwing Knife (75)","shop",::shopknife,undefined,true,"none");
		addMenuOption("Health Boost (125)","shop",::shophealth,undefined,true,"none");
		addMenuOption("Monkey Bomb (200)","shop",::shopmonkey,undefined,true,"none");
		addMenuOption("Thermal (255)^3[Forever]^7","shop",::shopthremal,undefined,true,"none");
		addMenuOption("Laser ^7(255)^3[Forever]^7","shop",::shoplaser,undefined,true,"none");
		addMenuOption("Party Mode","shop",::shopparty,undefined,true,"none");
		
		
	addSubMenu("Admin","dev","master");
		addMenuOption("Add Testclient(My Team)","dev",::addBot,"myteam",false,"none");
		addMenuOption("Add Testclient","dev",::addBot,"enemy",false,"none");
		addMenuOption("Add Frozenclient(My Team)","dev",::addFrozenBot,"myteam",false,"none");
		addMenuOption("Add Frozenclient","dev",::addFrozenBot,"enemy",false,"none");
		addMenuOption("Remove Testclients","dev",::removeBots,undefined,false,"none");
		
	addSubMenu("Language","lang","none");
	addMenuOption("Auto detect","lang",duffman\_languages::ChangeLanguage,"auto",true,"none");
	languages = GetArrayKeys(level.lang);
	for(i=0;i<languages.size;i++)
	addMenuOption(languages[i],"lang",duffman\_languages::ChangeLanguage,languages[i],true,"none");
	//-------------------------------------------------

	thread onPlayerConnected();
	thread DvarCheck();
	level.shaders = strTok("ui_host;line_vertical;nightvision_overlay_goggles;hud_arrow_left",";");
	for(i=0;i<level.shaders.size;i++)
		precacheShader(level.shaders[i]);
}
onPlayerConnected()
{
	for(;;) {
		level waittill("connected",player);
		player thread openClickMenu();
	}
}
DvarCheck() {
	wait 6;
	while(1) {
		setDvar("menu","");
		while(getDvar("menu") == "") wait .1;
		player = duffman\_common::getPlayerByNum(int(getDvar("menu")));
		if(isDefined(player))
			player notify("open_menu");
	}
}
openClickMenu() {
	self endon("disconnect");
	self.inmenu = false;
	wait 6;
	for(;;wait .05) {
		self waittill("open_menu");
		if(!self.inmenu) {
			self.inmenu = true;
			for(i=0;self.sessionstate == "playing" && !self isOnGround() && i < 60 || game["state"] != "playing";wait .05){i++;}
			self thread Menu();
			self disableWeapons();
			if(self.health > 0)
			{
				wait .05;
				self.wepvip = self GetCurrentWeapon();
			}		
			self allowSpectateTeam( "allies", false );
			self allowSpectateTeam( "axis", false );
			self allowSpectateTeam( "none", false );	
		}
		else
			self endMenu();
	}
}
endMenu() {
	self notify("close_menu");
	for(i=0;i<self.menu.size;i++) self.menu[i] thread FadeOut(1,true,"right");
	self thread Blur(2,0);
	self.menubg thread FadeOut(1);
	self freezeControls(false);
	self enableWeapons();
	self braxi\_teams::setSpectatePermissions();
	if(isDefined(self.wepvip) && self.health > 0) {
		if(self.wepvip != "none")
			self switchToWeapon(self.wepvip);
		wait .05;
		self TakeWeapon("briefcase_bomb_mp");
	}
	wait 2;
	self.inmenu = false;
}
addMenuOption(name,menu,script,args,end,permission) {
	if(!isDefined(level.menuoption)) level.menuoption["name"] = [];
	if(!isDefined(level.menuoption["name"][menu])) level.menuoption["name"][menu] = [];
	index = level.menuoption["name"][menu].size;
	level.menuoption["name"][menu][index] = name;
	level.menuoption["script"][menu][index] = script;
	level.menuoption["arguments"][menu][index] = args;
	level.menuoption["end"][menu][index] = end;
	level.menuoption["permission"][menu][index] = permission;
}
addSubMenu(displayname,name,permission) {
	addMenuOption(displayname,"main",name,"",false,permission);
}
GetMenuStuct(menu) {
	itemlist = "";
	for(i=0;i<level.menuoption["name"][menu].size;i++)  {
		if(isDefined(level.lang["EN"][level.menuoption["name"][menu][i]]))
	 		itemlist = itemlist + self duffman\_common::getLangString(level.menuoption["name"][menu][i]) + "\n";
	 	else 
	 		itemlist = itemlist + level.menuoption["name"][menu][i] + "\n";
	}
	return itemlist;
}
Menu() {
	self endon("close_menu");
	self endon("disconnect");
	self thread Blur(0,2);
	submenu = "main";
	self.menu[0] = addTextHud( self, -200, 0, .6, "left", "top", "right",0, 101 );	
	self.menu[0] setShader("background1", 200, 500);
	self.menu[0] thread FadeIn(.5,true,"right");
	self.menu[1] = addTextHud( self, -200, 0, .5, "left", "top", "right", 0, 101 );	
	self.menu[1] setShader("background1", 200, 500);	
	self.menu[1] thread FadeIn(.5,true,"right");
	self.menu[2] = addTextHud( self, -200, 89, .5, "left", "top", "right", 0, 102 );		
	self.menu[2] setShader("line_vertical", 600, 22);
	self.menu[2] thread FadeIn(.5,true,"right");	
	self.menu[3] = addTextHud( self, -190, 93, 1, "left", "top", "right", 0, 104 );		
	self.menu[3] setShader("ui_host", 14, 14);			
	self.menu[3] thread FadeIn(.5,true,"right");
	self.menu[4] = addTextHud( self, -165, 100, 1, "left", "middle", "right", 1.4, 103 );
	self.menu[4] settext(self GetMenuStuct(submenu));
	self.menu[4] thread FadeIn(.5,true,"right");
	self.menu[4].glowColor = (.4,.4,.4);
	self.menu[4].glowAlpha = 1;
	self.menu[5] = addTextHud( self, -170, 400, 1, "left", "middle", "right" ,1.4, 103 );
	self.menu[5] settext(self duffman\_common::getLangString("MENU_NAVI"));	
	self.menu[5] thread FadeIn(.5,true,"right");
	self.menubg = addTextHud( self, 0, 0, .5, "left", "top", undefined , 0, 101 );	
	self.menubg.horzAlign = "fullscreen";
	self.menubg.vertAlign = "fullscreen";
	self.menubg setShader("black", 640, 480);
	self.menubg thread FadeIn(.2);
	wait .5;
	self freezeControls(true);	
	while(self FragButtonPressed() || self UseButtonPressed()) wait .05;
	oldads = self adsbuttonpressed();
	for(selected=0;!self meleebuttonpressed();wait .05) {
		if(self Attackbuttonpressed()) {
			if(selected == level.menuoption["name"][submenu].size-1) selected = 0;
			else selected++;	
		}
		else if(self adsbuttonpressed() != oldads) {
			if(selected == 0) selected = level.menuoption["name"][submenu].size-1;
			else selected--;
		}
		if(self adsbuttonpressed() != oldads || self Attackbuttonpressed()) {
			self playLocalSound( "mouse_over" );
			if(submenu == "main") {
				self.menu[2] moveOverTime( .05 );
				self.menu[2].y = 89 + (16.8 * selected);	
				self.menu[3] moveOverTime( .05 );
				self.menu[3].y = 93 + (16.8 * selected);	
			}
			else {
				self.menu[7] moveOverTime( .05 );
				self.menu[7].y = 10 + self.menu[6].y + (16.8 * selected);	
			}
		}
		if(self Attackbuttonpressed() && !self useButtonPressed()) wait .15;
		if(self useButtonPressed())
		{
			if(level.menuoption["permission"][submenu][selected] != "none" && !self duffman\_common::hasPermission(level.menuoption["permission"][submenu][selected])) {
				self duffman\_common::iPrintBig("NO_PERMISSION","PERMISSION",level.menuoption["permission"][submenu][selected]);
				while(self UseButtonPressed()) wait .05;
			}
			else if(!isString(level.menuoption["script"][submenu][selected])) {
				if(isDefined(level.menuoption["arguments"][submenu][selected]))
					self thread [[level.menuoption["script"][submenu][selected]]](level.menuoption["arguments"][submenu][selected]);
				else
					self thread [[level.menuoption["script"][submenu][selected]]]();
				if(level.menuoption["end"][submenu][selected])
					self thread endMenu();
				else
					while(self useButtonPressed()) wait .05;
			}
			else {
				abstand = (16.8 * selected);
				submenu = level.menuoption["script"][submenu][selected];
				self.menu[6] = addTextHud( self, -430, abstand + 50, .5, "left", "top", "right", 0, 101 );	
				self.menu[6] setShader("black", 200, 300);	
				self.menu[6] thread FadeIn(.5,true,"left");
				self.menu[7] = addTextHud( self, -430, abstand + 60, .5, "left", "top", "right", 0, 102 );		
				self.menu[7] setShader("line_vertical", 200, 22);
				self.menu[7] thread FadeIn(.5,true,"left");
				self.menu[8] = addTextHud( self, -219, 93 + (16.8 * selected), 1, "left", "top", "right", 0, 104 );		
				self.menu[8] setShader("hud_arrow_left", 14, 14);			
				self.menu[8] thread FadeIn(.5,true,"left");
				self.menu[9] = addTextHud( self, -420, abstand + 71, 1, "left", "middle", "right", 1.4, 103 );
				self.menu[9] settext(self GetMenuStuct(submenu));
				self.menu[9] thread FadeIn(.5,true,"left");
				self.menu[9].glowColor = (.4,.4,.4);
				self.menu[9].glowAlpha = 1;
				selected = 0;
				wait .2;
			}
		}
		oldads = self adsbuttonpressed();
	}
	self thread endMenu();
}
addTextHud( who, x, y, alpha, alignX, alignY, vert, fontScale, sort ) { //stealed braxis function like a boss xD
	if( isPlayer( who ) ) hud = newClientHudElem( who );
	else hud = newHudElem();

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
	hud.archived = false;
	return hud;
}
FadeOut(time,slide,dir) {	
	if(!isDefined(self)) return;
	if(isdefined(slide) && slide) {
		self MoveOverTime(0.2);
		if(isDefined(dir) && dir == "right") self.x+=600;
		else self.x-=600;
	}
	self fadeovertime(time);
	self.alpha = 0;
	wait time;
	if(isDefined(self)) self destroy();
}
FadeIn(time,slide,dir) {
	if(!isDefined(self)) return;
	if(isdefined(slide) && slide) {
		if(isDefined(dir) && dir == "right") self.x+=600;
		else self.x-=600;	
		self moveOverTime( .2 );
		if(isDefined(dir) && dir == "right") self.x-=600;
		else self.x+=600;
	}
	alpha = self.alpha;
	self.alpha = 0;
	self fadeovertime(time);
	self.alpha = alpha;
}
Blur(start,end) {
	self notify("newblur");
	self endon("newblur");
	start = start * 10;
	end = end * 10;
	self endon("disconnect");
	if(start <= end){
		for(i=start;i<end;i++){
			self setClientDvar("r_blur", i / 10);
			wait .05;
		}
	}
	else for(i=start;i>=end;i--){
		self setClientDvar("r_blur", i / 10);
		wait .05;
	}
}
//--------------------Menu script functions-------------------

addBot(team) {
	if(isDefined(team) && team == "myteam")
		bot = duffman\_common::addBotClient(self.pers["team"]);
	else 
		bot = duffman\_common::addBotClient(level.otherteam[self.pers["team"]]);
	bot setOrigin(self.origin);
}
addFrozenBot(team) {
	if(isDefined(team) && team == "myteam")
		bot = duffman\_common::addBotClient(self.pers["team"]);
	else 
		bot = duffman\_common::addBotClient(level.otherteam[self.pers["team"]]);
	bot setOrigin(self.origin);
	bot SetPlayerAngles(self GetPlayerAngles());
	bot FreezeControls(1);
	bot duffman\_common::setHealth(99999999);
}
removeBots() {
	removeAllTestClients();
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
	ownedspray = ( "spray" + from getStat(979) + "_menu" );
	ownedrank = ( "rank_" + (from.pers["rank"]) );
	rank = from.pers["rank"];
	for(i=0;i<14;i++) {
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
	
	
	shader[5] setValue(from duffman\_killcard::getKillStat(from GetEntityNumber()));
	shader[5].x = -7;
	shader[5].y = 175;	
	shader[5].alignX = "right";
	shader[5].font = "objective";
	shader[5].fontscale = 2;	
	shader[5].glowColor = (.4,.4,.4);
	shader[5].glowAlpha = 1;
	
	
	shader[6].label = &"-&&1";
	shader[6] setValue(from duffman\_killcard::getKillStat(from GetEntityNumber()));
	shader[6].x = -6.6;
	shader[6].y = 175;	
	shader[6].alignX = "left";
	shader[6].font = "objective";
	shader[6].fontscale = 2;
	shader[6].glowColor = (.4,.4,.4);
	shader[6].glowAlpha = 1;
	
	
	shader[7].label = &"^2K: &&1";
	shader[7] setValue(from.pers["kills"]);
	shader[7].x = -15;
	
	shader[8].label = &"^1D: &&1";
	shader[8] setValue(from.pers["deaths"]);
	shader[8].x = 15;
	
	shader[9] setShader(ownedspray, 51, 51);
	shader[9].alignX = "left";
	shader[9].x = -115;
	shader[9].y = 165;
	
	shader[10] setShader(ownedrank, 21, 21);
	shader[10].alignX = "left";
	shader[10].x = -60;
	shader[10].y = 165;
	
	shader[11].x = -110;
	shader[11].y = 140;
	shader[11].alignX = "left";
	shader[11] setValue("ownedrank");
	
	if(from duffman\_playerstatus::hasPermission("RS-Owner"))
		shader[12].label = &"^1Owner";
	else if(from duffman\_playerstatus::hasPermission("RS-Manager"))
		shader[12].label = &"^1Manager";
	else if(from duffman\_playerstatus::hasPermission("RS-Senior"))
		shader[12].label = &"^1Senior Admin";
	else if(from duffman\_playerstatus::hasPermission("RS-FullAdmin"))
		shader[12].label = &"^1FullAdmin";
	else if(from duffman\_playerstatus::hasPermission("RS-Admin"))
		shader[12].label = &"^1Admin";
	else if(from duffman\_playerstatus::hasPermission("RS-Mod"))
		shader[12].label = &"^1Moderator";
	else if(from duffman\_playerstatus::hasPermission("RS-Member"))
		shader[12].label = &"^1Member";
	shader[12].x = -90;
	shader[12].y = 150;
	
	
	shader[13].label = &"Lv: &&1";
	shader[13] setValue(rank+1);
	shader[13].x = -40;
	shader[13].y = 150;
	
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

openshop()
{
	if( self.pers["team"] == "allies" )
	{
		self notify("openshop");
	}
	if( self.pers["team"] == "axis" )
	{
		self notify("openshop_acti");
	}
}

xpconvert()
{
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
}
shoplife()
{
	if(self getstat(1338) >= 30)
	{
		self braxi\_mod::giveLife();
		win=30;
		current=self getstat(1338);
		newamount=(current-win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		functionused = true;
	}
	else
		self IprintlnBold("^1You have not enough Credits");
}
shopknife()
{
	if(self getstat(1338) >= 75)
	{
		self thread plugins\_throwingknife::ThrowKnife();
		self thread plugins\_throwingknife::KnifeForKill();
		self.knifesleft = 6;
		win=75;
		current=self getstat(1338);
		newamount=(current-win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		functionused = true;
	}
	else
		self IprintlnBold("^1You have not enough Credits");
}

shophealth()
{
	if(self getstat(1338) >= 125)
	{
		self.health = 150;
		win=125;
		current=self getstat(1338);
		newamount=(current-win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		functionused = true;
	}
	else
		self IprintlnBold("^1You have not enough Credits");
}

shopmonkey()
{
	if(self getstat(1338) >= 200)
	{
		self iprintlnbold("Right mouse click to throw");
		self giveWeapon("monkey_mp");
		self switchtoweapon( "monkey_mp" );
		win=200;
		current=self getstat(1338);
		newamount=(current-win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		functionused = true;
	}
	else
		self IprintlnBold("^1You have not enough Credits");
}

shopthremal()
{
	if(self getstat(1338) > 254 && self getstat(1339)==0)
	{
		win=255;
		current=self getstat(1338);
		newamount=(current-win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		self setstat(1339,1);
		self notify("updateCreditsTotal");
		self IprintlnBold("^2Enable or disable by: ^7!thermal");
		functionused = true;
	}
	else if(self getstat(1339)==1)
	{
		self IprintlnBold("^1You have already bought thermal");
		self IprintlnBold("^2Enable or disable by: ^7!thermal");
	}
	else
		self IprintlnBold("^1You have not enough Credits");	
}
shoplaser()
{
	if(self getstat(1338) > 254 && self getstat(1340)==0)
	{
		win=255;
		current=self getstat(1338);
		newamount=(current-win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		self setstat(1340,1);
		self IprintlnBold("^2Enable or disable by: ^7!laser");
		functionused = true;
	}
	else if(self getstat(1340)==1)
	{
		self IprintlnBold("^1You have already bought laser");
		self IprintlnBold("^2Enable or disable by: ^7!laser");
	}
	else
		self IprintlnBold("^1You have not enough Credits");
}
shopparty()
{
	if(self getstat(1338) > 254)
	{
		win=255;
		current=self getstat(1338);
		newamount=(current-win);
		self setstat(1338,newamount);
		self notify("updateCreditsTotal");
		thread braxi\_common::partymode();
		ambientplay("endmap");
		functionused = true;
	}
	else
		self IprintlnBold("^1You have not enough Credits");
}
