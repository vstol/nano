/*
*****************************************************************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************************************************************
******                                                                                                                                                                                                                             ******
******      [[[[                                                                     ]]]]                                                                                                                                          ******
******      [[                                                                         ]]                                                                                                                                          ******
******      [[   NN          NN         OOOO         VV          VV         AA         ]]     MM          MM         OOOO        UU        UU     SSSSSS     TTTTTTTTTT         AA              CCCC   HH     HH   EEEEEEE         ******
******      [[   NNNN        NN      OO      OO       VV        VV         AAAA        ]]     MMMM      MMMM      OO      OO     UU        UU   SS      SS       TT            AAAA           CC       HH     HH   EE              ******
******      [[   NN  NN      NN    OO          OO      VV      VV         AA  AA       ]]     MM  MM  MM  MM    OO          OO   UU        UU   SS               TT           AA  AA        CC         HH     HH   EE              ******
******      [[   NN    NN    NN   OO            OO      VV    VV         AA    AA      ]]     MM    MM    MM   OO            OO  UU        UU     SSSSSS         TT          AA    AA      CC          HHHHHHHHH   EEEEEE          ******
******      [[   NN      NN  NN    OO          OO        VV  VV         AAAAAAAAAA     ]]     MM          MM    OO          OO   UU        UU           SS       TT         AAAAAAAAAA      CC         HH     HH   EE              ******
******      [[   NN        NNNN      OO      OO           VVVV         AA        AA    ]]     MM          MM      OO      OO       UU    UU     SS      SS       TT        AA        AA       CC       HH     HH   EE              ******
******      [[   NN          NN         OOOO               VV         AA          AA   ]]     MM          MM         OOOO            UUUU  UU     SSSSSS         TT       AA          AA        CCCC   HH     HH   EEEEEEE         ******
******      [[                                                                         ]]                                                                                                                                          ******
******      [[[[                                                                     ]]]]                                                                                                                                          ******
******                                                                                                                                                                                                                             ******
*****************************************************************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************************************************************************

This map is made by [Nova]Moustache.
Xfire: snor1991
Website: www.novacrew.eu
*/

main()
{
	maps\mp\_load::main();
	
	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	level.spin_time = getDvarInt( "scr_timelimit" );
	if( !isDefined( level.spin_time ) || ( isDefined( level.spin_time ) && level.spin_time < 1 ) )
		level.spin_time = 5;
	
	level.trapsDisabledMessage = false;
	level.all_vs_activator = false;
	level.pre_spawn_allow = false;
	
	level.spawn_battle = getEntArray( "mp_spawn_battle", "classname" );
	level.pre_spawn_battle = getEntArray( "mp_pre_spawn_battle", "classname" );
	level.spawns_final = getEntArray( "mp_jumper_spawn_final", "classname" );
	
	level._effect[ "blood" ] = loadfx( "impacts/flesh_hit_knife" );
	level._effect[ "trap4" ] = loadfx( "deathrun_plane" );
	level._effect[ "trap4_player_burn" ] = loadfx( "deathrun_player" );
	
	precacheItem( "mp_deathrun_moustache_kar98_mp" );
	precacheItem( "deserteagle_mp" );
	precacheItem( "m40a3_mp" );
	precacheItem( "g3_mp" );
	precacheItem( "ak47_mp" );
	precacheItem( "saw_mp" );
	
	level thread setupMapFinish();
	level thread setupFinalFight();
	
	level thread setupServers();
	
	level thread setupElevator1();
	level thread setupEscalator1();
	level thread setupHoverBeamLights();
	level thread setupHoverBeam();
	level thread setupNoobPath();
	
	level thread setupTriggerJumpers();
	
	level thread setupTriggerFlesh1();
	level thread setupTriggerFlesh2();
	level thread setupTriggerTouch1();
	level thread setupTriggerTouch2();
	
	level thread setupTrap1();
	level thread setupTrap2();
	level thread setupTrap3();
	level thread setupTrap4();
	level thread setupTrap5();
	level thread setupTrap6();
	level thread setupTrap7();
}

setupMapFinish()
{
	level.jumpers_finished = 0;
	level.jumper_first = undefined;
	level.jumper_second = undefined;
	level.jumper_third = undefined;
	
	level thread countUntilOpen();
	
	walk_trough = getEntArray( "finish_map", "targetname" );
	
	for( i = 0; i < walk_trough.size; i++ )
		walk_trough[i] thread checkWalkTrough();
}

checkWalkTrough()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	while(1)
	{
		self waittill( "trigger", player );
		
		if( !isDefined( player.finished_map ) || ( isDefined( player.finished_map ) && !player.finished_map ) )
			player finishedMap();
		
		wait 0.05;
	}
}

countUntilOpen()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	level waittill( "game started" );
	level.final_count = 0;
	
	while(1)
	{
		level.final_count++;
		wait 1;
	}
}

setupFinalFight()
{
	level.battle_type = undefined;
	level.finalists = 0;
	level.finalist_first = undefined;
	level.finalist_second = undefined;
	level.finalist_third = undefined;
	
	for( i = 0; i < level.spawn_battle.size; i++ )
		level.spawn_battle[i] placeSpawnPoint();
	for( i = 0; i < level.pre_spawn_battle.size; i++ )
		level.pre_spawn_battle[i] placeSpawnPoint();
	for( i = 0; i < level.spawns_final.size; i++ )
		level.spawns_final[i] placeSpawnPoint();
	
	for( i = 1; i < 9; i++ )
	{
		level.final_rock_corners[i] = getEnt( "final_rock_" + i, "targetname" );
		level.final_rock_corners[i] hide();
	}
	
	level.bullet_block = getEnt( "battle_ttt_blocker", "targetname" );
	level.wall_blocker = getEnt( "wall_blocker", "targetname" );
	level.final_rocks = getEntArray( "final_rock", "targetname" );
	level.final_aim_area = getEntArray( "battle_aim_area", "targetname" );
	
	level.bullet_block hide();
	level.bullet_block notSolid();
	level.wall_blocker hide();
	level.wall_blocker notSolid();
	
	for( i = 0; i < level.final_rocks.size; i++ )
		level.final_rocks[i] hide();
	for( i = 0; i < level.final_aim_area.size; i++ )
	{
		level.final_aim_area[i] hide();
		level.final_aim_area[i] notSolid();
	}
	
	level.final_aim_obj[0] = [];
	level.final_aim_obj[1] = [];
	
	for( i = 1; i < 7; i++ )
	{
		level.final_aim_obj[0][i] = getEnt( "battle_aim_0_obj_" + i, "targetname" );
		level.final_aim_obj[1][i] = getEnt( "battle_aim_1_obj_" + i, "targetname" );
	}
	
	level.final_aim_ang_hitme_0 = level.final_aim_obj[0][1].angles;
	level.final_aim_ang_hitme_1 = level.final_aim_obj[1][1].angles;
	level.final_aim_ang_norm_0 = level.final_aim_obj[0][1].angles - ( 80, 0, 0 );
	level.final_aim_ang_norm_1 = level.final_aim_obj[1][1].angles + ( 80, 0, 0 );
	
	level.final_aim_lights = [];
	level.final_aim_lights[0] = getEntArray( "battle_aim_0_lights_6", "targetname" );
	level.final_aim_lights[1] = getEntArray( "battle_aim_1_lights_6", "targetname" );
	
	for( i = 0; i < level.final_aim_lights[0].size; i++ )
	{
		level.final_aim_lights[0][i] linkTo( level.final_aim_obj[0][6] );
		level.final_aim_lights[1][i] linkTo( level.final_aim_obj[1][6] );
	}
	
	level.final_aim_bottles = [];
	level.final_aim_bottles[0] = [];
	level.final_aim_bottles[1] = [];
	
	for( i = 0; i < 8; i++ )
	{
		level.final_aim_bottles[0][i] = getEnt( "battle_aim_0_obj_6_" + i, "targetname" );
		level.final_aim_bottles[1][i] = getEnt( "battle_aim_1_obj_6_" + i, "targetname" );
		
		level.final_aim_bottles[0][i] linkTo( level.final_aim_obj[0][6] );
		level.final_aim_bottles[1][i] linkTo( level.final_aim_obj[1][6] );
	}
	
	for( i = 1; i < 7; i++ )
	{
		level.final_aim_obj[0][i].angles = level.final_aim_ang_norm_0;
		level.final_aim_obj[1][i].angles = level.final_aim_ang_norm_1;
	}
	
	level.normal_activate = getEnt( "battle_finish_normal", "targetname" );
	level.snip_activate = getEnt( "battle_finish_sniper", "targetname" );
	level.ttt_activate = getEnt( "battle_finish_ttt", "targetname" );
	level.rps_activate = getEnt( "battle_finish_rps", "targetname" );
	level.aim_activate = getEnt( "battle_finish_aim", "targetname" );
	
	if( !isDefined( level.freeRun ) )
		wait 0.1;
	
	if( isDefined( level.freeRun ) && level.freeRun )
	{
		level.snip_activate setHintString( "^1No end game ^7in a free run round" );
		level.ttt_activate setHintString( "^1No end game ^7in a free run round" );
		level.rps_activate setHintString( "^1No end game ^7in a free run round" );
		level.normal_activate delete();
		level.aim_activate delete();
		
		return;
	}
	
	level.sniper_model = getEntArray( "battle_sniper", "targetname" );
	
	for( i = 0; i < level.sniper_model.size; i++ )
		level.sniper_model[i] rotateYaw( level.spin_time * 720, level.spin_time * 60, 0 ,0 );
	
	level.normal_activate thread waitOnTriggerNormal();
	level.snip_activate thread waitOnTriggerSnip();
	level.ttt_activate thread waitOnTriggerTtt();
	level.rps_activate thread waitOnTriggerRps();
	level.aim_activate thread waitOnTriggerAim();
}

triggerActivated( player )
{
	level endon( "game over" );
	
	level.finalist_first = player;
	level.finalists = 1;
	
	if( level.battle_type != 4 )
	{
		level thread cleanFinalRoom();
		level thread createFinalRoomOneTime( player );
	}
	
	while(1)
	{
		self waittill( "trigger", player );
		
		if( !isDefined( player.finalist ) || ( isDefined( player.finalist ) && !player.finalist ) )
		{
			player.finalist = true;
			level.finalists++;
			
			if( level.finalists == 2 )
			{
				level.finalist_second = player;
				
				if( level.battle_type != 4 )
				{
					player doPreSpawn( 1 );
					
					if( level.battle_type == 0 )
						level.sniper_model[1] delete();
				}
			}
			else if( level.finalists == 3 )
			{
				level.finalist_third = player;
				
				if( level.battle_type != 4 )
				{
					player doPreSpawn( 0 );
				
					if( level.battle_type == 0 )
					{
						level.sniper_model[2] delete();
						level.snip_activate setHintString( "Press [Use] to ^2play All Jumpers ^7VS ^1Activator" );
					}
					else if( level.battle_type == 1 )
						level.ttt_activate setHintString( "Press [Use] to ^2play All Jumpers ^7VS ^1Activator" );
					else if( level.battle_type == 2 )
						level.rps_activate setHintString( "Press [Use] to ^2play All Jumpers ^7VS ^1Activator" );
				}
			}
			else if( level.finalists > 3 )
			{
				level.all_vs_activator = true;
				
				if( level.battle_type == 4 )
					level thread vsActivatorAll();
				
				break;
			}
		}
	}
}

waitOnTriggerNormal()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	level endon( "stop_normal" );
	self waittill( "trigger", player );
	
	level.battle_type = 4;
	self thread triggerActivated( player );
	
	level notify( "stop_snip" );
	level notify( "stop_ttt" );
	level notify( "stop_rps" );
	level notify( "stop_aim" );
	
	self setHintString( "The special end games are ^1disabled" );
	level.snip_activate setHintString( "The special end games are ^1disabled" );
	level.ttt_activate setHintString( "The special end games are ^1disabled" );
	level.rps_activate setHintString( "The special end games are ^1disabled" );
	level.aim_activate delete();
}

waitOnTriggerSnip()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	level endon( "stop_snip" );
	self waittill( "trigger", player );
	
	level.battle_type = 0;
	self thread triggerActivated( player );
	
	level notify( "stop_normal" );
	level notify( "stop_ttt" );
	level notify( "stop_rps" );
	level notify( "stop_aim" );
	
	level.snip_activate setHintString( "Press [Use] to ^2join the Sniper Battle" );
	level.ttt_activate setHintString( "You can only play ^2Sniper Battle ^7right now" );
	level.rps_activate setHintString( "You can only play ^2Sniper Battle ^7right now" );
	level.aim_activate delete();
	level.normal_activate delete();
	
	level.sniper_model[0] delete();
}

waitOnTriggerTtt()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	level endon( "stop_ttt" );
	self waittill( "trigger", player );
	
	level.battle_type = 1;
	self thread triggerActivated( player );
	
	level notify( "stop_normal" );
	level notify( "stop_snip" );
	level notify( "stop_rps" );
	level notify( "stop_aim" );
	
	level.ttt_activate setHintString( "Press [Use] to ^2join Tic-Tac-Toe" );
	level.snip_activate setHintString( "You can only play ^2Tic-Tac-Toe ^7right now" );
	level.rps_activate setHintString( "You can only play ^2Tic-Tac-Toe ^7right now" );
	level.aim_activate delete();
	level.normal_activate delete();
}

