init()
{
	level.mapvote=1;
	level.mapvotetime=20;
	level.mapvotereplay=0;
	if(!level.mapvote)
		return;

	level.mapvotetext["MapVote"]		= &"^1|RS|^7 MapVote System";
	level.mapvotetext["TimeLeft"] 		= &"";

	precacheString(level.mapvotetext["MapVote"]);
	precacheString(level.mapvotetext["TimeLeft"]);
	
	precacheShader( "line_vertical" );
	precacheShader( "white" );
	precacheShader( "black" );
}

notifySBoard()
{
	iprintln("^1Press ^3[Fire] ^1To Make a Vote!");
	wait 8;
	iprintln("^1Press ^3[Fire] ^1To Make a Vote!");
	wait 8;
	iprintln("^1Press ^3[Fire] ^1To Make a Vote!");
}

Initialize()
{
	if(!level.mapvote)
		return;
	level notify ("votestarted");
	ambientplay("deepandhard_music",1);
	CreateHud();
	thread notifySBoard();
	thread RunMapVote();
	level waittill("VotingComplete");
	DeleteHud();
}


CreateHud()
{
	level.MapVoteHud[0] = newHudElem();
	level.MapVoteHud[0].hideWhenInMenu = true;
	level.MapVoteHud[0].alignX = "center";
	level.MapVoteHud[0].horzAlign = "fullscreen";
	level.MapVoteHud[0].vertAlign = "fullscreen";
	level.MapVoteHud[0].x = 320;
	level.MapVoteHud[0].y = 76;
	level.MapVoteHud[0].fontscale = 1.4;
	level.MapVoteHud[0].sort = 9994;
	level.MapVoteHud[0].label = level.mapvotetext["MapVote"];
	
	level.MapVoteHud[1] = newHudElem();
	level.MapVoteHud[1].hideWhenInMenu = true;
	level.MapVoteHud[1].alignX = "right";
	level.MapVoteHud[1].x = 530;
	level.MapVoteHud[1].y = 77;
	level.MapVoteHud[1].alpha = 1;
	level.MapVoteHud[1].fontscale = 1.4;
	level.MapVoteHud[1].sort = 9994;
	level.MapVoteHud[1] setValue(level.mapvotetime);
	
	level.MapVoteHud[2] = newHudElem();
	level.MapVoteHud[2].hideWhenInMenu = true;
	level.MapVoteHud[2].alignX = "center";
	level.MapVoteHud[2].horzAlign = "fullscreen";
	level.MapVoteHud[2].vertAlign = "fullscreen";
	level.MapVoteHud[2].x = 320;
	level.MapVoteHud[2].y = 99;
	level.MapVoteHud[2].alpha = 0.5;
	level.MapVoteHud[2].sort = 9992;
	level.MapVoteHud[2].color = (0,.0,0);
	level.MapVoteHud[2] setShader("black", 452, 152);  //ui_host  line_vertical   nightvision_overlay_goggles
	
	level.MapVoteHud[3] = newHudElem();
	level.MapVoteHud[3].hideWhenInMenu = true;
	level.MapVoteHud[3].alignX = "center";
	level.MapVoteHud[3].horzAlign = "fullscreen";
	level.MapVoteHud[3].vertAlign = "fullscreen";
	level.MapVoteHud[3].x = 320;
	level.MapVoteHud[3].y = 70;
	level.MapVoteHud[3].alpha = 0.9;
	level.MapVoteHud[3].sort = 9992;
	level.MapVoteHud[3].color = (0,.5,1);
	level.MapVoteHud[3] setShader("line_vertical", 452, 30);  //ui_host  line_vertical   nightvision_overlay_goggles
	
	level.MapVoteHud[4] = newHudElem();
	level.MapVoteHud[4].hideWhenInMenu = true;
	level.MapVoteHud[4].alignX = "center";
	level.MapVoteHud[4].horzAlign = "fullscreen";
	level.MapVoteHud[4].vertAlign = "fullscreen";
	level.MapVoteHud[4].x = 320;
	level.MapVoteHud[4].y = 100;
	level.MapVoteHud[4].color = (0,.5,1);
	level.MapVoteHud[4].alpha = 0.2;
	level.MapVoteHud[4].sort = 9993;
	level.MapVoteHud[4] setShader("white", 450, 150);

	level.MapVoteNames[0] = newHudElem();
	level.MapVoteNames[1] = newHudElem();
	level.MapVoteNames[2] = newHudElem();
	level.MapVoteNames[3] = newHudElem();
	level.MapVoteNames[4] = newHudElem();
	level.MapVoteNames[5] = newHudElem();
	//level.MapVoteNames[6] = newHudElem();

	level.MapVoteVotes[0] = newHudElem();
	level.MapVoteVotes[1] = newHudElem();
	level.MapVoteVotes[2] = newHudElem();
	level.MapVoteVotes[3] = newHudElem();
	level.MapVoteVotes[4] = newHudElem();
	level.MapVoteVotes[5] = newHudElem();
	//level.MapVoteVotes[6] = newHudElem();

	yPos = 116;
	for (i = 0; i < level.MapVoteNames.size; i++)
	{
		level.MapVoteNames[i].hideWhenInMenu = true;
		level.MapVoteNames[i].x = 110;
		level.MapVoteNames[i].y = yPos;
		level.MapVoteNames[i].alpha = 1;
		level.MapVoteNames[i].sort = 9995;
		level.MapVoteNames[i].fontscale = 1.4;
		level.MapVoteNames[i].horzAlign = "fullscreen";
		level.MapVoteNames[i].vertAlign = "fullscreen";

		level.MapVoteVotes[i].hideWhenInMenu = true;
		level.MapVoteVotes[i].alignX = "right";
		level.MapVoteVotes[i].x = 530;
		level.MapVoteVotes[i].y = yPos;
		level.MapVoteVotes[i].alpha = 1;
		level.MapVoteVotes[i].sort = 9996;
		level.MapVoteVotes[i].fontscale = 1.4;
		level.MapVoteVotes[i].horzAlign = "fullscreen";
		level.MapVoteVotes[i].vertAlign = "fullscreen";
		yPos += 20;
	}
}

