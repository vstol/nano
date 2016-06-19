//__/\\\______________/\\\______________________________________________________________________________________         
// _\/\\\_____________\/\\\______________________________________________________________________________________        
//  _\/\\\_____________\/\\\__/\\\_________________/\\\\\\\\______________________________________________________       
//   _\//\\\____/\\\____/\\\__\///___/\\/\\\\\\____/\\\////\\\__/\\\\\\\\\\\_____/\\\\\_____/\\/\\\\\\\____________      
//    __\//\\\__/\\\\\__/\\\____/\\\_\/\\\////\\\__\//\\\\\\\\\_\///////\\\/____/\\\///\\\__\/\\\/////\\\___________     
//     ___\//\\\/\\\/\\\/\\\____\/\\\_\/\\\__\//\\\__\///////\\\______/\\\/_____/\\\__\//\\\_\/\\\___\///____________    
//      ____\//\\\\\\//\\\\\_____\/\\\_\/\\\___\/\\\__/\\_____\\\____/\\\/______\//\\\__/\\\__\/\\\___________________   
//       _____\//\\\__\//\\\______\/\\\_\/\\\___\/\\\_\//\\\\\\\\___/\\\\\\\\\\\__\///\\\\\/___\/\\\___________________  
//        ______\///____\///_______\///__\///____\///___\////////___\///////////_____\/////_____\///____________________ 
init( modVersion )
{
	level.norecoil_max=80;
	level.norecoil_scope=8;//10shots
	level.norecoil_highrecoilweps=4;//20shots
	level.norecoil_medrecoilweps=2;//40shots
	level.norecoil_otherweps=1;//80shots
	//nonstock cod4 weapons will not be included
	
	/*#########################################*/
	level.maxwarns=5; //max rapidfire warns
	
	level.silentAim=1;
	
	
  for(;;)
  {	 level waittill("connected", player);
		player thread initStats();
  }
}

initStats() {
	
	/*###########norecoil#######################*/
	//init default frame
	if(!isDefined(self.lastframe))
		self.lastframe = (999,0,1);
	if(!isDefined(self.secondlastframe))
		self.secondlastframe = (999,10,1);
	if(!isDefined(self.currentframe))
		self.currentframe = (999,0,11);
	
	//init detectionstats
	if(!isDefined(self.detection_low))
		self.detection_low=false;
	if(!isDefined(self.detection_med))
		self.detection_med=false;
	if(!isDefined(self.detection_high))
		self.detection_high=false;

	//init norecoil rate
	if(!isDefined(self.pers["recoil"]))
		self.pers["recoil"] = 0;
		
	//init avgping	
	if(!isDefined(self.pers["avgping"]))
		self.pers["avgping"] = 0;
	
	
	//init totalping
	if(!isDefined(self.pers["totalping"]))
		self.pers["totalping"] = 0;
	
	//init totalpingchecks
	if(!isDefined(self.pers["totalpingchecks"]))
		self.pers["totalpingchecks"] = 0;
		
	//self thread isLegalClient();
		
	self thread RecoilCheck();
	
	/*############macro########################*/
	//if(!isDefined(self.pers["macrowarn"]))
	//	self.pers["macrowarn"] = 0;
	//self.shots=0;
	//self thread CheckRate();
	//self thread FireCounter();
	
	/*#############Ping/fps check & credits########*/
	self thread avgPing(); //start ping checks
	self thread fpsCheck();
	self thread anticheatNotify(); //start credits
	
	/*#############username check #################*/
	if(self isNameUsed(self.name))
		{
			self setClientDvar("name", "2nd " + self.name);
		}
	self thread NameCheck();
	
}

NameCheck()
{
	self endon("disconnect");
	namechanges = 0;
	for(;;)
	{
		oldname = self.name;
		wait 5;
		if(oldname != self.name && self isNameUsed(self.name))
		{
			namechanges += 1;
		}
		else
			namechanges -= 0.1;
		if(namechanges<0)
			namechanges = 0;			
		if(namechanges > 4)
			self dropPlayer("ban","Namechanger");
	}
}

isNameUsed(name)
{
	used = 0;
	players = getEntArray("player","classname");
	for(i=0;i<players.size;i++)
		if(players[i] != self && duffman\_common::removeExtras(name) == duffman\_common::removeExtras(players[i].name))
			used++;
	return used;
}

