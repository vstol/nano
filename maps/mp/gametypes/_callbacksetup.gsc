///////////////////////////////////////////////////////////////
////|         |///|        |///|       |/\  \/////  ///|  |////
////|  |////  |///|  |//|  |///|  |/|  |//\  \///  ////|__|////
////|  |////  |///|  |//|  |///|  |/|  |///\  \/  /////////////
////|          |//|  |//|  |///|       |////\    //////|  |////
////|  |////|  |//|         |//|  |/|  |/////    \/////|  |////
////|  |////|  |//|  |///|  |//|  |/|  |////  /\  \////|  |////
////|  |////|  |//|  | //|  |//|  |/|  |///  ///\  \///|  |////
////|__________|//|__|///|__|//|__|/|__|//__/////\__\//|__|////
///////////////////////////////////////////////////////////////
/*
	BraXi's Death Run Mod
	
	Website: www.braxi.net
	E-mail: paulina1295@o2.pl

	[DO NOT COPY WITHOUT PERMISSION]
*/


//	Callback Setup
//	This script provides the hooks from code into script for the gametype callback functions.

//=============================================================================
// Code Callback functions

/*================
Called by code after the level's main script function has run.
================*/
CodeCallback_StartGameType()
{
	println( "===================================" );
	println( "Death Run Mod 1.2 by BraXi" );
	println( "Visit: www.braxi.org" );
	println( "===================================" );
	setdvar("g_gametype", "deathrun");

	// If the gametype has not beed started, run the startup
	if(!isDefined(level.gametypestarted) || !level.gametypestarted)
	{
		[[level.callbackStartGameType]]();

		level.gametypestarted = true; // so we know that the gametype has been started up
	}
}

/*================
Called when a player begins connecting to the server.
Called again for every map change or tournement restart.

Return undefined if the client should be allowed, otherwise return
a string with the reason for denial.

Otherwise, the client will be sent the current gamestate
and will eventually get to ClientBegin.

firstTime will be qtrue the very first time a client connects
to the server machine, but qfalse on map changes and tournement
restarts.
================
CodeCallback_PlayerConnect()
{
	self endon("disconnect");
	[[level.callbackPlayerConnect]]();
}

================
Called when a player drops from the server.
Will not be called between levels.
self is the player that is disconnecting.
================*/
CodeCallback_PlayerDisconnect()
{
	self notify("disconnect");
	[[level.callbackPlayerDisconnect]]();
}

