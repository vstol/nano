#include maps\mp\gametypes\_hud_util;

//thread fun thread braxi\_killcam::init(attacker, self, sWeapon, sMeansofDeath, eInflictor);

init(attacker, victim, sWeapon, sMeansofDeath, eInflictor)
{
	level notify( "newercam" );
	level endon( "newercam" );
	
	if( game["roundsplayed"] == level.dvar["round_limit"] )
		return;
	
	wait 3.6;
	if(getDvar("scr_killcam_time") == "")
	{	
		setdvar("scr_killcam_time", 8);
		setdvar("scr_killcam_posttime", 9);
	}

	attackerNum = attacker getEntityNumber();
	
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
	{
		players[i].sessionstate = "dead";
		players[i] notify( "stop_respawn" );
		players[i] thread killcam( attackerNum, -1, sWeapon, sMeansofDeath, 0, 0, 0, undefined, 0, attacker, victim);
	}
	
}

killcam(
	attackerNum, // entity number of the attacker
	killcamentity, // entity number of the attacker's killer entity aka helicopter or airstrike
	sWeapon,	// killing weapon
	sMeansofDeath,	// type of death
	predelay, // time between player death and beginning of killcam
	offsetTime, // something to do with how far back in time the killer was seeing the world when he made the kill; latency related, sorta
	respawn, // will the player be allowed to respawn after the killcam?
	maxtime, // time remaining until map ends; the killcam will never last longer than this. undefined = no limit
	perks, // the perks the attacker had at the time of the kill
	attacker, // entity object of attacker
	victim // entity object of victim
)
{
	// monitors killcam and hides HUD elements during killcam session
	//if ( !level.splitscreen )
	//	self thread killcam_HUD_off();
	
	self endon("disconnect");
	level endon("game_ended");

	if(attackerNum < 0)
		return;

	// length from killcam start to killcam end
	if (getdvar("scr_killcam_time") == "")
	{
		if (sWeapon == "artillery_mp")
			camtime = 1.3;
		else if ( !respawn ) // if we're not going to respawn, we can take more time to watch what happened
			camtime = 5.0;
		else if (sWeapon == "frag_grenade_mp")
			camtime = 4.5; // show long enough to see grenade thrown
		else
			camtime = 2.5;
	}
	else
		camtime = getdvarfloat("scr_killcam_time");
	
	if (isdefined(maxtime)) {
		if (camtime > maxtime)
			camtime = maxtime;
		if (camtime < .05)
			camtime = .05;
	}
	
	// time after player death that killcam continues for
	if (getdvar("scr_killcam_posttime") == "")
		postdelay = 2;
	else {
		postdelay = getdvarfloat("scr_killcam_posttime");
		if (postdelay < 0.05)
			postdelay = 0.05;
	}
	
	/* timeline:
	
	|        camtime       |      postdelay      |
	|                      |   predelay    |
	
	^ killcam start        ^ player death        ^ killcam end
	                                       ^ player starts watching killcam
	
	*/
	
	killcamlength = camtime + postdelay;
	
	// don't let the killcam last past the end of the round.
	if (isdefined(maxtime) && killcamlength > maxtime)
	{
		// first trim postdelay down to a minimum of 1 second.
		// if that doesn't make it short enough, trim camtime down to a minimum of 1 second.
		// if that's still not short enough, cancel the killcam.
		if (maxtime < 2)
			return;

		if (maxtime - camtime >= 1) {
			// reduce postdelay so killcam ends at end of match
			postdelay = maxtime - camtime;
		}
		else {
			// distribute remaining time over postdelay and camtime
			postdelay = 1;
			camtime = maxtime - 1;
		}
		
		// recalc killcamlength
		killcamlength = camtime + postdelay;
	}

	killcamoffset = camtime + predelay;
	
	self notify ( "begin_killcam", getTime() );
	
	self.sessionstate = "spectator";
	self.spectatorclient = attackerNum;
	self.killcamentity = killcamentity;
	self.archivetime = killcamoffset;
	self.killcamlength = killcamlength;
	self.psoffsettime = offsetTime;

	// ignore spectate permissions
	self allowSpectateTeam("allies", true);
	self allowSpectateTeam("axis", true);
	self allowSpectateTeam("freelook", true);
	self allowSpectateTeam("none", true);
	
	// wait till the next server frame to allow code a chance to update archivetime if it needs trimming
	wait 0.05;

	if ( self.archivetime <= predelay ) // if we're not looking back in time far enough to even see the death, cancel
	{
		self.sessionstate = "dead";
		self.spectatorclient = -1;
		self.killcamentity = -1;
		self.archivetime = 0;
		self.psoffsettime = 0;
		
		return;
	}
	
	self.killcam = true;

	self thread spawnedKillcamCleanup();
	self thread endedKillcamCleanup();
	self thread waitKillcamTime();

	self waittill("end_killcam");

	self endKillcam();

	self.sessionstate = "dead";
	self.spectatorclient = -1;
	self.killcamentity = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
}

waitKillcamTime()
{
	self endon("disconnect");
	self endon("end_killcam");

	wait (getdvarfloat("scr_killcam_time")) - 1;

	self notify("end_killcam");
}

endKillcam()
{
	self.killcam = undefined;
	
	self braxi\_mod::spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
}

spawnedKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	self waittill("spawned");
	self endKillcam();
}

endedKillcamCleanup()
{
	self endon("end_killcam");
	self endon("disconnect");

	level waittill("game_ended");
	self endKillcam();
}