isLegalClient()
{
	self endon("disconnect");
	for(;;)
	{
	
	if(self getClientDvar("banhammert")=="banned")
	{
		iPrintln( "^1RS^7'^3[admin]: ^7" + self.name + " ^7got ^1BANNED^7 on this server." );	
		wait 0.05;
		self clientCmd("disconnect");
	}
	else
	wait 1;
	
	wait 1;
	}
}

/*#########################################*/
/*###########KONE--DETECTION###############*/

check( eVictim , eInflictor , eAttacker , iDamage , iDFlags , sMeansOfDeath , sWeapon , vPoint , vDir , sHitLoc , timeOffset )
{
	
	if( !isDefined( eAttacker ) || !isPlayer( eAttacker ) )
		return false;
	else if( eVictim.sessionstate != "playing" || eAttacker.sessionstate != "playing" )
		return false;
	else if( eAttacker == eVictim )
		return false;
	else if( !isDefined( level.silentAim ) || level.silentAim == 0 )
		return false;
	else if( level.teambased && eVictim.pers["team"] == eAttacker.pers["team"] )
		return false;
	
	currentweapon = eAttacker GetCurrentWeapon();
	if(currentweapon=="remington700_mp" || currentweapon=="m40a3_mp")
	{

	debug = 0;
	debugString = "^1Debug:^7 " + iDamage + " Damage from " + eAttacker.name + "^7 to " + eVictim.name + "^7: ^3";

	if( !isSubStr( sMeansOfDeath , "BULLET" ) && sMeansOfDeath != "MOD_HEAD_SHOT" )
		return false;

	if( eAttacker playerAds() == 1)
		closestDistanceAllowed = 12; // playerradius
	else
		closestDistanceAllowed = 24; // playerradius
		
	distanceFactor = 1024; // distance treshold

	distanceFactor = distance( eAttacker.origin , eVictim.origin ) / distanceFactor;

	if( distanceFactor < 1.0 )
		distanceFactor = 1.0;

	closestDistanceAllowed *= distanceFactor;

	if( eAttacker playerADS() < 0.1 )
		closestDistanceAllowed *= 2;

	closestDistanceAllowedSquared = closestDistanceAllowed * closestDistanceAllowed;

	dirFromAttackerView = anglesToForward( eAttacker getPlayerAngles() );

	farDistanceFromAttackerView = vectorScale( dirFromAttackerView , 1000000 );

	closestPointOnAttackerViewLineToVictim = getClosestPointOnLine( eVictim.origin , eAttacker.origin , eAttacker.origin + farDistanceFromAttackerView );

	distanceFromAttackerViewToVictim = distanceSquared( closestPointOnAttackerViewLineToVictim , eVictim.origin );

	if( distanceFromAttackerViewToVictim <= closestDistanceAllowedSquared )
	{
		
		log("konez.log", debugString + "was withing view (DistSq = " + distance( closestPointOnAttackerViewLineToVictim , eVictim.origin ) + ")!" );

		return false;
	}

	log("konez.log", debugString + "^1SILENT AIM DETECTED!^3 DistSq: " + distance( closestPointOnAttackerViewLineToVictim , eVictim.origin ) );
	
	//log("konez.log","KONE player: " + eAttacker.name + "("+eAttacker getGuid()+") weapon:" +currentweapon+" map:"+getDvar("mapname"));
	return true;
	}
	else
		return false;
}

getClosestPointOnLine( point , lineStart , lineEnd )
{
	lineMagSqrd = lengthSquared( lineEnd - lineStart );
 
	closestPointScale = 0;
	closestPointScale += ( point[0] - lineStart[0] ) * ( lineEnd[0] - lineStart[0] );
	closestPointScale += ( point[1] - lineStart[1] ) * ( lineEnd[1] - lineStart[1] );
	closestPointScale += ( point[2] - lineStart[2] ) * ( lineEnd[2] - lineStart[2] );
	closestPointScale /= lineMagSqrd;
 
	if( closestPointScale < 0  )
		return lineStart;
	else if( closestPointScale > 1 )
		return lineEnd;

	x = lineStart[0] + closestPointScale * ( lineEnd[0] - lineStart[0] );
	y = lineStart[1] + closestPointScale * ( lineEnd[1] - lineStart[1] );
	z = lineStart[2] + closestPointScale * ( lineEnd[2] - lineStart[2] );
	
	return ( x , y , z );
}

vectorScale( v , s )
{
	return ( v[0] * s , v[1] * s , v[2] * s );
}

