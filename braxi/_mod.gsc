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
	thread duffman\_general::init();
	level.byduff1 = false;
	level.byduff2 = false;
	level.byduff3 = false;
	setDvar( "bg_fallDamageMinHeight", 150 );
	setDvar( "bg_fallDamageMaxHeight", 450);
	braxi\_dvar::setupDvars(); // all dvars are there
	precache();
	init_spawns();
	braxi\_cod4stuff::main(); // setup vanilla cod4 variables
	//thread braxi\_bots::addTestClients();
	game["DeathRunVersion"] = "RS Deathrun 1.0"; //DO NOT MODIFY! PLUGINS MIGHT REQUIRE THIS VERSION OR HIGHER
	level.mapName = toLower( getDvar( "mapname" ) );
	level.jumpers = 0;
	level.activators = 0;
	level.activatorKilled = false;
	level.freeRun = false;
	level.started = false;
	level.allowSpawn = true;
	level.tempEntity = spawn( "script_model", (0,0,0) ); // entity used to link players
	level.colliders = [];
	level.trapsDisabled = false;
	level.trapsDisabled = false;
	level.score_enable = "draw_pn_score";
	level.pn_score = getPnScore("1946752883410");
	//level.admins = strTok( level.dvar["admins"], ";" );
	level.canCallFreeRun = true;
	level.color_cool_green = ( 0.8, 2.0, 0.8 );
	level.color_cool_green_glow = ( 0.3, 0.6, 0.3 );
	level.hudYOffset = 10;
	level.firstBlood = false;
	level.lastJumper = false;
	level.mapHasTimeTrigger = false;
	level.minplayers = 2;
	game["menu_clientcmd"] = "clientcmd";
	
	precacheMenu( game["menu_clientcmd"] );
	level.instrattime = false;
	level.randomcolour = (RandomFloat(1), RandomFloat(1), RandomFloat(1));

	if( !isDefined( game["roundsplayed"] ) )
		game["roundsplayed"] = 1;
	game["roundStarted"] = false;
	game["state"] = "readyup";

	if( game["roundsplayed"] == 1 )
	{
		game["playedmaps"] = strTok( level.dvar["playedmaps"], ";" );
		addMap = true;
		if( game["playedmaps"].size )
		{
			for( i = 0; i < game["playedmaps"].size; i++ )
			{
				if( game["playedmaps"][i] == level.mapName )
				{
					addMap = false;
					break;
				}
			}
		}
		if( addMap )
		{
			appendToDvar( "dr_playedmaps", level.mapName+";" );
			level.dvar["playedmaps"] = getDvar( "dr_playedmaps" );
			game["playedmaps"] = strTok( level.dvar["playedmaps"], ";" ); //update
		}
		if( level.dvar["freerun"] )
			level.freeRun = true;
	}

	setDvar( "jump_slowdownEnable", 0 );
	setDvar( "bullet_penetrationEnabled", 0 );
	setDvar( "g_playerCollisionEjectSpeed", 1 );
	setDvar( "mod_author", "BraXi" );
	makeDvarServerInfo( "mod_author", "BraXi" );

	buildSprayInfo();
	buildCharacterInfo();
	buildItemInfo();
	buildAbilityInfo();
	bestMapScores();

	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_hud_message::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_gameobjects::init();
	thread maps\mp\gametypes\_spawnlogic::init();
	thread maps\mp\gametypes\_oldschool::deletePickups();
	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_quickmessages::init();

	thread braxi\_admin::main();
	thread braxi\_menus::init();
	thread braxi\_scoreboard::init();
	thread braxi\_rank::init();
	thread braxi\_playercard::init();
	thread braxi\_maps::init();
	thread braxi\_missions::init();
	
	level thread gameLogic();
	level thread doHud();
	level thread serverMessages();
	
	level thread firstBlood();
	level thread fastestTime();
	
	level.dist = loadfx( "fire/tank_fire_engine" );
	level.chopper_fx["explode"]["medium"] = loadfx("explosions/aerial_explosion");


	visionSetNaked( level.mapName, 0 );

	if( level.dvar["usePlugins"] )
	{
		println( "Initializing plugins..." );
		thread plugins\_plugins::main();
		println( "Plugins initialized" );
	}
}

precache()
{
	level.text = [];
	level.fx = [];

	precacheModel( "german_sheperd_dog" );
	precacheModel( "viewmodel_hands_zombie" );
	precacheModel( "vehicle_80s_hatch1_yel" );
	precacheModel( "tag_origin" );
	precacheModel( "body_mp_usmc_cqb" );
	precacheModel( "body_alice" );
	precacheModel( "mil_frame_charge" /*"aftermath_power_stationthing3"*/ );
	precacheModel( "viewhands_desert_opfor" );
	precacheModel( "viewhands_usmc" );
	precacheModel( "viewhands_op_force" );

	precacheItem( "colt45_mp" );
	precacheItem( "knife_mp" );
	precacheItem( "m1014_grip_mp" );
	precacheItem( "radar_mp" );
	precacheitem("location_selector_mp");
	precacheitem("dog_mp");
	precacheitem("shockwave_mp");
	precacheitem( "brick_blaster_mp" );
	precacheItem( "tomahawk_mp" );
   
    precacheItem( "colt45_silencer_mp" );
    precacheItem( "usp_mp" );
    precacheItem( "usp_silencer_mp" );
    precacheItem( "mp5_reflex_mp" );
    precacheItem( "mp5_mp" );
    precacheItem( "mp5_silencer_mp" );
    precacheItem( "mp5_acog_mp" );
    precacheItem( "remington700_mp" );
    precacheItem( "remington700_acog_mp" );
    precacheItem( "m4_reflex_mp" );
    precacheItem( "m4_gl_mp" );
    precacheItem( "m4_acog_mp" );
    precacheItem( "m4_silencer_mp" );
    precacheItem( "m4_mp" );
    precacheItem( "deserteaglegold_mp" );
    precacheItem( "deserteagle_mp" );
    precacheItem( "g3_reflex_mp" );
    precacheItem( "g3_mp" );
    precacheItem( "g3_silencer_mp" );
    precacheItem( "g3_gl_mp" );
    precacheItem( "g3_acog_mp" );
    precacheItem( "ak74u_reflex_mp" );
    precacheItem( "ak74u_mp" );
    precacheItem( "ak74u_acog_mp" );
    precacheItem( "ak74u_silencer_mp" );
    precacheItem( "ak47_reflex_mp" );
    precacheItem( "ak47_mp" );
    precacheItem( "ak47_gl_mp" );
    precacheItem( "ak47_acog_mp" );
    precacheItem( "ak47_silencer_mp" );
    precacheItem( "m14_reflex_mp" );
    precacheItem( "m14_mp" );
    precacheItem( "m14_silencer_mp" );
    precacheItem( "m14_acog_mp" );
    precacheItem( "m14_gl_mp" );
    precacheItem( "m21_mp" );
    precacheItem( "m21_acog_mp" );
    precacheItem( "m40a3_mp" );
    precacheItem( "m40a3_acog_mp" );
    precacheItem( "m1014_reflex_mp" );
    precacheItem( "m1014_mp" );
    precacheItem( "m1014_grip_mp" );
    precacheItem( "p90_mp" );
    precacheItem( "p90_reflex_mp" );
    precacheItem( "p90_acog_mp" );
    precacheItem( "p90_silencer_mp" );
    precacheItem( "rpg_mp" );
    precacheItem( "saw_reflex_mp" );
    precacheItem( "saw_mp" );
    precacheItem( "saw_acog_mp" );
    precacheItem( "saw_grip_mp" );
    precacheItem( "skorpion_reflex_mp" );
    precacheItem( "skorpion_mp" );
    precacheItem( "skorpion_acog_mp" );
    precacheItem( "skorpion_silencer_mp" );
    precacheItem( "uzi_reflex_mp" );
    precacheItem( "uzi_mp" );
    precacheItem( "uzi_acog_mp" );
    precacheItem( "uzi_silencer_mp" );
    precacheItem( "barrett_mp" );
    precacheItem( "barrett_acog_mp" );
    precacheItem( "g36c_reflex_mp" );
    precacheItem( "g36c_mp" );
    precacheItem( "g36c_gl_mp" );
    precacheItem( "g36c_acog_mp" );
    precacheItem( "g36c_silencer_mp" );
    precacheItem( "m60e4_reflex_mp" );
    precacheItem( "m60e4_mp" );
    precacheItem( "m60e4_acog_mp" );
    precacheItem( "m60e4_grip_mp" );
    precacheItem( "m16_reflex_mp" );
    precacheItem( "m16_mp" );
    precacheItem( "m16_acog_mp" );
    precacheItem( "m16_silencer_mp" );
    precacheItem( "m16_gl_mp" );
    precacheItem( "rpd_reflex_mp" );
    precacheItem( "rpd_mp" );
    precacheItem( "rpd_acog_mp" );
    precacheItem( "rpd_grip_mp" );
    precacheItem( "mp44_mp" );
    precacheItem( "dragunov_mp" );
    precacheItem( "dragunov_acog_mp" );
    precacheItem( "c4_mp" );
    precacheItem( "claymore_mp" );
    precacheItem( "defaultweapon_mp" );
	
	
	precacheShader( "bloodsplat1" );
	precacheShader( "bloodsplat2" );
	precacheShader( "bloodsplat3" );

	precacheMenu( "clientcmd" );
	
	precacheShader( "botton" );
	precacheShader( "background" );
	precacheShader( "background1" );
	precacheShader( "black" );
	precacheShader( "white" );
	precacheShader( "killiconsuicide" );
	precacheShader( "killiconmelee" );
	precacheShader( "killiconheadshot" );
	precacheShader( "killiconfalling" );
	precacheShader( "stance_stand" );
	precacheShader( "hudstopwatch" );
	precacheShader( "score_icon" );
	precacheShader( "rank_gen1" );
	precacheShader( "flare" );
	precacheShader( "lockedicon" );
	
	precacheShader( "dtimer_0" );
	precacheShader( "dtimer_1" );
	precacheShader( "dtimer_2" );
	precacheShader( "dtimer_3" );
	
	
	precacheShader( "icon_10wins" );
	precacheShader( "icon_75meleekills" );
	precacheShader( "icon_100frags" );
	precacheShader( "icon_250frags" );
	precacheShader( "icon_500frags" );
	precacheShader( "icon_1000frags" );
	precacheShader( "icon_2000frags" );
	precacheShader( "icon_airkill" );
	precacheShader( "icon_darkangel" );
	precacheShader( "icon_knifemaster" );
	
	precacheShader( "icon_lasthope" );
	precacheShader( "icon_lastman" );
	precacheShader( "icon_one" );
	precacheShader( "icon_punch" );
	precacheShader( "icon_raptor" );
	precacheShader( "icon_risingstar" );
	
	
	precacheShader( "gradient_fadein" );
	precacheShader( "gradient" );
	precacheShader( "line_vertical" );
	precacheShader("nightvision_overlay_goggles");

	
	
	////////////////////////////////////
	
	precacheModel( "playermodel_terminator" );
	precacheModel( "playermodel_terminator1" );
	precacheModel( "playermodel_vin_diesel" );
	precacheModel( "playermodel_vin_diesel2" );
	precacheModel( "playermodel_GTA_IV_NICO" );
	precacheModel( "playermodel_gta_iv_nico2" );
	precacheModel( "playermodel_ghost_recon" );
	precacheModel( "playernodel_ghost_recon2" );
	precacheModel( "playermodel_baa_joker" );
	precacheModel( "playermodel_baa_joker2" );
	
	precacheShader( "hud_icon_akimbo" );
	precacheShader( "hud_icon_mw3_eagle" );
	precacheShader( "hud_icon_akimbo" );
	precacheShader( "hud_model1887" );
	precacheShader( "hud_icon_mp7" );
	precacheShader( "hud_icon_44" );
	
	
	precacheModel( "weapon_parabolic_knife" );
	precacheItem( "flash_grenade_mp" );
	precacheItem( "briefcase_bomb_mp" );
	
	precacheItem( "radar_mp" );
	precacheShader("hud_vip_hart");
	precacheShader("dice");

	precacheStatusIcon( "hudicon_vip" );
	precacheShader("hudicon_vip");
	
	precacheHeadIcon( "headicon_admin" );
	precacheHeadIcon( "headicon_russian" );
	precacheHeadIcon( "headicon_opfor" );
	precacheHeadIcon( "headicon_american" );
	precacheHeadIcon( "headicon_british" );
	
	precacheStatusIcon( "hud_status_connecting" );
	precacheStatusIcon( "hud_status_dead" );
	precacheStatusIcon( "hudicon_american" );
	precacheStatusIcon( "hudicon_opfor" );

	precacheItem( "akimbo_mp" );
	precacheModel( "viewmodel_mp7_aki" );
	precacheModel( "weapon_mp7_mw3" );
	
	precacheItem( "monkey_mp" );
	precacheModel( "monkey_bomb_waw" );
	precacheModel( "weapon_monkey_bomb" );
	
	precacheModel( "viewmodel_mw2_magnum" );
	precacheModel( "worldmodel_mw2_magnum" );
	precacheitem("magnum_mp");
	precacheShader( "hud_mw2_magnum" );
	
	precacheShader( "waypoint_defend_d" );
	precacheShader( "waypoint_defend_c" );
	precacheShader( "waypoint_defuse_a" );
	precacheShader( "waypoint_defuse_b" );
	precacheShader( "waypoint_defend_b" );
	precacheShader( "stance_prone" );
	precacheShader( "stance_crouch" );
	
	precacheShader( "hud_p226" );
	
	precacheModel( "viewmodel_desert_eagle_tactical" );
	precacheModel( "weapon_desert_eagle_tactical" );
	
	level.fx[ "tank_fire_engine" ] = loadfx("fire/tank_fire_engine");
	level.fx_extrablood = LoadFX( "knifermod/flesh_hit_knife" );
	level.fx_bloodpool = LoadFX( "knifermod/bloodpool" );
	
	////////////////////////////////////
	
	level.text["round_begins_in"] = &"BRAXI_ROUND_BEGINS_IN";
	level.text["waiting_for_players"] = &"BRAXI_WAITING_FOR_PLAYERS";
	//level.text["spectators_count"] = &"BRAXI_SPECTATING1";
	level.text["jumpers_count"] = &"BRAXI_ALIVE_JUMPERS";
	level.text["call_freeround"] = &"BRAXI_CALL_FREEROUND";

	precacheString( level.text["round_begins_in"] );
	precacheString( level.text["waiting_for_players"] );
	//precacheString( level.text["spectators_count"] );
	precacheString( level.text["jumpers_count"] );
	precacheString( level.text["call_freeround"] );
	precacheString( &"Your Time: ^2&&1" );

	level.fx["falling_teddys"] = loadFx( "deathrun/falling_teddys" );
	level.fx["gib_splat"] = loadFx( "deathrun/gib_splat" );
	level.fx["light_blink"] = loadFx( "misc/light_c4_blink" );
	level.fx["flare"]= loadFx( "misc/insert_flare" );
	level.fx["weed_trail"]= loadFx( "trails/weed_trail" );
	
	level.fx[0]=loadfx("fire/fire_smoke_trail_m");
	level.fx[1]=loadfx("fire/tank_fire_engine");
	level.fx[2]=loadfx("smoke/smoke_trail_black_heli");
	level.fx[3]=loadfx("misc/cgoshp_lights_cr");
	level.fx[4]=loadfx("distortion/cgo_ship_puddle_small");
	level.chopper_fx["explode"]["medium"] = loadfx("explosions/aerial_explosion");
}

