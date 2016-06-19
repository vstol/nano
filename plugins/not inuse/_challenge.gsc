init( version )
{
	if( level.freeRun )
		return;
		
	if(!isDefined(getDvar("Completed_by")))
		setDvar("Completed_by", "");
		self thread Challenge();
		
	if(self getStat(295) > 120 && getDvar("Completed_by") == "")
	{
		self setStat(295,0);
		self iPrintlnBold("your stat has been reset");
	}
}

Challenge()
{
	if( level.freeRun )
		return;
	
	self endon("endmap");
	if(isdefined(self.hud_challengetask))
		self.hud_challengetask destroy();
	if(isdefined(self.hud_challengereward))
		self.hud_challengereward destroy();
	if(isdefined(self.hud_challengescore))
		self.hud_challengescore destroy();
	if(!isDefined(self getStat(295)))
		self setStat(295,0);
	self.hud_challengetask = newClientHudElem(self);
	self.hud_challengetask.alignX = "left";
	self.hud_challengetask.alignY = "top";
	self.hud_challengetask.horzAlign = "left";
	self.hud_challengetask.vertAlign = "top";
	self.hud_challengetask.x = 2;
	self.hud_challengetask.y = 10 + level.hudYOffset;
	self.hud_challengetask.sort = 0;
	self.hud_challengetask.fontScale = 1.4;
	self.hud_challengetask.font = "objective";
	self.hud_challengetask.glowColor = level.randomcolour;
	self.hud_challengetask.glowAlpha = 1;
	self.hud_challengetask.hidewheninmenu = true;
	self.hud_challengetask setText("Challenge:Kill 120 players");
	
	self.hud_challengereward = newClientHudElem(self);
	self.hud_challengereward.alignX = "left";
	self.hud_challengereward.alignY = "top";
	self.hud_challengereward.horzAlign = "left";
	self.hud_challengereward.vertAlign = "top";
	self.hud_challengereward.x = 2;
	self.hud_challengereward.y = 30 + level.hudYOffset;
	self.hud_challengereward.sort = 0;
	self.hud_challengereward.fontScale = 1.4;
	self.hud_challengereward.font = "objective";
	self.hud_challengereward.glowColor = self.hud_challengetask.glowColor;
	self.hud_challengereward.glowAlpha = 1;
	self.hud_challengereward.hidewheninmenu = true;
	if(getDvar("Completed_by") == "")
		self.hud_challengereward setText("Reward:3000 xP");
	else
		self.hud_challengereward setText("Reward:Completed by " + getDvar("Completed_by"));
		
	self.hud_challengescore = newClientHudElem(self);
	self.hud_challengescore.alignX = "left";
	self.hud_challengescore.alignY = "top";
	self.hud_challengescore.horzAlign = "left";
	self.hud_challengescore.vertAlign = "top";
	self.hud_challengescore.x = 2;
	self.hud_challengescore.y = 50 + level.hudYOffset;
	self.hud_challengescore.sort = 0;
	self.hud_challengescore.fontScale = 1.4;
	self.hud_challengescore.font = "objective";
	self.hud_challengescore.glowColor = self.hud_challengereward.glowColor;
	self.hud_challengescore.glowAlpha = 1;
	self.hud_challengescore.hidewheninmenu = true;
	if(getDvar("Completed_by") == "" )
		self.hud_challengescore setText("Your Killed:" + self getStat(295));
	else
		self.hud_challengescore setText("Your Killed:Completed by " + getDvar("Completed_by"));
}
Completed(attacker,reward)
{
	setDvar("Completed_by",attacker.name);
	attacker thread giveRankXp("challenge",reward);
	thread duffman\_hud::madebyduff2( 800, 0.8, 1, attacker.name + " Got 3000Xp For completing challenge" );
	thread duffman\_hud::madebyduff2( 800, 0.8, -1, attacker.name + " Got 3000Xp For completing challenge" );
	p = braxi\_common::getAllPlayers();
	for(i=0;i<p.size;i++)
	{
		if(isDefined(p[i].hud_challengescore) && isDefined(p[i].hud_challengereward))
		{
			p[i].hud_challengescore setText("Your Killed:Completed by " + getDvar("Completed_by"));
			p[i].hud_challengereward setText("Reward:Completed by " + getDvar("Completed_by"));
		}
	}
}

giveRankXP( type, value )
{
	self endon("disconnect");

	if ( !isDefined( value ) )
		value = braxi\_rank::getScoreInfoValue( type );
	
	if( getDvar("dedicated") == "listen server" )
		return;
		
	self.score += value;
	self.pers["score"] = self.score;

	score = self maps\mp\gametypes\_persistence::statGet( "score" );
	self maps\mp\gametypes\_persistence::statSet( "score", score+value );

	self braxi\_rank::incRankXP( value );
	self thread braxi\_rank::updateRankScoreHUD( value );
}