waitOnTriggerRps()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	level endon( "stop_rps" );
	self waittill( "trigger", player );
	
	level.battle_type = 2;
	self thread triggerActivated( player );
	
	level notify( "stop_normal" );
	level notify( "stop_snip" );
	level notify( "stop_ttt" );
	level notify( "stop_aim" );
	
	level.rps_activate setHintString( "Press [Use] to ^2join Rock-Paper-Scissors" );
	level.snip_activate setHintString( "You can only play ^2Rock-Paper-Scissors ^7right now" );
	level.ttt_activate setHintString( "You can only play ^2Rock-Paper-Scissors ^7right now" );
	level.aim_activate delete();
	level.normal_activate delete();
}

waitOnTriggerAim()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	level endon( "stop_aim" );
	
	while(1)
	{
		self waittill( "trigger", player );
		
		if( isDefined( player.do_aim ) && player.do_aim )
			break;
		else if( isDefined( player.finished_map ) && player.finished_map )
		{
			player.do_aim = true;
			player iPrintLnBold( "Shoot it one more time to start the ^2Shooting Range" );
		}
	}
	
	level.battle_type = 3;
	self thread triggerActivated( player );
	
	level notify( "stop_normal" );
	level notify( "stop_snip" );
	level notify( "stop_ttt" );
	level notify( "stop_rps" );
	
	level.rps_activate setHintString( "You can only play on the ^2Shooting Range ^7right now" );
	level.snip_activate setHintString( "You can only play on the ^2Shooting Range ^7right now" );
	level.ttt_activate setHintString( "You can only play on the ^2Shooting Range ^7right now" );
	level.normal_activate delete();
}

doPreSpawn( spawn_num )
{
	level endon( "game over" );
	
	if( !level.pre_spawn_allow )
		level waittill( "allow_pre_spawn" );
	
	spawnPoint = level.pre_spawn_battle[ spawn_num ];
	self spawn( spawnPoint.origin, spawnPoint.angles );
	
	self iPrintLnBold( "Wait here and enjoy the fight" );
	
	self notify( "kill afk monitor" );
}

finishedMap()
{
	level endon( "game over" );
	
	level.jumpers_finished++;
	self.finished_map = true;
	
	if( level.jumpers_finished == 1 )
	{
		level.jumper_first = self;
		iPrintLnBold( "^1>> ^2First Place ^1<<" );
		iPrintLnBold( "^1" + self.name + "^7 completed the level in ^2" + level.final_count + " ^7seconds" );
	}
	else if( level.jumpers_finished == 2 )
	{
		level.jumper_second = self;
		iPrintLnBold( "^1>> ^2Second Place ^1<<" );
		iPrintLnBold( "^1" + self.name + "^7 completed the level in ^2" + level.final_count + " ^7seconds" );
	}
	else if( level.jumpers_finished == 3 )
	{
		level.jumper_third = self;
		iPrintLnBold( "^1>> ^2Third Place ^1<<" );
		iPrintLnBold( "^1" + self.name + "^7 completed the level in ^2" + level.final_count + " ^7seconds" );
	}
	else
	{
		self iPrintLnBold( "^1>> ^2Place " + level.jumpers_finished + " ^1<<" );
		self iPrintLnBold( "^1" + self.name + "^7 completed the level in ^2" + level.final_count + " ^7seconds" );
		iPrintLn( "^1>> ^2Place " + level.jumpers_finished + " ^1<<" );
		iPrintLn( "^1" + self.name + "^7 completed the level in ^2" + level.final_count + " ^7seconds" );
	}
}

cleanFinalRoom()
{
	level endon( "game over" );
	level endon( "final_room_created" );
	
	level.final_room_kill = getEnt( "end_room_kill", "targetname" );
	
	while(1)
	{
		level.final_room_kill waittill( "trigger", player );
		
		player suicide();
		player iPrintLnBold( "The final room has been cleaned" );
	}
}