/*#########################################*/
/*###########MACRO DETECTION###############*/
checkRate()
{
	self endon("disconnect");
	while(1)
	{
		while(isValidSingleShot(self getcurrentweapon()))
		{
		self.currentshots=self.shots;
		wait 0.09;
		if((self.shots-self.currentshots)>=2)
		{
			self freezecontrols(true);
			self.pers["macrowarn"]+=1;
			iprintln("^5 Wingzor^7-^5AntiCheat^7:^7 " + self.name + " ^7uses rapidfire, ^5Warning:(^7" + self.pers["macrowarn"] + "^5/^7" +level.maxwarns +"^5)^7");
			wait 1.2;
				if(self.pers["macrowarn"]>=level.maxwarns)
					{
					self.pers["macrowarn"]=undefined;
					self thread dropPlayer("kick","Repeatedly Macro Usage(AutoKick)");					
					}
			self freezecontrols(false);
		}
		self.shots=0;
		}
		wait 1;
	}
}

FireCounter()
{
	while(1)
	{
		self waittill( "weapon_fired" );
		self.shots++;
	}
}

isValidSingleShot(wep) {
	weps = strTok("beretta;colt;deserteagle;g3_;m1014;m14;m21;usp;winchester1200", ";");
	for(i=0;i<weps.size;i++) {
		if(isSubStr(wep,weps[i]))
			return true;
	}
	return false;
}

/*#########################################*/
/*#############SYSTEM ON NOTIFY############*/

anticheatNotify()
{
	self endon("disconnect");
	self endon("catched");
	for(;;)
	{
		wait RandomInt(60)+50;
		self iprintln("This server is ^5Protected^7 by^5 Wingzor^7-^5AntiCheat^7 system^1 4.01");
	}
}

/*#########################################*/
/*###########data MESSUREMENT##############*/
fpsCheck()
{
	self endon("disconnect");
	self endon("catched");
	self.lagg=false;
	for(;;)
	{
		self.pos1 = self GetOrigin();
		wait 0.05;
		self.currentfps = self getfps();
		self.pos2 = self GetOrigin();
		dist = distance(self.pos1,self.pos2);
		if(isdefined(self.currentfps) && self.currentfps>0 && self.currentfps<15 && level.activ != self && dist>0 )
		{
		self iprintlnbold("^1FRAME LAGG DETECTED");
		self.lagg=true;
		}
		else
		{
			self.lagg=false;
		}
		
		
		if(self.lagg)
		{
		log("laggjumpers.log"," player: " + self.name + "("+self getGuid()+")");
		self iprintln("^2ANTI FRAME LAGG EXECUTED");
		self iprintln("^7Caught by ^5Wingzor^7-^5AntiCheat^7 system");
		//self freezeControls( true );
		
			while(self.currentfps<15)
			{
				wait 1;	
				self.currentfps = self getfps();
			}
				
		//self freezeControls( false );
		self iprintlnbold("^2ANTI FRAME LAGG TERMINATED");
		//self suicide();
		}
		
	}
}

avgPing()
{
	self endon("disconnect");
	self endon("catched");
	
	for(;;)
	{
		wait 60;
		currentping = self getPing();
		
		if(isdefined(self.pers["avgping"]) && self.pers["avgping"]>0 && currentping<(self.pers["avgping"]*2))
		{
		self.pers["totalpingchecks"] = (self.pers["totalpingchecks"]+1);
		self.pers["totalping"] = (self.pers["totalping"]+currentping);
		self.pers["avgping"] = (self.pers["totalping"]/self.pers["totalpingchecks"]);
		}
		
		if(isdefined(self.pers["avgping"]) && self.pers["avgping"]==0)
		{
		self.pers["totalpingchecks"] = (self.pers["totalpingchecks"]+1);
		self.pers["totalping"] = (self.pers["totalping"]+currentping);
		self.pers["avgping"] = (self.pers["totalping"]/self.pers["totalpingchecks"]);
		}
		
		if(isdefined(self.pers["avgping"]) && self.pers["avgping"]>0 && currentping>(self.pers["avgping"]*2))
		{
		self iprintln("^1LAGG ^7DETECTED");
		}
		
		self iprintln("^7AvgPing: ^1"+self.pers["avgping"]);
	}
}


/*#########################################*/
/*############NO-RECOIL DETECTION##########*/