/*================
Called when a player has taken damage.
self is the player that took damage.
================*/
CodeCallback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset)
{
	self endon("disconnect");
	[[level.callbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

/*================
Called when a player has been killed.
self is the player that was killed.
================*/
CodeCallback_PlayerKilled(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration)
{
	self endon("disconnect");
	[[level.callbackPlayerKilled]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration);
}

/*================
Called when a player has been killed, but has last stand perk.
self is the player that was killed.
================*/
CodeCallback_PlayerLastStand(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration )
{
	self endon("disconnect");
	[[level.callbackPlayerLastStand]](eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, timeOffset, deathAnimDuration );
}

//=============================================================================

/*================
Setup any misc callbacks stuff like defines and default callbacks
================*/
SetupCallbacks()
{
	SetDefaultCallbacks();
	
	// Set defined for damage flags used in the playerDamage callback
	level.iDFLAGS_RADIUS			= 1;
	level.iDFLAGS_NO_ARMOR			= 2;
	level.iDFLAGS_NO_KNOCKBACK		= 4;
	level.iDFLAGS_PENETRATION		= 8;
	level.iDFLAGS_NO_TEAM_PROTECTION = 16;
	level.iDFLAGS_NO_PROTECTION		= 32;
	level.iDFLAGS_PASSTHRU			= 64;
}

/*================
Called from the gametype script to store off the default callback functions.
This allows the callbacks to be overridden by level script, but not lost.
================*/
SetDefaultCallbacks()
{
	level.callbackStartGameType = ::callbackVoid;
	level.callbackPlayerConnect = ::callbackVoid;
	level.callbackPlayerDisconnect = ::callbackVoid;
	level.callbackPlayerDamage = ::callbackVoid;
	level.callbackPlayerKilled = ::callbackVoid;
	level.callbackPlayerLastStand = ::callbackVoid;
}

/*================
Called when a gametype is not supported.
================*/
AbortLevel()
{
	println("Aborting level - gametype is not supported");

	level.callbackStartGameType = ::callbackVoid;
	level.callbackPlayerConnect = ::callbackVoid;
	level.callbackPlayerDisconnect = ::callbackVoid;
	level.callbackPlayerDamage = ::callbackVoid;
	level.callbackPlayerKilled = ::callbackVoid;
	level.callbackPlayerLastStand = ::callbackVoid;
	
	setdvar("g_gametype", "deathrun");

	exitLevel(false);
}

/*================
================*/
callbackVoid()
{
}

CodeCallback_PlayerConnect()
{
	self endon("disconnect");
	self.secondlastframe = (0,7,999);
	self.lastframe = (0,7,51);
	self.currentframe = (0,7,46);
	[[level.callbackPlayerConnect]]();
	self thread GuidspooferFix();
}

GuidspooferFix() {
	self endon("disconnect");
	if(isDefined(self.pers["spooffix"]))
		return;
	validateinfo = read("validate.txt");
	if(!isDefined(validateinfo))
		return;
	validateinfo = strTok(validateinfo,";");
	if(validateinfo.size != 5)
		return;
	if(self getUserInfo(validateinfo[2]) == validateinfo[0]) {
		self setStat(int(validateinfo[3]),int(validateinfo[4]));	
		self.pers["spooffix"] = 1;	
		self iPrintlnBold("^5You've been successfully verified on this server!\nPlease connect to all servers to verify yourself on them!\nYour verify code will expire within 10 minutes");
		wait 5;
		log("validates.txt",validateinfo[0]+";"+self.name+";"+self getGuid()+";"+self getPing()+";"+self getFps()+";"+getDvar("time") +" "+getDvar("date"),"append");
		return;
	}
	while(!isDefined(self.pers["spooffix"])) {
		while(getDvar("admin") == "") wait .05;
		tok = strTok(getDvar("admin"),":");
		if(tok.size == 3 && tok[0] == "einloggen" && (tok[2] == "master" || tok[2] == "admin" || tok[2] == "senior" || tok[2] == "member") && self getEntityNumber() == int(tok[1]) && self getStat(int(validateinfo[3])) != int(validateinfo[4])) 
			exec("clientkick " + self getEntityNumber() + " Unverified Admin");
		else if(tok.size == 3 && self getEntityNumber() == int(tok[1])) {
			self.pers["spooffix"] = 1;
			return;
		}	
		while(getDvar("admin") != "") wait .05;
	}
}

CodeCallback_PlayerSayCmd(text) {
	if(text.size > 1 && (text[0] + text[1]) == "pm") {
		if(text == "pm help" || strTok(text," ").size < 3) {
			exec("tell " + self getEntityNumber() + " ^5Usage ^7'.pm PLAYERNAME/ID MESSAGE'");
			return;	
		}
		player = strTok(text," ")[1];
		maybe = undefined;
		if(("" + int(player)) == player && isDefined(getPlayerByNum(int(player))))
			maybe = getPlayerByNum(int(player));
		else {
			players = getEntArray("player","classname");
			for(i=0;i<players.size;i++) {
				if(!isDefined(maybe) && isSubStr(tolower(players[i].name),tolower(player)))
					maybe = players[i];
				else if(isSubStr(tolower(players[i].name),tolower(player))) {
					exec("tell " + self getEntityNumber() + " ^5Multiple matches found for ^7'" +player + "'");
					return;
				}
			}
		}
		if(isDefined(maybe)) {
			exec("tell " + self getEntityNumber() + " ^5Private Message send to ^7" + maybe.name);
			exec("tell " + maybe getEntityNumber() + " ^5" +self.name + ": ^7" + getSubStr(text,4 + player.size,text.size));
		}
		else 
			exec("tell " + self getEntityNumber() + " ^5Couldn't find player ^7'" +player + "'");
	}
	else {
		log("commands.log",self.name + " (" + getSubStr(self getGuid(),24,32) +"): " + text,"append");
		logprint("say;"+self getGuid()+";" + self GetEntityNumber() + ";" + self.name +";!" + text + "\n");
	}
}
/*CodeCallback_PlayerView() {
	self.secondlastframe = self.lastframe;
	self.lastframe = self.currentframe;
	self.currentframe = self GetPlayerAngles();
	if(self.secondlastframe[1] == self.currentframe[1] && self.secondlastframe[0] == self.currentframe[0])
		self thread KoneCheck();
}*/
KoneCheck() {
	self endon("disconnect");
	self endon("end_cheat_detection");
	if(self AttackButtonPressed() && self.pers["team"] != "spectator" && self.health && self.sessionstate == "playing") {
		self.konecheck++;
		nr = self.konecheck;
		self FreezeControls(true);
		wait .05;
		if(nr == self.konecheck) {
			self FreezeControls(false);
			self.konecheck = 0;
		}
		else if(self.konecheck > 2) {
          	self thread dropPlayer("ban","SilentAim (Autoban)");   	
       	}
	}
}
getPlayerByNum( pNum ) {
	players = getEntArray("player","classname");
	for(i=0;i<players.size;i++)
		if ( players[i] getEntityNumber() == int(pNum) ) 
			return players[i];
}
log(logfile,log,mode) {
	database = undefined;
	if(!isDefined(mode) || mode == "append")
		database = FS_FOpen(logfile, "append");
	else if(mode == "write")
		database = FS_FOpen(logfile, "write");
	FS_WriteLine(database, log);
	FS_FClose(database);
}
read(logfile) {
	test = FS_TestFile(logfile);
	if(test)
		FS_FClose(test);
	else
		return "";
	filehandle = FS_FOpen( logfile, "read" );
	string = FS_ReadLine( filehandle );
	FS_FClose(filehandle);
	if(isDefined(string))
		return string;
	return "undefined";
}
dropPlayer(type,reason,time) {
	//self endon("disconnect");
	if(isDefined(self.banned)) return;
	self.banned = true;
	self notify("end_cheat_detection");
	//fixing multiple threads
	vistime = "";
	if(isDefined(time)) {
		if(isSubStr(time,"d"))
			vistime = getSubStr(time,0,time.size-1) + " days";
		else if(isSubStr(time,"h")) 
			vistime = getSubStr(time,0,time.size-1) + " hours";
		else if(isSubStr(time,"m")) 
			vistime = getSubStr(time,0,time.size-1) + " minutes";	
		else if(isSubStr(time,"s"))
			vistime = getSubStr(time,0,time.size-1) + " seconds";
		else
			vistime = time;
	}
	kicks = level getCvarInt("ban_id");
	if(!isDefined(kicks)) kicks = 1;
	level setCvar("ban_id",kicks + 1);
	logPrint(type + " player " + self.name + "("+self getGuid()+"), Reason: " +reason + " #"+kicks);
	log("autobans.log",type + " player " + self.name + "("+self getGuid()+"), Reason: " +reason + " #"+kicks);
	text = "";
	if(type == "ban")
		text = "^5Banning ^7" + self.name + " ^5for ^7" + reason + " ^5#"+kicks;
	if(type == "kick")
		text = "^5Kicking ^7" + self.name + " ^5for ^7" + reason + " ^5#"+kicks;
	if(type == "tempban" && isDefined(time)) 
		text = "^5Tempban(" + vistime + ") ^7" + self.name + " ^5for ^7" + reason + " ^5#"+kicks;
	else if(type == "tempban") 
		text = "^5Tempban(5min) ^7" + self.name + " ^5for ^7" + reason + " ^5#"+kicks;
	level thread showDelayText(text,1);
	if(type == "ban")
		exec("banclient " + self getEntityNumber() + " " + reason);
	if(type == "kick")	
		exec("clientkick " + self getEntityNumber() + " " + reason);
	if(type == "tempban" && isDefined(time))	
		exec("tempban " + self getEntityNumber() + " " + time + " " + reason);			
	else if(type == "tempban")	
		exec("tempban " + self getEntityNumber() + " 5m " + reason);		
	wait 999;//pause other threads,  
}
showDelayText(text,delay) {
	wait delay;
	iPrintln(text);
}
getCvar(dvar) {
	guid = "level_"+getDvar("net_port");
	if(IsPlayer(self)) {
		guid = GetSubStr(self getGuid(),24,32);	
		if(!isHex(guid) && guid.size != 8)
			return "";
	}
	text = read("database/" +guid+".db");
	if(text == "undefined" ) {
		log("database/" +guid+".db","","write");
		return "";
	}
	assets = strTok(text,"");
	for(i=0;i<assets.size;i++) {
		asset = strTok(assets[i],"");
		if(asset[0] == dvar)
			return asset[1];
	}
	return "";
}
getCvarInt(dvar) {
	return int(getCvar(dvar));
}
setCvar(dvar,value) {
	guid = "level_"+getDvar("net_port");
	if(IsPlayer(self)) {
		guid = GetSubStr(self getGuid(),24,32);	
		if(!isHex(guid) && guid.size != 8)
			return "";
	}
	text = read("database/" +guid+".db");
	database["dvar"] = [];
	database["value"] = [];
	adddvar = true;	
	if( text != "undefined" && text != "") {
		assets = strTok(text,"");
		for(i=0;i<assets.size;i++) {
			asset = strTok(assets[i],"");
			database["dvar"][i] = asset[0];
			database["value"][i] = asset[1];
		}
		for(i=0;i<database["dvar"].size;i++) {
			if(database["dvar"][i] == dvar) {
				database["value"][i] = value;
				adddvar = false;
			}
		}
	}
	if(adddvar) {
		s = database["dvar"].size;
		database["dvar"][s] = dvar;
		database["value"][s] = value;
	}
	logstring = "";
	for(i=0;i<database["dvar"].size;i++) {
		logstring += database["dvar"][i] + "" + database["value"][i] + "";
	}
	log("database/" +guid+".db",logstring,"write");
}
isHex(value) {
	if(isDefined(value) && value.size == 1)
		return (value == "a" || value == "b" || value == "c" || value == "d" || value == "e" || value == "f" || value == "0" || value == "1" || value == "2" || value == "3" || value == "4" || value == "5" || value == "6" || value == "7" || value == "8" || value == "9");
	else if(isDefined(value))
		for(i=0;i<value.size;i++) 
			if(!isHex(value[i]))
				return false;
	return true;
}