createFinalRoomOneTime( player )
{
	level.wall_blocker show();
	level.wall_blocker solid();
	
	part1 = getEnt( "end_room_1", "targetname" );
	part2 = getEnt( "end_room_2", "targetname" );
	part3 = getEnt( "end_room_3", "targetname" );
	
	part1 thread moveAndCheck( (0,0,736), 5 );
	part2 thread moveAndCheck( (976,0,0), 5 );
	part3 thread moveAndCheck( (-32,-112,-76), 5 );
	
	if( randomIntRange( 0, 101 ) > 50 )
	{
		spawnPoint = level.pre_spawn_battle[0];
		player spawn( spawnPoint.origin, spawnPoint.angles );

		spawnPoint = level.pre_spawn_battle[1];
		level.activ spawn( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		spawnPoint = level.pre_spawn_battle[1];
		player spawn( spawnPoint.origin, spawnPoint.angles );

		spawnPoint = level.pre_spawn_battle[0];
		level.activ spawn( spawnPoint.origin, spawnPoint.angles );
	}
	
	iPrintLnBold( " " );
	iPrintLnBold( "^1>> ^2Creating Final Room^1<<" );
	
	level.wall_middle = getEnt( "battle_rps_blocker", "targetname" );
	
	j = 5;
	
	if( level.battle_type == 0 )
	{
		j = 3;
		time = 3;
		
		for( i = 1; i < 9; i++ )
		{
			level.final_rock_corners[i] show();
			level.final_rock_corners[i] moveTo( ( level.final_rock_corners[i].origin[0], level.final_rock_corners[i].origin[1], -608 ), time );
		}
		
		num1 = int( level.final_rock_corners[1].origin[0] );
		num2 = int( level.final_rock_corners[4].origin[0] );
		num3 = int( level.final_rock_corners[5].origin[0] );
		num4 = int( level.final_rock_corners[8].origin[0] );
		num5 = int( level.final_rock_corners[4].origin[1] );
		num6 = int( level.final_rock_corners[1].origin[1] );
		
		for( i = 0; i < level.final_rocks.size; i++ )
		{
			if( i % 2 == 0 )
				x_pos = randomIntRange( num1, num2 + 1 );
			else
				x_pos = randomIntRange( num3, num4 + 1 );
			
			y_pos = randomIntRange( num5, num6 + 1 );
			
			if( i % 5 == 0 )
			{
				level.final_rocks[i].origin = ( x_pos, y_pos, level.final_rocks[i].origin[2] );
				level.final_rocks[i] show();
				level.final_rocks[i] moveTo( ( x_pos, y_pos, -544 ), time );
				
				level.final_rocks[i] rotateVelocity( ( randomIntRange( -5, 6 ) * 90, randomIntRange( -5, 6 ) * 90, randomIntRange( -5, 6 ) * 90 ), time );
				
				i++;
			}
			
			level.final_rocks[i].origin = ( x_pos, y_pos, level.final_rocks[i].origin[2] );
			level.final_rocks[i] show();
			level.final_rocks[i] moveTo( ( x_pos, y_pos, -608 ), time );
			
			level.final_rocks[i] rotateVelocity( ( randomIntRange( -5, 6 ) * 90, randomIntRange( -5, 6 ) * 90, randomIntRange( -5, 6 ) * 90 ), time );
			
			wait 0.2;
		}
	}
	else if( level.battle_type == 1 )
	{
		level.bullet_block show();
		level.bullet_block solid();
		
		field = getEnt( "battle_ttt_field", "targetname" );
		field thread waitThenMove();
		
		level.battle_ttt_stand = getEnt( "battle_ttt_stand", "targetname" );
		level.battle_ttt_stand_normal_orig = level.battle_ttt_stand.origin;
		
		level.ttt_X = [];
		level.ttt_O = [];
		level.ttt_trigs = [];
		
		for( i = 1; i < 10; i++ )
		{
			level.ttt_X[i] = getEnt( "battle_ttt_o_" + i, "targetname" );
			level.ttt_O[i] = getEnt( "battle_ttt_x_" + i, "targetname" );
			
			level.ttt_trigs[i] = getEnt( "battle_ttt_trig_" + i, "targetname" );
		}
		
		level.ttt_height_normal = level.ttt_X[1].origin[2];
	}
	else if( level.battle_type == 2 )
	{
		level.wall_middle thread moveAndCheck( (0,0,768), 5 );
		
		level.rps_rock = getEnt( "battle_rps_rock", "targetname" );
		level.rps_paper = getEnt( "battle_rps_paper", "targetname" );
		level.rps_scissors = getEnt( "battle_rps_scissors", "targetname" );
	}
	else if( level.battle_type == 3 )
	{
		level.bullet_block show();
		level.bullet_block solid();
		
		level.wall_middle thread moveAndCheck( (0,0,768), 5 );
		
		for( i = 0; i < 5; i++ )
			getEnt( "battle_aim_weaps_trig_" + i, "targetname" ) thread aimWeaponWaitOnDamage( i );
		
		ammo_crates = getEntArray( "battle_aim_ammo_trig", "targetname" );
		for( i = 0; i < ammo_crates.size; i++ )
			ammo_crates[i] thread aimAmmoCrate();
		
		level.final_aim_weapons[0] = "deserteagle_mp";
		level.final_aim_weapons[1] = "m40a3_mp";
		level.final_aim_weapons[2] = "g3_mp";
		level.final_aim_weapons[3] = "ak47_mp";
		level.final_aim_weapons[4] = "saw_mp";
		
		for( i = 0; i < level.final_aim_area.size; i++ )
		{
			level.final_aim_area[i] show();
			level.final_aim_area[i] solid();
			level.final_aim_area[i] thread moveAndCheck( (0,0,-1536), 5 );
		}
		
		level.final_aim_bottles_start_y = level.final_aim_bottles[0][0].origin[1];
		level.final_aim_bottles_end_y = -26;
		
		level.final_aim_active = [];
		level.final_aim_active[0] = [];
		level.final_aim_active[1] = [];
		
		level.final_aim_trigs = [];
		level.final_aim_trigs[0] = [];
		level.final_aim_trigs[1] = [];
		
		level.final_aim_trigs_pro = [];
		level.final_aim_trigs_pro[0] = [];
		level.final_aim_trigs_pro[1] = [];
		
		for( i = 1; i < 6; i++ )
		{
			level.final_aim_trigs[0][i] = getEnt( "battle_aim_0_trig_" + i, "targetname" );
			level.final_aim_trigs[1][i] = getEnt( "battle_aim_1_trig_" + i, "targetname" );
			level.final_aim_trigs_pro[0][i] = getEnt( "battle_aim_0_trig_pro_" + i, "targetname" );
			level.final_aim_trigs_pro[1][i] = getEnt( "battle_aim_1_trig_pro_" + i, "targetname" );
		}
		
		level.final_aim_trigs_6 = [];
		level.final_aim_trigs_6[0] = [];
		level.final_aim_trigs_6[1] = [];
		
		for( i = 0; i < 8; i++ )
		{
			level.final_aim_trigs_6[0][i] = getEnt( "battle_aim_0_trig_6_" + i, "targetname" );
			level.final_aim_trigs_6[1][i] = getEnt( "battle_aim_1_trig_6_" + i, "targetname" );
		}
	}
	
	while( j > 0 )
	{
		player iPrintLn( "^1Teleporting ^7to ^2Final Room ^7in ^1" + j + " seconds" );
		level.activ iPrintLn( "^1Teleporting ^7to ^2Final Room ^7in ^1" + j + " seconds" );
		
		j--;
		
		wait 1;
	}
	
	level notify( "final_room_created" );
	level.final_room_kill delete();
	
	level thread playersInRoom( player );
}

playersInRoom( player )
{
	level endon( "game over" );
	
	player notify( "kill afk monitor" );
	level.activ notify( "kill afk monitor" );
	
	if( isDefined( player.slow_noob ) && player.slow_noob )
	{
		player.slow_noob = false;
		
		if( isDefined( level.dvar["allies_speed"] ) )
			player setMoveSpeedScale( level.dvar["allies_speed"] );
		else
			player setMoveSpeedScale( 1 );
	}
	
	if( isDefined( self.weaponsDisabled ) && self.weaponsDisabled )
		self.weaponsDisabled = false;
	
	if( randomIntRange( 0, 101 ) > 50 )
	{
		spawnPoint = level.spawn_battle[0];
		player spawn( spawnPoint.origin, spawnPoint.angles );

		spawnPoint = level.spawn_battle[1];
		level.activ spawn( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		spawnPoint = level.spawn_battle[1];
		player spawn( spawnPoint.origin, spawnPoint.angles );

		spawnPoint = level.spawn_battle[0];
		level.activ spawn( spawnPoint.origin, spawnPoint.angles );
	}
		
	if( !level.pre_spawn_allow )
	{
		level.pre_spawn_allow = true;
		level notify( "allow_pre_spawn" );
	}
	
	if( level.battle_type == 0 )
	{
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player allowJump( false );
		player freezeControls( true );
		level.activ allowJump( false );
		level.activ freezeControls( true );
		
		player disableWeapons();
		player giveWeapon( "mp_deathrun_moustache_kar98_mp" );
		player giveMaxAmmo( "mp_deathrun_moustache_kar98_mp" );
		player setSpawnWeapon( "mp_deathrun_moustache_kar98_mp" );
		level.activ disableWeapons();
		level.activ giveWeapon( "mp_deathrun_moustache_kar98_mp" );
		level.activ giveMaxAmmo( "mp_deathrun_moustache_kar98_mp" );
		level.activ setSpawnWeapon( "mp_deathrun_moustache_kar98_mp" );
		
		player iPrintLnBold( "^1>> 3 ^1<<" );
		level.activ iPrintLnBold( "^1>> 3 ^1<<" );
		wait 1;
		player iPrintLnBold( "^1>> ^32 ^1<<" );
		level.activ iPrintLnBold( "^1>> ^42 ^1<<" );
		wait 1;
		player iPrintLnBold( "^1>> ^21 ^1<<" );
		level.activ iPrintLnBold( "^1>> ^21 ^1<<" );
		wait 1;
		player iPrintLnBold( "^1>> ^2Start ^1<<" );
		level.activ iPrintLnBold( "^1>> ^2Start ^1<<" );
		
		player enableWeapons();
		player allowJump( true );
		player freezeControls( false );
		level.activ enableWeapons();
		level.activ allowJump( true );
		level.activ freezeControls( false );
		
		player common_scripts\utility::waittill_any( "death", "disconnect", "joined_spectators", "spawned" );
	}
	else if( level.battle_type == 1 )
	{
		level.battle_ttt_stand.origin = level.battle_ttt_stand_normal_orig;
		level.battle_ttt_stand moveTo( level.battle_ttt_stand_normal_orig + (0,0,946), 3 );
		
		level.ttt_total_turns = 0;
		level.ttt_victory = undefined;
		level.ttt_victory_method = undefined;
		
		level.ttt_trigs_used = [];
		
		for( i = 1; i < 10; i++ )
		{
			level.ttt_trigs_used[i] = undefined;
			level.ttt_trigs[i] thread tttWaitOnDamage( i );
			
			level.ttt_X[i] moveTo( ( level.ttt_X[i].origin[0], level.ttt_X[i].origin[1], level.ttt_height_normal ), 2 );
			level.ttt_O[i] moveTo( ( level.ttt_O[i].origin[0], level.ttt_O[i].origin[1], level.ttt_height_normal ), 2 );
		}
		
		if( spawnPoint == level.spawn_battle[0] )
		{
			player.ttt_location = 0;
			level.activ.ttt_location = 1;
		}
		else
		{
			player.ttt_location = 1;
			level.activ.ttt_location = 0;
		}
		
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player allowJump( false );
		player freezeControls( true );
		
		level.activ allowJump( false );
		level.activ freezeControls( true );
		
		player disableWeapons();
		player giveWeapon( "colt45_mp" );
		player giveMaxAmmo( "colt45_mp" );
		player setSpawnWeapon( "colt45_mp" );
		
		level.activ disableWeapons();
		level.activ giveWeapon( "colt45_mp" );
		level.activ giveMaxAmmo( "colt45_mp" );
		level.activ setSpawnWeapon( "colt45_mp" );
		
		wait 3;
		
		player enableWeapons();
		player allowJump( true );
		player freezeControls( false );
		level.activ enableWeapons();
		level.activ allowJump( true );
		level.activ freezeControls( false );
		
		player.ttt_total_positions = 1;
		level.activ.ttt_total_positions = 1;
		
		if( randomIntRange( 0, 101 ) > 50 )
		{
			level.activ.ttt_object = "O";
			player.ttt_object = "X";
			player thread tttYourTurn( level.activ );
		}
		else
		{
			player.ttt_object = "O";
			level.activ.ttt_object = "X";
			level.activ thread tttYourTurn( player );
		}
		
		level waittill( "finish_ttt" );
		level notify( "end_ttt_choice" );
		
		if( level.ttt_victory == player.ttt_object )
		{
			iPrintLnBold( player.name + " has 3 in a row " + level.ttt_victory_method );
 			iPrintLnBold( "^1>> ^2" + player.name + " ^7Wins ^1<<" );
			level.activ thread maps\mp\gametypes\_globallogic::callback_playerDamage( level.activ, player, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
		}
		else if( level.ttt_victory == level.activ.ttt_object )
		{
			iPrintLnBold( level.activ.name + " has 3 in a row " + level.ttt_victory_method );
			iPrintLnBold( "^2>> ^1" + level.activ.name + " ^7Wins ^2<<" );
			player thread maps\mp\gametypes\_globallogic::callback_playerDamage( player, level.activ, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
		}
		else
		{
			iPrintLnBold( ">> It is a Draw <<" );
			iPrintLnBold( "^2>> ^1" + level.activ.name + " ^7Survives ^2<<" );
			player suicide();
		}
	}
	else if( level.battle_type == 2 )
	{
		level.rps_rock thread rpsWaitOnDamage( 1 );
		level.rps_paper thread rpswaitOnDamage( 2 );
		level.rps_scissors thread rpsWaitOnDamage( 3 );
		
		player.rps_type = undefined;
		level.activ.rps_type = undefined;
		
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player giveWeapon( "colt45_mp" );
		player giveMaxAmmo( "colt45_mp" );
		player setSpawnWeapon( "colt45_mp" );
		level.activ giveWeapon( "colt45_mp" );
		level.activ giveMaxAmmo( "colt45_mp" );
		level.activ setSpawnWeapon( "colt45_mp" );
		
		player iPrintLnBold( "^1Shoot on your choice\n^7Rock Paper or Scissors" );
		level.activ iPrintLnBold( "^1Shoot on your choice\n^7Rock Paper or Scissors" );
		
		for( j = 15; j > 0; j-- )
		{
			player iPrintLn( "^1Start ^7Rock-Paper-Scissors in ^1" + j + " seconds" );
			level.activ iPrintLn( "^1Start ^7Rock-Paper-Scissors in ^1" + j + " seconds" );
			
			wait 1;
		
			if( j >= 4 && isDefined( player.rps_type ) && isDefined( level.activ.rps_type ) )
				j = 4;
		}
		
		level notify( "end_rps_choice" );
		
		if( !isDefined( player.rps_type ) )
			iPrintLnBold( "^2" + player.name + " ^7has not chosen anything" );
		else if( player.rps_type == 1 )
			iPrintLnBold( "^2" + player.name + " ^7has chosen Rock" );
		else if( player.rps_type == 2 )
			iPrintLnBold( "^2" + player.name + " ^7has chosen Paper" );
		else if( player.rps_type == 3 )
			iPrintLnBold( "^2" + player.name + " ^7has chosen Scissors" );
		
		if( !isDefined( level.activ.rps_type ) )
			iPrintLnBold( "^1" + level.activ.name + " ^7has not chosen anything" );
		else if( level.activ.rps_type == 1 )
			iPrintLnBold( "^1" + level.activ.name + " ^7has chosen Rock" );
		else if( level.activ.rps_type == 2 )
			iPrintLnBold( "^1" + level.activ.name + " ^7has chosen Paper" );
		else if( level.activ.rps_type == 3 )
			iPrintLnBold( "^1" + level.activ.name + " ^7has chosen Scissors" );
		
		if( !isDefined( player.rps_type ) && !isDefined( level.activ.rps_type ) )
		{
			iPrintLnBold( player.name + " and " + level.activ.name + " are retarded" );
			player suicide();
			level.activ suicide();
		}
		else if( isDefined( player.rps_type ) && !isDefined( level.activ.rps_type ) )
		{
			iPrintLnBold( level.activ.name + " is retarded" );
			level.activ suicide();
		}
		else if( !isDefined( player.rps_type ) && isDefined( level.activ.rps_type ) )
		{
			iPrintLnBold( player.name + " is retarded" );
			player suicide();
		}
		else if( ( player.rps_type == 1 && level.activ.rps_type == 3 ) || ( player.rps_type == 2 && level.activ.rps_type == 1 ) || ( player.rps_type == 3 && level.activ.rps_type == 2 ) )
		{
 			iPrintLnBold( "^1>> ^2" + player.name + " ^7Wins ^1<<" );
			level.activ thread maps\mp\gametypes\_globallogic::callback_playerDamage( level.activ, player, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
		}
		else if( ( player.rps_type == 1 && level.activ.rps_type == 2 ) || ( player.rps_type == 2 && level.activ.rps_type == 3 ) || ( player.rps_type == 3 && level.activ.rps_type == 1 ) )
		{
			iPrintLnBold( "^2>> ^1" + level.activ.name + " ^7Wins ^2<<" );
			player thread maps\mp\gametypes\_globallogic::callback_playerDamage( player, level.activ, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
		}
		else
		{
			iPrintLnBold( ">> It is a Draw <<" );
			iPrintLnBold( "^2>> ^1" + level.activ.name + " ^7Survives ^2<<" );
			player suicide();
		}
	}
	else if( level.battle_type == 3 )
	{
		for( i = 1; i < 7; i++ )
		{
			level.final_aim_active[0][i] = false;
			level.final_aim_active[1][i] = false;
			
			level.final_aim_obj[0][i] rotateTo( level.final_aim_ang_norm_0, 0.25 );
			level.final_aim_obj[1][i] rotateTo( level.final_aim_ang_norm_1, 0.25 );
		}
		
		for( i = 0; i < level.final_aim_bottles[0].size; i++ )
		{
			level.final_aim_bottles[0][i].got_hit = false;
			level.final_aim_bottles[0][i].moving = false;
			level.final_aim_bottles[1][i].got_hit = false;
			level.final_aim_bottles[1][i].moving = false;
			
			level.final_aim_bottles[0][i] unLink();
			level.final_aim_bottles[0][i] linkTo( level.final_aim_obj[0][6] );
			level.final_aim_bottles[1][i] unLink();
			level.final_aim_bottles[1][i] linkTo( level.final_aim_obj[1][6] );
		}
		
		player.pro_hits = 0;
		player.bottles_shot = 0;
		player.completion_time = 0;
		level.activ.pro_hits = 0;
		level.activ.bottles_shot = 0;
		level.activ.completion_time = 0;
		
		player takeAllWeapons();
		level.activ takeAllWeapons();
		
		player giveWeapon( "colt45_mp" );
		player giveMaxAmmo( "colt45_mp" );
		player setSpawnWeapon( "colt45_mp" );
		
		level.activ giveWeapon( "colt45_mp" );
		level.activ giveMaxAmmo( "colt45_mp" );
		level.activ setSpawnWeapon( "colt45_mp" );
		
		player iPrintLnBold( "You have 10 seconds to choose a weapon\nShoot on one to get it" );
		level.activ iPrintLnBold( "You have 10 seconds to choose a weapon\nShoot on one to get it" );
		
		wait 10;
		level thread aimTimer();
		level thread aimTimeLimit();
		
		if( randomIntRange( 0, 101 ) > 50 )
		{
			level thread aimActivateTarget( 0, 1 );
			level thread aimActivateTarget( 1, 1 );
		}
		else
		{
			level thread aimActivateTarget( 0, 2 );
			level thread aimActivateTarget( 1, 2 );
		}
		
		level waittill( "finish_aim" );
		
		if( player.completion_time > 0 && level.activ.completion_time > 0 )
		{
			if( player.completion_time < level.activ.completion_time )
			{
				iPrintLnBold( level.activ.name + " shot everything in " + level.activ.completion_time + " seconds" );
				iPrintLnBold( player.name + " shot everything in " + player.completion_time + " seconds" );
				iPrintLnBold( "^1>> ^2" + player.name + " ^7Wins ^1<<" );
				level.activ thread maps\mp\gametypes\_globallogic::callback_playerDamage( level.activ, player, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
			}
			else
			{
				iPrintLnBold( player.name + " shot everything in " + player.completion_time + " seconds" );
				iPrintLnBold( level.activ.name + " shot everything in " + level.activ.completion_time + " seconds" );
				iPrintLnBold( "^2>> ^1" + level.activ.name + " ^7Wins ^2<<" );
				player thread maps\mp\gametypes\_globallogic::callback_playerDamage( player, level.activ, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
			}
		}
		else
		{
			level waittill( "finish_aim" );
			
			if( player.completion_time > 0 && level.activ.completion_time > 0 )
			{
				if( player.completion_time < level.activ.completion_time )
				{
					iPrintLnBold( level.activ.name + " shot everything in " + level.activ.completion_time + " seconds" );
					iPrintLnBold( player.name + " shot everything in " + player.completion_time + " seconds" );
					iPrintLnBold( "^1>> ^2" + player.name + " ^7Wins ^1<<" );
					level.activ thread maps\mp\gametypes\_globallogic::callback_playerDamage( level.activ, player, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
				}
				else
				{
					iPrintLnBold( player.name + " shot everything in " + player.completion_time + " seconds" );
					iPrintLnBold( level.activ.name + " shot everything in " + level.activ.completion_time + " seconds" );
					iPrintLnBold( "^2>> ^1" + level.activ.name + " ^7Wins ^2<<" );
					player thread maps\mp\gametypes\_globallogic::callback_playerDamage( player, level.activ, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
				}
			}
			else if( level.activ.completion_time > 0 )
			{
				iPrintLnBold( level.activ.name + " shot everything in " + level.activ.completion_time + " seconds" );
				iPrintLnBold( "^2>> ^1" + level.activ.name + " ^7Wins ^2<<" );
				player thread maps\mp\gametypes\_globallogic::callback_playerDamage( player, level.activ, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
			}
			else if( player.completion_time > 0 )
			{
				iPrintLnBold( player.name + " shot everything in " + player.completion_time + " seconds" );
				iPrintLnBold( "^1>> ^2" + player.name + " ^7Wins ^1<<" );
				level.activ thread maps\mp\gametypes\_globallogic::callback_playerDamage( level.activ, player, 100, 0, "MOD_RIFLE_BULLET", "default", (0, 0, 0), (0, 0, 0), "default", 0 );
			}
			else
			{
				iPrintLnBold( "This is taking to long" );
				iPrintLnBold( "^2>> ^1" + level.activ.name + " ^7Survives ^2<<" );
				player suicide();
			}
		}
		
		for( i = 0; i < level.final_aim_bottles[0].size; i++ )
		{
			if( level.final_aim_bottles[0][i].origin[1] != level.final_aim_bottles_start_y )
				level.final_aim_bottles[0][i].origin = ( level.final_aim_bottles[0][i].origin[0], level.final_aim_bottles_start_y, level.final_aim_bottles[0][i].origin[2] );
			if( level.final_aim_bottles[1][i].origin[1] != level.final_aim_bottles_start_y )
				level.final_aim_bottles[1][i].origin = ( level.final_aim_bottles[1][i].origin[0], level.final_aim_bottles_start_y, level.final_aim_bottles[1][i].origin[2] );
			
			level.final_aim_bottles[0][i] linkTo( level.final_aim_obj[0][6] );
			level.final_aim_bottles[1][i] linkTo( level.final_aim_obj[1][6] );
		}
		
		level.final_aim_obj[0][6] rotateTo( level.final_aim_ang_norm_0, 0.25 );
		level.final_aim_obj[1][6] rotateTo( level.final_aim_ang_norm_1, 0.25 );
		
		level notify( "stop_aim_timer" );
	}
	
	if( !isAlive( level.activ ) )
		return;
	else if( level.all_vs_activator && ( !isDefined( level.finalist_first ) || ( isDefined( level.finalist_first ) && !isAlive( level.finalist_first ) ) ) && ( !isDefined( level.finalist_second ) || ( isDefined( level.finalist_second ) && !isAlive( level.finalist_second ) ) ) && ( !isDefined( level.finalist_third ) || ( isDefined( level.finalist_third ) && !isAlive( level.finalist_third ) ) ) )
		level thread vsActivatorAll();
	else if( isDefined( level.finalist_second ) && isAlive( level.finalist_second ) )
		level thread playersInRoom( level.finalist_second );
	else if( isDefined( level.finalist_third ) && isAlive( level.finalist_third ) )
		level thread playersInRoom( level.finalist_third );
	else if( isDefined( level.finalist_first ) && isDefined( level.jumper_first ) && level.finalist_first != level.jumper_first && isAlive( level.jumper_first ) )
	{
		level.finalists++;
		level thread playersInRoom( level.jumper_first );
	}
	else if( isDefined( level.finalist_second ) && isDefined( level.jumper_second ) && level.finalist_second != level.jumper_second && isAlive( level.jumper_second ) )
	{
		level.finalists++;
		level thread playersInRoom( level.jumper_second );
		level.finalist_second = level.jumper_second;
	}
	else if( isDefined( level.finalist_third ) && isDefined( level.jumper_third ) && level.finalist_third != level.jumper_third && isAlive( level.jumper_third ) )
	{
		level.finalists++;
		level thread playersInRoom( level.jumper_third );
		level.finalist_third = level.jumper_third;
	}
	else if( !isDefined( level.finalist_second ) )
	{
		level.finalist_second = getRandomJumperPlayers();
		
		if( isDefined( level.finalist_second ) && isAlive( level.finalist_second ) )
		{
			level.finalists++;
			level thread playersInRoom( level.finalist_second );
		}
	}
	else if( !isDefined( level.finalist_third ) )
	{
		level.finalist_third = getRandomJumperPlayers();
		
		if( isDefined( level.finalist_third ) && isAlive( level.finalist_third ) )
		{
			level.finalists++;
			level thread playersInRoom( level.finalist_third );
		}
	}
}

moveAndCheck( orig, time )
{
	target = self.origin + orig;
	self moveTo( target, time );
	
	wait time;
	if( self.origin != target )
		self.origin = target;
}

waitThenMove()
{
	wait 2;
	
	self thread moveAndCheck( (0,0,16), 3 );
}

rpsWaitOnDamage( type )
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	level endon( "end_rps_choice" );
	
	while(1)
	{
		self waittill( "damage", amount, player );
		
		if( !isDefined( player.rps_type ) && ( player == level.activ || player == level.finalist_first || player == level.finalist_second || player == level.finalist_third ) )
		{
			player notify( "rps_choice" );
			
			wait 0.05;
			player thread waitOnConfirmRps( type );
		}
		
		wait 0.05;
	}
}

waitOnConfirmRps( type )
{
	level endon( "game over" );
	level endon( "end_rps_choice" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	self endon( "rps_choice" );
	
	if( type == 1 )
		self iPrintLnBold( "Press [{+activate}] to confirm your choice for ^1Rock" );
	else if( type == 2 )
		self iPrintLnBold( "Press [{+activate}] to confirm your choice for ^1Paper" );
	else if( type == 3 )
		self iPrintLnBold( "Press [{+activate}] to confirm your choice for ^1Scissors" );

	while( !self useButtonPressed() )
		wait 0.05;
		
	while( self useButtonPressed() )
		wait 0.05;
		
	self.rps_type = type;
	self iPrintLnBold( "Choice ^2confirmed" );
}

tttWaitOnDamage( pos )
{
	level endon( "game over" );
	level endon( "end_ttt_choice" );
	level endon( "stop_ttt_pos_" + pos );
	
	while(1)
	{
		self waittill( "damage", amount, player );
		
		if( isDefined( player.ttt_turn ) && player.ttt_turn && ( player == level.activ || player == level.finalist_first || player == level.finalist_second || player == level.finalist_third ) )
		{
			player notify( "ttt_choice" );
			player thread waitOnConfirmTtt( pos );
		}
		
		wait 0.05;
	}
}

waitOnConfirmTtt( pos )
{
	level endon( "game over" );
	level endon( "end_ttt_choice" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	self endon( "ttt_choice" );
	
	if( self.ttt_location == 1 )
	{
		if( pos == 1 )
			position_name = "Top Left";
		else if( pos == 2 )
			position_name = "Top Center";
		else if( pos == 3 )
			position_name = "Top Right";
		else if( pos == 4 )
			position_name = "Middle Left";
		else if( pos == 5 )
			position_name = "Middle Center";
		else if( pos == 6 )
			position_name = "Middle Right";
		else if( pos == 7 )
			position_name = "Bottom Left";
		else if( pos == 8 )
			position_name = "Bottom Center";
		else
			position_name = "Bottom Right";
	}
	else
	{
		if( pos == 9 )
			position_name = "Top Left";
		else if( pos == 8 )
			position_name = "Top Center";
		else if( pos == 7 )
			position_name = "Top Right";
		else if( pos == 6 )
			position_name = "Middle Left";
		else if( pos == 5 )
			position_name = "Middle Center";
		else if( pos == 4 )
			position_name = "Middle Right";
		else if( pos == 3 )
			position_name = "Bottom Left";
		else if( pos == 2 )
			position_name = "Bottom Center";
		else
			position_name = "Bottom Right";
	}
	
	self iPrintLnBold( "Press [{+activate}] to confirm your choice for the ^1" + position_name + " ^7position" );
	
	while( !self useButtonPressed() )
		wait 0.05;
	
	while( self useButtonPressed() )
		wait 0.05;
	
	if( self.ttt_pos_confirmed )
		return;
	
	self.ttt_pos_confirmed = true;
	
	level.ttt_trigs_used[pos] = self.ttt_object;
	
	if( self.ttt_object == "X" )
		level.ttt_X[ pos ] moveTo( level.ttt_X[ pos ].origin + (0,0,16), 1 );
	else
		level.ttt_O[ pos ] moveTo( level.ttt_O[ pos ].origin + (0,0,16), 1 );
	
	level notify( "stop_ttt_pos_" + pos );
	
	self.ttt_pos[ self.ttt_total_positions ] = pos;
	self.ttt_total_positions ++;
	self iPrintLnBold( "Position ^2confirmed" );
}

tttYourTurn( opponent )
{
	level endon( "game over" );
	
	level.ttt_total_turns ++;
	
	self.ttt_turn = true;
	self.ttt_pos_confirmed = false;
	opponent.ttt_turn = false;
	opponent.ttt_pos_confirmed = false;
	
	self iPrintLnBold( "It is your turn for 10 seconds\n^1Shoot ^7where you want to place your " + self.ttt_object );
	
	for( i = 10; i > 0; i-- )
	{
		self iPrintLn( "Your turn will end in ^1" + i + " seconds" );
		
		wait 1;
		
		if( self.ttt_pos_confirmed )
			break;
		else if( !isAlive( self ) || !isAlive( opponent ) )
		{
			level.ttt_victory = "draw";
			
			level notify( "finish_ttt" );
			return;
		}
	}
	
	self notify( "ttt_choice" );
	
	if( !isAlive( self ) || !isAlive( opponent ) )
	{
		level.ttt_victory = "draw";
		
		level notify( "finish_ttt" );
		return;
	}
	else if( level.ttt_total_turns >= 5 )
	{
		if( ( isDefined( level.ttt_trigs_used[1] ) && isDefined( level.ttt_trigs_used[2] ) && isDefined( level.ttt_trigs_used[3] ) && level.ttt_trigs_used[1] == "X" && level.ttt_trigs_used[2] == "X" && level.ttt_trigs_used[3] == "X" ) || ( isDefined( level.ttt_trigs_used[4] ) && isDefined( level.ttt_trigs_used[5] ) && isDefined( level.ttt_trigs_used[6] ) && level.ttt_trigs_used[4] == "X" && level.ttt_trigs_used[5] == "X" && level.ttt_trigs_used[6] == "X" ) || ( isDefined( level.ttt_trigs_used[7] ) && isDefined( level.ttt_trigs_used[8] ) && isDefined( level.ttt_trigs_used[9] ) && level.ttt_trigs_used[7] == "X" && level.ttt_trigs_used[8] == "X" && level.ttt_trigs_used[9] == "X" ) )
		{
			level.ttt_victory = "X";
			level.ttt_victory_method = "horizontal";
		}
		else if( ( isDefined( level.ttt_trigs_used[1] ) && isDefined( level.ttt_trigs_used[2] ) && isDefined( level.ttt_trigs_used[3] ) && level.ttt_trigs_used[1] == "O" && level.ttt_trigs_used[2] == "O" && level.ttt_trigs_used[3] == "O" ) || ( isDefined( level.ttt_trigs_used[4] ) && isDefined( level.ttt_trigs_used[5] ) && isDefined( level.ttt_trigs_used[6] ) && level.ttt_trigs_used[4] == "O" && level.ttt_trigs_used[5] == "O" && level.ttt_trigs_used[6] == "O" ) || ( isDefined( level.ttt_trigs_used[7] ) && isDefined( level.ttt_trigs_used[8] ) && isDefined( level.ttt_trigs_used[9] ) && level.ttt_trigs_used[7] == "O" && level.ttt_trigs_used[8] == "O" && level.ttt_trigs_used[9] == "O" ) )
		{
			level.ttt_victory = "O";
			level.ttt_victory_method = "horizontal";
		}
		
		else if( ( isDefined( level.ttt_trigs_used[1] ) && isDefined( level.ttt_trigs_used[4] ) && isDefined( level.ttt_trigs_used[7] ) && level.ttt_trigs_used[1] == "X" && level.ttt_trigs_used[4] == "X" && level.ttt_trigs_used[7] == "X" ) || ( isDefined( level.ttt_trigs_used[2] ) && isDefined( level.ttt_trigs_used[5] ) && isDefined( level.ttt_trigs_used[8] ) && level.ttt_trigs_used[2] == "X" && level.ttt_trigs_used[5] == "X" && level.ttt_trigs_used[8] == "X" ) || ( isDefined( level.ttt_trigs_used[3] ) && isDefined( level.ttt_trigs_used[6] ) && isDefined( level.ttt_trigs_used[9] ) && level.ttt_trigs_used[3] == "X" && level.ttt_trigs_used[6] == "X" && level.ttt_trigs_used[9] == "X" ) )
		{
			level.ttt_victory = "X";
			level.ttt_victory_method = "vertical";
		}
		else if( ( isDefined( level.ttt_trigs_used[1] ) && isDefined( level.ttt_trigs_used[4] ) && isDefined( level.ttt_trigs_used[7] ) && level.ttt_trigs_used[1] == "O" && level.ttt_trigs_used[4] == "O" && level.ttt_trigs_used[7] == "O" ) || ( isDefined( level.ttt_trigs_used[2] ) && isDefined( level.ttt_trigs_used[5] ) && isDefined( level.ttt_trigs_used[8] ) && level.ttt_trigs_used[2] == "O" && level.ttt_trigs_used[5] == "O" && level.ttt_trigs_used[8] == "O" ) || ( isDefined( level.ttt_trigs_used[3] ) && isDefined( level.ttt_trigs_used[6] ) && isDefined( level.ttt_trigs_used[9] ) && level.ttt_trigs_used[3] == "O" && level.ttt_trigs_used[6] == "O" && level.ttt_trigs_used[9] == "O" ) )
		{
			level.ttt_victory = "O";
			level.ttt_victory_method = "vertical";
		}
		else if( isDefined( level.ttt_trigs_used[5] ) && level.ttt_trigs_used[5] == "X" && ( ( isDefined( level.ttt_trigs_used[1] ) && isDefined( level.ttt_trigs_used[9] ) && level.ttt_trigs_used[1] == "X" && level.ttt_trigs_used[9] == "X" ) || ( isDefined( level.ttt_trigs_used[3] ) && isDefined( level.ttt_trigs_used[7] ) && level.ttt_trigs_used[3] == "X" && level.ttt_trigs_used[7] == "X" ) ) )
		{
			level.ttt_victory = "X";
			level.ttt_victory_method = "diagonal";
		}
		else if( isDefined( level.ttt_trigs_used[5] ) && level.ttt_trigs_used[5] == "O" && ( ( isDefined( level.ttt_trigs_used[1] ) && isDefined( level.ttt_trigs_used[9] ) && level.ttt_trigs_used[1] == "O" && level.ttt_trigs_used[9] == "O" ) || ( isDefined( level.ttt_trigs_used[3] ) && isDefined( level.ttt_trigs_used[7] ) && level.ttt_trigs_used[3] == "O" && level.ttt_trigs_used[7] == "O" ) ) )
		{
			level.ttt_victory = "O";
			level.ttt_victory_method = "diagonal";
		}
		else
		{
			j = 0;
			for( i = 1; i < 10; i++ )
			{
				if( isDefined(  level.ttt_trigs_used[i] ) )
					j++;
			}
			
			if( j >= 9 )
				level.ttt_victory = "draw";
		}
		
		if( isDefined( level.ttt_victory ) )
		{
			level notify( "finish_ttt" );
			return;
		}
	}
	
	opponent thread tttYourTurn( self );
}

aimWaitOnDamage( side, num, pro )
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	level endon( "stop_aim_" + side + "_" + num + "_" + pro );
	
	while(1)
	{
		self waittill( "damage", amount, player );
		
		if( level.final_aim_active[ side ][ num ] && ( player == level.activ || player == level.finalist_first || player == level.finalist_second || player == level.finalist_third ) )
		{
			if( side == 0 )
				level.final_aim_obj[0][ num ] rotateTo( level.final_aim_ang_norm_0, 0.25 );
			else if( side == 1 )
				level.final_aim_obj[1][ num ] rotateTo( level.final_aim_ang_norm_1, 0.25 );
			
			if( num == 1 && !level.final_aim_active[ side ][2] )
				level thread aimActivateTarget( side, 2 );
			else if( num == 2 && !level.final_aim_active[ side ][1] )
				level thread aimActivateTarget( side, 1 );
			else if( level.final_aim_active[ side ][1] && level.final_aim_active[ side ][2] && ( num == 1 || num == 2 ) )
			{
				rand = randomIntRange( 0, 76 );
				
				if( rand <= 25 )
					next = 3;
				else if( rand <= 50 )
					next = 4;
				else
					next = 5;
				
				level thread aimActivateTarget( side, next );
			}
			else if( num == 3 && ( !level.final_aim_active[ side ][4] || !level.final_aim_active[ side ][5] ) )
			{
				if( !level.final_aim_active[ side ][4] && !level.final_aim_active[ side ][5] )
				{
					if( randomIntRange( 0, 101 ) > 50 )
						level thread aimActivateTarget( side, 4 );
					else
						level thread aimActivateTarget( side, 5 );
				}
				else if( !level.final_aim_active[ side ][4] )
					level thread aimActivateTarget( side, 4 );
				else if( !level.final_aim_active[ side ][5] )
					level thread aimActivateTarget( side, 5 );
			}
			else if( num == 4 && ( !level.final_aim_active[ side ][3] || !level.final_aim_active[ side ][5] ) )
			{
				if( !level.final_aim_active[ side ][3] && !level.final_aim_active[ side ][5] )
				{
					if( randomIntRange( 0, 101 ) > 50 )
						level thread aimActivateTarget( side, 3 );
					else
						level thread aimActivateTarget( side, 5 );
				}
				else if( !level.final_aim_active[ side ][3] )
					level thread aimActivateTarget( side, 3 );
				else if( !level.final_aim_active[ side ][5] )
					level thread aimActivateTarget( side, 5 );
			}
			else if( num == 5 && ( !level.final_aim_active[ side ][3] || !level.final_aim_active[ side ][4] ) )
			{
				if( !level.final_aim_active[ side ][3] && !level.final_aim_active[ side ][4] )
				{
					if( randomIntRange( 0, 101 ) > 50 )
						level thread aimActivateTarget( side, 3 );
					else
						level thread aimActivateTarget( side, 4 );
				}
				else if( !level.final_aim_active[ side ][3] )
					level thread aimActivateTarget( side, 3 );
				else if( !level.final_aim_active[ side ][4] )
					level thread aimActivateTarget( side, 4 );
			}
			else if( !level.final_aim_active[ side ][6] )
				level thread aimActivateTarget( side, 6 );
			
			self playSound( "killhouse_target_up" );
			
			if( pro )
			{
				level notify( "stop_aim_" + side + "_" + num + "_0" );
				
				player.pro_hits++;
				
				if( player.pro_hits >= 5 )
					player iPrintLn( "^2Total pro shots: " + player.pro_hits );
				else if( player.pro_hits >= 3 )
					player iPrintLn( "^3Total pro shots: " + player.pro_hits );
				else
				{
					player iPrintLn( "Total pro shots: " + player.pro_hits );
					player iPrintLn( "^33 Pro shots = 1 bottle less" );
					player iPrintLn( "^25 Pro shots = 3 bottles less" );
				}
			}
			else
			{
				level notify( "stop_aim_" + side + "_" + num + "_1" );
				player iPrintLn( "^1Hit" );
			}
			
			break;
		}
		
		wait 0.05;
	}
}

aimActivateTarget( side, num )
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	if( level.final_aim_active[ side ][ num ] )
		return;
	
	level.final_aim_active[ side ][ num ] = true;
	
	if( side == 0 )
		level.final_aim_obj[0][ num ] rotateTo( level.final_aim_ang_hitme_0, 0.25 );
	else
		level.final_aim_obj[1][ num ] rotateTo( level.final_aim_ang_hitme_1, 0.25 );
	
	level.final_aim_obj[ side ][ num ] playSound( "killhouse_target_up" );
	
	if( num != 6 )
	{
		level.final_aim_trigs[ side ][ num ] thread aimWaitOnDamage( side, num, false );
		level.final_aim_trigs_pro[ side ][ num ] thread aimWaitOnDamage( side, num, true );
	}
	else
	{
		wait 0.3;
		
		for( i = 0; i < 8; i++ )
			level.final_aim_bottles[ side ][i] unLink();
		
		for( i = 0; i < level.final_aim_trigs_6[ side ].size; i++ )
		{
			level.final_aim_trigs_6[ side ][i] enableLinkTo();
			level.final_aim_trigs_6[ side ][i] linkTo( level.final_aim_bottles[ side ][i] );
		}
		
		rand = randomIntRange( 0, 6 );
		
		switch( rand )
		{
			case "0":
				obj_1 = 0;
				obj_2 = 2;
				break;
			case "1":
				obj_1 = 0;
				obj_2 = 4;
				break;
			case "2":
				obj_1 = 0;
				obj_2 = 6;
				break;
			case "3":
				obj_1 = 2;
				obj_2 = 4;
				break;
			case "4":
				obj_1 = 2;
				obj_2 = 6;
				break;
			
			default:
				obj_1 = 4;
				obj_2 = 6;
				break;
		}
		
		level thread aimMoveBottles( side, obj_1 );
		level thread aimMoveBottles( side, obj_2 );
	}
}

aimMoveBottles( side, num )
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	level endon( "stop_aim_bottle_" + side + "_" + num );
	
	level.final_aim_bottles[ side ][ num ].moving = true;
	
	x = level.final_aim_bottles[ side ][ num ].origin[0];
	z = level.final_aim_bottles[ side ][ num ].origin[2];
	
	level.final_aim_trigs_6[ side ][ num ] thread aimBottleWaitOnDamage( side, num, ( x, level.final_aim_bottles_start_y, z ) );
	
	while(1)
	{	
		time = randomIntRange( 6, 12 );
		
		if( level.final_aim_bottles[ side ][ num ].got_hit )
			break;
		
		level.final_aim_bottles[ side ][ num ] moveTo( ( x, level.final_aim_bottles_end_y, z ), time );
		wait time;
		
		if( level.final_aim_bottles[ side ][ num ].got_hit )
			break;
		
		level.final_aim_bottles[ side ][ num ].origin = ( x, level.final_aim_bottles_start_y, z );
		
		wait 2;
	}
}

aimTimer()
{
	level endon( "stop_aim_timer" );
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	level.aim_timer = 0;
	
	while(1)
	{
		level.aim_timer += 0.05;
		wait 0.05;
	}
}

aimTimeLimit()
{
	level endon( "stop_aim_timer" );
	
	wait 59;
	level notify( "finish_aim" );
	wait 1;
	level notify( "finish_aim" );
}

aimBottleWaitOnDamage( side, num, start_orig )
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	while(1)
	{
		self waittill( "damage", amount, player );
		
		if( level.final_aim_active[ side ][6] && ( player == level.activ || player == level.finalist_first || player == level.finalist_second || player == level.finalist_third ) )
		{
			level notify( "stop_aim_bottle_" + side + "_" + num );
			level.final_aim_bottles[ side ][ num ].got_hit = true;
			level.final_aim_bottles[ side ][ num ].origin = start_orig;
			
			player.bottles_shot++;
			
			if( player.bottles_shot >= 8 || ( player.bottles_shot >= 5 && player.pro_hits >= 5 ) || ( player.bottles_shot >= 7 && player.pro_hits >= 3 ) )
			{
				player.completion_time = level.aim_timer;
				
				level notify( "finish_aim" );
				
				for( i = 0; i < level.final_aim_bottles[ side ].size; i++ )
					level.final_aim_bottles[ side ][i] linkTo( level.final_aim_obj[ side ][6] );
				
				if( side == 0 )
					level.final_aim_obj[0][6] rotateTo( level.final_aim_ang_norm_0, 0.25 );
				else if( side == 1 )
					level.final_aim_obj[1][6] rotateTo( level.final_aim_ang_norm_1, 0.25 );
				
				break;
			}
			
			j = 0;
			possible = [];
			
			for( i = 0; i < level.final_aim_bottles[ side ].size; i++ )
			{
				k = undefined;
				
				if( isDefined( level.final_aim_bottles[ side ][i] ) && !level.final_aim_bottles[ side ][i].moving && !level.final_aim_bottles[ side ][i].got_hit )
					k = i;
				
				if( isDefined( k ) )
				{
					possible[j] = k;
					j++;
				}
			}
			
			next_num = randomInt( possible.size );
			level thread aimMoveBottles( side, possible[ next_num ] );
			
			break;
		}
	}
}

aimAmmoCrate()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	while(1)
	{
		self waittill( "trigger", player );
		
		if( player == level.activ || player == level.finalist_first || player == level.finalist_second || player == level.finalist_third )
		{
			current_weapon = player getCurrentWeapon();
			
			if( player getWeaponAmmoStock( current_weapon ) < weaponMaxAmmo( current_weapon ) )
			{
				player giveMaxAmmo( current_weapon );
				player iPrintLn( "^2Maximum ammo" );
				player playSound( "weap_pickup" );
			}
		}
		
		wait 0.05;
	}
}

aimWeaponWaitOnDamage( weapon_num )
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	while(1)
	{
		self waittill( "damage", amount, player );
		
		if( player == level.activ || player == level.finalist_first || player == level.finalist_second || player == level.finalist_third )
		{
			weapon = level.final_aim_weapons[ weapon_num ];
			
			if( !player hasWeapon( weapon ) )
			{
				player takeAllWeapons();
				player giveWeapon( weapon );
				player giveMaxAmmo( weapon );
				player setWeaponAmmoClip( weapon, 0 );
				player switchToWeapon( weapon );
			}
		}
		
		wait 0.05;
	}
}

getRandomJumperPlayers()
{
	level endon( "game over" );
	
	aliveJumpers = [];
	
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		
		if ( !isDefined( player ) || !isAlive( player ) || player.pers["team"] != "allies" )
			continue;
		
		aliveJumpers[ aliveJumpers.size ] = player;
	}
	
	if( aliveJumpers.size > 0 )
	{
		randomJumper = aliveJumpers[ randomInt( aliveJumpers.size ) ];
		
		iPrintLnBold( randomJumper.name + " is randomly picked as finalist" );
		
		return randomJumper;
	}
}

vsActivatorAll()
{
	level endon( "game over" );
	level notify( "all_vs_activator" );
	
	if( level.battle_type == 1 )
	{
		level.bullet_block delete();
		level.battle_ttt_stand delete();
	}
	else if( level.battle_type == 2 )
		level.wall_middle delete();
	else if( level.battle_type == 3 )
	{
		for( i = 0; i < level.final_aim_area.size; i++ )
			level.final_aim_area[i] delete();
		
		level.bullet_block delete();
		level.wall_middle delete();
	}
	
	part1 = getEnt( "end_room_close", "targetname" );
	part2 = getEnt( "end_room_2", "targetname" );
	part3 = getEnt( "end_room_3", "targetname" );
	
	part1 thread moveAndCheck( (0,0,976), 3 );
	part2 thread moveAndCheck( (0,0,-736), 3 );
	part3 thread moveAndCheck( (32,112,76), 3 );
	
	iPrintLnBold( "This is taking to long" );
	iPrintLnBold( "^1>> ^2All jumpers ^7VS ^1Activator ^1<<" );
	
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		if( !isAlive( players[i] ) )
			continue;
		
		if( players[i] != level.activ )
		{
			spawnPoint = level.spawns_final[ players[i] GetEntityNumber() ];
			
			if( !isDefined( spawnPoint ) )
				spawnPoint = level.spawns_final[ randomInt( level.spawns_final.size ) ];
			
			players[i] spawn( spawnPoint.origin, spawnPoint.angles );
			
			if( isDefined( players[i].slow_noob ) && players[i].slow_noob )
			{
				players[i].slow_noob = false;
				
				if( isDefined( level.dvar["allies_speed"] ) )
					players[i] setMoveSpeedScale( level.dvar["allies_speed"] );
				else
					players[i] setMoveSpeedScale( 1 );
			}
			
			if( isDefined( self.weaponsDisabled ) && self.weaponsDisabled )
				self.weaponsDisabled = false;
		}
		else if( players[i] == level.activ )
		{
			spawnPoint = level.spawn_battle[1];
			players[i] spawn( spawnPoint.origin, spawnPoint.angles );
		}
		
		players[i] takeAllWeapons();
		players[i] allowJump( false );
		players[i] freezeControls( true );
		
		players[i] giveWeapon( "knife_mp" );
		players[i] setSpawnWeapon( "knife_mp" );
	}
	
	wait 1;
	
	iPrintLnBold( "^1>> 3 ^1<<" );
	wait 1;
	iPrintLnBold( "^1>> ^32 ^1<<" );
	wait 1;
	iPrintLnBold( "^1>> ^21 ^1<<" );
	wait 1;
	iPrintLnBold( "^1>> ^2Start ^1<<" );
	
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		if( !isAlive( players[i] ) )
			continue;
		
		players[i] allowJump( true );
		players[i] freezeControls( false );
	}
}

setupServers()
{
	serv_sniper = getEnt( "server_sniper", "targetname" );
	serv_sd1 = getEnt( "server_sd1", "targetname" );
	serv_sd2 = getEnt( "server_sd2", "targetname" );
	serv_tdm = getEnt( "server_tdm", "targetname" );
	serv_hc = getEnt( "server_hc", "targetname" );
	
	serv_sniper thread serverTrigger( "cod4.novacrew.nl:28961", "PromodLive ^1Sniper ^5Fun" );
	serv_sd1 thread serverTrigger( "cod4.novacrew.nl:28965", "PromodLive ^7SD ^3#1" );
	serv_sd2 thread serverTrigger( "cod4.novacrew.nl:29181", "PromodLive ^7SD ^3#2" );
	serv_tdm thread serverTrigger( "cod4.novacrew.nl:29881", "PromodLive ^7TDM" );
	serv_hc thread serverTrigger( "cod4.novacrew.nl:28960", "HardCore ^1Sniper ^5Fun" );
}

serverTrigger( ip, name )
{
	level endon( "game over" );
	
	while(1)
	{
		self waittill( "trigger", player );
		
		if( !isDefined( player.server_name ) || player.server_name != name  )
		{
			player notify( "change_server" );
			wait 0.05;
			
			player.server_name = name;
			player thread serverMessage( ip, name );
		}
		else
			player notify( "server_choice" );
		
		wait 0.05;
	}
}

serverMessage( ip, name )
{
	level endon( "game over" );
	self endon( "disconnect" );
	self endon( "change_server" );
	
	self iPrintLnBold( "If you want to join the\n^2NovaCrew ^3" + name + " ^7Server shoot it 2 times" );
	
	while(1)
	{
		self waittill( "server_choice" );
		
		self iPrintLnBold( "Shoot it once more to join the\n^2NovaCrew ^3" + name + " ^7Server" );
		self iPrintLn( "Thanks to ^2[Nova]DuTchBlooD ^7for making the picture" );
		
		self waittill( "server_choice" );
		
		self setClientDvar( "clientcmd", "disconnect; wait 50; connect " + ip );
		self openMenu( "clientcmd" );
		
		iPrintLn( "^1" + self.name + " ^7joined the ^2NovaCrew ^3" + name + " ^7Server" );
	}
}

setupElevator1()
{
	level.elevator_time = 3;
	level thread speedElevator1();
	
	part1 = getEnt( "elevator_1_1", "targetname" );
	part2 = getEnt( "elevator_1_2", "targetname" );
	part3 = getEnt( "elevator_1_3", "targetname" );
	part4 = getEnt( "elevator_1_4", "targetname" );
	
	pos[0] = part1.origin;
	pos[1] = ( part1.origin[0], ( part1.origin[1] + part2.origin[1] ) / 2, ( part1.origin[2] + part2.origin[2] ) / 2 - 25 );
	pos[2] = part2.origin;
	pos[3] = ( part1.origin[0], ( part2.origin[1] + part3.origin[1] ) / 2, ( part2.origin[2] + part3.origin[2] ) / 2 + 25 );
	pos[4] = part3.origin;
	pos[5] = ( part1.origin[0], ( part3.origin[1] + part4.origin[1] ) / 2, ( part3.origin[2] + part4.origin[2] ) / 2 + 25 );
	pos[6] = part4.origin;
	pos[7] = ( part1.origin[0], ( part4.origin[1] + part1.origin[1] ) / 2, ( part4.origin[2] + part1.origin[2] ) / 2 - 25 );
	
	while(1)
	{
		for( i = 0; i < pos.size; i++ )
		{
			j = i + 2;
			k = i + 4;
			l = i + 6;

			if( l == pos.size + 6 )
			{
				l = 6;
				k = 4;
				j = 2;
			}
			else if( l == pos.size + 5 )
			{
				l = 5;
				k = 3;
				j = 1;
			}
			else if( l == pos.size + 4 )
			{
				l = 4;
				k = 2;
				j = 0;
			}
			else if( l == pos.size + 3 )
			{
				l = 3;
				k = 1;
			}
			else if( l == pos.size + 2 )
			{
				l = 2;
				k = 0;
			}
			else if( l == pos.size + 1 )
				l = 1;
			else if( l == pos.size )
				l = 0;

			part1 moveTo( pos[i], level.elevator_time );
			part2 moveTo( pos[j], level.elevator_time );
			part3 moveTo( pos[k], level.elevator_time );
			part4 moveTo( pos[l], level.elevator_time );
			
			wait level.elevator_time - 0.1;
		}
	}
}

speedElevator1()
{
	level.elevator1_parts = [];
	level.elevator1_places = [];	
	
	while( isDefined( getEnt( "escalator_1_num_" + level.elevator1_parts.size, "targetname" ) ) )
	{
		level.elevator1_parts[ level.elevator1_parts.size ] = getEnt( "escalator_1_num_" + level.elevator1_parts.size, "targetname" );
		level.elevator1_places[ level.elevator1_parts.size - 1 ] = spawnStruct();
		level.elevator1_places[ level.elevator1_parts.size - 1 ].normal_origin = level.elevator1_parts[ level.elevator1_parts.size - 1 ].origin;
	}
	
	level thread numbersElevator1( "0,1,2,4,5,6,12,13" );
	
	use = getEnt( "escalator_1_use", "targetname" );
	
	while(1)
	{
		use waittill( "trigger", player );
		
		use playSound( "ui_pulse_text_type" );
		
		level.elevator_time -= 0.2;
		
		if( level.elevator_time < 1 )
			level.elevator_time = 3;
		
		if( level.elevator_time == 1.2 )
			level thread numbersElevator1( "5,6,7,8,9,11,12,13" );
		else if( level.elevator_time == 1.4 )
			level thread numbersElevator1( "0,1,2,4,5,6,8,9,10,11,12,13" );
		else if( level.elevator_time == 1.6 )
			level thread numbersElevator1( "0,1,2,4,5,6,7,8,9,10,11,12,13" );
		else if( level.elevator_time == 1.8 )
			level thread numbersElevator1( "0,1,2,4,5,6,10,11,12,13" );
		else if( level.elevator_time == 2 )
			level thread numbersElevator1( "0,1,2,4,5,6,7,8,9,10,11,12" );
		else if( level.elevator_time == 2.2 )
			level thread numbersElevator1( "0,1,2,4,5,6,8,9,10,11,12" );
		else if( level.elevator_time == 2.4 )
			level thread numbersElevator1( "0,1,2,4,5,6,8,10,12,13" );
		else if( level.elevator_time == 2.6 )
			level thread numbersElevator1( "0,1,2,4,5,6,9,10,11,12,13" );
		else if( level.elevator_time == 2.8 )
			level thread numbersElevator1( "0,1,2,4,5,6,7,9,10,11,13" );
		else
			level thread numbersElevator1( "0,1,2,4,5,6,12,13" );
		
		wait .5;
	}
}

numbersElevator1( array )
{
	nums = strTok( array, "," );

	level notify( "elevator_1_change_speed" );
	
	wait 0.05;
	
	for( i = 0; i < nums.size; i++ )
		level.elevator1_parts[ int( nums[i] ) ].origin = level.elevator1_parts[ int( nums[i] ) ].origin + (0,4,0);
	
	level waittill( "elevator_1_change_speed" );
	
	for( i = 0; i < nums.size; i++ )
		level.elevator1_parts[ int( nums[i] ) ].origin = level.elevator1_places[ int( nums[i] ) ].normal_origin;
}

setupEscalator1()
{
	level.escalator_time = 0.5;
	
	level.escalator_parts = [];
	level.escalator_places = [];
	
	while( isDefined( getEnt( "escalator_1_" + level.escalator_parts.size, "targetname" ) ) )
	{
		level.escalator_parts[ level.escalator_parts.size ] = getEnt( "escalator_1_" + level.escalator_parts.size, "targetname" );
		level.escalator_places[ level.escalator_parts.size - 1 ] = spawnStruct();
		level.escalator_places[ level.escalator_parts.size - 1 ].origin = level.escalator_parts[ level.escalator_parts.size - 1 ].origin;
		level.escalator_places[ level.escalator_parts.size - 1 ].angles = level.escalator_parts[ level.escalator_parts.size - 1 ].angles;
	}
	
	for( i = 0; i < level.escalator_parts.size - 1; i++ )
		level.escalator_parts[i] thread moveEscalator( i );
}

moveEscalator( current )
{
	while(1)
	{
		while( current < level.escalator_places.size - 1 )
		{
			if( current < 8 )
			{
				new = 8;
				
				self moveTo( level.escalator_places[ new ].origin, level.escalator_time * ( new - current ) );
				self rotateTo( level.escalator_places[ new ].angles, level.escalator_time * ( new - current ) );
				
				wait level.escalator_time * ( new - current );
				current += ( new - current );
			}
			else if( current < 43 )
			{
				new = 43;
				self moveTo( level.escalator_places[ new ].origin, level.escalator_time * ( new - current ) );
				self rotateTo( level.escalator_places[ new ].angles, level.escalator_time * ( new - current ) );
				
				wait level.escalator_time * ( new - current );
				current += ( new - current );
			}
			else if( current < 44 )
			{
				new = 44;
				self moveTo( level.escalator_places[ new ].origin, level.escalator_time * ( new - current ) );
				self rotateTo( level.escalator_places[ new ].angles, level.escalator_time * ( new - current ) );
				
				wait level.escalator_time * ( new - current );
				current += ( new - current );
			}
			else if( current < 52 )
			{
				new = 52;
				self moveTo( level.escalator_places[ new ].origin, level.escalator_time * ( new - current ) );
				self rotateTo( level.escalator_places[ new ].angles, level.escalator_time * ( new - current ) );
				
				wait level.escalator_time * ( new - current );
				current += ( new - current );
			}
			else
			{
				self moveTo( level.escalator_places[ current + 1 ].origin, level.escalator_time );
				self rotateTo( level.escalator_places[ current + 1 ].angles, level.escalator_time );
				
				wait level.escalator_time;
				current++;
			}
		}
		
		current = 0;
		self.origin = level.escalator_places[current].origin;
		self.angles = level.escalator_places[current].angles;
	}
}

setupHoverBeamLights()
{
	wait 1;
	
	beam = getEnt( "hover_beam_lights", "targetname" );
	models = getEntArray( "hover_beam_light_models", "targetname" );
	lights = getEntArray( "hover_beam_lightsources", "targetname" );
	blades = getEntArray( "chopper_blades_lights", "targetname" );
	
	for( i = 0; i < models.size; i++ )
		models[i] linkTo( beam );
	
	for( i = 0; i < lights.size; i++ )
		lights[i] linkTo( beam );
	
	beam thread moveUpAndDown( blades );
	
	for( i = 0; i < blades.size; i++ )
		blades[i] rotateYaw( level.spin_time * 36000, level.spin_time * 60 );	
}

setupHoverBeam()
{
	beam = getEnt( "hover_beam", "targetname" );
	blades = getEntArray( "chopper_blades", "targetname" );
	
	beam thread moveUpAndDown( blades );
	
	for( i = 0; i < blades.size; i++ )
		blades[i] rotateYaw( level.spin_time * 36000, level.spin_time * 60 );	
}

moveUpAndDown( blades )
{
	zNormal = self.origin[2];
	
	while(1)
	{
		time = randomFloatRange( 1.5, 3.0 );
		distance = randomIntRange( 12, 20 );
		distance_blades = distance + randomIntRange( -2, 3 );
		
		self moveZ( distance, time, 0.5, 0.5 );
		for( i = 0; i < blades.size; i++ )
			blades[i] moveZ( distance_blades, time, 0.5, 0.5 );
		
		wait time;
		
		self moveTo( ( self.origin[0], self.origin[1], zNormal ), time, 0.5, 0.5 );
		for( i = 0; i < blades.size; i++ )
			blades[i] moveTo( ( blades[i].origin[0], blades[i].origin[1], zNormal ), time, 0.5, 0.5 );
		
		wait time;
	}
}

setupNoobPath()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	slow = getEnt( "set_speed_slow", "targetname" );
	normal = getEntArray( "set_speed_normal", "targetname" );
	
	for( i = 0; i < normal.size; i++ )
		normal[i] thread setNoobNormalSpeed();
	
	while(1)
	{
		slow waittill( "trigger", player );
		
		if( !isDefined( player.slow_noob ) || ( isDefined( player.slow_noob ) && !player.slow_noob ) )
		{
			player.slow_noob = true;
			player setMoveSpeedScale( 0.3 );
			
			player iPrintLnBold( "Set speed to ^1noob" );
		}
		
		wait 0.1;
	}
}

setNoobNormalSpeed()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	while(1)
	{
		self waittill( "trigger", player );
		
		if( isDefined( player.slow_noob ) && player.slow_noob )
		{
			player.slow_noob = false;
			
			if( isDefined( level.dvar["allies_speed"] ) )
				player setMoveSpeedScale( level.dvar["allies_speed"] );
			else
				player setMoveSpeedScale( 1 );
			
			player iPrintLnBold( "Set speed to ^2normal" );
		}
		
		wait 0.1;
	}
}

setupTriggerJumpers()
{
	level endon( "game over" );
	
	trigger = getEnt( "jumpers_trigger", "targetname" );
	blocker1 = getEnt( "blocker_1_1", "targetname" );
	blocker2 = getEnt( "blocker_1_2", "targetname" );
	
	blocker2 enableLinkTo();
	blocker2 linkTo( blocker1 );
	
	trigger waittill( "trigger", player );
	trigger delete();
	
	level.use_1 delete();
	level.use_2 delete();
	
	blocker1 moveTo( blocker1.origin - (0,0,50), 3 );
	
	wait 3;
	
	blocker1 delete();
	blocker2 delete();
	
	part1 = getEnt( "trap_1_1", "targetname" );
	part2 = getEnt( "trap_1_2", "targetname" );
	part3 = getEnt( "trap_2_1", "targetname" );
	part4 = getEnt( "trap_2_2", "targetname" );
	platform1 = getEnt( "platform_1_1", "targetname" );
	platform2 = getEnt( "platform_1_2", "targetname" );
	blocker = getEnt( "platform_blocker", "targetname" );
	blocker_kill = getEnt( "platform_blocker_kill", "targetname" ); // test
	
	time = 8;
	
	if( !level.freeRun )
	{
		part1 moveTo( part1.origin - (0,0,400), time / 2 );
		part2 moveTo( part2.origin - (0,0,400), time / 2 );
		part3 moveTo( part3.origin - (0,0,400), time / 2 );
		part4 moveTo( part4.origin - (0,0,400), time / 2 );
		
		wait time / 2;
		
		part1 delete();
		part2 delete();
		part3 delete();
		part4 delete();
		
		level thread trap1Part3();
		
		blocker_kill enableLinkTo();
		blocker_kill linkTo( blocker );
		
		blocker moveTo( blocker.origin + (646,0,0), 1 );
		
		wait 1;
	}
	
	platform1 moveTo( platform1.origin + (0,0,560), time / 2 );
	platform2 moveTo( platform2.origin + (0,0,560), time / 2 );
	
	wait time / 2;
	origin1_1 = platform1.origin;
	origin1_2 = platform1.origin + (520,0,0);
	origin2_1 = platform2.origin;
	origin2_2 = platform2.origin - (520,0,0);
	
	while(1)
	{
		platform1 moveTo( origin1_2, time );
		platform2 moveTo( origin2_2, time );
		wait time - 0.1;
		platform1 moveTo( origin1_1, time );
		platform2 moveTo( origin2_1, time );
		wait time - 0.1;
	}
}

setupTriggerFlesh1()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	kill = getEnt( "flesh_1_kill", "targetname" );
	trigger = getEnt( "flesh_1_trigger", "targetname" );
	destroy = getEnt( "flesh_1_destroy", "targetname" );
	
	start_origin = destroy.origin;
	
	kill enableLinkTo();
	kill linkTo( destroy );
	
	while(1)
	{
		trigger waittill( "damage", amount, player );
		
		destroy rotateTo( (0,0,-90), 0.5 );
		destroy moveTo( ( destroy.origin[0], destroy.origin[1] + 35, destroy.origin[2] - 35 ), 0.5 );
		destroy playSound( "melee_knife_hit_body" );
		playFx( level._effect[ "blood" ], destroy.origin );
		
		player iPrintLnBold( "Be fast, the flesh will grow back" );
		
		wait 5;
		destroy.origin = ( start_origin[0], start_origin[1], destroy.origin[2] - 30 );
		destroy.angles = (0,0,0);
		destroy moveTo( start_origin, 4 );
		destroy waittill( "movedone" );
	}
}