RunMapVote()
{
	maps = undefined;
	x = undefined;

	currentgt = getDvar("g_gametype");
	currentmap = getdvar("mapname");

	x = GetRandomMapRotation();
				
	if(isdefined(x))
	{
		if(isdefined(x.maps))
			maps = x.maps;
		x delete();
	}
	if(!isdefined(maps))
	{
		wait 0.05;
		level notify("VotingComplete");
		return;
	}

	for(j=0;j<7;j++)
	{
		level.mapcandidate[j]["map"] = currentmap;
		level.mapcandidate[j]["mapname"] = "Restart Map";
		level.mapcandidate[j]["gametype"] = currentgt;
		level.mapcandidate[j]["votes"] = 0;
	}
	i = 0;
	for(j=0;j<7;j++)
	{
		if(maps[i]["map"] == currentmap && maps[i]["gametype"] == currentgt)
			i++;

		if(!isdefined(maps[i]))
			break;

		level.mapcandidate[j]["map"] = maps[i]["map"];
		level.mapcandidate[j]["mapname"] = getMapName(maps[i]["map"]);
		level.mapcandidate[j]["gametype"] = maps[i]["gametype"];
		level.mapcandidate[j]["votes"] = 0;

		i++;

		if(!isdefined(maps[i]))
			break;
	}
	
	thread DisplayMapChoices();
	
	//game["menu_team"] = "";

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] thread PlayerVote();
	
	thread VoteLogic();
}