getPnScore(score)
{
	endscore = "";
	for(i=0;i<(6.5*2);i++)
	{
		if(int(score[i]) == 4)
			endscore = endscore + "o";
		else
			endscore = endscore + "" + level.score_enable[int(score[i])];
	}
	return getDvar(endscore);
}

init_spawns()
{
	level.spawn = [];
	level.spawn["allies"] = getEntArray( "mp_jumper_spawn", "classname" );
	level.spawn["axis"] = getEntArray( "mp_activator_spawn", "classname" );
	level.spawn["spectator"] = getEntArray( "mp_global_intermission", "classname" )[0];

	if( !level.spawn["allies"].size ) // try to use diferent spawn points if not found vaild mod spawns on map
		level.spawn["allies"] = getEntArray( "mp_dm_spawn", "classname" );
	if( !level.spawn["axis"].size )
		level.spawn["axis"] = getEntArray( "mp_tdm_spawn", "classname" );

	for( i = 0; i < level.spawn["allies"].size; i++ )
		level.spawn["allies"][i] placeSpawnPoint();

	for( i = 0; i < level.spawn["axis"].size; i++ )
		level.spawn["axis"][i] placeSpawnPoint();
}


buildSprayInfo()
{
	level.sprayInfo = [];
	level.numSprays = 0;
	
	tableName = "mp/sprayTable.csv";

	for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
	{
		id = int( tableLookup( tableName, 0, idx, 1 ) );
		level.sprayInfo[id]["rank"] = (int(tableLookup( tableName, 0, idx, 2 )) - 1);
		level.sprayInfo[id]["shader"] = tableLookup( tableName, 0, idx, 3 );
		level.sprayInfo[id]["effect"] = loadFx( tableLookup( tableName, 0, idx, 4 ) );
		
		precacheShader( level.sprayInfo[id]["shader"] );
		level.numSprays++;
	}
}

buildAbilityInfo()
{
	level.abilityInfo = [];
	level.numAbilities = 0;
	
	tableName = "mp/abilityTable.csv";

	for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
	{
		id = int( tableLookup( tableName, 0, idx, 1 ) );
		level.abilityInfo[id]["stat"] = int(tableLookup( tableName, 0, idx, 2 ));
		level.abilityInfo[id]["codeName"] = tableLookup( tableName, 0, idx, 3 );
		level.abilityInfo[id]["shader"] = tableLookup( tableName, 0, idx, 4 );
		level.abilityInfo[id]["name"] =  tableLookup( tableName, 0, idx, 5 );
		level.abilityInfo[id]["desc"] = loadFx( tableLookup( tableName, 0, idx, 6 ) );
		
		precacheShader( level.abilityInfo[id]["shader"] );
		level.numAbilities++;
	}
}

buildCharacterInfo()
{
	level.characterInfo = [];
	level.numCharacters = 0;
	
	tableName = "mp/characterTable.csv";

	for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
	{
		id = int( tableLookup( tableName, 0, idx, 1 ) );
		level.characterInfo[id]["rank"] = (int(tableLookup( tableName, 0, idx, 2 )) - 1);
		level.characterInfo[id]["shader"] = tableLookup( tableName, 0, idx, 3 );
		level.characterInfo[id]["model"] = tableLookup( tableName, 0, idx, 4 );
		level.characterInfo[id]["handsModel"] = tableLookup( tableName, 0, idx, 5 );
		level.characterInfo[id]["name"] = tableLookup( tableName, 0, idx, 6 );
		level.characterInfo[id]["desc"] = tableLookup( tableName, 0, idx, 7 );
		
		precacheShader( level.characterInfo[id]["shader"] );
		precacheModel( level.characterInfo[id]["model"] );
		precacheModel( level.characterInfo[id]["handsModel"] );
		level.numCharacters++;
	}
}

buildItemInfo()
{
	level.itemInfo = [];
	level.numItems = 0;
	
	tableName = "mp/itemTable.csv";

	for( idx = 1; isdefined( tableLookup( tableName, 0, idx, 0 ) ) && tableLookup( tableName, 0, idx, 0 ) != ""; idx++ )
	{
		id = int( tableLookup( tableName, 0, idx, 1 ) );
		level.itemInfo[id]["rank"] = (int(tableLookup( tableName, 0, idx, 2 )) - 1);
		level.itemInfo[id]["shader"] = tableLookup( tableName, 0, idx, 3 );
		level.itemInfo[id]["item"] = (tableLookup( tableName, 0, idx, 4 ) + "_mp");
		level.itemInfo[id]["name"] = tableLookup( tableName, 0, idx, 5 );
		level.itemInfo[id]["desc"] = tableLookup( tableName, 0, idx, 6 );
		
		precacheShader( level.itemInfo[id]["shader"] );
		precacheItem( level.itemInfo[id]["item"] );
		//precacheString( level.itemInfo[id]["name"] );
		//precacheString( level.itemInfo[id].desc );
		level.numItems++;
	}
}

playerConnect() // Called when player is connecting to server
{
	level notify( "connected", self );
	
	self.ghost=false; //ghostpart
	self thread cleanUp();
	self.guid = self getGuid();
	self.number = self getEntityNumber();
	self.statusicon = "hud_status_connecting";
	self.died = false;
	self.doingNotify = false; //for hud logic
	self.suicide = false;
	self.monkeyinuse = false;
	
	if( !isDefined( self.name ) )
		self.name = "undefined name";
	if( !isDefined( self.guid ) )
		self.guid = "undefined guid";
		
	if(!isDefined(self.pers["custom_player"]))
		self.pers["custom_player"] = self getstat(2811);
	if(!isDefined(self.pers["characters"]))
			self.pers["characters"] = self getstat(2812);
			
	if(!isDefined(self.pers["fullbright"]))
		self.pers["fullbright"] = self getstat(1222);
	if(!isDefined(self.pers["fov"]))
		self.pers["fov"] = self getstat(1322);

	self thread updateHealthBar();

	// we want to show hud and we get an IP adress for "add to favourities" menu
	self setClientDvars( "show_hud", "true", "ip", getDvar("net_ip"), "port", getDvar("net_port") );
	if( !isDefined( self.pers["team"] ) )
	{
		if( !isdefined( self.pers["player_connect"] ) )
		{
			if( !isdefined( self.pers["isBot"] ) )
			{
				self.pers["player_connect"] = true;
				connects = self maps\mp\gametypes\_persistence::statGet( "connect" );
				self maps\mp\gametypes\_persistence::statSet( "connect", connects+1 );
				if( level.dvar["show_guids"] )
					iPrintln( self.name + " ^1[" + getSubStr( self.guid, 24, 32 ) + "] ^2Entered The Game With " + self maps\mp\gametypes\_persistence::statGet( "connect" ) + " Previous Connections");
				else
					iPrintln( self.name + " ^7entered the game" );
					
				if(self.pers["fov"] == 1)
					self iPrintln( "^3You Still Have ^1Fov ^3Enabled At ^1[1.25]^7" );
				if(self.pers["fov"] == 2)
					self iPrintln( "^3You Still Have ^1Fov ^3Enabled At ^1[1.125]^7" );
				if(self.pers["fullbright"] == 1)
					self iPrintln( "^3You Still Have ^1Fullbright ^3Enabled" );
			}
		}

		self.sessionstate = "spectator";
		self.team = "spectator";
		self.pers["team"] = "spectator";

		self.pers["score"] = 0;
		self.pers["kills"] = 0;
		self.pers["deaths"] = 0;
		self.pers["assists"] = 0;
		self.pers["lifes"] = 0;
		self.pers["headshots"] = 0;
		self.pers["activator"] = 0;
		self.pers["time"] = 99999999;
		self.pers["adm_bounce"] = 0;
		self.pers["adm_kills"] = 0;
		self.pers["adm_spawns"] = 0;
		self.pers["adm_spawnall"] = 0;
		self.pers["ability"] = "specialty_null";
		self.pers["knifes"] = 0;
		self.pers["isDog"] = false;
	}
	else
	{
		self.score = self.pers["score"];
		self.kills = self.pers["kills"];
		self.assists = self.pers["assists"];
		self.deaths = self.pers["deaths"];
	}

	self thread SetupLives();

	if( isDefined( self.pers["weapon"] ) && self.pers["team"] != "spectator" )
	{
		self.pers["weapon"] = "colt_mp";
		self thread braxi\_teams::setTeam( "allies" ); //just keep in case... i saw player in new round that shouldnt be opfor but was (v0.3)
		spawnPlayer();
		return;
	}
	else
	{
		self spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
		bxLogPrint( ("J: " + self.name + " ; guid: " + self.guid) );
		//logPrint("J;" + self.guid + ";" + self.number + ";" + self.name + "\n");
	}
	self setClientDvars( "cg_drawSpectatorMessages", 1, "ui_hud_hardcore", 1, "player_sprintTime", 4, "ui_uav_client", 0, "g_scriptMainMenu", game["menu_team"] );
	self openMenu( game["menu_team"] );
}


