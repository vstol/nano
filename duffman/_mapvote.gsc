#include duffman\_common;

init()
{
	level.windowheight = 180;
	level.windowwidth  = 500;
	level.borderwidth  = 20;
	level.maps4vote    = 6;
	level.endmap_weapon_falldown = array("ak74u_mp","p90_mp","mp44_mp","saw_mp","m40a3_mp","deserteaglegold_mp","remington700_mp","uzi_mp","m60e4_mp","mp5_mp");
	maprotation = strTok(getDvar("sv_maprotation")," ");
	level.voteablemaps = [];
	tryes = 0;
	i = 0;
	while(level.voteablemaps.size < level.maps4vote && tryes < 100) {
		tryes++;
		i = randomint(maprotation.size);
		while(maprotation[i] != "gametype")
			i = randomint(maprotation.size);
		i+=2;
		if((i+1)<maprotation.size && maprotation[i] == "map" && isLegal(maprotation[i+1] + ";" + maprotation[i-1]))
			level.voteablemaps[level.voteablemaps.size] = maprotation[i+1] + ";" + maprotation[i-1];
	}

	level.mapvote = true;
	level notify("mapvote");

	if(level.gametype != "dm")
		thread FallDownWeapon();
	arraymaps = level.voteablemaps;

	//center
	hud[0] = addTextHud( level, 0, 0, .6, "center", "middle", "center", "middle", 0, 100 );
	hud[0] setShader("white",level.windowwidth,level.windowheight);
	hud[0].color = (0,0,0);
	hud[0] thread fadeIn(.3);
	//left
	hud[1] = addTextHud( level, level.windowwidth/-2, 0, .6, "right", "middle", "center", "middle", 0, 100 );
	hud[1] setShader("gradient_fadein",level.borderwidth,level.windowheight);
	hud[1].color = (0,0,0);
	hud[1] thread fadeIn(.3);
	//right
	hud[2] = addTextHud( level, level.windowwidth/2, 0, .6, "left", "middle", "center", "middle", 0, 100 );
	hud[2] setShader("gradient",level.borderwidth,level.windowheight);
	hud[2].color = (0,0,0);
	hud[2] thread fadeIn(.3);
	//text
	hud[3] = addTextHud( level, 0, level.windowheight/-2-8, 1, "center", "bottom", "center", "middle", 2.2, 102 );
	hud[3] setText("Mapvote System");
	hud[3] thread fadeIn(.3);
	//timer
	hud[4] = addTextHud( level, level.windowwidth/2 - 20, level.windowheight/-2-8, 1, "center", "bottom", "center", "middle", 2.2, 102 );
	hud[4] SetTenthsTimer(20);
	hud[4] thread fadeIn(.3);
	//blue top bg
	hud[5] = addTextHud( level, 0, level.windowheight/-2+5, .8, "center", "bottom", "center", "middle", 2.2, 101 );
	hud[5].color = (0, 0.402 ,1);
	hud[5] SetShader("line_vertical",level.windowwidth+level.borderwidth+level.borderwidth,50);
	hud[5] thread fadeIn(.3);
	//mappool
	string = "";
	hud[6] = addTextHud( level, 0, level.windowheight/-2+6, .1, "center", "top", "center", "middle", 2.2, 101 );
	hud[6].color = (0, 0.402 ,1);
	hud[6] SetShader("white",level.windowwidth,int(arraymaps.size * 26.8 + 3));
	hud[6] thread fadeIn(.3);
	
	hud[7] = addTextHud( level, 125, -96, 1, "left", "bottom", "left", "middle", 2.2, 102 );
	hud[7] setText("Rotate:"+level.dynamic_rotations+"/"+level.dynamic_limit);
	hud[7] thread fadeIn(.3);
	
	//voting results
	map = [];
	for(i=0;i<arraymaps.size;i++) {
		index = i + hud.size;
		hud[index] = addTextHud( level, -55, level.windowheight/-2+11.5+(i*26.8), 1, "left", "top", "center", "middle", 1.4, 102 );
		hud[index] setText("...");
		map[arraymaps[i]] = hud[index];
		hud[index] thread fadeIn(.3);
	}

	players = getAllPlayers();
	for(i=0;i<players.size;i++) {
		if(isDefined(players[i]) && isFalse(players[i].pers["isBot"]))
			players[i] thread PlayerVote();
	}

	addConnectThread(::PlayerVote);

	wait .1;
	
	iPrintln("Rotate: "+level.dynamic_rotations+"/"+level.dynamic_limit);

	level thread updateVotes(arraymaps,map);

	for(y=20;y>0;y--) {
		if(!(y%2) || y<6)
			level thread playSoundOnAllPlayers( "ui_mp_timer_countdown" );
		hud[5] fadeOverTime(.9);
		hud[5].alpha = .5;
		hud[4] fadeOverTime(.9);
		hud[4].alpha = .5;
		wait .9;
		hud[5] fadeOverTime(.1);
		hud[5].alpha = 1;	
		hud[4] fadeOverTime(.1);
		hud[4].alpha = 1;	
		wait .1;
	}
	level notify("end_vote");
	for(i=0;i<arraymaps.size;i++)
		map[arraymaps[i]] thread fadeOut(.5);

	hud[6] thread fadeOut(.5);
	hud[4] thread fadeOut(.5);
	level.mapvotes thread fadeOut(.5);

	players = getAllPlayers();
	for(i=0;i<players.size;i++)
		if(isDefined(players[i]) && isDefined(players[i].mapvote_selection))
			players[i].mapvote_selection thread fadeOut(.5);

	wait .5;


	hud[4] = addTextHud( level, 0, -20, 1, "center", "middle", "center", "middle", 2.2, 102 );
	hud[4] setText("Next Map:");
	hud[4].glowalpha = 1;
	hud[4].glowcolor = (0,.5,1);
	hud[4] thread fadeIn(.5);

	hud[6] = addTextHud( level, 0, 10, 1, "center", "middle", "center", "middle", 3, 102 );
	hud[6] setText(getMapNameString(strTok(level.winning,";")[0]) + " " + getGameTypeString(strTok(level.winning,";")[1]));
	hud[6].glowalpha = 1;
	hud[6].glowcolor = (0,.5,1);
	hud[6] thread fadeIn(.5);

	wait 3;

	blackscreen = addTextHud( level, 0, 0, 1, "center", "middle", "center", "middle", 3, 9999999 );
	blackscreen setShader("white",1000,1000);
	blackscreen.color = (0,0,0);
	blackscreen1 = addTextHud( level, 0, 0, 1, "center", "middle", "center", "middle", 3, 9999999 );
	blackscreen1 setShader("white",1000,1000);
	blackscreen1.color = (0,0,0);	
	blackscreen thread fadeIn(1.5);
	blackscreen1 thread fadeIn(1.5);
	wait 1.8;
	changeMap();
}