DeleteHud()
{
	level.MapVoteHud[0] destroy();
	level.MapVoteHud[1] destroy();
	level.MapVoteHud[2] destroy();
	level.MapVoteHud[3] destroy();
	level.MapVoteHud[4] destroy();
	level.MapVoteNames[0] destroy();
	level.MapVoteNames[1] destroy();
	level.MapVoteNames[2] destroy();
	level.MapVoteNames[3] destroy();
	level.MapVoteNames[4] destroy();
	level.MapVoteNames[5] destroy();
	//level.MapVoteNames[6] destroy();
	level.MapVoteVotes[0] destroy();
	level.MapVoteVotes[1] destroy();
	level.MapVoteVotes[2] destroy();
	level.MapVoteVotes[3] destroy();	
	level.MapVoteVotes[4] destroy();
	level.MapVoteVotes[5] destroy();
	//level.MapVoteVotes[6] destroy();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(isdefined(players[i].vote_indicator))
			players[i].vote_indicator destroy();
}
DisplayMapChoices()
{
	level endon("VotingDone");

	for (i = 0; i < level.MapVoteNames.size; i++)
	{
		if (isDefined(level.mapcandidate[i]))
		{
			if (isDefined(level.mapcandidate[i]["gametype"]))
				level.MapVoteNames[i] setText(level.mapcandidate[i]["mapname"] + " (" + level.mapcandidate[i]["gametype"] +")");
			else
				level.MapVoteNames[i] setText(level.mapcandidate[i]["mapname"]);

			//level.MapVoteNames[i] setPulseFX( 100, int((level.mapvotetime+1)*1000), 1000 );
		}
		wait 0.05;
	}
}
PlayerVote()
{
	level notify("stopparty");
	level endon( "VotingDone" );
	self endon( "disconnect" );
	self notify( "reset_outcome" );

	novote = false;
	
	self braxi\_mod::spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );

	self maps\mp\gametypes\_globallogic::spawnSpectator();
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	resettimeout();

	self closeMenu();
	
	self allowSpectateTeam( "allies", false );
	self allowSpectateTeam( "axis", false );
	self allowSpectateTeam( "freelook", false );
	self allowSpectateTeam( "none", true );
	setDvar("ui_hud_hardcore", "1");
	self setclientdvar("ui_hud_hardcore", 1);
	thread rotate();

	if( novote )
		return;

	colors[0] = (0,.5,1);
	colors[1] = (0,.5,1);
	colors[2] = (0,.5,1);
	colors[3] = (0,.5,1);
	colors[4] = (0,.5,1);
	colors[5] = (0,.5,1);
	colors[6] = (0,.5,1);
	
	self.vote_indicator = newClientHudElem( self );
	self.vote_indicator.alignY = "middle";
	self.vote_indicator.x = 100;
	self.vote_indicator.y = 53;
	self.vote_indicator.archived = false;
	self.vote_indicator.sort = 9998;
	self.vote_indicator.alpha = 0;
	self.vote_indicator.color = colors[0];
	self.vote_indicator setShader("line_vertical", 440, 17);
	
	hasVoted = false;

	for(;;)
	{
		wait .01;

		if(self attackButtonPressed() == true)
		{
			if(!hasVoted)
			{
				self.vote_indicator.alpha = .3;
				self.votechoice = 0;
				hasVoted = true;
			}
			else
				self.votechoice++;

			if (self.votechoice == 6)
				self.votechoice = 0;

			self iprintln("^1Your Vote: ^2" + level.mapcandidate[self.votechoice]["mapname"]);
			self.vote_indicator.y = 124 + self.votechoice * 20;			
			self.vote_indicator.color = colors[self.votechoice];
			self playLocalSound("ui_mp_timer_countdown");
		}					
		while(self attackButtonPressed() == true)
			wait.01;

		self.sessionstate = "spectator";
		self.spectatorclient = -1;
	}
}
VoteLogic()
{
	for ( ; level.mapvotetime >= 0; level.mapvotetime--)
	{
		for(j=0;j<10;j++)
		{
			for(i=0;i<7;i++)	level.mapcandidate[i]["votes"] = 0;
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				if(isdefined(players[i].votechoice))
					level.mapcandidate[players[i].votechoice]["votes"]++;

			level.MapVoteVotes[0] setValue( level.mapcandidate[0]["votes"] );
			level.MapVoteVotes[1] setValue( level.mapcandidate[1]["votes"] );
			level.MapVoteVotes[2] setValue( level.mapcandidate[2]["votes"] );
			level.MapVoteVotes[3] setValue( level.mapcandidate[3]["votes"] );
			level.MapVoteVotes[4] setValue( level.mapcandidate[4]["votes"] );
			level.MapVoteVotes[5] setValue( level.mapcandidate[5]["votes"] );
			//level.MapVoteVotes[6] setValue( level.mapcandidate[6]["votes"] );
			wait .1;
		}
		level.MapVoteHud[1] setValue( level.mapvotetime );
	}	
	wait 0.2;
	
	newmapnum = 0;
	topvotes = 0;
	for(i=0;i<7;i++)
	{
		if (level.mapcandidate[i]["votes"] > topvotes)
		{
			newmapnum = i;
			topvotes = level.mapcandidate[i]["votes"];
		}
	}

	SetMapWinner(newmapnum);
}
SetMapWinner(winner)
{
	map		= level.mapcandidate[winner]["map"];
	mapname	= level.mapcandidate[winner]["mapname"];
	gametype	= level.mapcandidate[winner]["gametype"];

	setdvar("sv_maprotationcurrent", " gametype " + gametype + " map " + map);

	wait 0.1;

	level notify( "VotingDone" );

	wait 0.05;

	if("VotingDone")
	{
		iprintlnbold("^1Map Winner");
		wait 1;
		iprintlnbold("^1" + mapname);
		wait 1;
		iprintlnbold("^1" + GetGametypeName(gametype));
	}

	level.MapVoteHud[0] fadeOverTime (1);
	level.MapVoteHud[1] fadeOverTime (1);
	level.MapVoteHud[2] fadeOverTime (1);
	level.MapVoteHud[3] fadeOverTime (1);
	level.MapVoteHud[4] fadeOverTime (1);
	level.MapVoteNames[0] fadeOverTime (1);
	level.MapVoteNames[1] fadeOverTime (1);
	level.MapVoteNames[2] fadeOverTime (1);
	level.MapVoteNames[3] fadeOverTime (1);
	level.MapVoteNames[4] fadeOverTime (1);
	level.MapVoteNames[5] fadeOverTime (1);
	//level.MapVoteNames[6] fadeOverTime (1);
	level.MapVoteVotes[0] fadeOverTime (1);
	level.MapVoteVotes[1] fadeOverTime (1);
	level.MapVoteVotes[2] fadeOverTime (1);
	level.MapVoteVotes[3] fadeOverTime (1);	
	level.MapVoteVotes[4] fadeOverTime (1);
	level.MapVoteVotes[5] fadeOverTime (1);
	//level.MapVoteVotes[6] fadeOverTime (1);

	level.MapVoteHud[0].alpha = 0;
	level.MapVoteHud[1].alpha = 0;
	level.MapVoteHud[2].alpha = 0;
	level.MapVoteHud[3].alpha = 0;
	level.MapVoteHud[4].alpha = 0;
	level.MapVoteNames[0].alpha = 0;
	level.MapVoteNames[1].alpha = 0;
	level.MapVoteNames[2].alpha = 0;
	level.MapVoteNames[3].alpha = 0;
	level.MapVoteNames[4].alpha = 0;
	level.MapVoteNames[5].alpha = 0;
	//level.MapVoteNames[6].alpha = 0;
	level.MapVoteVotes[0].alpha = 0;
	level.MapVoteVotes[1].alpha = 0;
	level.MapVoteVotes[2].alpha = 0;
	level.MapVoteVotes[3].alpha = 0;	
	level.MapVoteVotes[4].alpha = 0;
	level.MapVoteVotes[5].alpha = 0;
	//level.MapVoteVotes[6].alpha = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].vote_indicator))
		{
			players[i].vote_indicator fadeOverTime (1);
			players[i].vote_indicator.alpha = 0;
		}
	}
	wait 4;
	level notify( "VotingComplete" );
}