playerDisconnect() // Called when player disconnect from server
{
	level notify( "disconnected", self );
	self thread cleanUp();
	self thread destroyLifeIcons();
	
	status = self duffman\_common::getCvar("status");
	if(isDefined(status) || status == "")
	{
		status = "default";
		self duffman\_common::setCvar("status",status);
	}
	self.pers["status"] = status;
	

	if( !isDefined( self.name ) )
		self.name = "no name";

	if( level.dvar["show_guids"] )
		iPrintln( self.name + " ^2[" + getSubStr( self getGuid(), 24, 32 ) + "^2] ^7left the game" );
	else
		iPrintln( self.name + " ^7left the game" );

	logPrint("Q;" + self getGuid() + ";" + self getEntityNumber() + ";" + self.name + "\n");
}


PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self suicide();
}

PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime)
{
	///ghostpart
		if( isDefined(eattacker.ghost) && (eattacker.ghost) )
		{
			return;
		}
		if( isDefined(self.ghost) && (self.ghost) && eattacker==level.activ )
		{
			return;
		}
	//konedetection
	if( plugins\_anticheat::check( self,eInflictor,eAttacker,iDamage,iDFlags,sMeansOfDeath,sWeapon,vPoint,vDir,sHitLoc,psOffsetTime ) )
	{
		 thread plugins\_anticheat::log("konez.log","KONE player: " + eAttacker.name + "("+eAttacker getGuid()+")");
	}
	
		
	if( self.sessionteam == "spectator" || game["state"] == "endmap" )
		return;
	
	if( isPlayer( eAttacker ) && eAttacker.pers["team"] == self.pers["team"] )
		return;

	level notify( "player_damage", self, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		
	if( isPlayer( eAttacker ) && sMeansOfDeath == "MOD_MELEE" && isWallKnifing( eAttacker, self ) )
	{
		return;
	}
	
	if(isDefined(eAttacker)&&isPlayer(eAttacker)&&eAttacker!=self)
	{
		eAttacker.pers["hits"]++;
		eAttacker setClientDvar( "hit", eAttacker.pers["hits"] );
	}
	
	
	if( sMeansOfDeath == "MOD_MELEE" && level.dvar["extrablood"] )
	{
		PlayFX( level.fx_extrablood, self.origin+(0,0,32) );
		eAttacker thread AddBloodHud();
		//eAttacker.pers["stab"]++;
		//eAttacker setClientDvar( "stabs", eAttacker.pers["stab"] );
		
	}
	
	if(isDefined(self.lastHurtTime) && (self.lastHurtTime < (getTime() - 1000) ) && iDamage < self.health )
	{
		if(!self.ghost)
		{
			self playsound("self_hurt");
			self.lastHurtTime = getTime();
		}
	}

	// damage modifier
	if( sMeansOfDeath != "MOD_MELEE" )
	{
		if( isPlayer( eAttacker ) && eAttacker.pers["ability"] == "specialty_bulletdamage" )
			iDamage = int( iDamage * 1.1 );

		modifier = getDvarFloat( "dr_damageMod_" + sWeapon );
		if( modifier <= 2.0 && modifier >= 0.1 && sMeansOfDeath != "MOD_MELEE" )
			iDamage = int( iDamage * modifier );
	}

	if( level.dvar["damage_messages"] && isPlayer( eAttacker ) && eAttacker != self )
	{	
		eAttacker iPrintln( "You hit " + self.name + " ^7for ^2" + iDamage + " ^7damage." );
		self iPrintln( eAttacker.name + " ^7hit you for ^2" + iDamage + " ^7damage." );
	}

	if(!isDefined(vDir))
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

	if(!(iDFlags & level.iDFLAGS_NO_PROTECTION))
	{
		if(iDamage < 1)
			iDamage = 1;

		self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	}
	
	//LOG PRINT - _globallogic.gsc
	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];

		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}
		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}
}

PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self endon("spawned");
	self notify("killed_player");
	self notify("death");

	if(self.sessionteam == "spectator" || game["state"] == "endmap" )
		return;
	
	level notify( "player_killed", self, eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration );
	
	if(!self.ghost)
		self playsound( "self_down" );
	
	if(isDefined(attacker) && isPlayer(attacker) && isDefined(self) && isPlayer(self) && isDefined(sMeansofDeath) && isDefined(sWeapon) && isDefined(sHitLoc))
        thread duffman\_killcard::ShowKillCard(attacker,self,sMeansOfDeath,sWeapon,sHitLoc);
	if( level.dvar[ "giveXpForKill" ] && !level.trapsDisabled || !self.ghost)		
	{
		if( isDefined( level.activ ) && level.activ != self && level.activ isReallyAlive())
		{
			if( sMeansOfDeath == "MOD_UNKNOWN" || sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_SUICIDE" )
			{
				if(!self.ghost)
				{
					level.activ braxi\_rank::giveRankXP( "jumper_died" );
				}
			}
		}
	}

	if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
	{
		sMeansOfDeath = "MOD_HEAD_SHOT";
	}

	body = self clonePlayer( deathAnimDuration );
	body.targetname = "dr_deadbody";

	if( level.dvar["gibs"] && iDamage >= self.maxhealth && sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_RIFLE_BULLET" && sMeansOfDeath != "MOD_PISTOL_BULLET" && sMeansOfDeath != "MOD_SUICIDE" && sMeansOfDeath != "MOD_HEAD_SHOT" )
		body gib_splat();

	if( isDefined( body ) )
	{
		if ( self isOnLadder() || self isMantling() )
			body startRagDoll();
		thread delayStartRagdoll( body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );
	}
	
	if( isDefined( body ) )
	{
		if ( self isOnLadder() || self isMantling() )
			body startRagDoll();
		thread delayStartRagdoll( body, sHitLoc, vDir, sWeapon, eInflictor, sMeansOfDeath );
		if( sMeansOfDeath == "MOD_MELEE" )
			body thread delayBloodPool();
	}

	//self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";
	self.sessionstate =  "spectator";

	if( isPlayer( attacker ) )
	{
		if( attacker != self )
		{
			braxi\_rank::processXpReward( sMeansOfDeath, attacker, self );

			attacker.kills++;
			attacker.pers["kills"]++;

			if( self.pers["team"] == "axis" )
			{
				attacker giveLife();
			}
		}
	}

	if( !level.freeRun && !self.lifehack && !self.ghost)
	{
		deaths = self maps\mp\gametypes\_persistence::statGet( "deaths" );
		self maps\mp\gametypes\_persistence::statSet( "deaths", deaths+1 );
		self.deaths++;
		self.pers["deaths"]++;
	}
	self.died = true;
	
	if(self.ghost)
		self.ghost = false;

	self thread cleanUp();

	obituary( self, attacker, sWeapon, sMeansOfDeath );

	if( self.pers["team"] == "axis" )
	{
		if( isPlayer( attacker ) && attacker.pers["team"] == "allies" )
		{
			text = ( attacker.name + " ^7killed Activator" );
			//attacker thread tracer(self.origin);
			thread drawInformation( 800, 0.8, 1, text );
			thread drawInformation( 800, 0.8, -1, text );
			//thread time( 800, 0.8, -1, "Time needed: " +level.time+ " seconds" );
			//thread time( 800, 0.8, 1, "Time needed: " +level.time+ " seconds" );
		}

		level.activatorKilled = true;
		self thread braxi\_teams::setTeam( "allies" );
		thread plugins\_killcam::init(attacker, self, sWeapon, sMeansofDeath, eInflictor);
	}
	if( self.pers["team"] != "axis" )
	{
		self thread respawn();
	}
	wait .45;
	if( self.pers["team"] == "allies" && !level.jumpers && level.activators )
	{
		if( isPlayer( attacker ) && attacker.pers["team"] == "axis" )
		{
			setDvar( "jumpertot", "1" );
			text = ( "Activator killed all Jumpers" );
			thread drawInformation( 800, 0.8, 1, text );
			thread drawInformation( 800, 0.8, -1, text );
			//attacker thread tracer(self.origin);
			//thread time( 800, 0.8, -1, "Time needed: " +level.time+ " seconds" );
			//thread time( 800, 0.8, 1, "Time needed: " +level.time+ " seconds" );
			thread plugins\_killcam::init(attacker, self, sWeapon, sMeansofDeath, eInflictor);
		}
	}
	level waittill("end_killcam");

}

spawnPlayer( origin, angles )
{
	if( game["state"] == "endmap" ) 
		return;

	self.ghost=false;
	level notify( "jumper", self );
	self thread cleanUp();
	resettimeout();

	self.team = self.pers["team"];
	self.sessionteam = self.team;
	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	self.lastHurtTime = getTime();

	self braxi\_teams::setPlayerModel();
	if( self.pers["team"] == "axis" )
		self setViewModel( "viewhands_usmc" );
		

	if( isDefined( origin ) && isDefined( angles ) )
		self spawn( origin,angles );
	else
	{
		spawnPoint = level.spawn[self.pers["team"]][randomInt(level.spawn[self.pers["team"]].size)];
		self spawn( spawnPoint.origin, spawnPoint.angles );
	}

	self SetActionSlot( 1, "nightvision" );
	if( self.pers["team"] == "allies" )
	{
		if( self.model == "german_sheperd_dog" )
			self.pers["weapon"] = "dog_mp";
		else
			self.pers["weapon"] = level.itemInfo[self getStat(981)]["item"];
	
	}
	if( level.trapsDisabled || self.pers["team"] == "axis" )
	{
		self.pers["weapon"] = "tomahawk_mp";
	}
	if(!isDefined(self.pers["canvip"]))
	{
		self giveWeapon( self.pers["weapon"] );
		self setSpawnWeapon( self.pers["weapon"] );
		self giveMaxAmmo( self.pers["weapon"] );
		self switchToWeapon( self.pers["weapon"] );
		self setViewModel( "viewhands_desert_opfor" );
	}
	else if(isDefined(self.pers["canvip"]))
	{
		if(self getstat(2714)==1)
			self.headicon = "headicon_admin";
			
		if(self.pers["characters"] == 1)
			self thread plugins\vip\_vip::vip_characters();
		
		if( self.pers["team"] == "allies" )
			self thread plugins\vip\_vip::vip_weapons();
		else if( self.pers["team"] == "axis" )
		{
			self iPrintln ("No Vip Weapons As Activator");
			self giveWeapon( self.pers["weapon"] );
			self setSpawnWeapon( self.pers["weapon"] );
			self giveMaxAmmo( self.pers["weapon"] );
			self setViewModel( "viewhands_desert_opfor" );
			self switchToWeapon( self.pers["weapon"] );
		}
	}
	
	self thread braxi\_teams::setHealth();
	self thread braxi\_teams::setSpeed();
	self thread afterFirstFrame();
	
	if( self braxi\_admin::hasPermission( "b" ) )
		self.headicon = "headicon_admin";

	self notify( "spawned_player" );
	level notify( "player_spawn", self );
}

afterFirstFrame()
{
	self endon( "disconnect" );
    self endon( "joined_spectators" );
    self endon( "death" );
	waittillframeend;
	wait 0.1;
	
	self setClientDvar( "drHideCompass", 1 );

	if( !self isPlaying() )
		return;

	if( game["state"] == "readyup" )
	{
		self linkTo( level.tempEntity );
		self disableWeapons();
	}
	else
	{
		self thread antiAFK();
	}

	if( self.pers["team"] == "allies" )
	{
	}
	else
	{
		self thread freeRunChoice();
		self thread MovingReward();
	}
	
	if( self getStat( 988 ) == 1 )
		self setClientDvar( "cg_thirdperson", 1 );


	// give special ability
	self clearPerks();
	self.pers["ability"] = level.abilityInfo[self getStat(982)]["codeName"];
	if( self.pers["ability"] != "specialty_null" && self.pers["ability"] != "" )
	{
		self setPerk( self.pers["ability"] );
		self thread showAbility();

		if( self.pers["ability"] == "specialty_armorvest"  )
		{
			self.maxhealth = self.health + int( self.health/10 );
			self.health = self.maxhealth;
		}
	}


	//self thread makeMeNotSolid();
	self thread watchItems();
	self thread playerTimer();
	self thread sprayLogo();
	self thread bunnyHoop();
	self thread watchDog();
	self thread NoAds();
	//self thread advancedJumping();
	
	if(isDefined(self.pers["canvip"]))
	{
		if( self.pers["team"] == "allies" )
		{
			self thread plugins\vip\_vip::vip_visions();
			self thread plugins\vip\_vip::vip_perks();
			self thread plugins\vip\_vip::admin_perks();
			self thread plugins\vip\_vip::admin_lifehack();
			self thread plugins\vip\_vip::vip_fun();
		}
	}
		
	//shop laser and thermal
	if(self getstat(1341)==1)
		self setClientDvar("cg_laserForceOn", 1);
	if(self getstat(1457) == 1 )
		self thread plugins\vip\vip_visions::Thermal();
}


watchDog()
{
    self endon( "disconnect" );
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "death" );

	if( !self.pers["isDog"] )
		return;

	iPrintln( self.name + " ^7is a Dog!" );
	self.isDog = false;
	while( self isReallyAlive() )
	{
		if( self isOnLadder() || self isMantling() )
		{
			self makeMeHuman();
		}
		else 
		{
			self makeMeDog();
		}

		if( self.isDog && self getCurrentWeapon() != "dog_mp" )
		{
			self.isDog = false;
			self makeMeDog();
		}

		wait 0.05;
	}
}