updateVotes(arraymaps,map) {
	level endon("end_vote");
	string = "";
	array = [];
	mostvotes = 0;
	players = getAllPlayers();
	level.mapvotes = addTextHud( level, level.windowwidth/-2 + 3, level.windowheight/-2+8, 1, "left", "top", "center", "middle", 2.2, 102 );
	level.mapvotes thread fadeIn(.3);
	while(1) {
		array = [];
		mostvotes = 0;
		level.winning = getDvar("mapname") + ";" +getDvar("g_gametype");//just in case
		players = getAllPlayers();
		for(i=0;i<players.size;i++) {
			if(isDefined(players[i]) && isDefined(players[i].votedmap)) {
				if(!isDefined(array[players[i].votedmap]))
					array[players[i].votedmap] = [];
				array[players[i].votedmap][array[players[i].votedmap].size] = players[i];
			}
		}
		string = "";
		for(i=0;i<arraymaps.size;i++) { 
			if(!isDefined(array[arraymaps[i]]))
				voted = 0;
			else 
				voted = array[arraymaps[i]].size;
			string += (voted + " - " + getMapNameString(strTok(arraymaps[i],";")[0]) + " " + getGameTypeString(strTok(arraymaps[i],";")[1]) + "\n");
			level.voteablemapstring = "";
			if(isDefined(array[arraymaps[i]])) {
				for(k=0;k<array[arraymaps[i]].size;k++) {
					if(level.voteablemapstring.size < 30 )
						level.voteablemapstring += (array[arraymaps[i]][k].name + ", ");
					else {
						level.voteablemapstring = getSubStr(level.voteablemapstring,0,level.voteablemapstring.size-2);
						level.voteablemapstring += (" and " + (array[arraymaps[i]].size-k+1) + " more..., ");
						k = 999;
					} 
				}
				if(mostvotes < array[arraymaps[i]].size) {
					mostvotes = array[arraymaps[i]].size;
					level.winning = arraymaps[i];
				}
				level.voteablemapstring = getSubStr(level.voteablemapstring,0,level.voteablemapstring.size-2);
				map[arraymaps[i]] setText(level.voteablemapstring);
			}
			else 
				map[arraymaps[i]] setText("...");
		}
		level.mapvotes setText(string);
		wait 1;
		level.mapvotes destroy();
		level.mapvotes = addTextHud( level, level.windowwidth/-2 + 3, level.windowheight/-2+8, 1, "left", "top", "center", "middle", 2.2, 102 );
	}
}

