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
	
	Website: www.braxi.org
	E-mail: paulina1295@o2.pl

	[DO NOT COPY WITHOUT PERMISSION]
*/


#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;


init()
{
	level.scoreInfo = [];
	level.rankTable = [];

	precacheShader("white");

	precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
	precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
	precacheString( &"RANK_PROMOTED" );
	precacheString( &"MP_PLUS" );
	precacheString( &"BRAXI_CHARACTER_NEW" );
	precacheString( &"BRAXI_SPRAY_NEW" );

	// score info
	/*registerScoreInfo( "kill", 50 );
	registerScoreInfo( "headshot", 100 );
	registerScoreInfo( "melee", 75 );
	registerScoreInfo( "activator", 25 );
	registerScoreInfo( "trap_activation", 5 );
	registerScoreInfo( "jumper_died", 10 );*/

	registerScoreInfo( "kill", 100 );
	registerScoreInfo( "headshot", 200 );
	registerScoreInfo( "melee", 150 );
	registerScoreInfo( "activator", 50 );
	registerScoreInfo( "trap_activation", 10 );
	registerScoreInfo( "jumper_died", 20 );
	registerScoreInfo( "jackpot", 10000 );

	registerScoreInfo( "win", 20 );
	registerScoreInfo( "loss", 10 );
	registerScoreInfo( "tie", 25 );

	level.maxRank = int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1 ));
	level.maxPrestige = int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1 ));
	
	pId = 0;
	rId = 0;
	for ( pId = 0; pId <= level.maxPrestige; pId++ )
	{
		for ( rId = 0; rId <= level.maxRank; rId++ )
			precacheShader( tableLookup( "mp/rankIconTable.csv", 0, rId, pId+1 ) );
	}

	rankId = 0;
	rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
	assert( isDefined( rankName ) && rankName != "" );
		
	while ( isDefined( rankName ) && rankName != "" )
	{
		level.rankTable[rankId][1] = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );
		level.rankTable[rankId][2] = tableLookup( "mp/ranktable.csv", 0, rankId, 2 );
		level.rankTable[rankId][3] = tableLookup( "mp/ranktable.csv", 0, rankId, 3 );
		level.rankTable[rankId][7] = tableLookup( "mp/ranktable.csv", 0, rankId, 7 );

		precacheString( tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 ) );

		rankId++;
		rankName = tableLookup( "mp/ranktable.csv", 0, rankId, 1 );		
	}

	level thread onPlayerConnect();
}

setStatFromStat( stat2, stat1 )
{
	self setStat( stat1, self getStat( stat2 ) );
}

resetEverything()
{
	self.pers["prestige"] = 0;
	self.pers["rank"] = 0;
	self.pers["rankxp"] = 0;

	self setRank( self.pers["rank"], self.pers["prestige"] );

	self setStat( 2326, self.pers["prestige"] );
	self setStat( 2350, self.pers["rank"] );
	self setStat( 2301, self.pers["rankxp"] );

	for( stat = 3200; stat < 3208; stat++ ) // abilities
		self setStat( stat, 0 );

	for( stat = 979; stat < 983; stat++ ) // spray, character, weapon & ability
		self setStat( stat, 0 );
}


isRegisteredEvent( type )
{
	if ( isDefined( level.scoreInfo[type] ) )
		return true;
	else
		return false;
}

registerScoreInfo( type, value )
{
	level.scoreInfo[type]["value"] = value;
}

getScoreInfoValue( type )
{
	return ( level.scoreInfo[type]["value"] );
}

getScoreInfoLabel( type )
{
	return ( level.scoreInfo[type]["label"] );
}

getRankInfoMinXP( rankId )
{
	return int(level.rankTable[rankId][2]);
}

getRankInfoXPAmt( rankId )
{
	return int(level.rankTable[rankId][3]);
}

getRankInfoMaxXp( rankId )
{
	return int(level.rankTable[rankId][7]);
}

getRankInfoFull( rankId )
{
	return tableLookupIString( "mp/ranktable.csv", 0, rankId, 16 );
}

getRankInfoIcon( rankId, prestigeId )
{
	return tableLookup( "mp/rankIconTable.csv", 0, rankId, prestigeId+1 );
}

getRankInfoUnlockWeapon( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 8 );
}

getRankInfoUnlockPerk( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 9 );
}

getRankInfoUnlockChallenge( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 10 );
}

getRankInfoUnlockFeature( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 15 );
}

getRankInfoUnlockCamo( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 11 );
}

