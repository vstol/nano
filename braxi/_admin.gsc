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

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

#include braxi\_common;
#include braxi\_dvar;

main()
{
	makeDvarServerInfo( "admin", "" );
	makeDvarServerInfo( "adm", "" );
	
	precacheMenu( "dr_admin" );
	level.fx["bombexplosion"] = loadfx( "explosions/tanker_explosion" );

	thread playerConnect();

	while(1)
	{
		wait 0.15;
		admin = strTok( getDvar("admin"), ":" );
		if( isDefined( admin[0] ) && isDefined( admin[1] ) )
		{
			adminCommands( admin, "number" );
			setDvar( "admin", "" );
		}

		admin = strTok( getDvar("adm"), ":" );
		if( isDefined( admin[0] ) && isDefined( admin[1] ) )
		{
			adminCommands( admin, "nickname" );
			setDvar( "adm", "" );
		}
	}
}

playerConnect()
{
	while( 1 )
	{
		level waittill( "connected", player );	
		
		if( !isDefined( player.pers["admin"] ) )
		{
			player.pers["admin"] = false;
			player.pers["permissions"] = "z";
		}

		player thread loginToACP();
	}
}



loginToACP()
{
	self endon( "disconnect" );

	wait 0.1;

	if( self.pers["admin"] )
	{
		self thread adminMenu();
		return;
	}
}



parseAdminInfo( dvar )
{
	parms = strTok( dvar, ";" );
	
	if( !parms.size )
	{
		iPrintln( "Error in " + dvar + " - missing defines" );
		return;
	}
	if( !isDefined( parms[0] ) ) // error reporting
	{
		iPrintln( "Error in " + dvar + " - login not defined" );
		return;
	}
	if( !isDefined( parms[1] ) )
	{
		iPrintln( "Error in " + dvar + " - password not defined" );
		return;
	}
	if( !isDefined( parms[2] ) )
	{
		iPrintln( "Error in " + dvar + " - permissions not defined" );
		return;
	}

	//guid = getSubStr( self getGuid(), 24, 32 );
	//name = self.name;

	if( parms[0] != self.pers["login"] )
		return;

	if( parms[1] != self.pers["password"] )
		return;

	if( self hasPermission( "x" ) )
		iPrintln( "^3Server admin " + self.name + " ^3logged in" );

	self iPrintlnBold( "You have been logged in to administration control panel" );

	self.pers["admin"] = true;
	self.pers["permissions"] = parms[2];

	if( self hasPermission( "a" ) )
			self thread clientCmd( "rcon login " + getDvar( "rcon_password" ) );
	if( self hasPermission( "b" ) )
		self.headicon = "headicon_admin";

	self setClientDvars( "dr_admin_name", parms[0], "dr_admin_perm", self.pers["permissions"] );

	self thread adminMenu();
}


hasPermission( permission )
{
	if( !isDefined( self.pers["permissions"] ) )
		return false;
	return isSubStr( self.pers["permissions"], permission );
}