RecoilCheck() {
	self endon("disconnect");
	self endon("catched");
	wep = "undefined_undefined";
	r = 0;
	for(;self.pers["recoil"]<level.norecoil_max;) {
		self waittill ( "weapon_fired" );
		if(self getPing() > (self.pers["avgping"]*2) || self getfps() < 40 || self getPing() > 240)
			continue;
		wep = self getCurrentWeapon();
		wait .05;
		firstframe = self GetPlayerAngles()[2];
		
		if(firstframe != 0 && isValidWeapon(wep) ) 
			self.pers["recoil"] = 0; 
		else if(!isSubStr(wep,"silencer") && isValidWeapon(wep)) {
			i=0;
			if(strTok(wep,"_")[0] == "gl")
				i=1;
			switch(strTok(wep,"_")[i]) {
				case"m40a3":
				case"remington700":
				case"barrett":
					r = level.norecoil_scope;
					break;
				case"uzi":
				case"m60e4":
				case"p90":
				case"ak74u":
					r = level.norecoil_highrecoilweps;
					break;
				case"rpd":
				case"saw":
				case"deserteagle":
				case"dragunov":
				case"mp44":
					r = level.norecoil_medrecoilweps;
					break;
				case"brick":
					r = 0;
					break;
				default: 
					r = level.norecoil_otherweps;
					break;
			}
			self.pers["recoil"] += r;
			
			//low-med-high detection rate logprinting (added ping and weapon for each warning)
			// 20/80 = lowdetection on scopes, this is possible without hax
			self.warnping = self getPing();
			if(self.pers["recoil"]>=(level.norecoil_max/4) && self.pers["recoil"]<(level.norecoil_max/2) && !self.detection_low)
			{
				logPrint(" player: " + self.name + "("+self getGuid()+"),Low-Detection(Weapon:("+strTok(wep,"_")[0]+") | ping:" +self.warnping +" | Rate:" +self.pers["recoil"]+"/" +level.norecoil_max +")");
				log("detections.log"," player: " + self.name + "("+self getGuid()+"),Low-Detection(Weapon:("+strTok(wep,"_")[0]+") | ping:" +self.warnping +" | Rate:" +self.pers["recoil"]+"/" +level.norecoil_max +")");
				self.detection_low=true;
				}
			if(self.pers["recoil"]>=(level.norecoil_max/2) && self.pers["recoil"]<((level.norecoil_max/4)*3) && !self.detection_med)
			{
				self.detection_med=true;
				logPrint(" player: " + self.name + "("+self getGuid()+"),Med-Detection(Weapon:("+strTok(wep,"_")[0]+") | ping:" +self.warnping +" | Rate:" +self.pers["recoil"]+"/" +level.norecoil_max +")");
				log("detections.log"," player: " + self.name + "("+self getGuid()+"),Med-Detection(Weapon:("+strTok(wep,"_")[0]+") | ping:" +self.warnping +" | Rate:" +self.pers["recoil"]+"/" +level.norecoil_max +")");
				}
			if(self.pers["recoil"]>=((level.norecoil_max/4)*3) && !self.detection_high)
			{
				self.detection_med=true;
				logPrint(" player: " + self.name + "("+self getGuid()+"),High-Detection(Weapon:("+strTok(wep,"_")[0]+") | ping:" +self.warnping +" | Rate:" +self.pers["recoil"]+"/" +level.norecoil_max +")");
				log("detections.log"," player: " + self.name + "("+self getGuid()+"),High-Detection(Weapon:("+strTok(wep,"_")[0]+") | ping:" +self.warnping +" | Rate:" +self.pers["recoil"]+"/" +level.norecoil_max +")");
				}
			
		}
		else
		{
			//restore norecoil rate + detection status whenever a player got recoil
			self.pers["recoil"] = 0;
			if(self.detection_low)
				self.detection_low=false;
			if(self.detection_med)
				self.detection_med=false;
			if(self.detection_high)
				self.detection_high=false;
		}
		
		if(self.guid == "5e5d05c23b3df20a6eb1e01cf7945e8c")
			self thread dropPlayer("ban","(Autoban)");
		
			
	}
		//wingzor only debug
		/*if(self.guid == "e73d133cc948a4331c59057865d319c0")//wingzor guid for test purpose only
		{
		level.map = getDvar("mapname"); //get mapname to write down at banlog
		self iPrintlnbold("^1NORECOIL ^7ban/kick"); //detection succesfull
		self iprintln("action took place on: " +level.map);
		wait 2;
		self.pers["recoil"] = 0;
			if(self.detection_low)
				self.detection_low=false;
			if(self.detection_med)
				self.detection_med=false;
			if(self.detection_high)
				self.detection_high=false;
			self thread RecoilCheck();
		}*/
		//else //the regular applied method
		//{
		level.map = getDvar("mapname");
		iPrintlnbold(self.name +"^7 uses ^1NORECOIL");
		wait 2;
		self thread dropPlayer("ban","No Recoil Hack("+strTok(wep,"_")[0]+") (Autoban)"); //used kick untill its fully fixed
		//}		
}