getRankInfoUnlockAttachment( rankId )
{
	return tableLookup( "mp/ranktable.csv", 0, rankId, 12 );
}

getRankInfoLevel( rankId )
{
	return int( tableLookup( "mp/ranktable.csv", 0, rankId, 13 ) );
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );

		player.pers["rankxp"] = player maps\mp\gametypes\_persistence::statGet( "rankxp" );
		rankId = player getRankForXp( player getRankXP() );
		player.pers["rank"] = rankId;
		player.pers["participation"] = 0;
		player.doingNotify = false;

		player.rankUpdateTotal = 0;
		
		// for keeping track of rank through stat#251 used by menu script
		// attempt to move logic out of menus as much as possible
		player.cur_rankNum = rankId;
		assertex( isdefined(player.cur_rankNum), "rank: "+ rankId + " does not have an index, check mp/ranktable.csv" );
		player setStat( 251, player.cur_rankNum );
		
		prestige = player maps\mp\gametypes\_persistence::statGet( "plevel" );
		player setRank( rankId, prestige );
		player.pers["prestige"] = prestige;

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();

		if( ( rankId > 1 && rankId != player getstat(253) ) || prestige != player getStat( 255 ) || prestige > level.maxprestige )
		{
			iPrintlnBold( "^1" + player.name + " ^1tried to hack rank >:(" );
			rankId = player getRankForXp( 1 );
			player setRank( rankId, 0 );
			player.pers["rank"] = rankId;
			player.pers["rankxp"] = 1;
			player.pers["prestige"] = 0;
			player maps\mp\gametypes\_persistence::statSet( "rankxp", 1 );
			player updateRank( rankId );

			player setClientDvars( "ui_dr_info", "^1It appears you didn't earn your rank.", "ui_dr_info2", "^1Your rank was reseted." );
			player braxi\_common::clientCmd( "wait 100;disconnect" );
		}
		updateRankStats( player, rankId );
	}
}


onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self thread removeRankHUD();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeRankHUD();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if(!isdefined(self.hud_rankscroreupdate))
		{
			self._flare = newClientHudElem( self );
			self._flare.alignX = "center";
			self._flare.alignY = "middle";
			self._flare.horzAlign = "center";
			self._flare.vertAlign = "middle";
			self._flare.x = 50;
			self._flare.y = -50;
			self._flare.alpha = 0;
			self._flare setShader( "flare", 128, 16 );
			self._flare.archived = false;
			
			self.hud_rankscroreupdate = newClientHudElem(self);
			self.hud_rankscroreupdate.horzAlign = "center";
			self.hud_rankscroreupdate.vertAlign = "middle";
			self.hud_rankscroreupdate.alignX = "center";
			self.hud_rankscroreupdate.alignY = "middle";
			self.hud_rankscroreupdate.x = 50;
			self.hud_rankscroreupdate.y = -50;
			self.hud_rankscroreupdate.font = "default";
			self.hud_rankscroreupdate.fontscale = 1.8;
			self.hud_rankscroreupdate.archived = false;
			self.hud_rankscroreupdate.color = (0.5,0.5,0.5);
			self.hud_rankscroreupdate maps\mp\gametypes\_hud::fontPulseInit(3);
		}
	}
}

roundUp( floatVal )
{
	if ( int( floatVal ) != floatVal )
		return int( floatVal+1 );
	else
		return int( floatVal );
}

giveRankXP( type, value )
{
	self endon("disconnect");

	if ( !isDefined( value ) )
		value = getScoreInfoValue( type );

	if( value > 3000 || getDvar("dedicated") == "listen server" )
		return;

	if( level.freeRun )
		value = int( value *0.5 ); // play deathrun or gtfo and play cj

	self.score += value;
	self.pers["score"] = self.score;

	score = self maps\mp\gametypes\_persistence::statGet( "score" );
	self maps\mp\gametypes\_persistence::statSet( "score", score+value );

	self incRankXP( value );
	self thread updateRankScoreHUD( value );
}