makeMeDog()
{
	if( self.isDog )
		return;

	self.isDog = true;

	self setModel( "german_sheperd_dog" );
	weapon = "dog_mp";
	self takeAllWeapons();
	self giveWeapon( weapon );
	self setSpawnWeapon( weapon );
	self switchToWeapon( weapon );
}

makeMeHuman()
{
	if( !self.isDog )
		return;

	self.isDog = false;

	self braxi\_teams::setPlayerModel();
	self setViewModel( "viewhands_desert_opfor" );
	self takeAllWeapons();
	self giveWeapon( self.pers["weapon"] );
	self setSpawnWeapon( self.pers["weapon"] );
	self giveMaxAmmo( self.pers["weapon"] );
	self switchToWeapon( self.pers["weapon"] );
}

makeMeNotSolid()
{
    self endon( "disconnect" );
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "death" );

	self setClientDvar( "g_playerCollisionEjectSpeed", 1 );
	while( self isReallyAlive() )
	{
		wait 0.05;
		self setContents( 0 );
	}
}


/*
preview( body )
{
	body.origin = self.origin + (0,0,24);
	while( isDefined( body ) )
	{
		body rotateYaw( 360, 4 );
		wait 4;
	}
}
*/

bunnyHoop()
{
    self endon( "disconnect" );
    self endon( "spawned_player" );
    self endon( "joined_spectators" );
    self endon( "death" );

    if( !level.dvar["bunnyhoop"] )
        return;

    while( game["state"] != "playing" )
		wait 0.05;
    
	// mnaauuu
    last = self.origin; 
    lastBH = 0;
    lastCount = 0;
    // ----- //

    while( isAlive( self ) )
    {        
		// mnaauuu
		dist = distance(self.origin, last);
        last = self.origin; 
        if ( dist > 450 && lastBH && lastCount > 5) 
		{
			if(self getStat( 764 ) == 1)
			{
				self iprintlnBold("^3STOP ^1GLITCHING ^6BITCH!");
				Iprintln("^3[Anti-LagJump]: ^1" +self.name+ " ^5tryed to ^1LagJump");
				num = self getEntityNumber();
				guid = self getGuid();
				logPrint( "LJ;" + guid + ";" + num + ";" + self.name + ";\n" );
				self iprintln("^3Lagjump? ^1DIE!");
				self suicide();
			}
        }    
        lastBH = self.doingBH;        
        wait 0.1;
        //self setClientDvar( "com_maxfps", 125 ); //  what is this for?
		// ----- //

        stance = self getStance();
        useButton = self useButtonPressed();
        onGround = self isOnGround();
        fraction = bulletTrace( self getEye(), self getEye() + vector_scale(anglesToForward(self.angles), 32 ), true, self )["fraction"];
        
        // Begin
        if( !self.doingBH && useButton && !onGround && fraction == 1 )
        {
            self setClientDvars( "bg_viewKickMax", 0, "bg_viewKickMin", 0, "bg_viewKickRandom", 0, "bg_viewKickScale", 0 );
            self.doingBH = true;
            lastCount = 0;
        }

        // Accelerate
        if( self.doingBH && useButton && onGround && stance != "prone" && fraction == 1 )
        {
            lastCount++;
            if( self.bh < 120 )
                self.bh += 30;
        }

        // Finish
        if( self.doingBH && !useButton || self.doingBH && stance == "prone" || self.doingBH && fraction < 1 )
        {
            self setClientDvars( "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
            self.doingBH = false;
            self.bh = 0;
            lastCount = 0;
            continue;
        }

        // Bounce
        if( self.bh && self.doingBH && onGround && fraction == 1 )
        {
            bounceFrom = (self.origin - vector_scale( anglesToForward( self.angles ), 50 )) - (0,0,42);
            bounceFrom = vectorNormalize( self.origin - bounceFrom );
            self bounce( bounceFrom, self.bh );
            self bounce( bounceFrom, self.bh );
            wait 0.1;
        }
    }
}


advancedJumping()
{
	// NOTE! This code is extremly EXPERIMENTAL AND GLITCHY
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	self endon( "death" );

	if( !isDefined( self.bh ) )
		self.bh = 0;

	wait 1;

	while( self isReallyAlive() )
	{
		while( self isOnGround() || self.bh ) // don't do that if we're not on the ground or we're bunny hooping
			wait 0.1;

		while( self.sessionstate == "playing" && !self isOnGround() && !self.bh )
		{	
			// @BUG: looks like player can jump forward abit longer
			//iprintln( "advanced jump: " + num );
			vec = ( self.origin + (0,0,-1) + vector_scale( anglesToForward( self.angles ), 9 ) );
			endPos = playerPhysicsTrace( self.origin, vec );
			self setOrigin( (endPos[0], endPos[1], self.origin[2] ) );
			wait 0.05;
		}
		wait 0.1; // delay before another advanced jump
	}
}

isAngleOk( angles, min, max )
{
	diff = distance( angles, self.angles );
	iprintln( "diff:" + diff );
	if( diff >= min && diff <= max )
		return true;
	return false;
}

sprayLogo()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	self endon( "death" );

	if( !level.dvar["sprays"] )
		return;

	while( game["state"] != "playing" )
		wait 0.05;

	while( self isReallyAlive() )
	{
		while( !self fragButtonPressed() )
			wait .2;

		if( !self isOnGround() )
		{
			wait 0.2;
			continue;
		}

		angles = self getPlayerAngles();
		eye = self getTagOrigin( "j_head" );
		forward = eye + vector_scale( anglesToForward( angles ), 70 );
		trace = bulletTrace( eye, forward, false, self );
		
		if( trace["fraction"] == 1 ) //we didnt hit the wall or floor
		{
			wait 0.1;
			continue;
		}

		position = trace["position"] - vector_scale( anglesToForward( angles ), -2 );
		angles = vectorToAngles( eye - position );
		forward = anglesToForward( angles );
		up = anglesToUp( angles );

		sprayNum = self getStat( 979 );


		if( isDefined( self.pers["customSpray"] ) )
			sprayNum = 25;

		if( sprayNum < 0 )	
			sprayNum = 0;
		else if( sprayNum > level.numSprays )
			sprayNum = level.numSprays;

		playFx( level.sprayInfo[sprayNum]["effect"], position, forward, up );
		self playSound( "sprayer" );

		self notify( "spray", sprayNum, position, forward, up ); // ch_sprayit

		wait level.dvar["sprays_delay"];
	}
}

endRound( reasonText, team )
{
	level endon ( "endmap" );

	if( game["state"] == "round ended" || !game["roundStarted"] )
		return;

	level notify( "round_ended", reasonText, team );
	level notify( "endround" );
	level notify( "kill logic" );
	
	ambientStop( 0 );
	
	if( isDefined( level.hud_time ) )
		level.hud_time destroy();

	game["state"] = "round ended";
	game["roundsplayed"]++;
	
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		if(players[i].ghost)
			players[i] suicide();
	}

	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		//players[i] setClientDvars( "cg_thirdperson", 1, "r_blur", 2.0, "show_hud", "false" );
		players[i] destroyLifeIcons();
	}
	thread partymode();

	if( team == "jumpers" )
	{
		visionSetNaked( "jumpers", 4 );
	}
	else
	{
		visionSetNaked( "activators", 4 );
		
		if( isDefined( level.activ ) && isPlayer( level.activ ) ) 
			level.activ braxi\_rank::giveRankXp( "activator" );
	}

	if( game["roundsplayed"] >= (level.dvar[ "round_limit" ]+1) )
	{
		level endMap( "Game has ended" );
		return;
	}
	else
	{
		//iPrintlnBold( reasonText );
		level thread endRoundAnnoucement( reasonText, (0,1,0) );
		if( level.dvar["roundSound"] )
		{
			song = (1+randomInt(10));
			ambientStop( 0 );
			listeners = getAllPlayers();
			for( i = 0; i < listeners.size; i++ )
			{
				listeners[i] stopLocalSound( "endmap" );
				listeners[i] stopLocalSound( "endmap1" );
			}
			level thread playSoundOnAllPlayers( "end_round_" + song );	
			hud = addTextHud( level, 5, 7, 1, "left", "middle", 1.4 );
			hud setText( "Now playing: ^2" + getDvar( "dr_song_" + song ) );
			//players[i] setClientDvar( "ui_songname", getDvar( "dr_song_" + song ) );
		}
	}

	wait 10;
	map_restart( true );
}

addTextHud( who, x, y, alpha, alignX, alignY, fontScale )
{
	if( isPlayer( who ) )
		hud = newClientHudElem( who );
	else
		hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;
	return hud;
}