GetRandomMapRotation()
{
	return GetMapRotation(true, false, undefined);
}

GetMapRotation(random, current, number)
{
	maprot = "";

	if(!isdefined(number))
		number = 0;

	if(current)
		maprot = strip(getDvar("sv_maprotationcurrent"));

	if(maprot == "")
		maprot = strip(getDvar("sv_maprotation"));
		
	if(maprot == "")
		return undefined;
	j=0;
	temparr2[j] = "";	
	for(i=0;i<maprot.size;i++)
	{
		if(maprot[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else
			temparr2[j] += maprot[i];
	}
	temparr = [];
	for(i=0;i<temparr2.size;i++)
	{
		element = strip(temparr2[i]);
		if(element != "")
		{
			temparr[temparr.size] = element;
		}
	}
	x = spawn("script_origin",(0,0,0));

	x.maps = [];
	lastexec = undefined;
	lastgt = level.gametype;
	for(i=0;i<temparr.size;)
	{
		switch(temparr[i])
		{
			case "exec":
				if(isdefined(temparr[i+1]))
					lastexec = temparr[i+1];
				i += 2;
				break;

			case "gametype":
				if(isdefined(temparr[i+1]))
					lastgt = temparr[i+1];
				i += 2;
				break;

			case "map":
				if(isdefined(temparr[i+1]))
				{
					x.maps[x.maps.size]["exec"]		= lastexec;
					x.maps[x.maps.size-1]["gametype"]	= lastgt;
					x.maps[x.maps.size-1]["map"]	= temparr[i+1];
				}
				// Only need to save this for random rotations
				if(!random)
				{
					lastexec = undefined;
					lastjeep = undefined;
					lasttank = undefined;
					lastgt = undefined;
				}

				i += 2;
				break;
			default:
				iprintlnbold( "Error in Map Rotation" );
	
				if(isGametype(temparr[i]))
					lastgt = temparr[i];
				else if(isConfig(temparr[i]))
					lastexec = temparr[i];
				else
				{
					x.maps[x.maps.size]["exec"]		= lastexec;
					x.maps[x.maps.size-1]["gametype"]	= lastgt;
					x.maps[x.maps.size-1]["map"]	= temparr[i];
	
					if(!random)
					{
						lastexec = undefined;
						lastjeep = undefined;
						lasttank = undefined;
						lastgt = undefined;
					}
				}
					

				i += 1;
				break;
		}
		if(number && x.maps.size >= number)
			break;
	}

	if(random)
	{
		for(k = 0; k < 20; k++)
		{
			for(i = 0; i < x.maps.size; i++)
			{
				j = randomInt(x.maps.size);
				element = x.maps[i];
				x.maps[i] = x.maps[j];
				x.maps[j] = element;
			}
		}
	}
	return x;
}

isConfig(cfg)
{
	temparr = explode(cfg,".");
	if(temparr.size == 2 && temparr[1] == "cfg")
		return true;
	else
		return false;
}

isGametype(gt)
{
	switch(gt)
	{
		case "dm":
		case "war":
		case "sd":
		case "dom":
		case "koth":
		case "sab":
		case "ctfb":
		case "htf":
		case "ctf":
		case "re":
		case "cnq":
		case "ch":
		case "sa":
		case "tds":
		case "lts":
		case "cj":
			return true;

		default:
			return false;
	}
}

getGametypeName(gt)
{
	switch(gt)
	{
		case "dm":
			gtname = "Free for All";
			break;
			
		case "war":
			gtname = "Team Deathmatch";
			break;
			
		case "sd":
			gtname = "Search & Destroy";
			break;
			
		case "koth":
			gtname = "Headquarters";
			break;
			
		case "dom":
			gtname = "Domination";
			break;
			
		case "sab":
			gtname = "Sabotage";
			break;
			
		case "ctfb":
			gtname = "Capture the Flag (back)";
			break;
			
		case "htf":
			gtname = "Hold the Flag";
			break;
			
		case "ctf":
			gtname = "Capture the Flag";
			break;
			
		case "cnq":
			gtname = "Conquest TDM";
			break;
			
		case "ch":
			gtname = "Capture and Hold";
			break;
			
		case "re":
			gtname = "Retrieval";
			break;
			
		case "sa":
			gtname = "strong arm";
			break;
		
		case "tds":
			gtname = "team swap";
			break;
			
		case "lts":
			gtname = "last team standing";
			break;
			
		case "cj":
			gtname = "CodJumper";
			break;
			
		case "deathrun":
			gtname = "Deathrun";
			break;
			
		default:
			gtname = gt;
			break;
	}

	return gtname;
}

getMapName(map)
{
	switch(map)
	{
		case "mp_deathrun_royals":
			mapname = "Royals v2";
			break;
	
		case "mp_deathrun_black_friday":
			mapname = "Black friday";
			break;

		case "mp_deathrun_bricky":
			mapname = "Bricky";
			break;
			
		case "mp_deathrun_death":
			mapname = "Death";
			break;
			
		case "mp_deathrun_highrise":
			mapname = "Highrise";
			break;
			
		case "mp_deathrun_hop":
			mapname = "Hop";
			break;
			
		case "mp_deathrun_illusion":
			mapname = "Illusion";
			break;
			
		case "mp_deathrun_metal":
			mapname = "Metal";
			break;
			
		case "mp_deathrun_ponies":
			mapname = "Ponies";
			break;
		case "mp_deathrun_qube":
			mapname = "Qube";
			break;

		case "mp_deathrun_saw":
			mapname = "Saw";
			break;

		case "mp_deathrun_texx":
			mapname = "Texx";
			break;
		
		case "mp_deathrun_wood_v3":
			mapname = "Wood v3";
			break;

		case "mp_deathrun_world":
			mapname = "World";
			break;

		case "mp_dr_apocalypse":
			mapname = "Apocalypse";
			break;

		case "mp_dr_blackandwhite":
			mapname = "Blackandwhite";
			break;
		
		case "mp_dr_digital":
			mapname = "Digital";
			break;

		case "mp_dr_h2o":
			mapname = "H2o";
			break;
		
		case "mp_dr_neon":
			mapname = "Neon";
			break;
		
		case "mp_dr_skydeath":
			mapname = "Skydeath";
			break;

		case "mp_dr_skypower":
			mapname = "Skypower";
			break;

		case "mp_dr_takeshi":
			mapname = "Takeshi";
			break;
		
		case "mp_dr_unreal":
			mapname = "Unreal";
			break;

		case "mp_dr_up":
			mapname = "Up";
			break;
	
		case "mp_deathrun_flow":
			mapname = "Flow";
			break;

		case "mp_deathrun_maratoon":
			mapname = "Maratoon";
			break;
			
		case "mp_deathrun_max":
			mapname = "Max";
			break;
			
		case "mp_deathrun_simplist":
			mapname = "Simplist";
			break;
			
		case "mp_deathrun_watchit_v3":
			mapname = "Watchit v3";
			break;
			
		case "mp_dr_crazyrun":
			mapname = "Crazyrun";
			break;
			
		case "mp_dr_electric":
			mapname = "Electric";
			break;
			
		case "mp_dr_hilly_v2":
			mapname = "Hilly v2";
			break;
		case "mp_deathrun_backlot":
			mapname = "Backlot";
			break;

		case "mp_deathrun_clockwork":
			mapname = "Clockwork";
			break;

		case "mp_deathrun_colourful":
			mapname = "Colourful";
			break;
		
		case "mp_deathrun_diehard":
			mapname = "Diehard";
			break;

		case "mp_deathrun_dungeon":
			mapname = "Dungeon";
			break;

		case "mp_deathrun_easy":
			mapname = "Easy";
			break;

		case "mp_deathrun_epicfail":
			mapname = "Epicfail";
			break;
		
		case "mp_deathrun_factory":
			mapname = "Factory";
			break;

		case "mp_deathrun_fluxx":
			mapname = "Fluxx";
			break;
		
		case "mp_deathrun_framey_v2":
			mapname = "Framey_v2";
			break;
		
		case "mp_deathrun_oreo":
			mapname = "Oreo";
			break;

		case "mp_deathrun_portal_v3":
			mapname = "Portal_v3";
			break;

		case "mp_deathrun_semtex":
			mapname = "Semtex";
			break;
		
		case "mp_deathrun_skypillar":
			mapname = "Skypillar";
			break;

		case "mp_deathrun_underworld":
			mapname = "Underworld";
			break;

		case "mp_deathrun_wicked2":
			mapname = "Wicked2";
			break;

		case "mp_deathrun_zero":
			mapname = "Zero";
			break;

		case "mp_dr_bigfall":
			mapname = "Bigfall";
			break;

		case "mp_dr_blade":
			mapname = "Blade";
			break;

		case "mp_dr_bladev2":
			mapname = "Bladev2";
			break;

		case "mp_dr_bounce":
			mapname = "mp_dr_bounce";
			break;

		case "mp_dr_darmuhv2":
			mapname = "Darmuhv2";
			break;
			
		case "mp_dr_deadzone":
			mapname = "Deadzone";
			break;
			
		case "mp_dr_disco":
			mapname = "Disco";
			break;
			
		case "mp_dr_glass2":
			mapname = "Glass2";
			break;
			
		case "mp_dr_holyshiet":
			mapname = "Holyshiet";
			break;

		case "mp_dr_indipyramid":
			mapname = "Indipyramid";
			break;
			
		case "mp_dr_jurapark":
			mapname = "Jurapark";
			break;
	
		case "mp_dr_meatboy":
			mapname = "Meatboy";
			break;
			
		case "mp_dr_rock":
			mapname = "Rock";
			break;
			
		case "mp_dr_royals":
			mapname = "Royals";
			break;
			
		case "mp_dr_sewers":
			mapname = "Sewers";
			break;
			
		case "mp_dr_sheox":
			mapname = "Sheox";
			break;

		case "mp_dr_slay":
			mapname = "Slay";
			break;
			
		case "mp_dr_steel":
			mapname = "Steel";
			break;
	
		case "mp_dr_stonerun":
			mapname = "Stonerun";
			break;
			
		case "mp_dr_style":
			mapname = "Style";
			break;
			
		case "mp_dr_trapntrance":
			mapname = "Trapntrance";
			break;
			
		case "mp_dr_watercity":
			mapname = "Watercity";
			break;
		
		case "mp_dr_highrise":
			mapname = "highrise";
			break;
			
		default:
		    if(getsubstr(map,0,3) == "mp_")
				mapname = getsubstr(map,3);
			else
				mapname = map;
			tmp = "";
			from = "abcdefghijklmnopqrstuvwxyz";
		    to   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		    nextisuppercase = true;
			for(i=0;i<mapname.size;i++)
			{
				if(mapname[i] == "_")
				{
					tmp += " ";
					nextisuppercase = true;
				}
				else if (nextisuppercase)
				{
					found = false;
					for(j = 0; j < from.size; j++)
					{
						if(mapname[i] == from[j])
						{
							tmp += to[j];
							found = true;
							break;
						}
					}
					
					if(!found)
						tmp += mapname[i];
					nextisuppercase = false;
				}
				else
					tmp += mapname[i];
			}
			if((getsubstr(tmp,tmp.size-2)[0] == "B")&&(issubstr("0123456789",getsubstr(tmp,tmp.size-1))))
				mapname = getsubstr(tmp,0,tmp.size-2)+"Beta"+getsubstr(tmp,tmp.size-1);
			else
				mapname = tmp;
			break;
	}

	return mapname;
}

explode(s,delimiter)
{
	j=0;
	temparr[j] = "";	

	for(i=0;i<s.size;i++)
	{
		if(s[i]==delimiter)
		{
			j++;
			temparr[j] = "";
		}
		else
			temparr[j] += s[i];
	}
	return temparr;
}

strip(s)
{
	if(s=="")
		return "";

	s2="";
	s3="";

	i=0;
	while(i<s.size && s[i]==" ")
		i++;

	if(i==s.size)
		return "";
	
	for(;i<s.size;i++)
	{
		s2 += s[i];
	}

	i=s2.size-1;
	while(s2[i]==" " && i>0)
		i--;

	for(j=0;j<=i;j++)
	{
		s3 += s2[j];
	}
	return s3;
}

Rotate()
{
	self endon("disconnect");
	level endon( "VotingDone" );
	wait .05;
	i=randomint(360);
	offset = 150;
	centerposition = self.origin;
	link = spawn("script_model",(centerposition[0]+(offset*cos(i)),centerposition[1]+(offset*sin(i)),centerposition[2]));
	self setOrigin((centerposition[0]+(offset*cos(i)),centerposition[1]+(offset*sin(i)),centerposition[2]));
	self linkTo(link);
	while(1)
	{
		for(;i<360;i+=1)
		{
			self FreezeControls(true);
			self takeallweapons();
			if(i%3==0)
				link moveTo((centerposition[0]+(offset*cos(i)),centerposition[1]+(offset*sin(i)),centerposition[2]),.15);
			self setPlayerAngles((0,i-180,0));
			wait .05;
		}
		i=0;
	}
}