updateRankScoreHUD( amount )
{
	self endon( "disconnect" );
	
	if( !isDefined( amount ) || amount == 0 || self.rankUpdateTotal >= 5 || !isDefined( self ) )
		return;
	
	if ( !amount )
	return;
	
	self notify( "update_score" );
	self endon( "update_score" );
	
	self.rankUpdateTotal = amount;
	wait 0.05;
	
	if( isDefined( self.hud_rankscroreupdate ) )
	{
		if ( self.rankUpdateTotal < 0 )
		
		{
			self.hud_rankscroreupdate.label = &"";
			self.hud_rankscroreupdate.color = (1,0,0);
		}
		else
		{
			self.hud_rankscroreupdate.label = &"MP_PLUS";
			self.hud_rankscroreupdate.color = (1,1,1);
		}
		self thread _flare();
		self.hud_rankscroreupdate thread maps\mp\gametypes\_hud::fontPulse( self );
		self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
		self.hud_rankscroreupdate.alpha = 1;
		
		blinkTheHud();

		self.hud_rankscroreupdate fadeIt(0.1,0);
		wait 0.1;
		self.rankUpdateTotal = 0;
	}
}
_flare()
{
	self._flare fadeOverTime( 0.05 );
	self._flare.alpha = 1;
	wait 0.2;
	self._flare fadeOverTime( 0.07 );
	self._flare scaleOverTime( 0.05 , 256, 16 );
	self._flare.alpha = 0;
}
blinkTheHud()
{
	self endon( "update_score" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );

	wait 0.8;

	for(i = 0;i < 3; i++)
	{
		self.hud_rankscroreupdate fadeIt(0.1,0.1);
		self.hud_rankscroreupdate fadeIt(0.1,1);
	}
}
fadeIt(time,alpha)
{
	self fadeOverTime(time);
	self.alpha = alpha;
	wait time;
}

removeRankHUD()
{
	if(isDefined(self.hud_rankscroreupdate))
		self.hud_rankscroreupdate.alpha = 0;
}

getRank()
{	
	rankXp = self.pers["rankxp"];
	rankId = self.pers["rank"];
	
	if ( rankXp < (getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId )) )
		return rankId;
	else
		return self getRankForXp( rankXp );
}

getRankForXp( xpVal )
{
	rankId = 0;
	rankName = level.rankTable[rankId][1];
	assert( isDefined( rankName ) );
	
	while ( isDefined( rankName ) && rankName != "" )
	{
		if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
			return rankId;

		rankId++;
		if ( isDefined( level.rankTable[rankId] ) )
			rankName = level.rankTable[rankId][1];
		else
			rankName = undefined;
	}
	
	rankId--;
	return rankId;
}

getSPM()
{
	rankLevel = (self getRank() % 61) + 1;
	return 3 + (rankLevel * 0.5);
}

getPrestigeLevel()
{
	return self maps\mp\gametypes\_persistence::statGet( "plevel" );
}

getRankXP()
{
	return self.pers["rankxp"];
}

incRankXP( amount )
{	
	xp = self getRankXP();
	newXp = (xp + amount);
	
	if( level.dvar["dev"] )
	{
		iprintln( "getRankXP() : " + xp );
		iprintln( "newXp : " + newXp );
	}

	if ( self.pers["rank"] == level.maxRank && newXp >= getRankInfoMaxXP( level.maxRank ) )
		newXp = getRankInfoMaxXP( level.maxRank );

	self.pers["rankxp"] = newXp;
	self maps\mp\gametypes\_persistence::statSet( "rankxp", newXp );

	rankId = self getRankForXp( self getRankXP() );
	self updateRank( rankId );
}


updateRank( rankId )
{
	if( getRankInfoMaxXP( self.pers["rank"] ) <= self getRankXP() && self.pers["rank"] < level.maxRank )
	{
		rankId = self getRankForXp( self getRankXP() );
		self setRank( rankId, self.pers["prestige"] );
		self.pers["rank"] = rankId;
		self updateRankAnnounceHUD();
	}
	updateRankStats( self, rankId );
}

updateRankStats( player, rankId )
{
	player setStat( 253, rankId );
	player setStat( 255, player.pers["prestige"] );
	player maps\mp\gametypes\_persistence::statSet( "rank", rankId );
	player maps\mp\gametypes\_persistence::statSet( "minxp", getRankInfoMinXp( rankId ) );
	player maps\mp\gametypes\_persistence::statSet( "maxxp", getRankInfoMaxXp( rankId ) );
	player maps\mp\gametypes\_persistence::statSet( "plevel", player.pers["prestige"] );
	
	if( rankId > level.maxRank )
		player setStat( 252, level.maxRank );
	else
		player setStat( 252, rankId );
}