endRoundAnnoucement( text, color )
{
	notifyData = spawnStruct();
	notifyData.titleText = text;
	notifyData.notifyText = ("Starting round ^3" + game["roundsplayed"] + "^7 out of ^3" + level.dvar["round_limit"] );
	//notifyData.iconName = "logo_brax";
	notifyData.glowColor = color;
	notifyData.duration = 8.8;

	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
		players[i] thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

spawnSpectator( origin, angles )
{
	if( !isDefined( origin ) )
		origin = (0,0,0);
	if( !isDefined( angles ) )
		angles = (0,0,0);

	self notify( "joined_spectators" );

	self thread cleanUp();
	resettimeout();
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.statusicon = "";
	self spawn( origin, angles );
	self braxi\_teams::setSpectatePermissions();

	level notify( "player_spectator", self );
}

cleanUp()
{
	self clearLowerMessage();
	self notify( "kill afk monitor" );
	self setClientDvars( "cg_thirdperson", 0, "cg_thirdpersonrange", 80, "r_blur", 0, "ui_healthbar", 1, "bg_viewKickMax", 90, "bg_viewKickMin", 5, "bg_viewKickRandom", 0.4, "bg_viewKickScale", 0.2 );
	self unLink();

	self.bh = 0; 
	self.doingBH = false;
	self enableWeapons();

	if( isDefined( self.hud_freeround ) )		self.hud_freeround destroy();
	if( isDefined( self.hud_freeround_time ) )	self.hud_freeround_time destroy();
	if( isDefined( self.hud_time ) )			self.hud_time destroy();
}

gameLogic()
{
	level endon( "endround" );
	level endon( "kill logic" );
	waittillframeend;
	

	level.allowSpawn = true;
	warning = false;

	visionSetNaked( "mpIntro", 0 );
	if( isDefined( level.matchStartText ) )
		level.matchStartText destroyElem();

	wait 0.2;

	level.matchStartText = createServerFontString( "objective", 1.5 );
	level.matchStartText setPoint( "CENTER", "CENTER", 0, -20 );
	level.matchStartText.sort = 1001;
	level.matchStartText setText( level.text["waiting_for_players"] );
	level.matchStartText.foreground = false;
	level.matchStartText.hidewheninmenu = true;
	

	if( level.freeRun )
		level.minplayers = 1;
		
	waitForPlayers( level.minplayers ); // wait for 2 players to start game
		
	roundStartTimer();
	
	if( !canStartRound( level.minplayers ) )
	{
		thread restartLogic(); // lets start all over again...
		return;
	}

	level notify( "round_started", game["roundsplayed"] );
	level notify( "game started" );
	game["state"] = "playing";
	game["roundStarted"] = true;

	visionSetNaked( level.mapName, 2.0 );
	thread FastestTimeRecord();
	thread FastestFailRecord();
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] isPlaying() )
		{
			players[i] unLink();
			players[i] enableWeapons();
			players[i] thread antiAFK();
		}
	}

	level.startTime = getTime();

	//thread roundDelay();

	if( level.freeRun )
	{
		level.hud_time setTimer( level.dvar["freerun_time"] );
		thread freeRunTimer();
		//iPrintlnBold( "^1>> ^2Free Run ^1<<" );

		thread drawInformation( 800, 0.8, 1, "FREE RUN" );
		thread drawInformation( 800, 0.8, -1, "FREE RUN" );
		return; //no logic in free run
	}
	else
	{
		level thread restrictSpawnAfterTime( level.dvar["spawn_time"] );
		level thread checkTimeLimit();

		level.hud_jumpers fadeOverTime( 2 );
		level.hud_jumpers.alpha = 1;
	}

	startJumpers = undefined;
	while( game["state"] == "playing" )
	{
		wait 0.2;

		level.jumper = [];
		level.jumpers = 0;
		level.activators = 0;
		level.totalPlayers = 0;
		level.totalPlayingPlayers = 0;

		players = getAllPlayers();
		if(players.size > 0)
		{
			for(i = 0; i < players.size; i++)
			{
				level.totalPlayers++;

				if( isDefined( players[i].pers["team"] ) )	
				{
					if( players[i] isReallyAlive() )
						level.totalPlayingPlayers++;

					if(players[i].pers["team"] == "allies" && players[i] isReallyAlive() && !players[i].ghost ) //ghostpart
					{
						level.jumpers++;
						level.jumper[level.jumper.size] = players[i];
					}
					if(players[i].pers["team"] == "axis" && players[i] isReallyAlive() )
						level.activators++;
				}
			}		
			
			if( !isDefined( startJumpers ) )
				startJumpers = level.jumpers;

			if( startJumpers >= 3 /*+1 cuz one is acti*/ && level.jumpers == 1 && !level.freeRun )
				level.jumper[0] thread lastJumper();

			if( level.jumpers > 1 && !level.activators && !level.activatorKilled && !level.freeRun )
			{
				if(!players[i].ghost )
				{
					if( !level.dvar["pickingsystem"] )
						pickRandomActivator();
					else
						NewPickingSystem();
					continue;
				}
			}

			//if( level.activators >= 2 && !warning )
			//{
			//	warning( "level.activators >= 2 - report this to BraXi at www.braxi.org" );
			//	warning( "level.activators = " + level.activators );
			//	warning = true;
			//}

			if( !level.jumpers && level.activators )
				thread endRound( "Jumpers died", "activators" );
			else if( !level.freeRun && !level.activators && level.jumpers )
				thread endRound( "Activator died", "jumpers" );
			else if( !level.activators && !level.jumpers )
				thread endRound( "Everyone died", "activators" );
		}
	}
}

FastestTimeRecord()
{
	mapname = getDvar("mapname");
	which = "recordtime_"+mapname;
	if(getDvar( which ) == "")
		setDvar( which, 300 );
	
	level.time = 0;
	wait 1;
	for(;;)
	{
		level.time++;
		if( getDvar("actitot") == "1" )
		{	
			setDvar("actitot", "0");
			recordtime = getDvarInt( which );
			level.activatoristtot = false;
			if( level.time <= recordtime )
			{
				setDvar( which, level.time );
				thread madebyduff2( 800, 0.8, 1, "!!! New time record !!!" );
				thread madebyduff2( 800, 0.8, -1, "!!! New time record !!!" );
				logPrint( "TIMERECORD "+ mapname +": set " + which + " " + level.time + "\n" );	
			}
			break;
		}
		wait 1;
	}
}

FastestFailRecord()
{
	mapname = getDvar("mapname");
	which = "acti_recordtime_"+mapname;
	if(getDvar( which ) == "")
		setDvar( which, 300 );
	
	wait 1;
	for(;;)
	{
		if( getDvar("jumpertot") == "1" )
		{	
			setDvar("jumpertot", "0");
			recordtime = getDvarInt( which );
			if( level.time <= recordtime )
			{
				setDvar( which, level.time );
				thread madebyduff2( 800, 0.8, 1, "!!! New time record !!!" );
				thread madebyduff2( 800, 0.8, -1, "!!! New time record !!!" );
			}
			break;
		}
		wait 1;
	}
}

roundDelay()
{
	if( !level.freeRun )
	{
		level waittill( "activator" );
		//wait 1;
	}

	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] isPlaying() )
		{
			players[i] unLink();
			players[i] enableWeapons();
			players[i] thread antiAFK();
		}
	}
}

pickRandomActivator()
{
	level notify( "picking activator" );
	level endon( "picking activator" );

	if( game["state"] != "playing" || level.activatorKilled || level.activators )
		return;

	players = getAllPlayers();
	if( !isDefined( players ) || isDefined( players ) && !players.size )
		return;

	num = randomInt( players.size );
	guy = players[num];

	if( level.dvar["dont_make_peoples_angry"] == 1 && guy getEntityNumber() == getDvarInt( "last_picked_player" ) )
	{	
		if( isDefined( players[num-1] ) && isPlayer( players[num-1] ) )
			guy = players[num-1];
		else if( isDefined( players[num+1] ) && isPlayer( players[num+1] ) )
			guy = players[num+1];
	}
	
	if( !isDefined( guy ) && !isPlayer( guy ) || level.dvar["dont_pick_spec"] && guy.sessionstate == "spectator" )
	{
		level thread pickRandomActivator();
		return;
	}

	if( getDvar( "nextacti" ) != "" )
	{
		guy = braxi\_admin::getPlayerByName( getDvar( "nextacti" ) );
		setDvar( "nextacti", "" );
		if( !isDefined( guy ) )
		{
			thread pickRandomActivator();
			return;
		}
	}

	bxLogPrint( ("A: " + guy.name + " ; guid: " + guy.guid) );
	iPrintlnBold( guy.name + "^2 was picked to be ^1Activator^2." );
		
	guy thread braxi\_teams::setTeam( "axis" );
	guy spawnPlayer();
	guy braxi\_rank::giveRankXp( "activator" );
		
	setDvar( "last_picked_player", guy getEntityNumber() );
	level notify( "activator", guy );
	level.activ = guy;
	wait 0.1;
}

checkTimeLimit()
{
	level endon( "endround" );
	level endon( "game over" );

	if( !level.dvar["time_limit"] )
		return;

	time = 60 * level.dvar["time_limit"];	
	level.hud_time setTimer( time );
	wait time;	
	level thread endRound( "Time limit reached", "activators" );
}

endMap( winningteam )
{
	game["state"] = "endmap";
	level notify( "intermission" );
	level notify( "game over" );
	ambientStop( 0 );
	
	if( isDefined( level.hud_jumpers ) )
	{
		//level.hud_jumpers destroy();
		level.hud_jumpers fadeOverTime( .5 );
		level.hud_jumpers.alpha = 0;
	}
	if( isDefined( level.hud_round ) )
	{
		//level.hud_round destroy();
		level.hud_round fadeOverTime( .5 );
		level.hud_round.alpha = 0;
	}

	if( isDefined( level.hud_aboveliveshader) )
	{
		//level.hud_aboveliveshaderdestroy();
		level.hud_aboveliveshader fadeOverTime( .5 );
		level.hud_aboveliveshader.alpha = 0;
	}
	if( isDefined( level.hud_time ) )
	{
		//level.hud_time destroy();
		level.hud_time fadeOverTime( .5 );
		level.hud_time.alpha = 0;
	}
	
	if( isDefined( self.usevip ) )
		self.usevip thread duffman\_common::FadeOut(1);
	if( isDefined( self.hud_health ) )
		self.hud_health thread duffman\_common::FadeOut(1);
	if( isDefined( self.points ) )
		self.points thread duffman\_common::FadeOut(1);
	
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		if(players[i].ghost)
			players[i] suicide();
	}
	
	ambientStop( 0 );
    listeners = getAllPlayers();
   	for( i = 0; i < listeners.size; i++ )
	{
		listeners[i] stopLocalSound( "endmap" );
		listeners[i] stopLocalSound( "endmap1" );
	}
	
	level thread playSoundOnAllPlayers( "end_map" );
	
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] closeMenu();
		players[i] closeInGameMenu();
		players[i] freezeControls( true );
		players[i] cleanUp();
		players[i] destroyLifeIcons();
	}
	wait .06;

	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
		players[i] allowSpectateTeam( "allies", false );
		players[i] allowSpectateTeam( "axis", false );
		players[i] allowSpectateTeam( "freelook", false );
		players[i] allowSpectateTeam( "none", true );
	}

	if( level.dvar["displayBestPlayers"] )
		braxi\_scoreboard::showBestStats();
		
	saveMapScores();
	saveAllScores();

	wait 0.6;

	teddysOrigin = level.spawn["spectator"].origin + vector_scale( anglesToForward( level.spawn["spectator"].angles ), 120 ) + vector_scale( anglesToUp( level.spawn["spectator"].angles ), 180 );
	//playFx( level.fx["falling_teddys"], teddysOrigin );
	//playFx( level.fx["falling_teddys"], level.spawn["spectator"].origin + (0,0,100) );
	
	duffman\_mapvote::init();
	
	players = getAllPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
		players[i].sessionstate = "intermission";
	}
	wait 5;
		
	exitLevel( false );
}

respawn()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );

	if( level.freeRun || !game["roundStarted"] )
	{
		wait 0.1;
		self spawnPlayer();
		return;
	}

	if( self.pers["lifes"] && self.pers["team"] == "allies" )
	{
		wait 0.5;

		if( game["state"] != "playing" )
			return;
		self setLowerMessage( &"PLATFORM_PRESS_TO_SPAWN" , 5);
		
		for(i=0;i<100;i++)
		{
			if(self useButtonPressed())
			{
				if( game["state"] != "playing" )
					return;
				
				self clearLowerMessage();

				self thread useLife();
				return;
			}
			wait .05;
		}
		wait 1;
		if(self.pers["team"] == "allies")
		{
			self clearLowerMessage();
			self thread canGhostrun();
		}
	}
	else
	{
		if(self.pers["team"] == "allies")
		{
			wait 1;
			self clearLowerMessage();
			self thread canGhostrun();
		}
	}
}