changeMap() 
{ 	
	setDvar("timescale",1);
	setDvar( "sv_maprotationcurrent", "gametype " + strTok(level.winning,";")[1] + " map " + strTok(level.winning,";")[0] );
	exitLevel(false);
}

PlayerVote() {
	self endon("disconnect");
	level endon("end_vote");

	self thread Rotate();

	wait .05;

	self.sessionteam = "spectator";
	self.sessionstate = "spectator";
	self.pers["team"] = "spectator";

	ads = self AdsButtonPressed();
	self.howto = addTextHud( self, 0, level.windowheight/2+5, 1, "center", "top", "center", "middle", 2.4, 101 );
	self.howto thread fadeIn(.3);
	self.howto setText("Start Mapvote");
	while(!self AttackButtonPressed() && ads == self AdsButtonPressed()) wait .05;
	self.howto thread fadeOut(1);
	selected = -1;
	offset = 26.8;
	self.mapvote_selection = addTextHud( self, 0, level.windowheight/-2+9+(selected*offset), 1, "center", "top", "center", "middle", 1.6, 101 );
	self.mapvote_selection setShader("line_vertical",level.windowwidth,25);
	self.mapvote_selection.color = (0, 0.402 ,1);
	self.mapvote_selection thread fadeIn(.3);
	maps = level.voteablemaps;
	while(1) {
		self allowSpectateTeam( "allies", false );
		self allowSpectateTeam( "axis", false );
		self allowSpectateTeam( "freelook", false );
		self allowSpectateTeam( "none", true );
		if(ads != self AdsButtonPressed()) {
			ads = self AdsButtonPressed();
			selected--;
			if(selected < 0)
				selected = maps.size-1;
			self.votedmap = maps[selected];
			self.mapvote_selection MoveOverTime(.1);
			self.mapvote_selection.y = level.windowheight/-2+9+(selected*offset);
		}
		if(self AttackButtonPressed()) {
			selected++;
			if(selected >= maps.size)
				selected = 0;
			self.votedmap = maps[selected];
			self.mapvote_selection MoveOverTime(.1);
			self.mapvote_selection.y = level.windowheight/-2+9+(selected*offset);
			for(k=0;k<8 && self attackButtonPressed();k++) wait .05;
		}
		wait .05;
	}
}

Rotate() {
	self endon("disconnect");
	wait .05;
	i=randomint(360);
	offset = 150;
	centerposition = self.origin;
	link = spawn("script_model",(centerposition[0]+(offset*cos(i)),centerposition[1]+(offset*sin(i)),centerposition[2]));
	self setOrigin((centerposition[0]+(offset*cos(i)),centerposition[1]+(offset*sin(i)),centerposition[2]));
	self linkTo(link);
	while(1) {
		for(;i<360;i+=1) {
			self FreezeControls(true);
			if(i%3==0)
				link moveTo((centerposition[0]+(offset*cos(i)),centerposition[1]+(offset*sin(i)),centerposition[2]),.15);
			self setPlayerAngles((0,i-180,0));
			wait .05;
		}
		i=0;
	}
}