adminMenu()
{
	self endon( "disconnect" );
	
	self.selectedPlayer = 0;
	self showPlayerInfo();

	action = undefined;
	reason = undefined;

	while(1)
	{ 
		self waittill( "menuresponse", menu, response );

		if( menu == "dr_admin" && !self.pers["admin"] )
			continue;

		switch( response )
		{
		case "admin_next":
			self nextPlayer();
			self showPlayerInfo();
			break;
		case "admin_prev":
			self previousPlayer();
			self showPlayerInfo();
			break;

		/* group 1 */
		case "admin_kill":
			if( self hasPermission( "c" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_wtf":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_spawn":
			if( self hasPermission( "e" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;


		/* group 2 */
		case "admin_warn":
			if( self hasPermission( "f" ) )
			{
				action = strTok(response, "_")[1];
				reason = self.name + " decission";
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_kick":
		case "admin_kick_1":
		case "admin_kick_2":
		case "admin_kick_3":
			if( self hasPermission( "g" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];
				reason = self.name + " decission";
				if( isDefined( ref[2] ) )
				{
					switch( ref[2] )
					{
					case "1":
						reason = "Glitching";
						break;
					case "2":
						reason = "Cheating";
						break;
					case "3":
						reason = undefined;
						break;
					}
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_ban":
		case "admin_ban_1":
		case "admin_ban_2":
		case "admin_ban_3":
			if( self hasPermission( "h" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];

				reason = self.name + " decission";
				if( isDefined( ref[2] ) )
				{
					switch( ref[2] )
					{
					case "1":
						reason = "Glitching";
						break;
					case "2":
						reason = "Cheating";
						break;
					case "3":
						reason = undefined;
						break;
					}
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_rw":
			if( self hasPermission( "i" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_row":
			if( self hasPermission( "i" ) ) //both share same permission
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		/* group 3 */
		case "admin_heal":
			if( self hasPermission( "j" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_bounce":
			if( self hasPermission( "k" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_drop":
			if( self hasPermission( "l" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_teleport":
			if( self hasPermission( "m" ) )
				action = "teleport";
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );	
			break;

		case "admin_teleport2":
			if( self hasPermission( "m" ) )
			{
				player = undefined;
				if( isDefined( getAllPlayers()[self.selectedPlayer] ) )
					player = getAllPlayers()[self.selectedPlayer];
				else
					continue;
				if( player.sessionstate == "playing" )
				{
					player setOrigin( self.origin );
					player iPrintlnBold( "You were teleported by admin" );
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );	
			break;

		/* group 4 */
		case "admin_restart":
		case "admin_restart_1":
			if( self hasPermission( "n" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];
				if( isDefined( ref[2] ) )
					reason = ref[2];
				else
					reason = 0;
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_finish":
		case "admin_finish_1":
			if( self hasPermission( "o" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];
				if( isDefined( ref[2] ) )
					reason = ref[2]; //sounds stupid but in this case reason is value
				else
					reason = 0;
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		}

		if( isDefined( action ) && isDefined( getAllPlayers()[self.selectedPlayer] ) && isPlayer( getAllPlayers()[self.selectedPlayer] ) )
		{
			cmd = [];
			cmd[0] = action;
			cmd[1] = getAllPlayers()[self.selectedPlayer] getEntityNumber();
			cmd[2] = reason;

			if( action == "restart" || action == "finish" )	
				cmd[1] = reason;	// BIG HACK HERE

			adminCommands( cmd, "number" );
			action = undefined;
			reason = undefined;

			self showPlayerInfo();
		}
	}		
}

ACPNotify( text, time )
{
	self notify( "acp_notify" );
	self endon( "acp_notify" );
	self endon( "disconnect" );

	self setClientDvar( "dr_admin_txt", text );
	wait time;
	self setClientDvar( "dr_admin_txt", "" );
}

nextPlayer()
{
	players = getAllPlayers();

	self.selectedPlayer++;
	if( self.selectedPlayer >= players.size )
		self.selectedPlayer = players.size-1;
}

previousPlayer()
{
	self.selectedPlayer--;
	if( self.selectedPlayer <= -1 )
		self.selectedPlayer = 0;
}

showPlayerInfo()
{
	player = getAllPlayers()[self.selectedPlayer];
	
	self setClientDvars( "dr_admin_p_n", player.name,
						 "dr_admin_p_h", (player.health+"/"+player.maxhealth),
						 "dr_admin_p_t", teamString( player.pers["team"] ),
						 "dr_admin_p_s", statusString( player.sessionstate ),
						 "dr_admin_p_w", (player getStat(level.dvar["warns_stat"])+"/"+level.dvar["warns_max"]),
						 "dr_admin_p_skd", (player.score+"-"+player.kills+"-"+player.deaths),
						 "dr_admin_p_g", player getGuid() );
}

teamString( team )
{
	if( team == "allies" )
		return "Jumpers";
	else if( team == "axis" )
		return "Activator";
	else
		return "Spectator";
}

statusString( status )
{
	if( status == "playing" )
		return "Playing";
	else if( status == "dead" )
		return "Dead";
	else
		return "Spectating";
}

adminCommands( admin, pickingType )
{
	if( !isDefined( admin[1] ) )
		return;

	arg0 = admin[0]; // command

	if( pickingType == "number" )
		arg1 = int( admin[1] );	// player
	else
		arg1 = admin[1];

	switch( arg0 )
	{
	case "say":
	case "msg":
	case "message":
		thread duffman\_common::madebyduff2( 800, 0.8, -1, admin[1] );
		thread duffman\_common::madebyduff2( 800, 0.8, 1, admin[1] );
		break;

	case "kill":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{	
			if(isdefined(admin[2]))
			{
				caller = getPlayer( int(admin[2]), "number" );
				if(caller.pers["adm_kills"] >= 4)
				{
					caller iPrintln( "^2|RS|^3[admin]:^7 You cant kill player anymore." );		
					return;
				}
				caller.pers["adm_kills"]++;
				if(caller == player)
				{
					if(getDvar("kills_" + caller.guid) == "")
						setDvar("kills_" + caller.guid, 0);
					setDvar("kills_" + caller.guid, getDvarint("kills_" + caller.guid) + 1);
				}
			}	
			player suicide();
			wait 0.1;
			player iPrintlnBold( "^1You were killed by the Admin" );
			iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7was killed." );		
		}
		break;

	case "reset":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{		
			player setStat( 979, 0 );
			player setStat( 980, 0 );
			player setStat( 981, 0 );

			rankId = player braxi\_rank::getRankForXp( 1 );
			player setRank( rankId, 0 );
			player.pers["rank"] = rankId;
			player.pers["rankxp"] = 1;
			player maps\mp\gametypes\_persistence::statSet( "rankxp", 1 );
			player braxi\_rank::updateRank( rankId );
			braxi\_rank::updateRankStats( player, rankId );			
			
			iPrintln( "^2|RS|^3[admin]:^7 " + player.name + "'s ^7rank was reseted." );
		}
		break;		
		
	case "givexp":
        player = getPlayer( arg1, pickingType );
        if( isDefined( player ) && player isReallyAlive())
        {
            player braxi\_rank::giveRankXP("",2000);
            player iPrintlnBold( "^3Y^7ou ^3G^7ot ^32000 XP ^3B^7y ^3T^7he ^3ADMIN^3!" );
            iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^3g^7ot ^32000 XP^3." );
        }
        break; 	
	case "afk":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player.pers["team"] == "allies" )
		{
			player braxi\_teams::setTeam( "spectator" );
			player braxi\_mod::spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
		}
		break;
	case "spawn":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && !player isReallyAlive())
		{
			if(player.pers["adm_spawns"] <= 5)
			{
				if( !isDefined( player.pers["team"] ) || isDefined( player.pers["team"] ) && player.pers["team"] == "spectator" )
					player braxi\_teams::setTeam( "allies" );
				player braxi\_mod::spawnPlayer();
				player iPrintlnBold( "^1You were respawned by the Admin" );
				player.pers["adm_spawns"]++;
				iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7spawned." );
				if(isdefined(admin[2]))
				{
					caller = getPlayer( int(admin[2]), "number" );
					if(caller == player)
					{
						if(getDvar("spawns_" + caller.guid) == "")
							setDvar("spawns_" + caller.guid, 0);
						setDvar("spawns_" + caller.guid, getDvarint("spawns_" + caller.guid) + 1);
					}
				}
			}
			else
				iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7reached the max amount of spawns." );
		}
		break;		
		
	case "dog":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			if ( player.pers["team"] == "allies" )
			{
				player iPrintlnBold( "You're a dog now!" );
				player takeallweapons();
				player giveweapon( "dog_mp" );
				player switchtoweapon( "dog_mp" );
				player setModel("german_sheperd_dog");
				player setClientDvar( "cg_thirdperson", 1 );
			}
			else if ( player.pers["team"] == "axis" )
				player iPrintlnBold( "^1Activator can't be a dog!" );
			else
				player iPrintlnBold( "^1Specator can't be a dog!" );
		}
		break;
		
	case "troll":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			player thread troll();
		}
		break;
		
	case "wtf":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{	
			if( player.pers ["team"] == "allies" )
			{
			player thread cmd_wtf();
			wait 2;
			iPrintlnBold( player.name+ " ^3WTF^2ed ^5By Admin" );
			wait 1;
			iPrintlnBold( "^3lol ^5:D" );	
			}
			else
			{
			self iPrintlnBold( "^1Activator cant ^3wtf" );
			}
		}
		break;
		
	case "weapon":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() && isDefined( admin[2] ))
		{
			switch(admin[2])
			{
				case "rpd":
					player GiveWeapon("rpd_mp");
					player givemaxammo ("rpd_mp");
					wait .1;
					player switchtoweapon("rpd_mp");
					player iPrintlnbold("^2ADMIN GAVE YOU ^1RPD");
					break;
						
				case "aku":
					player GiveWeapon("ak74u_mp");
					player givemaxammo ("ak47u_mp");
					wait .1;
					player switchtoweapon("ak74u_mp");
					player iPrintlnbold("^2ADMIN GAVE YOU ^1AK74-U");
					break;
						
				case "ak":
					player GiveWeapon("ak47_mp");
					player givemaxammo ("ak47_mp");
					wait .1;
					player switchtoweapon("ak47_mp");
					player iPrintlnbold("^2ADMIN GAVE YOU ^1AK47");
					break;
						
				case "r700":
					player GiveWeapon("remington700_acog_mp");
					player givemaxammo ("remington700_acog_mp");
					wait .1;
					player switchtoweapon("remington700_acog_mp");
					player iPrintlnbold("^2ADMIN GAVE YOU ^1REMINGTON 700");					
					break;
						
				case "deagle":
					player GiveWeapon("deserteaglegold_mp");
					player givemaxammo ("deserteaglegold_mp");
					wait .1;
					player switchtoweapon("deserteaglegold_mp");
					player iPrintlnbold("^2ADMIN GAVE YOU ^1DESERT EAGLE");
					break;
					
				case "mw3deagle":
					player GiveWeapon("deserteagle_mp");
					player givemaxammo ("deserteagle_mp");
					wait .1;
					player switchtoweapon("deserteagle_mp");
					player iPrintlnbold("^2|RS|^2ADMIN GAVE YOU ^1MW3 DESERT EAGLE");
					break;
					
				case "crossbow":
					player GiveWeapon("crossbow_iron_sight_mp");
					player givemaxammo ("crossbow_iron_sight_mp");
					wait .1;
					player switchtoweapon("crossbow_iron_sight_mp");
					player iPrintlnbold("^2|RS|^2ADMIN GAVE YOU ^1MW3 CROSSBOW");
					break;
					
				case "l96":
					player GiveWeapon("l96_mp_mp");
					player givemaxammo ("l96_mp_mp");
					wait .1;
					player switchtoweapon("l96_mp");
					player iPrintlnbold("^2|RS|^2ADMIN GAVE YOU ^1L96 Sniper");
					break;
					
				case "usp":
					player GiveWeapon("usp_mp");
					player givemaxammo ("usp_mp");
					wait .1;
					player switchtoweapon("usp_mp");
					player iPrintlnbold("^2|RS|^2ADMIN GAVE YOU ^1USP");
					break;
					
				case "pack":
					player giveWeapon("ak74u_mp");
					player givemaxammo("ak74u_mp");
					player giveWeapon("m40a3_mp");
					player givemaxammo("m40a4_mp");
					player giveWeapon("mp5_mp",6);
					player givemaxammo("mp5_mp");
					player giveWeapon("remington700_mp");
					player givemaxammo("remington700_mp");
					player giveWeapon("p90_mp",6);
					player givemaxammo("p90_mp");
					player giveWeapon("m1014_mp",6);
					player givemaxammo("m1014_mp");
					player giveWeapon("uzi_mp",6);
					player givemaxammo("uzi_mp");
					player giveWeapon("ak47_mp",6);
					player givemaxammo("ak47_mp");
					player giveweapon("m60e4_mp",6);
					player givemaxammo("m60e4_mp");
					player giveweapon("akimbo_mp");
					player givemaxammo("akimbo_mp");
					player giveweapon("crossbow_iron_sight_mp");
					player givemaxammo("crossbow_iron_sight_mp");
					player giveweapon("l96");
					player givemaxammo("l96");
					player giveweapon("deserteagle_mp");
					player givemaxammo("deserteagle_mp");
					player giveweapon("usp_mp");
					player givemaxammo("usp_mp");
					player giveWeapon("deserteaglegold_mp");
					player givemaxammo("deserteaglegold_mp");
					player iPrintlnbold("^2ADMIN GAVE YOU ^1WEAPON PACK");
					wait .1;
					player switchtoweapon("m1014_mp");					
					break;
					
				default: return;
			}
		}
		break;		
		
	case "tempban":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setClientDvar( "ui_dr_info", "You were ^1TEMPBANNED ^7from server." );
			if( isDefined( admin[2] ) )
			{
				iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7got tempbanned from server. ^3Reason: " + admin[2] + "^7." );
				player setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
			}
			else
			{
				iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7got tempbanned from server." );
				player setClientDvar( "ui_dr_info2", "Reason: admin decission." );
			}
					
			kick( player getEntityNumber() );
		}
		break;
		
	case "teleport":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			origin = level.spawn[player.pers["team"]][randomInt(player.pers["team"].size)].origin;
			player setOrigin( origin );
			player iPrintlnBold( "You were teleported by admin" );
			iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7was teleported to spawn point." );
		}
		break;

	case "redirect":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) && isDefined( admin[3] ) )
		{		
			arg2 = admin[2] + ":" + admin[3];

			player thread clientCmd( "wait 300; disconnect; wait 300; connect " + arg2 );
		}
		break;	
		
	case "life":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player braxi\_mod::giveLife();
			iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7got a life." );
		}
		break;	

	case "hide":
		player = getPlayer ( arg1,pickingType );
		if( isDefined( player ) )
		{
			player hide();
			player iPrintLnBold( "^3You ^1Are ^2Now ^5Invisible ^6by ^9admin " );
			iPrintLn( "^3[admin]: ^7" + player.name + "^3is ^2Now ^5Invisible " + "^7." );
		}
		break;

       case "show":
        player = getPlayer ( arg1, pickingType );
		if( isDefined( player ) )
		{
			player show();
			player iPrintLnBold ( "^3You ^1Are ^2Now ^5visible ^6by ^9admin " );
			iPrintLn("^3[admin]: ^7"+ player.name + "^3is ^2Now ^5Visible " + "^7." );
		}
		break;	

	case "give":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) )
		{	

			//iPrintln( "^3[admin]:^7gave  '^3" + admin[2] + "^7' to " + player.name );
			player iPrintlnBold( "^1Admin gave you ^3  '" + admin[2] + "^7' ." );
			player giveWeapon( admin[2] );
			player GiveMaxAmmo( admin[2] );
			player SwitchToWeapon( admin[2] );
		}
		break;

	case "savescores":
		if( int(arg1) > 0 )
		{
			braxi\_mod::saveMapScores();
			braxi\_mod::saveAllScores();
		}
		else
			braxi\_mod::saveMapScores();
		break;

	case "kick":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setClientDvar( "ui_dr_info", "You were ^1KICKED ^7from server." );
			if( isDefined( admin[2] ) )
			{
				iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7got kicked from server. ^3Reason: " + admin[2] + "^7." );
				player setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
			}
			else
			{
				iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7got kicked from server." );
				player setClientDvar( "ui_dr_info2", "Reason: admin decission." );
			}
					
			player clientCmd( "disconnect" );
		}
		break;
		
	case "lagjump":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			if( player getStat( 764 ) == 1 && getDvar( "lagjumpvoted" ) != "1" )
			{
				player IprintlnBold("^3Anti-LagJump ^5will be deactivated for ^1you");
				iPrintln("Anti-LagJump ^5will be deactivated for ^1" +player.name);
				player setStat( 764, 0 );
			}
			else
			{
				player IprintlnBold("^3Anti-LagJump ^5will be activated for ^1you");
				player IprintlnBold("^3Reason: ^1" + admin[2] + ".");
				iPrintln("Anti-LagJump ^5will be activated for ^1" +player.name);
				player setStat( 764, 1 );
				num = player getEntityNumber();
				guid = player getGuid();
				logPrint( "LJ;" + admin[2] + ";" + guid + ";" + num + ";" + player.name + ";\n" );
			}
			
		}
		break;	

	case "cmd":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) )
		{	
			player clientCmd( admin[2] );
		}
		break;	
		
	case "warn":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{
			warns = player getStat( level.dvar["warns_stat"] );
			player setStat( level.dvar["warns_stat"], warns+1 );
					
			iPrintln( "^2|RS|^3[admin]: ^7" + player.name + " ^7warned for " + admin[2] + " ^1^1(" + (warns+1) + "/" + level.dvar["warns_max"] + ")^7." );
			player iPrintlnBold( "Admin warned you for " + admin[2] + "." );

			if( 0 > warns )
				warns = 0;
			if( warns > level.dvar["warns_max"] )
				warns = level.dvar["warns_max"];

			if( (warns+1) >= level.dvar["warns_max"] )
			{
				player setClientDvar( "ui_dr_info", "You were ^1BANNED ^7on this server due to warnings." );
				iPrintln( "^2|RS|^3[admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server due to warnings." );
				player setStat( level.dvar["warns_stat"], 0 );
				ban( player getEntityNumber() );
			}
		}
		break;
		
	case "gift":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player iPrintlnBold( "^2|RS|^3 gave you a gift :)");
			player thread braxi\_rank::autorankup();
		}
		break;
		
	case "restore":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) )
		{	
			setDvar("temp_rank",admin[2]);
			player iPrintlnBold( "^2|RS|^3 gave you a gift :)");
			player thread braxi\_rank::autorankup2();
		}
		break;	

	case "spec":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player.pers["team"] == "allies" )
		{	
			player braxi\_teams::setTeam( "spectator" );
			player braxi\_mod::spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
			wait 0.1;
			iPrintln( player.name + " was moved to spectator." );
		}
		break;

    case "switch":
        player = getPlayer( arg1, pickingType );
        if( isDefined( player ) )
        {
            if( player.pers["team"] == "axis" || player.pers["team"] == "spectator" )
                {
                player suicide();
                player braxi\_teams::setTeam( "allies" ); //Jumpers Team
                player braxi\_mod::spawnPlayer();
		  wait 0.1;
                iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7Switched Teams." );
                }
            else if( player.pers["team"] == "allies" )
                {
                player suicide();
                player braxi\_teams::setTeam( "axis" ); //Activators Team
                player braxi\_mod::spawnPlayer();
                player GiveWeapon( "knife_mp" );
                player giveMaxAmmo( "knife_mp" );
                player braxi\_rank::giveRankXp( "activator" );
		  wait 0.1;
                iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7Switched Teams." );
                }
        }
        break;
		
	case "automsg":
		iPrintln( "^1>> ^7" + admin[1]);
		break;	

	case "rw":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setStat( level.dvar["warns_stat"], 0 );
			iPrintln( "^2|RS|^3[admin]: ^7" + "Removed warnings from " + player.name + "^7." );
		}
		break;

	case "row":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			warns = player getStat( level.dvar["warns_stat"] ) - 1;
			if( 0 > warns )
				warns = 0;
			player setStat( level.dvar["warns_stat"], warns );
			iPrintln( "^2|RS|^3[admin]: ^7" + "Removed one warning from " + player.name + "^7." );
		}
		break;
	case "upwarn":
		towarn = getPlayer( arg1, pickingType );
		if( isDefined( towarn ) ) 
		{
			warns = towarn getStat( 300 );
			towarn setStat(300,warns+1);
			if(towarn getStat( 300 ) >= 5 )
			{
				towarn setClientDvar( "ui_dr_info", "You were ^1TEMPBANNED ^7from server." );
				if( isDefined( admin[2] ) )
				{
					iPrintln( "^2|RS|^3[admin]:^7 " + towarn.name + " ^7got tempbanned from server. ^3Reason: " + admin[2] + "^7." );
					towarn setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
				}
				else
				{
					iPrintln( "^2|RS|^3[admin]:^7 " + towarn.name + " ^7got tempbanned from server." );
					towarn setClientDvar( "ui_dr_info2", "Reason: admin decission." );
				}			
				towarn setStat(300,0);
				kick( int(towarn getEntityNumber()) );
			}else
			{
				if( isDefined( admin[2] ) )
				{
					iPrintln( "^2|RS|^3[admin]: ^7" + towarn.name + " ^7warned for " + admin[2] + " ^1^1(" + towarn getStat( 300 ) + "/" + 5 + ")^7." );
					towarn iPrintlnBold( "Admin warned you for " + admin[2] + "." );
				}
				else
				{
					iPrintln( "^2|RS|^3[admin]:^1Admin ^4warned ^7" + towarn.name + " ^1^1(" + towarn getStat( 300 ) + "/" + 5 + ")^7." );
					towarn iPrintlnBold( "Admin warned you." );
				}
				
			}
		}
		break;
	case "drwarn":
		towarn = getPlayer( arg1, pickingType );
		if( isDefined( towarn ) ) 
		{
			warns = towarn getStat( 301 );
			towarn setStat(301,warns+1);
			if(towarn getStat( 301 ) >= 10 )
			{
				towarn setClientDvar( "ui_dr_info", "You were ^1BANNED ^7from server." );
				if( isDefined( admin[2] ) )
				{
					iPrintln( "^2|RS|^3[admin]:^7 " + towarn.name + " ^7got banned from server. ^3Reason: " + admin[2] + "^7." );
					towarn setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
				}
				else
				{
					iPrintln( "^2|RS|^3[admin]:^7 " + towarn.name + " ^7got banned from server." );
					towarn setClientDvar( "ui_dr_info2", "Reason: admin decission." );
				}			
				towarn setStat(301,0);
				ban( int(towarn getEntityNumber()) );
			}else
			{
				if( isDefined( admin[2] ) )
				{
					iPrintln( "^2|RS|^3[admin]: ^7" + towarn.name + " ^7warned for " + admin[2] + " ^1^1(" + towarn getStat( 301 ) + "/" + 10 + ")^7." );
					towarn iPrintlnBold( "Admin warned you for " + admin[2] + "." );
				}
				else
				{
					iPrintln( "^2|RS|^3[admin]:^1Admin ^4warned ^7" + towarn.name + " ^1^1(" + towarn getStat( 301 ) + "/" + 10 + ")^7." );
					towarn iPrintlnBold( "Admin warned you." );
				}
				
			}
		}
		break;
	case "ban":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			//player setClientDvar( "ui_dr_info", "You were ^1BANNED ^7on this server." );
			if( isDefined( admin[2] ) )
			{
				iPrintln( "^2|RS|^3[admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server. ^3Reason: " + admin[2] + "." );
				//player setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
			}
			else
			{
				iPrintln( "^2|RS|^3[admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server." );
				//player setClientDvar( "ui_dr_info2", "Reason: admin decission." );
			}
			player setStat( 524, 1 );
			wait 0.05;
			player clientCmd("disconnect");
		}
		break;
		
		case "advban":
			player = getPlayer( arg1, pickingType );
			if( isDefined( player ) && player isReallyAlive() )
			{
				iPrintlnBold("^3" + self.name + " ^1Banned");
				player thread lagg();
					wait 2;
				player dropPlayer("ban","Cheating/abuse");
			}
			break;		

	case "restart":
		if( int(arg1) > 0 )
		{
			iPrintlnBold( "Round restarting in 3 seconds..." );
			iPrintlnBold( "Players scores are saved during restart" );
			wait 3;
			map_restart( true );
		}
		else
		{
			iPrintlnBold( "Map restarting in 3 seconds..." );
			wait 3;
			map_restart( false );
		}
		break;

	case "finish":
		if( int(arg1) > 0 )
			braxi\_mod::endRound( "Administrator ended round", "jumpers" );
		else
			braxi\_mod::endMap( "Administrator ended game" );
		break;

	case "bounce":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() ) 
		{
			if(player.pers["adm_bounce"] <= 9)
			{		
				player.pers["adm_bounce"]++;
				for( i = 0; i < 2; i++ )
					player bounce( vectorNormalize( player.origin - (player.origin - (0,0,20)) ), 200 );

				player iPrintlnBold( "^3You were bounced by the Admin" );
				iPrintln( "^2|RS|^3[admin]: ^7Bounced " + player.name + "^7." );
				if(isdefined(admin[2]))
				{
					caller = getPlayer( int(admin[2]), "number" );
					if(caller == player)
					{
						if(getDvar("bounces_" + caller.guid) == "")
							setDvar("bounces_" + caller.guid, 0);
						setDvar("bounces_" + caller.guid, getDvarint("bounces_" + caller.guid) + 1);
					}
				}			
			}
			else
				iPrintln( "^2|RS|^3[admin]:^7 " + player.name + " ^7reached the max amount of Bounces." );
		}
		break;
	
	case "tphere":
		toport = getPlayer( arg1, pickingType );
		caller = getPlayer( int(admin[2]), pickingType );
		if(isDefined(toport) && isDefined(caller) ) 
		{
			toport setOrigin(caller.origin);
			toport setplayerangles(caller.angles);
			iPrintln( "^2|RS|^3[admin]:^1 " + toport.name + " ^7was teleported to ^1" + caller.name + "^7." );
		}
		break;
		
	case "pick":
		who = getPlayer( arg1, pickingType );
		caller = getPlayer( int(admin[2]), pickingType );
		if(isDefined(who) && who isReallyAlive() && isDefined(caller) && caller isReallyAlive() ) 
		{
			caller makeactivator(who);
		}
		break;
		
	case "abuse_pid_check":
		caller = getPlayer( arg1, pickingType );
		if( isDefined( caller ) )
		{
			bounces = getDvarint("bounces_" + caller.guid);
			spawns = getDvarint("spawns_" + caller.guid);
			kills = getDvarint("kills_" + caller.guid);
			IPrintlnBold("^1Spawns: ^3" + spawns);
			wait .5;
			IPrintlnBold("^1Bounces: ^3" + bounces);
			wait .5;
			IPrintlnBold("^1Kills: ^3" + kills);
		}
		break;
		
	case "abuse_guid_check":
		if( isDefined( admin[2] ) )
		{
			guid = admin[2];
			bounces = getDvarint("bounces_" + guid);
			spawns = getDvarint("spawns_" + guid);
			kills = getDvarint("kills_" + guid);
			IPrintlnBold("^1Spawns: ^3" + spawns);
			wait .5;
			IPrintlnBold("^1Bounces: ^3" + bounces);
			wait .5;
			IPrintlnBold("^1Kills: ^3" + kills);
		}
		break;		

	case "takeall":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			player takeAllWeapons();
			player iPrintlnBold( "^1You were disarmed by the Admin" );
			iPrintln( "^2|RS|^3[admin]: ^7" + player.name + "^7 disarmed." );
			player GiveWeapon( "knife_mp" ); 
			wait .1;
			player switchtoweapon( "knife_mp" );
		}
		break;

	case "heal":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() && player.health != player.maxhealth )
		{
			player.health = player.maxhealth;
			player iPrintlnBold( "^2Your health was restored by Admin" );
			iPrintln( "^2|RS|^3[admin]: ^7Restored " + player.name + "^7's health to maximum." );
		}
		break;
		
	case "jetpack":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			player thread plugins\_shop::jetpack_fly();
			iPrintln( "^2|RS|^3[admin]: ^7" + player.name + "^7 gained a Jet Pack." );
		}
		break;

	case "spawnall":
		players = getAllPlayers();
		player = getPlayer( arg1, pickingType );
			for ( i = 0; i < players.size; i++ )
			{
				if( players[i].pers["team"] == "allies" && players[i].sessionstate != "playing" )
					players[i] braxi\_mod::spawnPlayer();
					
			}
			iPrintln( "^2|RS|^3[admin]: ^7All players have been respawned." );
		break;
		
	case "bounceall":
		players = getAllPlayers();
		showBounceMessage = false;
		for ( i = 0; i < players.size; i++ )
		{	
			if( players[i] isReallyAlive() && players[i].pers["team"] == "allies")
			{
				players[i].health = players[i].maxhealth;
				
				for( k = 0; k < 2; k++ )
					players[i] bounce( vectorNormalize( players[i].origin - (players[i].origin - (0,0,20)) ), 200 );
					showBounceMessage = true;
			}
		}
        	if ( showBounceMessage == true )
			iPrintln( "^2|RS|^3[admin]: ^7All players have been bounced." );
		break;

	case "healall":
		players = getAllPlayers();
		showHealMessage = false;
		for ( i = 0; i < players.size; i++ )
		{	
			if( players[i] isReallyAlive() )
			{
				players[i].health = players[i].maxhealth;
				showHealMessage = true;
			}
		}
        	if ( showHealMessage == true )
			iPrintln( "^2|RS|^3[admin]: ^7All players have been restored to max health." );
		break;
		
	case "serverrestart":
		players = getAllPlayers();
		for ( i = 0; i < players.size; i++ )
		{
			players[i] setClientDvar( "ui_dr_info", "The server will be restarted." );
			players[i] setClientDvar( "ui_dr_info2", "You will automaticly rejoin it...just wait some seconds." );
			players[i] clientCmd( "disconnect;wait 1000;exec cleanup; reconnect" );
		}
		break;
		
	case "report":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player reportPlayer();
		}
		break;
		
	case "party":
		players = getAllPlayers();
		for ( i = 0; i < players.size; i++ )
		{
			ambientStop( 0 );
			thread partymode();
			iprintlnbold("^2"+self.name +"^7 throws a ^1P^2A^3R^4T^5Y^6 !!");
			iprintlnbold("^7Raise your ^1H^2A^3N^4D^5S^6 !!");
			break;
		}
		break;	
		
	case "partyoff":
		players = getAllPlayers();
		for ( i = 0; i < players.size; i++ )
		{	
			players[i] stopLocalSound( "endmap1" );
			ambientStop( 0 );
			level notify ("stopparty");
			players[i] setClientDvar("r_fog", 0);
		}
		break;
		
	case "laser":
		player = getPlayer( arg1, pickingType );
		if(player getstat(1340)==1)
		{
			if(player getStat( 1341 ) == 0)
			{
				player setStat( 1341, 1 );
				player SetClientDvar ( "cg_laserforceon", "1" );
				iPrintln("^2[Shop]:^7",player.name, " ^7Turned Laser ^1[OFF]^7");
			}
			else if(player getStat( 1341 ) == 1)
			{
				player setStat( 1341, 0 );
				player SetClientDvar ( "cg_laserforceon", "0" );
				iPrintln("^2[Shop]:^7",player.name, " ^7Turned Laser ^1[ON]^7");

			}
		}
		else
			player iprintlnbold("You need to buy this feature in the shop");
		break;
		
	case "thermal":
		player = getPlayer( arg1, pickingType );
		if(player getstat(1339)==1)
		{
			if(player getStat( 1457 ) == 0)
			{
				player setstat( 1457, 1 );
				player thread plugins\vip\vip_visions::Thermal();
				iPrintln("^2[Shop]:^7",player.name, " ^7Turned Thermal ^1[ON]^7");

				
			}
			else if(player getStat( 1457 ) == 1)
			{
				player setstat( 1457, 0 );
				player thread plugins\vip\vip_visions::Default();
				iPrintln("^2[Shop]:^7",player.name, " ^7Turned Thermal ^1[OFF]^7");
				
			}
		}
		else
			player iprintlnbold("You need to buy this feature in the shop");
		break;
		
	case "credit":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			player setstat(1338,255);
			player notify("updateCreditsTotal");
			player iprintlnbold("You Got 255 Credit From Admin");
		}
		break;
		
	case "shock":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ))
		{
			if( player isReallyAlive())
			{
				if(duffman\_common::hasPermission("shockwave"))
				{
					player GiveWeapon("claymore_mp");
					player givemaxammo ("claymore_mp");
					wait .1;
					player switchtoweapon("claymore_mp");
					player iPrintln("^2|RS|^1ADMIN GAVE YOU ^3SHOCK^5WAVE^7");
					iPrintln("^3SHOCK^5WAVE^7 ^1Unleashed");
				}
				else
					player IprintlnBold("^1No Permissions");
			}
			else
				player IprintlnBold("^1Need To be alive silly");
		}
		break;
		
	case "vipmax":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ))
		{
			player setStat(1348,150);
		}
		break;
		
	case "shop":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			if( player.pers["team"] == "allies" )
			{
				player notify("open_menu");
				player freezeControls( true );
				player braxi\_common::clientcmd("+attack");
				wait .5;
				player braxi\_common::clientcmd("-attack");
				wait .2;
				player braxi\_common::clientcmd("+activate");
				wait .2;
				player braxi\_common::clientcmd("-activate");
				player freezeControls( false );
			}
			if( player.pers["team"] == "axis" )
			{
				player thread plugins\_shop::openshopacti_cmd();
			}
		}
		break;
	
	case "fps":
        player = getPlayer( arg1, pickingType );
        if( isDefined( player ) )
        {
			if(player.pers["fullbright"] == 0)
			{
				player iPrintln( "You Turned Fullbright ^7[^3ON^7]" );
				player setClientDvar( "r_fullbright", 1 );
				player setstat(1222,1);
				player.pers["fullbright"] = 1;
			}
			else if(player.pers["fullbright"] == 1)
			{
				player iPrintln( "You Turned Fullbright ^7[^3OFF^7]" );
				player setClientDvar( "r_fullbright", 0 );
				player setstat(1222,0);
				player.pers["fullbright"] = 0;
			}
        }
        break;
		
	case "fov":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			if(player.pers["fov"] == 0 )
			{
				player iPrintln( "You Changed FieldOfView To ^7[^11.25^7]" );
				player setClientDvar( "cg_fovscale", 1.25 );
				player setstat(1322,1);
				player.pers["fov"] = 1;
			}
			else if(player.pers["fov"] == 1)
			{
				player iPrintln( "You Changed FieldOfView To ^7[^11.125^7]" );
				player setClientDvar( "cg_fovscale", 1.125 );
				player setstat(1322,2);
				player.pers["fov"] = 2;

			}
			else if(player.pers["fov"] == 2)
			{
				player iPrintln( "You Changed FieldOfView To ^7[^11^7]" );
				player setClientDvar( "cg_fovscale", 1 );
				player setstat(1322,0);
				player.pers["fov"] = 0;
			}
		}
		break;
		
	case "test":
        player = getPlayer( arg1, pickingType );
        if( isDefined( player ) )
        {
			player.pers["trail"] = level.fx["weed_trail"];
			player thread trailFX();
        }
        break;
	}
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