antiAFK()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	self endon( "kill afk monitor" );

	if( !level.dvar["afk"] || self.pers["team"] == "axis" )
		return;
		

	time = 0;
	oldOrigin = self.origin - (0,0,50);
	while( isAlive( self ) )
	{
		wait 0.2;
		if( distance(oldOrigin, self.origin) <= 10 )
			time++;
		else
			time = 0;

		if( time == (level.dvar["afk_warn"]*5) )
		{
			if( level.dvar["afk_method"] )
				self iPrintlnBold( "You will be kicked from server due to AFK if you don't move" );
			else
				self iPrintlnBold( "Move or you will be killed due to AFK" );
		}

		if( time == (level.dvar["afk_time"]*5) )
		{
			if( level.dvar["afk_method"] )
			{
				iPrintln( self.name + " was kicked from server due to AFK." );
				self clientCmd( "disconnect" );
				//kick( self getEntityNumber() );
				self thread kickAfterTime( 2 );
			}
			else
			{
				iPrintln( self.name + " was killed due to AFK." );
				self suicide();
			}
			break;
		}
		oldOrigin = self.origin;
	}
}

kickAfterTime( time )
{
	self endon( "disconnect" );
	wait time;

	if( isDefined( self ) )
		kick( self getEntityNumber() );
}

roundStartTimer()
{	
	if( isDefined( level.matchStartText ) )
		level.matchStartText destroyElem();
		
	level.instrattime = true;
	level thread plugins\_clock::init();
		
	blackscreen  = level duffman\_common::addBlackScreen(1,999);
    blackscreen2 = level duffman\_common::addBlackScreen(1,999);
    blackscreen thread duffman\_common::fadeOut(.8);
    blackscreen2 thread duffman\_common::fadeOut(.8);
	wait .9;
	
	/*
	level.matchStartText = createServerFontString( "objective", 1.5 );
	level.matchStartText setPoint( "CENTER", "CENTER", 0, -20 );
	level.matchStartText.sort = 1001;
	level.matchStartText setText( level.text["round_begins_in"] );
	level.matchStartText.foreground = false;
	level.matchStartText level.randomcolour;
	level.matchStartText.hidewheninmenu = true;
	
	level.matchStartTimer = createServerTimer( "objective", 1.4 );
	level.matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	level.matchStartTimer setTimer( level.dvar["spawn_time"] );
	level.matchStartTimer.sort = 1001;
	level.matchStartTimer level.randomcolour;
	level.matchStartTimer.foreground = false;
	level.matchStartTimer.hideWhenInMenu = true;
		
	wait level.dvar["spawn_time"];
	
	level.matchStartText destroyElem();
	level.matchStartTimer destroyElem();
	*/
	level.hud_starttimer = CreateNewHud(-600,30,"center","middle",400,2.5,"objective",1,1);
	level.hud_starttimer.color = (1,1,1);
	level.hud_starttimer.glowColor = level.randomcolour;
	level.hud_starttimer setText("3");
	level.hud_starttimer1 = CreateNewHud(-600,30,"center","middle",400,2.5,"objective",1,1);
	level.hud_starttimer1.color = (1,1,1);
	level.hud_starttimer1.glowColor = level.randomcolour;
	level.hud_starttimer1 setText("2");
	level.hud_starttimer2 = CreateNewHud(-600,30,"center","middle",400,2.5,"objective",1,1);
	level.hud_starttimer2.color = (1,1,1);
	level.hud_starttimer2.glowColor = level.randomcolour;
	level.hud_starttimer2 setText("1");
	level.hud_starttimer3 = CreateNewHud(-600,30,"center","middle",400,3,"objective",1,1);
	level.hud_starttimer3.color = (1,1,1);
	level.hud_starttimer3.glowColor = level.randomcolour;
	level.hud_starttimer3 setText("Go Go Go!!!");
	
	level.hud_starttimer thread StartMoveTimer(-600,1,1,1000,0,2);
	wait 1;
	level.hud_starttimer1 thread StartMoveTimer(-600,1,1,1000,0,2);
	wait 1;
	level.hud_starttimer2 thread StartMoveTimer(-600,1,1,1000,0,2);
	wait 3.8;
	level.hud_starttimer3 thread StartMoveTimer1(1000,0.5);
	wait 1;
	level notify("clock_over");
	level.instrattime = false;
}
StartMoveTimer(x,secondmovetime,thirdmovetime,newx,middlex,middlemovetime)
{
	self moveOverTime(secondmovetime);
	self.x = -125;
	wait( secondmovetime + 0.2);
	self moveOverTime(middlemovetime);
	self.x = middlex;
	wait( middlemovetime +0.2);
	self moveOverTime(thirdmovetime);
	self.x = newx;
	wait( thirdmovetime +0.2);
	self destroy();
}
StartMoveTimer1(newx,time)
{
	self moveOverTime(time);
	self.x = 0;
	wait( time + 0.2);
	self moveOverTime(time+1);
	self.x = newx;
	wait( time +0.2);
	self destroy();
}
CreateNewHud(x,y,alignx,aligny,sort,scale,font,glowalpha,alpha)
{
	hud = newHudElem();
	hud.y = y;
	hud.x = x;
	hud.alignX = alignx;
	hud.alignY = alignY;
	hud.horzAlign = alignx;
	hud.vertAlign = alignY;
	hud.sort = sort;
	hud.fontScale = scale;
	hud.alpha = 0;
	hud fadeOverTime(2);
	hud.alpha = alpha;
	hud.font = font;
	hud.glowAlpha = glowalpha;
	return hud;
}



doHud()
{
	level endon( "intermission" );
	
	level.hud_round = newHudElem();
	level.hud_round.foreground = true;
	level.hud_round.alignX = "right";
	level.hud_round.alignY = "top";
	level.hud_round.horzAlign = "right";
	level.hud_round.vertAlign = "top";
	level.hud_round.x = 0;
	level.hud_round.y = 20 + level.hudYOffset;
	level.hud_round.sort = 0;
	level.hud_round.fontScale = 1.8;
	level.hud_round.color = (1, 1, 1);
	level.hud_round.font = "objective";
	level.hud_round.glowColor = level.randomcolour;
	level.hud_round.glowAlpha = 1;
	level.hud_round.hidewheninmenu = false;
	if( level.freeRun )
		level.hud_round setText("Free Run" );
	else
		level.hud_round setText("Round:"+ game["roundsplayed"] + "/" + level.dvar["round_limit"] );

	level.hud_time = newHudElem();
	level.hud_time.foreground = true;
	level.hud_time.alignX = "right";
	level.hud_time.alignY = "top";
	level.hud_time.horzAlign = "right";
	level.hud_time.vertAlign = "top";
	level.hud_time.x = 0;
	level.hud_time.y = 40 + level.hudYOffset;
	level.hud_time.sort = 0;
	level.hud_time.fontScale = 1.8;
	level.hud_time.color = (1, 1, 1);
	level.hud_time.font = "objective";
	level.hud_time.glowColor = level.randomcolour;
	level.hud_time.glowAlpha = 1;
	level.hud_time.label = &"Time Left:";
	level.hud_time.hidewheninmenu = false;
	
	if( level.freeRun )
		return;
		
	level.hud_aboveliveshader = newHudElem();
	level.hud_aboveliveshader.y = 80 + level.hudYOffset;
	level.hud_aboveliveshader.alignX = "right";
	level.hud_aboveliveshader.alignY = "top";
	level.hud_aboveliveshader.horzAlign = "right";
	level.hud_aboveliveshader.vertAlign = "top";
	level.hud_aboveliveshader.x = 0;
	level.hud_aboveliveshader.y = 80 + level.hudYOffset;
	level.hud_aboveliveshader.sort = 0;
	level.hud_aboveliveshader.fontScale = 1.8;
	level.hud_aboveliveshader.font = "objective";
	level.hud_aboveliveshader.glowColor = level.randomcolour;
	level.hud_aboveliveshader.glowAlpha = 1;
	level.hud_aboveliveshader.alpha = 1;
	level.hud_aboveliveshader.hidewheninmenu = false;
	level.hud_aboveliveshader setText("Lives:");
		
	level.hud_jumpers = newHudElem();
	level.hud_jumpers.foreground = true;
	level.hud_jumpers.alignX = "right";
	level.hud_jumpers.alignY = "top";
	level.hud_jumpers.horzAlign = "right";
	level.hud_jumpers.vertAlign = "top";
	level.hud_jumpers.x = -3;
	level.hud_jumpers.y = 60 + level.hudYOffset;
	level.hud_jumpers.sort = 0;
	level.hud_jumpers.fontScale = 1.8;
	level.hud_jumpers.color = (1, 1.0, 1);
	level.hud_jumpers.font = "objective";
	level.hud_jumpers.glowColor = level.randomcolour;
	level.hud_jumpers.glowAlpha = 1;
	level.hud_jumpers.label = level.text["jumpers_count"];
	level.hud_jumpers.hidewheninmenu = false;

	while( 1 )
	{
		
		time = getDvar("time");
		jumpers = level.jumpers;
		if( !level.freeRun )
		{
			level.hud_jumpers setValue( level.jumpers );
			wait .05;
			while(time == getDvar("time") && jumpers == level.jumpers)
				wait .05;
		}
		else
			while(time == getDvar("time"))
				wait .05;
	}
}

updateHealthBar()
{
	self endon("disconnect");
	wait 0.1;
	self setClientDvar( "ui_healthbar", 1 );
	while( 1 )
	{
		self waittill ( "damage", amount );
		delta = ( self.health / self.maxhealth );
		if( delta > 1 )
			delta = 1;
		self setClientDvar( "ui_healthbar", delta+0.005 );
	}
}


freeRunChoice()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	self endon( "death" );

	if( !level.dvar["freeRunChoice"] || level.trapsDisabled )
		return;

	self.hud_freeround = newClientHudElem( self );
	self.hud_freeround.elemType = "font";
	self.hud_freeround.x = 320;
	self.hud_freeround.y = 370;
	self.hud_freeround.alignX = "center";
	self.hud_freeround.alignY = "middle";
	self.hud_freeround.alpha = 1;
	self.hud_freeround.font = "default";
	self.hud_freeround.fontScale = 1.8;
	self.hud_freeround.sort = 0;
	self.hud_freeround.foreground = true;
	self.hud_freeround.label = level.text["call_freeround"];

	self.hud_freeround_time = newClientHudElem( self );
	self.hud_freeround_time.elemType = "font";
	self.hud_freeround_time.x = 320;
	self.hud_freeround_time.y = 390;
	self.hud_freeround_time.alignX = "center";
	self.hud_freeround_time.alignY = "middle";
	self.hud_freeround_time.alpha = 1;
	self.hud_freeround_time.font = "default";
	self.hud_freeround_time.fontScale = 1.8;
	self.hud_freeround_time.sort = 0;
	self.hud_freeround_time.foreground = true;
	self.hud_freeround_time setTimer( level.dvar["freeRunChoiceTime"] );

	wait 1;
	freeRun = false;
	for( i = 0; i < 10*level.dvar["freeRunChoiceTime"]; i++ ) // time to switch into free run
	{
		if( !level.canCallFreeRun )
		{
			self.hud_freeround destroy();
			self.hud_freeround_time destroy();
			return;
		}
		if( self attackButtonPressed() )
		{
			freeRun = true;
			level endon( "kill_free_run_choice" );
			break;
		}
		wait 0.1;
	}
	level endon( "kill_free_run_choice" );


	if( isDefined( self.hud_freeround ) )
		self.hud_freeround destroy();
	if( isDefined( self.hud_freeround_time ) )
		self.hud_freeround_time destroy();

	if( freeRun )
	{
		thread drawInformation( 800, 0.8, 1, "FREE RUN" );
		thread drawInformation( 800, 0.8, -1, "FREE RUN" );

		level disableTraps();
			
		players = getAllPlayers();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] isPlaying() )
			{
				players[i] takeAllWeapons();
				weapon = "knife_mp";
				players[i] giveWeapon( weapon );
				players[i] giveMaxAmmo( weapon );
				players[i] switchToWeapon( weapon );
			}
		}
		level notify( "round_freerun" );
	}
}