FallDownWeapon() {
	wait .1;
	link = spawn("script_origin",maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(getentarray("mp_global_intermission", "classname")).origin+(0,0,200));
	bot = addBotClient("axis");
	bot freezeControls(true);
	bot setOrigin(link.origin);
	bot.pers["player_welcomed"] = true;
	bot linkTo(link);
	while(1) {
		for(i=0;i<level.endmap_weapon_falldown.size;i++) {
			bot giveWeapon(level.endmap_weapon_falldown[i]);
			wep = bot dropItem(level.endmap_weapon_falldown[i]);
			if(isDefined(wep))
				wep thread destroyAfterTime(1);
			wait .15;
		}
		wait .05;
	}
}

destroyAfterTime(time) {
	wait time;
	if(isDefined(self)) 
		self delete();
}

getGameTypeString( gt ) {
	switch( toLower( gt ) ) {
		case "war":
			gt = "(TDM)";
			break;
		case "dm":
			gt = "(DM)";
			break;
		case "sd":
			gt = "(S&D)";
			break;
		case "koth":
			gt = "(HQ)";
			break;
		case "sab":
			gt = "(SAB)";
			break;
		case "deathrun":
			gt = "";
			break;
			
		default:
			gt = "";
	}
	return gt;
}

getMapNameString( mapName ) 
{
	switch( toLower( mapName ) )
	{
		case "mp_dr_running":
			mapName = "Running";
			break;
			
		case "mp_deathrun_grassy_v4":
			mapName = "Grassy v4";
			break;
			
		case "mp_vc_unnatural":
			mapName = "VC Unnatural";
			break;
			
		case "mp_deathrun_royals":
			mapName = "Royals v2";
			break;
	
		case "mp_deathrun_black_friday":
			mapName = "Black friday";
			break;

		case "mp_deathrun_bricky":
			mapName = "Bricky";
			break;
			
		case "mp_deathrun_death":
			mapName = "Death";
			break;
			
		case "mp_deathrun_highrise":
			mapName = "Highrise";
			break;
			
		case "mp_deathrun_hop":
			mapName = "Hop";
			break;
			
		case "mp_deathrun_illusion":
			mapName = "Illusion";
			break;
			
		case "mp_deathrun_metal":
			mapName = "Metal";
			break;
			
		case "mp_deathrun_ponies":
			mapName = "Ponies";
			break;
		case "mp_deathrun_qube":
			mapName = "Qube";
			break;

		case "mp_deathrun_saw":
			mapName = "Saw";
			break;

		case "mp_deathrun_texx":
			mapName = "Texx";
			break;
		
		case "mp_deathrun_wood_v3":
			mapName = "Wood v3";
			break;
			
		case "mp_dr_rock ":
			mapName = "Rock";
			break;
			
		case "mp_deathrun_toxic":
			mapName = "Toxic";
			break;
			
		case "mp_dr_spacetunnel":
			mapName = "Spacetunnel";
			break;
		
		case "mp_dr_destiny":
			mapName = "Destiny";
			break;
			
		case "mp_deathrun_world":
			mapName = "World";
			break;

		case "mp_dr_apocalypse":
			mapName = "Apocalypse";
			break;

		case "mp_dr_blackandwhite":
			mapName = "Blackandwhite";
			break;
		
		case "mp_dr_digital":
			mapName = "Digital";
			break;

		case "mp_dr_h2o":
			mapName = "H2o";
			break;
		
		case "mp_dr_neon":
			mapName = "Neon";
			break;
		
		case "mp_dr_skydeath":
			mapName = "Skydeath";
			break;

		case "mp_dr_skypower":
			mapName = "Skypower";
			break;

		case "mp_dr_takeshi":
			mapName = "Takeshi";
			break;
		
		case "mp_dr_unreal":
			mapName = "Unreal";
			break;

		case "mp_dr_up":
			mapName = "Up";
			break;
	
		case "mp_deathrun_flow":
			mapName = "Flow";
			break;

		case "mp_deathrun_maratoon":
			mapName = "Maratoon";
			break;
			
		case "mp_deathrun_max":
			mapName = "Max";
			break;
			
		case "mp_deathrun_simplist":
			mapName = "Simplist";
			break;
			
		case "mp_dr_simple":
			mapName = "Simple";
			break;
			
		case "mp_deathrun_watchit_v3":
			mapName = "Watchit v3";
			break;
			
		case "mp_dr_crazyrun":
			mapName = "Crazyrun";
			break;
			
		case "mp_dr_electric":
			mapName = "Electric";
			break;
			
		case "mp_dr_hilly_v2":
			mapName = "Hilly v2";
			break;
		case "mp_deathrun_backlot":
			mapName = "Backlot";
			break;

		case "mp_deathrun_clockwork":
			mapName = "Clockwork";
			break;

		case "mp_deathrun_colourful":
			mapName = "Colourful";
			break;
		
		case "mp_deathrun_diehard":
			mapName = "Diehard";
			break;

		case "mp_deathrun_dungeon":
			mapName = "Dungeon";
			break;

		case "mp_deathrun_easy":
			mapName = "Easy";
			break;

		case "mp_deathrun_epicfail":
			mapName = "Epicfail";
			break;
		
		case "mp_deathrun_factory":
			mapName = "Factory";
			break;

		case "mp_deathrun_fluxx":
			mapName = "Fluxx";
			break;
		
		case "mp_deathrun_framey_v2":
			mapName = "Framey_v2";
			break;
		
		case "mp_deathrun_oreo":
			mapName = "Oreo";
			break;

		case "mp_deathrun_portal_v3":
			mapName = "Portal_v3";
			break;

		case "mp_deathrun_semtex":
			mapName = "Semtex";
			break;
		
		case "mp_deathrun_skypillar":
			mapName = "Skypillar";
			break;

		case "mp_deathrun_underworld":
			mapName = "Underworld";
			break;

		case "mp_deathrun_wicked2":
			mapName = "Wicked2";
			break;

		case "mp_deathrun_zero":
			mapName = "Zero";
			break;

		case "mp_dr_bigfall":
			mapName = "Bigfall";
			break;

		case "mp_dr_blade":
			mapName = "Blade";
			break;

		case "mp_dr_bladev2":
			mapName = "Bladev2";
			break;

		case "mp_dr_bounce":
			mapName = "Bounce";
			break;

		case "mp_dr_darmuhv2":
			mapName = "Darmuhv2";
			break;
			
		case "mp_dr_deadzone":
			mapName = "Deadzone";
			break;
			
		case "mp_dr_disco":
			mapName = "Disco";
			break;
			
		case "mp_dr_glass2":
			mapName = "Glass2";
			break;
			
		case "mp_dr_holyshiet":
			mapName = "Holyshiet";
			break;

		case "mp_dr_indipyramid":
			mapName = "Indipyramid";
			break;
			
		case "mp_dr_jurapark":
			mapName = "Jurapark";
			break;
	
		case "mp_dr_meatboy":
			mapName = "Meatboy";
			break;
			
		case "mp_dr_rock":
			mapName = "Rock";
			break;
			
		case "mp_dr_royals":
			mapName = "Royals";
			break;
			
		case "mp_dr_sewers":
			mapName = "Sewers";
			break;
			
		case "mp_dr_sheox":
			mapName = "Sheox";
			break;

		case "mp_dr_slay":
			mapName = "Slay";
			break;
			
		case "mp_dr_steel":
			mapName = "Steel";
			break;
	
		case "mp_dr_stonerun":
			mapName = "Stonerun";
			break;
			
		case "mp_dr_style":
			mapName = "Style";
			break;
			
		case "mp_dr_trapntrance":
			mapName = "Trapntrance";
			break;
			
		case "mp_dr_watercity":
			mapName = "Watercity";
			break;
		
		case "mp_dr_highrise":
			mapName = "highrise";
			break;
			
		case "mp_dr_xd":
			mapName = "xd";
			break;
			
		case "mp_dr_wtf":
			mapName = "wtf";
			break;
			
		case "mp_dr_wipeout":
			mapName = "wipeout";
			break;
			
		case "mp_dr_wicked":
			mapName = "wicked";
			break;
			
		case "mp_dr_vector":
			mapName = "vector";
			break;

		case "mp_dr_turnabout":
			mapName = "turnabout";
			break;
			
		case "mp_dr_troublemaker":
			mapName = "troublemaker";
			break;
	
		case "mp_dr_tron":
			mapName = "tron";
			break;
			
		case "mp_dr_stronghold":
			mapName = "stronghold";
			break;
			
		case "mp_dr_ssc_nothing":
			mapName = "ssc nothing";
			break;
			
		case "mp_dr_spedex":
			mapName = "spedex";
			break;
			
		case "mp_dr_sonic":
			mapName = "sonic";
			break;

		case "mp_dr_snip":
			mapName = "snip";
			break;
			
		case "mp_dr_sm_world":
			mapName = "sm_world";
			break;
	
		case "mp_dr_ryno":
			mapName = "ryno";
			break;
			
		case "mp_dr_prisonv2":
			mapName = "prison v2";
			break;
			
		case "mp_dr_pool":
			mapName = "pool";
			break;
			
		case "mp_dr_nyan":
			mapName = "nyan";
			break;
		
		case "mp_dr_nimble":
			mapName = "nimble";
			break;
			
		case "mp_dr_nightlight":
			mapName = "nightlight";
			break;
			
		case "mp_dr_minibounce_v2":
			mapName = "minibounce v2";
			break;
			
		case "mp_dr_minerun":
			mapName = "minerun";
			break;
			
		case "mp_dr_likeaboss":
			mapName = "likeaboss";
			break;
			
		case "mp_dr_levels":
			mapName = "levels";
			break;

		case "mp_dr_iwillrockyou":
			mapName = "iwillrockyou";
			break;
			
		case "mp_dr_impossibru":
			mapName = "impossibru";
			break;
	
		case "mp_dr_imaginary":
			mapName = "imaginary";
			break;
			
		case "mp_dr_gooby":
			mapName = "gooby";
			break;
			
		case "mp_dr_gohome":
			mapName = "gohome";
			break;
			
		case "mp_dr_glass3":
			mapName = "glass3";
			break;
			
		case "mp_dr_framey":
			mapName = "framey";
			break;

		case "mp_dr_finalshuttle":
			mapName = "finalshuttle";
			break;
			
		case "mp_dr_emerald":
			mapName = "emerald";
			break;
	
		case "mp_dr_detained":
			mapName = "detained";
			break;
			
		case "mp_dr_deathyard":
			mapName = "deathyard";
			break;
			
		case "mp_dr_caelum":
			mapName = "caelum";
			break;
			
		case "mp_dr_buggedlikehell":
			mapName = "buggedlikehell";
			break;
		
		case "mp_dr_bouncev2":
			mapName = "Bounce v2";
			break;
			
		case "mp_dr_blue":
			mapName = "blue";
			break;
			
		case "mp_dr_beat":
			mapName = "beat";
			break;
			
		case "mp_dr_apocalypse_v2":
			mapName = "apocalypse v2";
			break;
			
		case "mp_dr_antichamber":
			mapName = "antichamber";
			break;
			
		case "mp_dr_android":
			mapName = "android";
			break;

		case "mp_dr_35":
			mapName = "35";
			break;
			
		case "mp_deathrun_wood":
			mapName = "wood";
			break;
	
		case "mp_deathrun_wipeout_v2":
			mapName = "wipeout v2";
			break;
			
		case "mp_deathrun_wipeout":
			mapName = "wipeout";
			break;
			
		case "mp_deathrun_winter":
			mapName = "winter";
			break;
			
		case "mp_deathrun_waterworld":
			mapName = "waterworld";
			break;
			
		case "mp_deathrun_under":
			mapName = "under";
			break;

		case "mp_deathrun_tiger":
			mapName = "tiger";
			break;
			
		case "mp_deathrun_takecare":
			mapName = "takecare";
			break;
	
		case "mp_deathrun_supermario":
			mapName = "supermario";
			break;
			
		case "mp_deathrun_spaceball":
			mapName = "spaceball";
			break;
			
		case "mp_deathrun_sonic":
			mapName = "sonic";
			break;
			
		case "mp_deathrun_sm_v2":
			mapName = "sm v2";
			break;
		
		case "mp_deathrun_slow":
			mapName = "slow";
			break;
			
		case "mp_deathrun_skybox":
			mapName = "skybox";
			break;
			
		case "mp_deathrun_sick_v2":
			mapName = "sick v2";
			break;
			
		case "mp_deathrun_sick":
			mapName = "sick";
			break;
			
		case "mp_deathrun_shadow":
			mapName = "shadow";
			break;
		case "mp_deathrun_saw_v2":
			mapName = "saw v2";
			break;

		case "mp_deathrun_sapphire":
			mapName = "sapphire";
			break;

		case "mp_deathrun_ruin2":
			mapName = "ruin2";
			break;
		
		case "mp_deathrun_ruin":
			mapName = "ruin";
			break;

		case "mp_deathrun_rocky":
			mapName = "rocky";
			break;

		case "mp_deathrun_palm":
			mapName = "palm";
			break;

		case "mp_deathrun_moustache":
			mapName = "moustache";
			break;
		
		case "mp_deathrun_mirroredge":
			mapName = "mirroredge";
			break;

		case "mp_deathrun_minecraft":
			mapName = "minecraft";
			break;
		
		case "mp_deathrun_mine":
			mapName = "mine";
			break;
		
		case "mp_deathrun_metal2":
			mapName = "metal2";
			break;

		case "mp_deathrun_mbox":
			mapName = "mbox";
			break;

		case "mp_deathrun_long":
			mapName = "long";
			break;
		
		case "mp_deathrun_liferun":
			mapName = "liferun";
			break;

		case "mp_deathrun_legend":
			mapName = "legend";
			break;

		case "mp_deathrun_jailhouse":
			mapName = "jailhouse";
			break;

		case "mp_deathrun_islands":
			mapName = "islands";
			break;

		case "mp_deathrun_inferno":
			mapName = "inferno";
			break;

		case "mp_deathrun_greenland":
			mapName = "greenland";
			break;

		case "mp_deathrun_grassy":
			mapName = "grassy";
			break;

		case "mp_deathrun_gold":
			mapName = "gold";
			break;

		case "mp_deathrun_godfather":
			mapName = "godfather";
			break;
			
		case "mp_deathrun_galaxy":
			mapName = "galaxy";
			break;
			
		case "mp_deathrun_fusion":
			mapName = "fusion";
			break;
			
		case "mp_deathrun_freefall":
			mapName = "freefall";
			break;
			
		case "mp_deathrun_framey_v3":
			mapName = "framey_v3";
			break;

		case "mp_deathrun_farm":
			mapName = "farm";
			break;
			
		case "mp_deathrun_eudora":
			mapName = "eudora";
			break;
	
		case "mp_deathrun_dragonball":
			mapName = "dragonball";
			break;
			
		case "mp_deathrun_dirt":
			mapName = "dirt";
			break;
			
		case "mp_deathrun_destroyedv3":
			mapName = "destroyedv3";
			break;
			
		case "mp_deathrun_destroyed":
			mapName = "destroyed";
			break;
			
		case "mp_deathrun_darkness":
			mapName = "darkness";
			break;

		case "mp_deathrun_dark":
			mapName = "dark";
			break;
			
		case "mp_deathrun_cosmic":
			mapName = "cosmic";
			break;

		case "mp_deathrun_cookie":
			mapName = "cookie";
			break;
			
		case "mp_deathrun_control":
			mapName = "control";
			break;
		case "mp_deathrun_city":
			mapName = "city";
			break;

		case "mp_deathrun_chunk":
			mapName = "chunk";
			break;

		case "mp_deathrun_cherry":
			mapName = "cherry";
			break;
		
		case "mp_deathrun_cave":
			mapName = "cave";
			break;

		case "mp_deathrun_bunker":
			mapName = "bunker";
			break;

		case "mp_deathrun_bounce_v3":
			mapName = "bounce_v3";
			break;

		case "mp_deathrun_bland":
			mapName = "bland";
			break;
		
		case "mp_deathrun_beauty_v2":
			mapName = "beauty_v2";
			break;

		case "mp_deathrun_bangarang":
			mapName = "bangarang";
			break;
		
		case "mp_deathrun_azteca":
			mapName = "azteca";
			break;
		
		case "mp_deathrun_arbase":
			mapName = "marbase";
			break;

		case "mp_deathrun_apollo":
			mapName = "apollo";
			break;

		case "mp_deathrun_annihilation":
			mapName = "annihilation";
			break;
		
		case "mp_deathrun_amazon":
			mapName = "amazon";
			break;
			
	}
	return mapName;
}

isLegal(map) {
	if(map == (getDvar("mapname") + ";" + getDvar("g_gametype"))) 
		return false;
	for(i=0;i<level.voteablemaps.size;i++)
		if(level.voteablemaps[i] == map)
			return false;
	return true;
}