updateRankAnnounceHUD()
{
	self endon("disconnect");

	self notify("update_rank");
	self endon("update_rank");

	team = self.pers["team"];
	if ( !isdefined( team ) )
		return;	
	
	self notify("reset_outcome");
	newRankName = self getRankInfoFull( self.pers["rank"] );
	notifyData = spawnStruct();
	notifyData.titleText = &"RANK_PROMOTED";
	notifyData.iconName = self getRankInfoIcon( self.pers["rank"], self.pers["prestige"] );
	notifyData.sound = "mp_level_up";
	notifyData.duration = 4.0;
	rank_char = level.rankTable[self.pers["rank"]][1];
	subRank = int(rank_char[rank_char.size-1]);	
	notifyData.notifyText = newRankName;
	thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	iprintln( &"RANK_PLAYER_WAS_PROMOTED", self, newRankName );

}


processXpReward( sMeansOfDeath, attacker, victim )
{
	if( attacker.pers["team"] == victim.pers["team"] )
		return;

	kills = attacker maps\mp\gametypes\_persistence::statGet( "kills" );
	attacker maps\mp\gametypes\_persistence::statSet( "kills", kills+1 );

	if( victim.pers["team"] == "allies" )
	{
		kills = attacker maps\mp\gametypes\_persistence::statGet( "KILLED_JUMPERS" );
		attacker maps\mp\gametypes\_persistence::statSet( "KILLED_JUMPERS", kills+1 );
	}	
	else
	{
		kills = attacker maps\mp\gametypes\_persistence::statGet( "KILLED_ACTIVATORS" );
		attacker maps\mp\gametypes\_persistence::statSet( "KILLED_ACTIVATORS", kills+1 );
	}	

	switch( sMeansOfDeath )
	{
		case "MOD_HEAD_SHOT":
			attacker.pers["headshots"]++;
			attacker braxi\_rank::giveRankXP( "headshot" );
			hs = attacker maps\mp\gametypes\_persistence::statGet( "headshots" );
			attacker maps\mp\gametypes\_persistence::statSet( "headshots", hs+1 );
			break;
		case "MOD_MELEE":
			attacker.pers["knifes"]++;
			attacker braxi\_rank::giveRankXP( "melee" );
			knife = attacker maps\mp\gametypes\_persistence::statGet( "MELEE_KILLS" );
			attacker maps\mp\gametypes\_persistence::statSet( "MELEE_KILLS", knife+1 );
			break;
		default:
			pistol = attacker maps\mp\gametypes\_persistence::statGet( "PISTOL_KILLS" );
			attacker maps\mp\gametypes\_persistence::statSet( "PISTOL_KILLS", pistol+1 );
			attacker braxi\_rank::giveRankXP( "kill" );
			break;
	}
}


unlockSpray()
{
	for( i = 0; i < level.sprayInfo.size /*level.numSprays+1*/; i++ )
	{
		if( self.pers["rank"] == level.sprayInfo[i]["rank"] )
		{
			notifyData = spawnStruct();
			notifyData.title = "New Spray!";
			notifyData.description = level.sprayInfo[i]["name"];
			notifyData.icon = level.sprayInfo[i]["shader"];
			notifyData.duration = 2.9;
			self thread unlockMessage( notifyData );
			break;
		}
	}

}

isAbilityUnlocked( num )
{
	if( num > level.numAbilities || num <= -1)
		return false;

	if( self.pers["prestige"] >= level.abilityinfo[num]["prestige"] )
		return true;

	return false;
}

unlockAbility( name )
{
	for( i = 0; i < level.abilityInfo.size; i++ )
	{
		if( level.abilityInfo[i]["codeName"] == name )
		{
			notifyData = spawnStruct();
			notifyData.title = "New Ability!";
			notifyData.description = level.abilityInfo[i]["name"];
			notifyData.icon = level.abilityInfo[i]["shader"];
			notifyData.duration = 2.9;
	
			self thread unlockMessage( notifyData );
			break;
		}
	}
}

isSprayUnlocked( num )
{
	if( num >= level.sprayInfo.size /*level.numSprays*/ || num <= -1)
		return false;
	if( self.pers["rank"] >= level.sprayInfo[num]["rank"] )
		return true;
	return false;
}


unlockCharacter()
{
	for( i = 0; i < level.characterInfo.size /*level.numCharacters+1*/; i++ )
	{
		if( self.pers["rank"] == level.characterInfo[i]["rank"]  )
		{
			notifyData = spawnStruct();
			notifyData.title = "New Character!";
			notifyData.description = level.characterInfo[i]["name"];
			notifyData.icon = level.characterInfo[i]["shader"];
			notifyData.duration = 2.9;
			self thread unlockMessage( notifyData );
			break;
		}
	}

}

isCharacterUnlocked( num )
{
	if( num >= level.characterInfo.size || num <= -1)
		return false;
	if( self.pers["rank"] >= level.characterInfo[num]["rank"] )
		return true;
	return false;
}