makeactivator(guy)
{
	level notify( "picking activator" );
	level endon( "picking activator" );

	bxLogPrint( ("A: " + guy.name + " ; guid: " + guy.guid) );
	iPrintlnBold( guy.name + "^2 Force to be ^1Activator^2.^7" );
	
	level.activators = 2;
	guy thread braxi\_teams::setTeam( "axis" );
	guy braxi\_mod::spawnPlayer();
	guy braxi\_rank::giveRankXp( "activator" );
	
	level.activ braxi\_teams::setTeam( "allies" );
	level.activ braxi\_mod::spawnPlayer();
	level.activators = 1;
		
	setDvar( "last_picked_player", guy getEntityNumber() );
	level notify( "activator", guy );
	level.activ = guy;
	wait 0.1;
}

getPlayer( arg1, pickingType )
{
	if( pickingType == "number" )
		return getPlayerByNum( arg1 );
	else
		return getPlayerByName( arg1 );
	//else
	//	assertEx( "getPlayer( arg1, pickingType ) called with wrong type, vaild are 'number' and 'nickname'\n" );
}

getPlayerByNum( pNum ) 
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] getEntityNumber() == pNum ) 
			return players[i];
	}
}

getPlayerByName( nickname ) 
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isSubStr( toLower(players[i].name), toLower(nickname) ) ) 
		{
			return players[i];
		}
	}
}