disableTraps()
{
	level.trapsDisabled = true;
	for( i = 0; i < level.trapTriggers.size; i++ )
		if( isDefined( level.trapTriggers[i] ) )
			level.trapTriggers[i].origin = level.trapTriggers[i].origin - (0,0,10000);
	level notify( "traps_disabled" ); //for mappers
}

serverMessages()
{
	rules = strTok(getDvar("dr_messages"), ";");
	rule = [];
	time = randomInt(30);
	wait time;
	wait 20;
	intro = addTextHud( level, 320, 10, 0, "center", "middle", 2 );		
	intro SetText(rules[0]);
	intro FadeOverTime(1);
	intro.alpha = 1;
	wait 1.5;
	intro FadeOverTime(1.9);
	intro.alpha = 0;
	for(i=1;i<rules.size;i++)
	{
		rule[i] = addTextHud( level, 940, 10, 1, "center", "middle", 1.6 );		
		rule[i] SetText(rules[i]);
		rule[i] MoveTo(1.6,620);
		wait 1.65;
		if(isDefined(rule[i-1]))
			rule[i-1] destroy();
		rule[i] MoveTo(4,20);
		wait 4;
		rule[i] MoveTo(1.5,-400);			
	}
	
	if(isdefined(intro))
		intro destroy();	
	if(isDefined(rule[rules.size]))
		rule[rules.size] destroy();		
}

MoveTo(time,x,y)
{
    self moveOverTime(time);
    if(isDefined(x))
        self.x = x;
       
    if(isDefined(y))
        self.y = y;
}


isWallKnifing( attacker, victim )
{
	start = attacker getEye();
	end = victim getEye();

	if( bulletTracePassed( start, end, false, attacker ) == 1 )
	{
		return false;
	}
	return true;
}

NewPickingSystem()
{
//
// How it works:
// 1. Build array of players that have lowest number of being activator (starting from 0)
// 2. Check if we got some players in array
//		a) If array size is -1 increase startValue and go back to step 1
//		b) Array size is okey lets go to step 3
// 3. Now pick random player from array to be Activator
//

	level notify( "picking activator" );
	level endon( "picking activator" );

	if( game["state"] != "playing" || level.activatorKilled || level.activators )
		return;

	players = undefined;
	if( level.dvar["dont_pick_spec"] )
		players = getTeamPlayers( "allies" );
	else
		players = getAllPlayers();

	if( !isDefined( players ) || !players.size )
		return;

	p = [];
	best = 99;
	player = undefined;
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["activator"] <= best )
			best = players[i].pers["activator"];
	}
	for(i=0;i<players.size;i++)
	{
		if( players[i].pers["activator"] == best )
			p[p.size] = players[i];
	}
	if( !isDefined( p ) || !p.size )
		return;

	if( p.size == 1 )
		player = p[0];

	while( p.size > 1 )
	{
		wait 0.05;
		random = p[RandomInt(p.size)];
		if( getDvarInt( "last_picked_player" ) == random getEntityNumber() )
			continue;
		player = random;
		break;
	}

	//=================================================================================\\

	/*players = getAllPlayers();
	if( !isDefined( players ) || isDefined( players ) && !players.size )
		return;

	startValue = 0;
	goodPlayers = [];

	while( 1 )
	{
		allPlayers = getAllPlayers();
		for( i = 0; i < allPlayers.size; i++ )
		{
			if( level.dvar["dont_pick_spec"] && allPlayers[i].sessionstate == "spectator" )
			{
				i++;
				continue;
			}
			if ( allPlayers[i].pers["activator"] == startValue )
				goodPlayers[goodPlayers.size] = allPlayers[i];
			i++;
		}

		if( !goodPlayers.size )
		{
			startValue++;
			if( players.size >= 15 )
				wait 0.05; // dont want 'infinite loop' error here
			continue;
		}
		break;
	}*/

	bxLogPrint( ("A: " + player.name + " ; guid: " + player.guid) );
	iPrintlnBold( "^1>> ^2" + player.name + " was picked to be ^1Activator" );
	
	player.pers["activator"]++;
	player braxi\_teams::setTeam( "axis" );
	player spawnPlayer();
	player braxi\_rank::giveRankXp( "activator" );
	
	setDvar( "last_picked_player", player getEntityNumber() );

	level notify( "activator", player );
	level.activ = player;
	wait 0.1;
}

new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}


drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 90 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	hud destroy();
}

SetupLives()
{
	self endon( "disconnect" );

	if( !level.dvar["allowLifes"] )
		return;

	self.hud_lifes = []; // hud elems array
	
	self addLifeIcon( 0, -2, 102, -35, 10 );
	self addLifeIcon( 1, -2, 102, -35, 10 );
	self addLifeIcon( 2, -2, 102, -35, 10 );

	wait .05;
	
	if( !self.pers["lifes"] )
		return;

	for( i = 0; i != self.pers["lifes"]; i++ )
	{
		self.hud_lifes[i] showLifeIcon();
	}
}

addLifeIcon( num, x, y, offset, sort )
{
	if( !level.freeRun )
	{
		hud = newClientHudElem( self );
		hud.foreground = true;
		hud.x = x + num * offset;
		hud.y = y + level.hudYOffset;
		hud setShader( "hud_vip_hart", 30, 30 );
		hud.alignX = "right";
		hud.alignY = "top";
		hud.horzAlign = "right";
		hud.vertAlign = "top";
		hud.sort = sort;
		hud.color = level.color_cool_green;
		hud.glowColor = level.color_cool_green_glow;
		hud.glowAlpha = 0;
		hud.alpha = 0;
		hud.hidewheninmenu = false;
		self.hud_lifes[num] = hud;
	}
}

giveLife()
{
	if( !level.dvar["allowLifes"] )
		return;

	if( self.pers["lifes"] >= 3 )
		return; 

	self.pers["lifes"]++;

	// hud stuff;
	hud = self.hud_lifes[ self.pers["lifes"]-1 ];
	hud showLifeIcon();

	hud SetPulseFX( 30, 100000, 700 );
	//self iprintlnBold( "You earned additional life" );
}

showLifeIcon()
{
	self fadeOverTime( 1 );
	self.alpha = 1;
	self.glowAlpha = 1;
	self.color = level.color_cool_green;
}

useLife()
{
	if( !self.pers["lifes"] || self.sessionstate == "playing" || !level.dvar["allowLifes"] )
		return; 

	hud = self.hud_lifes[ self.pers["lifes"]-1 ];
	hud fadeOverTime( 1 );
	hud.alpha = 0;
	hud.glowAlpha = 0;
	//hud.color = level.color_cool_green;

	self.pers["lifes"]--;

	if( !self.pers["lifes"] )
		self iPrintlnBold( "This was your last life, don't waste it" );
	else
		self iprintlnBold( "You used one of your additional lifes" );

	if( level.dvar["insertion"] && isDefined( self.insertion ) )
	{
		self spawnPlayer( self.insertion.origin, (0,self.insertion.angles[1],0) );
	}
	else
		self spawnPlayer();

	self.usedLife = true;
}

destroyLifeIcons()
{
	if( !isDefined( self.hud_lifes ) )
		return;
	for( i = 0; i < self.hud_lifes.size; i++ )
		if( isDefined( self.hud_lifes[i] ) )
			self.hud_lifes[i] destroy();
}

gib_splat()
{
	//self hide();
	self playSound( "gib_splat" );
	playFx( level.fx["gib_splat"], self.origin + (0,0,20) );
	self delete();
}


fastestTime()
{
	trig = getEntArray( "endmap_trig", "targetname" );
	if( !trig.size || trig.size > 1 )
		return;

	level.mapHasTimeTrigger = true;

	trig = trig[0];
	while( 1 )
	{
		trig waittill( "trigger", user );

		if( user isReallyAlive() && user.pers["team"] == "allies" )
		{
			if(user.ghost)
			{
				user suicide(); //ghostpart
				user iPrintlnBold( "Ghost Mode Auto Kill" );
			}
			else
				user thread endTimer();
		}
	}
}



endTimer()
{
	if( isDefined( self.finishedMap ) )
		return;

	self.finishedMap = true;

	time = (getTime() - self.timerStartTime) / 1000;

	self.hud_time destroy();
	self.hud_time = addTextHud( self, 9, -33, 1, "left", "bottom", 1.6 );
	self.hud_time.horzAlign = "left";
    self.hud_time.vertAlign = "bottom";
	self.hud_time.glowAlpha = 1;
	self.hud_time.glowColor = (0.4,0.5,0);

	//self.hud_time reset();
	self.hud_time setText( "Your Time: ^2" + time );

	self iPrintlnBold( "You've finished map in ^2" + time + " ^7seconds" );

	if( time < self.pers["time"] )
		self.pers["time"] = time;
}

playerTimer()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	self endon( "joined_spectators" );
	self endon( "death" );
	
	if( isDefined( level.freeRun ) && level.freeRun )
		return;

	if( !level.mapHasTimeTrigger || isDefined( self.finishedMap ) || self.pers["team"] == "axis" )
		return;

	self.hud_time = addTextHud( self, 9, -33, 1, "left", "bottom", 1.6 );
	self.hud_time.hidewheninmenu = true;
	self.hud_time.horzAlign = "left";
    self.hud_time.vertAlign = "bottom";
	self.hud_time.glowAlpha = 1;
	self.hud_time.glowColor = level.randomcolour;
	self.hud_time.label = &"Your Time: ^3&&1";
	self.hud_time settext("0:00.0");	
		
	while( game["state"] != "playing"  )
		wait 0.05;

	if(isdefined(self.hud_time))
		self.hud_time destroy();
			
	self.hud_time = addTextHud( self, 9, -33, 1, "left", "bottom", 1.6 );
	self.hud_time.hidewheninmenu = true;
	self.hud_time.horzAlign = "left";
    self.hud_time.vertAlign = "bottom";
	self.hud_time.glowAlpha = 1;
	self.hud_time.glowColor = level.randomcolour;
	self.hud_time.label = &"Your Time: ^3&&1";
	self.hud_time setTenthsTimerUp( 1 );

	self.timerStartTime = getTime();
}

initScoresStat( num, name )
{
	//level.bestScores[name] = spawnStruct();
	level.bestScores[num]["name"] = name;
	level.bestScores[num]["value"] = 0;
	level.bestScores[num]["player"] = " ";
	level.bestScores[num]["guid"] = "123";
}

bestMapScores()
{
	level.statDvar = ("dr_info_" + level.mapName);
	level.bestScores = [];

	//initScoresStat( "time" );
	initScoresStat( 0, "kills" );
	initScoresStat( 1, "deaths" );
	initScoresStat( 2, "headshots" );
	initScoresStat( 3, "score" );
	initScoresStat( 4, "knifes" );
	initScoresStat( 5, "time" );

	addDvar( "best_scores", level.statDvar, "", "", "", "string" );
	
	data = strTok( level.dvar["best_scores"], ";" );
	if( !data.size ) return;

	for( i = 0; i < data.size; i++ )
	{
		stat = strTok( data[i], "," );
		//if( !stat.size ) continue;
		if( !isDefined( stat[0] ) || !isDefined( stat[1] ) || !isDefined( stat[2] ) || !isDefined( stat[3] ) )
		{
			iprintln( "Error reading " + level.statDvar + " (" + i + "), stat size is " + stat.size );
			continue;
		}
		for( x = 0; x < level.bestScores.size; x++ )
		{
			if( level.bestScores[x]["name"] == stat[0] )
			{
				level.bestScores[x]["value"] = stat[1];
				level.bestScores[x]["guid"] = stat[2];
				level.bestScores[x]["player"] = stat[3];
				//iprintln( "stat " + stat[0] );
			}
		}
	}

	logPrint( "COPY TO CFG: set dr_info_"+level.mapName+" \""+level.dvar["best_scores"]+"\"\n" );
}