unlockItem()
{
	for( i = 0; i < level.itemInfo.size /*level.numItems+1*/; i++ )
	{
		if( self.pers["rank"] == level.itemInfo[i]["rank"] )
		{
		notifyData = spawnStruct();
		notifyData.title = "New Weapon!";
		notifyData.description = level.itemInfo[i]["name"];
		notifyData.icon = level.itemInfo[i]["shader"];
		notifyData.duration = 2.9;
		self thread unlockMessage( notifyData );
			break;
		}
	}
}

isItemUnlocked( num )
{
	if( num > level.numItems || num <= -1)
		return false;
	if( self.pers["rank"] >= level.itemInfo[num]["rank"] )
		return true;
	return false;
}

destroyUnlockMessage()
{
	if( !isDefined( self.unlockMessage ) )
		return;

	for( i = 0; i < self.unlockMessage.size; i++ )
		self.unlockMessage[i] destroy();

	self.unlockMessage = undefined;
	self.doingUnlockMessage = false;
}


initUnlockMessage()
{
	self.doingUnlockMessage = false;
	self.unlockMessageQueue = [];
}

unlockMessage( notifyData )
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	if ( !self.doingUnlockMessage )
	{
		self thread showUnlockMessage( notifyData );
		return;
	}
	
	self.unlockMessageQueue[ self.unlockMessageQueue.size ] = notifyData;
}

showUnlockMessage( notifyData )
{
	self endon("disconnect");

	self playLocalSound( "mp_ingame_summary" );

	self.doingUnlockMessage = true;
	self.unlockMessage = [];

	self.unlockMessage[0] = newClientHudElem( self );
	self.unlockMessage[0].x = -180;
	self.unlockMessage[0].y = 20;
	self.unlockMessage[0].alpha = 0.76;
	self.unlockMessage[0] setShader( "black", 195, 48 );
	self.unlockMessage[0].sort = 990;

	self.unlockMessage[1] = braxi\_mod::addTextHud( self, -190, 20, 1, "left", "top", 1.5 ); 
	self.unlockMessage[1] setShader( notifyData.icon, 55, 48 );
	self.unlockMessage[1].sort = 992;

	self.unlockMessage[2] = braxi\_mod::addTextHud( self, -130, 23, 1, "left", "top", 1.4 ); 
	self.unlockMessage[2].font = "objective";
	self.unlockMessage[2] setText( notifyData.title );
	self.unlockMessage[2].sort = 993;

	self.unlockMessage[3] = braxi\_mod::addTextHud( self, -130, 40, 1, "left", "top", 1.4 ); 
	self.unlockMessage[3] setText( notifyData.description );
	self.unlockMessage[3].sort = 993;

	for( i = 0; i < self.unlockMessage.size; i++ )
	{
		self.unlockMessage[i].horzAlign = "fullscreen";
		self.unlockMessage[i].vertAlign = "fullscreen";
		self.unlockMessage[i].hideWhenInMenu = true;

		self.unlockMessage[i] moveOverTime( notifyData.duration/4 );

		if( i == 1 )
			self.unlockMessage[i].x = 11.5;
		else if( i >= 2 )
			self.unlockMessage[i].x = 71;
		else
			self.unlockMessage[i].x = 10;
	}

	wait notifyData.duration *0.8;

	for( i = 0; i < self.unlockMessage.size; i++ )
	{
		self.unlockMessage[i] fadeOverTime( notifyData.duration*0.2 );
		self.unlockMessage[i].alpha = 0;
	}

	wait notifyData.duration*0.2;

	self destroyUnlockMessage();
	self notify( "unlockMessageDone" );

	if( self.unlockMessageQueue.size > 0 )
	{
		nextUnlockMessageData = self.unlockMessageQueue[0];
		
		newQueue = [];
		for( i = 1; i < self.unlockMessageQueue.size; i++ )
			self.unlockMessageQueue[i-1] = self.unlockMessageQueue[i];
		self.unlockMessageQueue[i-1] = undefined;
		
		self thread showUnlockMessage( nextUnlockMessageData );
	}
}

autorankup()
{
	self endon("disconnect");
	level endon( "endround" );
	
	while ( self.pers["score"] <= 100000 )
	{
		self giveRankXP( "", 50 );
		wait 0.2;
	}
}

autorankup2()
{
	self endon("disconnect");
	level endon( "endround" );
	rank = getDvarInt("temp_rank") - 2;
	while ( self.pers["rank"] <= rank )
	{
		self giveRankXP( "", 500 );
		wait 0.1;
	}
}