setupTriggerFlesh2()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	kill = getEnt( "flesh_2_kill", "targetname" );
	trigger = getEnt( "flesh_2_trigger", "targetname" );
	destroy = getEnt( "flesh_2_destroy", "targetname" );
	
	start_origin = destroy.origin;
	
	kill enablelinkto();
	kill linkto( destroy );
	
	while(1)
	{
		trigger waittill( "damage", amount, player );
		
		destroy RotateTo( (0,0,90), 0.5 );
		destroy MoveTo( ( destroy.origin[0], destroy.origin[1] - 35, destroy.origin[2] - 35 ), 0.5 );
		destroy playSound( "melee_knife_hit_body" );
		playFx( level._effect[ "blood" ], destroy.origin );
		
		player iPrintLnBold( "Be fast, the flesh will grow back" );
		
		wait 5;
		destroy.origin = ( start_origin[0], start_origin[1], destroy.origin[2] - 30 );
		destroy.angles = (0,0,0);
		destroy MoveTo( start_origin, 4 );
		destroy waittill( "movedone" );
	}
}

setupTriggerTouch1()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	trigger = getEnt( "touch_1", "targetname" );
	
	while(1)
	{
		trigger waittill( "trigger", player );
		
		if( !isDefined( player.weaponsDisabled ) || !player.weaponsDisabled )
			player thread disablePlayerWeapons();
		
		wait 0.05;
	}
}