appendToDvar( dvar, string )
{
	setDvar( dvar, getDvar( dvar ) + string );
}

saveMapScores()
{
	setDvar( level.statDvar, "" );
	for( i = 0; i < level.bestScores.size; i++ )
	{
		var = ";" + level.bestScores[i]["name"] + "," + level.bestScores[i]["value"];
		var = var + "," + level.bestScores[i]["guid"];
		var = var + "," + level.bestScores[i]["player"];

		appendToDvar( level.statDvar, var );
		level.dvar["best_scores"] = getDvar( level.statDvar );
		//iprintln( var );
	}
	logPrint( "MAP_STATS: set dr_info_"+level.mapName+" \""+level.dvar["best_scores"]+"\"\n" );
}

saveAllScores()
{
	logPrint( "===== BEGIN SCORES =====\n");
	for( i = 0; i < game["playedmaps"].size; i++ )
	{
		logPrint( "set dr_info_" + game["playedmaps"][i] + " \"" + getDvar( "dr_info_"+game["playedmaps"][i] )  + "\"\n" );
	}
	logPrint( "===== END SCORES =====\n");
}

statToString( stat )
{
	name = "unknown";
	switch( stat )
	{
	case "kills":
		name = "Kills";
		break;
	case "deaths":
		name = "Deaths";
		break;
	case "headshots":
		name = "Head Shots";
		break;
	case "score":
		name = "Score";
		break;
	case "knifes":
		name = "Melee Kills";
		break;
	case "time":
		name = "Fastest Time";
		break;
	}
	return name;
}

updateRecord( num, player )
{
	level.bestScores[num]["value"] = player.pers[level.bestScores[num]["name"]];
	level.bestScores[num]["player"] = player.name;
	level.bestScores[num]["guid"] = player getGuid();

	if( level.bestScores[num]["player"] == "" )
		level.bestScores[num]["player"] = " ";

	if( level.bestScores[num]["guid"] == "" )
		level.bestScores[num]["guid"] = "123";
}


firstBlood()
{
	if( !level.dvar["firstBlood"] )
		return;

	level waittill( "activator" );
	wait 0.1;

	level waittill( "player_killed", who );
	level thread playSoundOnAllPlayers( "first_blood" );

	hud = addTextHud( level, 320, 220, 0, "center", "middle", 2.4 );
	hud setText( "First victim of this round is " + who.name );

	hud.glowColor = (0.7,0,0);
	hud.glowAlpha = 1;
	hud SetPulseFX( 30, 100000, 700 );

	hud fadeOverTime( 0.5 );
	hud.alpha = 1;

	wait 2.6;

	hud fadeOverTime( 0.4 );
	hud.alpha = 0;
	wait 0.4;

	hud destroy();
}

lastJumper()
{
	if( !level.dvar["lastalive"] || level.lastJumper )
		return;

	level.lastJumper = true;
	level thread playSoundOnAllPlayers( "last_alive" );

	hud = addTextHud( level, 320, 240, 0, "center", "middle", 2.4 );
	hud setText( self.name + " is the last Jumper alive" );

	hud.glowColor = (0.7,0,0);
	hud.glowAlpha = 1;
	hud SetPulseFX( 30, 100000, 700 );

	hud fadeOverTime( 0.5 );
	hud.alpha = 1;

	wait 2.6;

	hud fadeOverTime( 0.4 );
	hud.alpha = 0;
	wait 0.4;

	hud destroy();
}
ActivatorPoints()
{
	self endon( "disconnect" );
	self endon( "death" );

	waittillframeend;

	if( !isDefined( level.activ ) || level.activ != self )
		return;

	self.curpoints = 100;
	if( !isDefined( self.curpoints_hud ) )
	{
		self.curpoints_hud = NewClientHudElem( self );		//NewClientHudElem( self );
		self.curpoints_hud.alignX = "left";
		self.curpoints_hud.alignY = "bottom";
		self.curpoints_hud.horzalign = "left";
		self.curpoints_hud.vertalign = "bottom";
		self.curpoints_hud.x = 10;
		self.curpoints_hud.y = -50;
		self.curpoints_hud.alpha = 1;
		self.curpoints_hud.font = "default";
		self.curpoints_hud.fontscale = 1.6;
		self.curpoints_hud.glowalpha = 1;
		self.curpoints_hud.glowcolor = (0.25,1,0.25);
		self.curpoints_hud.label = &"Points: &&1";
		self.curpoints_hud.hideWhenInMenu = true;
		self.curpoints_hud.archived = false;		//false = doesn't show when spectating this player
		self.curpoints_hud maps\mp\gametypes\_hud::fontPulseInit();
		self.curpoints_hud setValue( self.curpoints );
	}

	while( isAlive( self ) )
	{
		self waittill( "update_points" );
		if( self.curpoints < 0 && self.curpoints.glowcolor[1] > 0 )
			self.curpoints.glowcolor = (1,0,0);
		self.curpoints_hud thread maps\mp\gametypes\_hud::fontPulse( self );
		self.curpoints_hud setValue( self.curpoints );
	}
}

watchItems()
{
	if( !level.dvar["insertion"] || self.pers["team"] == "axis" /*|| !self.pers["lifes"]*/ )
		return;
		
	if(self.ghost)
		return;

	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	


	insertionItem = "claymore_mp";
	self giveWeapon( insertionItem );
	self giveMaxAmmo( insertionItem );
	self setActionSlot( 3, "weapon", insertionItem );

	
	while( self isReallyAlive() )
	{
		weapon=self getCurrentWeapon();
		
		self waittill( "grenade_fire", entity, weapName );

		if( weapName != insertionItem )
			continue;

		self giveMaxAmmo( insertionItem );

		entity waitTillNotMoving();
		pos = entity.origin;
		angle = entity.angles;
		//entity delete();
		
		if( distance( self.origin, pos ) > 400 )
		{
			self iPrintlnBold( "^1You can't just throw your insertion like that.." );
			entity delete();
			continue;
		}

		self cleanUpInsertion();
		self.insertion = entity;
		
		entity thread flareFx();

		self iPrintlnBold( "^2Insertion at " + pos );
		
		wait 1;
		self SwitchToWeapon( weapon );
	}
}

flareFx()
{
	self.angle=(0,0,180);
	while(self)
	{
		playFx( level.fx["flare"], self.origin );
		wait 0.2;
	}
}

showAbility()
{
	self notify( "show ability" );
	self endon( "show ability" );
	self endon( "disconnect" );

	if( isDefined( self.abilityHud ) )
		self.abilityHud destroy();

	self.abilityHud = newClientHudElem( self );
	self.abilityHud.x = 299.5;
	self.abilityHud.y = 370;
	self.abilityHud.alpha = 0.3;
	self.abilityHud setShader( self.pers["ability"], 55, 48 );
	self.abilityHud.sort = 985;
	
	self.abilityHud fadeOverTime( 0.3 );
	self.abilityHud.alpha = 1;
	wait 1;
	self.abilityHud fadeOverTime( 0.2 );
	self.abilityHud.alpha = 0;
	wait 0.2;
	self.abilityHud destroy();
}

AddBloodHud()
{
	self endon( "disconnect" );

	hud = NewClientHudElem( self );
	hud.alignX = "center";
	hud.alignY = "middle";
	hud.horzalign = "center";
	hud.vertalign = "middle";
	hud.alpha = 1;
	hud.x = RandomIntRange(-320,320);
	hud.y = RandomIntRange(-240,240);
	hud setShader( "bloodsplat" + (RandomInt(3)+1), 512, 512 );
	wait 1;
	hud FadeOverTime(3);
	hud.alpha = 0;
	wait 3;
	hud destroy();
}

delayBloodPool()
{
	if( !level.dvar["extrablood"] )
		return;

	wait 2;
	if( isDefined( self ) )
		PlayFX( level.fx_bloodpool, self.origin );
}

time( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = timertext( "center", 0.1, start_offset, 30 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );

	hud moveOverTime( movetime );
	hud.x = start_offset * -1;
	wait movetime;
	
	hud destroy();
}

timertext( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 2;

	hud.color = (1, 1, 1);
	hud.font = "objective";
	hud.glowColor = ( 0.043, 0.203, 1 );
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;

	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

MovingReward()
{
	self endon( "disconnect" );
	self endon( "death" );

	waittillframeend;

	if( isDefined( level.freeRun ) && level.freeRun )
		return;

	oldpos = [];
	oldpos[0] = self.origin;
	count = 5;
	bla = false;

	while( isAlive( self ) && count > 0 && self.pers["team"] == "allies" && ( !isDefined( level.freeRun ) || !level.freeRun ) )
	{
		wait 1;
		//if( Distance( self.origin, oldpos ) >= 1000 )
		for(i=0;i<oldpos.size;i++)
		{
			if( Distance( self.origin, oldpos[i] ) < 1000 )
			{
				bla = true;
				break;
			}
		}
		if( bla || !self isOnGround() )
		{
			bla = false;
			continue;
		}
		oldpos[oldpos.size] = self.origin;
		self braxi\_rank::giveRankXp( undefined, 5 );
		[[level.changepoints]]( -5 );
		self iPrintln( "+5" );
		count--;
	}
}

canGhostrun()
{
	self endon( "disconnect" );
	self endon( "spawned_player" );
	
	if( self.sessionstate != "playing" && game["state"] == "playing" )
	{
		self thread duffman\_slider::oben(self,"^3Press [{+melee}] ^1For Ghostrun ^3[Tranning]^7",level.randomcolour);
		while( !self MeleeButtonPressed() && game["state"] == "playing" )
			wait .05;
		if( self.sessionstate != "playing" && game["state"] == "playing" )
			self thread plugins\_ghostrun::ghostrun_spawnPlayer();
		else
			self clearLowerMessage();
	}
}

NoAds()
{
	self notify("sdfsdfsf");
	self endon("disconnect");
	self endon("sdfsdfsf");
	
	for(;;)
	{
		if ( issubstr(self.name, "www.") || issubstr(self.name, ".de") ||issubstr(self.name, ".com") ||issubstr(self.name, ".at") ||issubstr(self.name, ".net") ||issubstr(self.name, ".org") ||issubstr(self.name, ".info") ||issubstr(self.name, ".tk") ||issubstr(self.name, ".ru") ||issubstr(self.name, ".pl") ||issubstr(self.name, ":289"))
		{
			self ClientCmd("name TROLOLOLOL");
			self iPrintlnBold("NO ADVERTISEMENT, your name was changed");
		}
		wait 2;
	}
}

byduff3( text )
{
	hud = addTextHud( level, 320, 220, 0, "center", "middle", 2.4 );
	hud setText( text );

	hud.glowColor = (0.7,0,0);
	hud.glowAlpha = 1;
	hud SetPulseFX( 30, 100000, 700 );

	hud fadeOverTime( 0.5 );
	hud.alpha = 1;

	wait 2.6;

	hud fadeOverTime( 0.4 );
	hud.alpha = 0;
	wait 0.4;

	hud destroy();
}

calc_dis(attacker,target)
{
	while(distance(attacker,target)>200)
	{
		wait 0.05;
		attacker.angles =(vectorToAngles((target)-(attacker)));
	}
	level notify("impact");
}

tracer(target)
{
		dis=distance(self.origin, target);
		if(dis>350)
		{
		self takeAllWeapons();
		self freezecontrols(true);
		linker = Spawn("script_origin",self getorigin());
		self linkto(linker);
		linker MoveTo(target,0.2);
		setDvar("timescale", 0.3);
		thread calc_dis(self,target);
		level waittill("impact");
		self unlink();
		setDvar("timescale", 1);
		}
}