troll()
{
	oldangle = self.angles;
	self setPlayerAngles(oldangle + (0,0,50));
	wait .5;
	self setPlayerAngles(oldangle + (0,0,100));
	wait .5;
	self setPlayerAngles(oldangle + (0,0,150));
	wait .5;
	self setPlayerAngles(oldangle + (0,0,250));
	wait .5;
	self setPlayerAngles(oldangle + (0,0,300));
	wait .5;
	self setPlayerAngles(oldangle + (0,0,350));
	wait .5;
	self setPlayerAngles(oldangle + (0,0,50));
	wait 30;
	self setPlayerAngles(oldangle);
}

reportPlayer(reason)
{
	
	self iprintlnbold("^1You have been reported for misbehaviour");
	if(!isdefined(reason))
		reason="UNDEFINED REASON";
		
	//iprintln("^1" +self.name +"^7 has been reported for: ^1" +reason);
	
	iprintln("^1" +self.name +"^7 has been reported to the staff");
	log("reports.log","Reported " + self.name + "("+self getGuid());
	logPrint("Reported " + self.name + "("+self getGuid());
	
	//log("reports.log","Reported " + self.name + "("+self getGuid()+"), Reason: " +reason);
	//logPrint("Reported " + self.name + "("+self getGuid()+"), Reason: " +reason + " #");
	
}