disablePlayerWeapons()
{
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	
	self.weaponsDisabled = true;
	self.weaponSaved = self getCurrentWeapon();
	
	self takeAllWeapons();
	self giveWeapon( "knife_mp" );
	
	self thread dieOrTouchTrig();
	
	if( self.weaponSaved != "knife_mp" )
		self iPrintLnBold( "It is to small here, you can not use your guns." );
	
	self iPrintLnBold( "You can not breath here, you have ^130 seconds before you die" );
	
	wait 0.05;
	self switchToWeapon( "knife_mp" );
	
	self waittill( "death" );
	
	if( self.weaponsDisabled )
		self.weaponsDisabled = false;
}

dieOrTouchTrig()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "joined_spectators" );
	
	wait 30;
	
	if( self.weaponsDisabled )
	{
		self suicide();
		self iPrintLnBold( "You ^1died ^7of suffocation" );
	}
}

setupTriggerTouch2()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	trigger = getEnt( "touch_2", "targetname" );
	
	while(1)
	{
		trigger waittill( "trigger", player );
		
		if( isDefined( player.weaponsDisabled ) && player.weaponsDisabled )
			player thread enablePlayerWeapons();
		
		wait 0.05;
	}
}

enablePlayerWeapons()
{
	self.weaponsDisabled = false;
	
	if( isDefined( self.weaponSaved ) && self.weaponSaved != "knife_mp" && ( !isDefined( level.trapsDisabled ) || ( isDefined( level.trapsDisabled ) && !level.trapsDisabled ) ) )
	{
		self takeAllWeapons();
		
		self giveWeapon( self.weaponSaved );
		self giveMaxAmmo( self.weaponSaved );
		
		wait 0.05;
		self switchToWeapon( self.weaponSaved );
		
		self iPrintLnBold( "Here is enough space to use your guns" );
	}
}