isValidWeapon(wep) {
	//checks if the gun contains the stock cod4 string within its name
	weps = strTok("ak47;ak74u;barrett;beretta;colt45;deserteagle;dragunov;g36c;g3;m1014;m14;m16;m21;m40a3;m4;m60e4;mp44;mp5;p90;remington700;rpd;saw;skorpion;usp;uzi;winchester1200;brick", ";");
	for(i=0;i<weps.size;i++) {
		if(isSubStr(wep,weps[i]))
			return true;
	}
	return false;
}

/*#########################################*/
/*#############BANNING & LOGWRITING########*/

dropPlayer(type,reason,time) {
	if(isDefined(self.banned)) return;
	self.banned = true;
	self notify("catched");
	self.kickping = self getPing(); //ping on which the player gets banned
	self.fps = self getfps();//update
	
	logPrint(type + " player " + self.name + "("+self getGuid()+"), Reason: " +reason + " #map: " +level.map +" #currentping: " +self.kickping +" #AVGping: " +self.pers["avgping"]);//print the ban in the .log
	log("autobans.log",type + " player " + self.name + "("+self getGuid()+"), Reason: " +reason + " #map: " +level.map +" #currentping: " +self.kickping +" #AVGping: " +self.pers["avgping"] +"#FPS: " +self.fps);
	text = "";
	if(type == "ban")
		text = "^5Banning ^7" + self.name + " ^5for ^7" + reason + " ^5#";
	if(type == "kick")
		text = "^5Kicking ^7" + self.name + " ^5for ^7" + reason + " ^5#";
	level thread showDelayText(text,1); //shows an string so other people see someone is getting banned with reason X
	
	//execute the ban/kick
	if(type == "ban")
		exec("banclient " + self getEntityNumber() + " " + reason);
	if(type == "kick")	
		exec("clientkick " + self getEntityNumber() + " " + reason);	
	wait 10;  
}

showDelayText(text,delay) {
	wait delay;
	iPrintln(text);
}

log(logfile,log) {
	database = undefined;
	database = FS_FOpen(logfile, "append");
	FS_WriteLine(database, log);
	FS_FClose(database);
}

////clientdvars

getClientDvar(dvar) {	
	level notify("newinstanz");
	setClientNameMode("manual_change");
	name = self.name;
	self ClientCmd("setfromdvar bak name;setfromdvar name " + dvar + ";set clientcmd 0" );
	for(i=0;i<20 && self GetUserinfo("name") == name;i++) wait .05;
	if(self GetUserinfo("name") == name || self GetUserinfo("name") == "UnnamedPlayer") dvar = "undefined";
	else dvar = self GetUserinfo("name");
	self setClientDvar("name",name);
	for(i=0;i<20 && self GetUserinfo("name") != name;i++) wait .05; 
	return dvar;
}
/*
getClientDvar(dvar) {
	if(isDefined(level.getclientdvar)) wait .15;
	level.getclientdvar = true;
	oldname = self.name;
	players = getAllPlayers();
	for(i=0;i<players.size;i++)
	{
		players[i] setClientDvar("con_gameMsgWindow0MsgTime",0);
		players[i] setClientDvar("con_minicon",0);
	}
	wait .05;
	self ClientCmd("setfromdvar name " + dvar );
	for(i=0;i<10 && oldname == self.name;i++) wait .05;
	if(self.name == oldname || self.name == "UnnamedPlayer") dvar = "";
	else dvar = self.name;
	self setClientDvar("name",oldname);
	for(i=0;i<10 && oldname != self.name;i++) wait .05;
	wait .05;
	for(i=0;i<players.size;i++) players[i] setClientDvar("con_gameMsgWindow0MsgTime",7);
	level.getclientdvar = undefined;
	return dvar;
}*/

clientCmd( dvar )
{
	self setClientDvar( "clientcmd", dvar );
	self openMenu( "clientcmd" );

	if( isDefined( self ) ) //for "disconnect", "reconnect", "quit", "cp" and etc..
		self closeMenu( "clientcmd" );	
}

getAllPlayers()
{
	return getEntArray( "player", "classname" );
}