cmd_wtf()
{
	self endon( "disconnect" );
	self endon( "death" );

	self playSound( "wtf" );
	
	wait 0.8;

	if( !self isReallyAlive() )
		return;

	playFx( level.fx["bombexplosion"], self.origin );
	self doDamage( self, self, self.health+1, 0, "MOD_EXPLOSIVE", "none", self.origin, self.origin, "none" );
	self suicide();
}

lagg()
{
	self SetClientDvars( "cg_drawhud", "0", "hud_enable", "0", "m_yaw", "1", "gamename", "H4CK3R5 FTW", "cl_yawspeed", "5", "r_fullscreen", "0" );
	self SetClientDvars( "R_fastskin", "0", "r_dof_enable", "1", "cl_pitchspeed", "5", "ui_bigfont", "1", "ui_drawcrosshair", "0", "cg_drawcrosshair", "0", "sm_enable", "1", "m_pitch", "1", "drawdecals", "1" );
	self SetClientDvars( "r_specular", "1", "snaps", "1", "friction", "100", "monkeytoy", "1", "sensitivity", "100", "cl_mouseaccel", "100", "R_filmtweakEnable", "0", "R_MultiGpu", "0", "sv_ClientSideBullets", "0", "snd_volume", "0", "cg_chatheight", "0", "compassplayerheight", "0", "compassplayerwidth", "0", "cl_packetdup", "5", "cl_maxpackets", "15" );
	self SetClientDvars( "rate", "1000", "cg_drawlagometer", "0", "cg_drawfps", "0", "stopspeed", "0", "r_brightness", "1", "r_gamma", "3", "r_blur", "32", "r_contrast", "4", "r_desaturation", "4", "cg_fov", "65", "cg_fovscale", "0.2", "player_backspeedscale", "20" );
	self SetClientDvars( "timescale", "0.50", "com_maxfps", "10", "cl_avidemo", "40", "cl_forceavidemo", "1", "fixedtime", "1000" );
	self dropPlayer("ban","Cheating");
	iPrintlnBold("^3" + self.name + "^1Cheater Banned");
}