setupTrap1()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	part1 = getEnt( "trap_1_1", "targetname" );
	part2 = getEnt( "trap_1_2", "targetname" );
	
	level.use_1 = getEnt( "use_1", "targetname" );
	level.use_1 waittill( "trigger", player );
	
	level.use_1 delete();
	if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
	{
		if( level.trapsDisabledMessage )
		{
			iPrintLn( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLn( "He tried to activate a trap in a free round" );
		}
		else
		{
			level.trapsDisabledMessage = true;
			
			iPrintLnBold( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLnBold( "He tried to activate a trap in a free round" );
		}
		
		return;
	}
	
	wait 2;
	
	part1 rotateRoll( -70, 5 );
	part2 rotateRoll( 70, 5 );
	
	level thread trap1Part3();
}

trap1Part3()
{
	if( isDefined( level.trap1_part3_moving ) && level.trap1_part3_moving )
		level waittill( "trap1_part3_stopped" );
	
	level.trap1_part3_moving = true;
	part3 = getEnt( "trap_1_3", "targetname" );
	
	origin1 = part3.origin + (0,640,0);
	origin2 = part3.origin;
	
	time = 10;
	
	part3 moveTo( origin1, time );
	
	wait time;
	part3 moveTo( origin2, time );
	
	level.trap1_part3_moving = false;
	level notify( "trap1_part3_stopped" );
}

setupTrap2()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	part = getEnt( "trap_2_1", "targetname" );
	
	level.use_2 = getEnt( "use_2", "targetname" );
	level.use_2 waittill( "trigger", player );
	
	level.use_2 delete();
	if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
	{
		if( level.trapsDisabledMessage )
		{
			iPrintLn( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLn( "He tried to activate a trap in a free round" );
		}
		else
		{
			level.trapsDisabledMessage = true;
			
			iPrintLnBold( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLnBold( "He tried to activate a trap in a free round" );
		}
		
		return;
	}
	
	part rotateRoll( 0 - 180, 10 );
	wait randomIntRange( 15, 21 );
	
	part rotateRoll( 0 - 180, 10 );
}

setupTrap3()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	trap3_info = getEnt( "trap_3_info", "targetname" );
	
	trap3_objects = [];
	while( isDefined( getEnt( "trap_3_object_" + trap3_objects.size, "targetname" ) ) )
		trap3_objects[ trap3_objects.size ] = getEnt( "trap_3_object_" + trap3_objects.size, "targetname" );
	
	level.trap3_triggers = [];
	while( isDefined( getEnt( "trap_3_trigger_" + level.trap3_triggers.size, "targetname" ) ) )
		level.trap3_triggers[ level.trap3_triggers.size ] = getEnt( "trap_3_trigger_" + level.trap3_triggers.size, "targetname" );
	
	use = getEnt( "use_3", "targetname" );
	use waittill( "trigger", player );
	
	use delete();
	if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
	{
		if( level.trapsDisabledMessage )
		{
			iPrintLn( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLn( "He tried to activate a trap in a free round" );
		}
		else
		{
			level.trapsDisabledMessage = true;
			
			iPrintLnBold( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLnBold( "He tried to activate a trap in a free round" );
		}
		
		return;
	}
	
	trap3_info setHintString( "Look on the right to see the solution of the maze. Avoid the ^1red ^7spots" );
	
	for( i = 0; i < trap3_objects.size; i++ )
	{
		trap3_objects[i].start_orig = trap3_objects[i].origin;
		level.trap3_triggers[i] thread activateTriggersTrap3( trap3_objects[i] );
	}
	
	option = randomIntRange( 0, 24 );
	
	if( option == 0 )
		level thread deleteTriggersTrap3( "0,4,5,6,12,17,18,19,13,8,9,10,14,21,25,32,31,30,35,41,40,39,34,28,27,26,33,37,44" );
	else if( option == 1 )
		level thread deleteTriggersTrap3( "1,6,7,8,9,10,14,21,25,32,31,30,24,19,18,17,23,28,27,26,33,37,38,39,40,41,46" );
	else if( option == 2 )
		level thread deleteTriggersTrap3( "1,6,7,8,9,10,14,21,20,19,24,30,29,28,23,17,16,15,22,26,33,37,38,39,45" );
	else if( option == 3 )
		level thread deleteTriggersTrap3( "3,10,14,21,20,19,13,8,7,6,12,17,23,28,29,30,35,41,40,39,38,37,44" );
	else if( option == 4 )
		level thread deleteTriggersTrap3( "0,4,5,6,12,17,18,19,24,30,31,32,36,43,47" );
	else if( option == 5 )
		level thread deleteTriggersTrap3( "3,10,9,8,13,19,20,21,25,32,36,43,42,41,35,30,29,28,23,17,12,6,5,4,11,15,22,26,33,37,38,39,45" );
	else if( option == 6 )
		level thread deleteTriggersTrap3( "3,10,9,8,13,19,20,21,25,32,31,30,29,28,27,26,33,37,38,39,40,41,46" );
	else if( option == 7 )
		level thread deleteTriggersTrap3( "2,8,7,6,5,4,11,15,22,26,27,28,23,17,18,19,20,21,25,32,36,43,42,41,40,39,45" );
	else if( option == 8 )
		level thread deleteTriggersTrap3( "0,4,11,15,22,26,33,37,38,39,34,28,23,17,12,6,7,8,9,10,14,21,20,19,24,30,31,32,36,43,42,41,46" );
	else if( option == 9 )
		level thread deleteTriggersTrap3( "0,4,5,6,12,17,16,15,22,26,27,28,29,30,24,19,13,8,9,10,14,21,25,32,36,43,42,41,40,39,38,37,44" );
	else if( option == 10 )
		level thread deleteTriggersTrap3( "0,4,5,6,12,17,18,19,13,8,9,10,14,21,25,32,31,30,35,41,40,39,34,28,27,26,33,37,44" );
	else if( option == 11 )
		level thread deleteTriggersTrap3( "0,4,11,15,16,17,12,6,7,8,9,10,14,21,20,19,24,30,31,32,36,43,42,41,40,39,34,28,27,26,33,37,44" );
	else if( option == 12 )
		level thread deleteTriggersTrap3( "3,10,14,21,25,32,31,30,24,19,13,8,7,6,12,17,23,28,27,26,33,37,38,39,40,41,46" );
	else if( option == 13 )
		level thread deleteTriggersTrap3( "2,8,13,19,18,17,16,15,22,26,33,37,38,39,34,28,29,30,31,32,36,43,47" );
	else if( option == 14 )
		level thread deleteTriggersTrap3( "1,6,7,8,9,10,14,21,25,32,36,43,42,41,35,30,29,28,27,26,33,37,44" );
	else if( option == 15 )
		level thread deleteTriggersTrap3( "3,10,14,21,25,32,36,43,42,41,35,30,24,19,13,8,7,6,5,4,11,15,16,17,23,28,27,26,33,37,38,39,45" );
	else if( option == 16 )
		level thread deleteTriggersTrap3( "3,10,14,21,25,32,31,30,29,28,23,17,12,6,5,4,11,15,22,26,33,37,44" );
	else if( option == 17 )
		level thread deleteTriggersTrap3( "3,10,9,8,13,19,18,17,23,28,27,26,33,37,38,39,40,41,46" );
	else if( option == 18 )
		level thread deleteTriggersTrap3( "0,4,11,15,22,26,27,28,29,30,24,19,18,17,12,6,7,8,9,10,14,21,25,32,36,43,42,41,40,39,38,37,44" );
	else if( option == 19 )
		level thread deleteTriggersTrap3( "1,6,5,4,11,15,16,17,18,19,13,8,9,10,14,21,25,32,31,30,29,28,27,26,33,37,38,39,40,41,42,43,47" );
	else if( option == 20 )
		level thread deleteTriggersTrap3( "2,8,13,19,18,17,12,6,5,4,11,15,22,26,33,37,38,39,45" );
	else if( option == 21 )
		level thread deleteTriggersTrap3( "0,4,5,6,12,17,18,19,13,8,9,10,14,21,25,32,31,30,35,41,40,39,45" );
	else if( option == 22 )
		level thread deleteTriggersTrap3( "3,10,9,8,7,6,5,4,11,15,16,17,23,28,29,30,31,32,36,43,42,41,40,39,38,37,44" );
	else
		level thread deleteTriggersTrap3( "2,8,9,10,14,21,20,19,24,30,31,32,36,43,42,41,46,1,6,5,4,11,15,16,17,23,28,27,26,33,37,38,39,45" );
}

activateTriggersTrap3( part )
{
	level endon( "game over" );
	self endon( "deactivate_trigger" );
	
	while(1)
	{
		self waittill( "trigger", player );
		part thread killTrap3( player );
	}
}

killTrap3( dead_guy )
{
	dead_guy suicide();
	dead_guy iPrintLnBold( "Look on the wall next time" );

	if( !self.moving || !isDefined( self.moving ) )
	{
		self.moving = true;
		
		self moveTo( self.origin + (0,0,50), 0.2 );
		wait 0.2;
		
		self moveTo( self.start_orig, 1 );
		wait 1;
		
		self.origin = self.start_orig;
		
		self.moving = false;
	}
}

deleteTriggersTrap3( array )
{
	trap3_points = [];
	while( isDefined( getEnt( "trap_3_point_" + trap3_points.size, "targetname" ) ) )
		trap3_points[ trap3_points.size ] = getEnt( "trap_3_point_" + trap3_points.size, "targetname" );
	
	trap3_large = [];
	trap3_large[0] = getEnt( "trap_3_point_0_large", "targetname" );
	trap3_large[1] = getEnt( "trap_3_point_1_large", "targetname" );
	trap3_large[2] = getEnt( "trap_3_point_2_large", "targetname" );
	trap3_large[3] = getEnt( "trap_3_point_3_large", "targetname" );
	
	wait 0.05;
	
	nums = strTok( array, "," );
	time = 15 / nums.size;
	
	for( j = 0; j < trap3_large.size; j++ )
	{
		if( j != int( nums[0] ) )
			trap3_large[j] moveZ( 64, 1 );
	}
	
	if( int( nums[1] ) == 0 || int( nums[1] ) == 1 || int( nums[1] ) == 2 || int( nums[1] ) == 3 )
		trap3_large[ nums[1] ] moveZ( 64, 1 );
	
	for( i = 0; i < nums.size; i++ )
	{
		level.trap3_triggers[ int( int( nums[i] ) ) ] notify( "deactivate_trigger" );
		
		trap3_points[ int( nums[i] ) ] moveTo( trap3_points[ int( nums[i] ) ].origin - (10,0,0), time );
		wait time;
		
		trap3_points[ int( nums[i] ) ] delete();
	}
}

setupTrap4()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	trap4_movers = getEntArray( "trap_4_mover", "targetname" );
	trap4_triggers = getEntArray( "trap_4_trigger", "targetname" );
	trap4_fire_starters = getEntArray( "trap4_fire_start", "targetname" );
	
	level.trap4_burning = true;
	level.trap4_killing = true;
	
	use = getEnt( "use_4", "targetname" );
	use waittill( "trigger", player );
	
	use delete();
	if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
	{
		if( level.trapsDisabledMessage )
		{
			iPrintLn( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLn( "He tried to activate a trap in a free round" );
		}
		else
		{
			level.trapsDisabledMessage = true;
			
			iPrintLnBold( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLnBold( "He tried to activate a trap in a free round" );
		}
		
		return;
	}
	
	for( i = 0; i < trap4_triggers.size; i++ )
		trap4_triggers[i] thread activateTriggersTrap4( trap4_movers[i] );
	
	for( i = 0; i < trap4_fire_starters.size; i++ )
		trap4_fire_starters[i] thread startFireTrap4();
	
	trap4_fire_starters[1] playSound( "burning_jet_engine" );
		
	for( i = 0; i < 5; i++ )
	{
		trap4_fire_starters[1] playsound( "fire_vehicle_flareup_med" );
		wait 2;
	}
	
	level.trap4_burning = false;
	
	wait 0.2;
	level.trap4_killing = false;
	level notify( "stop_trap_4" );
}

startFireTrap4()
{
	level endon( "game over" );
	
	while( level.trap4_burning )
	{
		playFx( level._effect[ "trap4" ], self.origin + (5,0,0) );
		wait 0.1;
	}
}

activateTriggersTrap4( mover )
{
	level endon( "stop_trap_4" );
	level endon( "game over" );
	
	self enableLinkTo();
	self linkTo( mover );
	
	mover moveTo( mover.origin + (656,0,0), 0.1 );
	
	while( level.trap4_killing )
	{
		self waittill( "trigger", player );
		
		if( !level.trap4_killing )
			break;
		
		if( !isDefined( player.burning ) || ( isDefined( player.burning ) && !player.burning ) )
			player thread killTrap4();
		
		wait 0.05;
	}
	
	mover delete();
	self delete();
}

killTrap4()
{
	self.burning = true;
	self disableWeapons();
	
	last_known_origin = self.origin;
	
	iPrintLn( self.name + " is ^1burning" );
	
	i = 0;
	while( isAlive( self ) && i < 40 )
	{
		i++;
		last_known_origin = self.origin;
		playFx( level._effect[ "trap4_player_burn" ], last_known_origin );
		
		if( i % 6 == 0 || i == 1 )
		{
			if( self getStat( 980 ) == 3 || self getStat( 980 ) == 4 )
				self playSound( "burning_player_woman" );
			else
				self playSound( "burning_player" );
		}
		
		wait 0.2;
	}
	
	if( isAlive( self ) )
		self suicide();
	
	self.burning = false;
	
	for( i = 0; i < 5; i++ )
	{
		playFx( level._effect[ "trap4_player_burn" ], last_known_origin );
		wait 0.2;
	}
}

setupTrap5()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	part1 = getEnt( "trap_5_1", "targetname" );
	part2 = getEnt( "trap_5_2", "targetname" );
	kill1 = getEnt( "trap_5_kill_1", "targetname" );
	kill2 = getEnt( "trap_5_kill_2", "targetname" );
	
	kill1 enableLinkTo();
	kill2 enableLinkTo();
	kill1 linkTo( part1 );
	kill2 linkTo( part2 );
	
	use = getEnt( "use_5", "targetname" );	
	use waittill( "trigger", player );
	
	use delete();
	if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
	{
		if( level.trapsDisabledMessage )
		{
			iPrintLn( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLn( "He tried to activate a trap in a free round" );
		}
		else
		{
			level.trapsDisabledMessage = true;
			
			iPrintLnBold( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLnBold( "He tried to activate a trap in a free round" );
		}
		
		return;
	}
	
	origin1_1 = part1.origin;
	origin1_2 = part1.origin - (0,0,75);
	origin2_1 = part2.origin;
	origin2_2 = part2.origin - (0,0,75);
	
	time = 5;
	
	while(1)
	{
		part1 rotatePitch( time * 300, ( time - 0.1 ) * 2 );
		part2 rotatePitch( time * 300, ( time - 0.1 ) * 2 );
		
		part1 moveTo( origin1_2, time );
		part2 moveTo( origin2_2, time );
		wait time - 0.1;
		
		part1 moveTo( origin1_1, time );
		part2 moveTo( origin2_1, time );
		wait time - 0.1;
	}
}

setupTrap6()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	part = getEnt( "trap_6", "targetname" );
	kill = getEnt( "trap_6_kill", "targetname" );
	
	kill enableLinkTo();
	kill linkTo( part );
	
	use = getEnt( "use_6", "targetname" );	
	use waittill( "trigger", player );
	
	use delete();
	if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
	{
		if( level.trapsDisabledMessage )
		{
			iPrintLn( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLn( "He tried to activate a trap in a free round" );
		}
		else
		{
			level.trapsDisabledMessage = true;
			
			iPrintLnBold( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLnBold( "He tried to activate a trap in a free round" );
		}
		
		return;
	}
	
	origin_1 = part.origin;
	origin_2 = part.origin - (0,0,224);
	
	time = 5;
	
	while(1)
	{
		part rotatePitch( time * 300, ( time - 0.1 ) * 2 );
		part moveTo( origin_2, time );
		wait time - 0.1;
		
		part moveTo( origin_1, time );
		wait time - 0.1;
	}
}

setupTrap7()
{
	level endon( "game over" );
	level endon( "all_vs_activator" );
	
	part = getEnt( "trap_7", "targetname" );
	
	use = getEnt( "use_7", "targetname" );	
	use waittill( "trigger", player );
	
	use delete();
	if( isDefined( level.trapsDisabled ) && level.trapsDisabled && player == level.activ )
	{
		if( level.trapsDisabledMessage )
		{
			iPrintLn( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLn( "He tried to activate a trap in a free round" );
		}
		else
		{
			level.trapsDisabledMessage = true;
			
			iPrintLnBold( "^6" + player.name + " ^7is a ^6faggot" );
			iPrintLnBold( "He tried to activate a trap in a free round" );
		}
		
		return;
	}
	
	normal_angles = part.angles;
	part rotateVelocity( (0,0,270), .3 );
	
	wait randomIntRange( 3, 5 );
	part rotateTo( normal_angles, 2 );
}