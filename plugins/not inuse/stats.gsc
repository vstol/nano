Start()
{
	self thread makeVars();

	if( isDefined( self.hud_playermodstats ) )
		self.hud_playermodstats destroy();

	self.hud_playermodstats = newClientHudElem(self);
    self.hud_playermodstats.foreground = true;
	self.hud_playermodstats.alignX = "left";
	self.hud_playermodstats.alignY = "top";
	self.hud_playermodstats.horzAlign = "left";
    self.hud_playermodstats.vertAlign = "top";
    self.hud_playermodstats.x = 2;
    self.hud_playermodstats.y = 250;
    self.hud_playermodstats.sort = 5;
  	self.hud_playermodstats.fontScale = 1.4;
	self.hud_playermodstats = level.randomcolour;
	self.hud_playermodstats.font = "objective";
	self.hud_playermodstats.glowAlpha = 1;
	self.hud_playermodstats SetPulseFX( 50, 1000000, 7000 );
 	self.hud_playermodstats.hidewheninmenu = true;
	
	self thread loop();
}
loop()
{
	self endon("disconnect");
	
	while(isDefined(self.hud_playermodstats))
	{
		if(isDefined(self.hud_playermodstats))
			self.hud_playermodstats setText("You Killed " + self.jumpers_kills + " Jumpers");self.hud_playermodstats SetPulseFX( 30, 1000000, 7000 );
		wait 20;
		if(isDefined(self.hud_playermodstats))
			self.hud_playermodstats setText("You Killed " + self.acti_kills + " Activators");self.hud_playermodstats SetPulseFX( 30, 1000000, 7000 );
		wait 20;
		if(isDefined(self.hud_playermodstats))	
			self.hud_playermodstats setText("Your RankXp is " + self.rankxp );self.hud_playermodstats SetPulseFX( 30, 1000000, 7000 );
		wait 20;
		if(isDefined(self.hud_playermodstats))
			self.hud_playermodstats setText("Your Rank is " + self.rank );self.hud_playermodstats SetPulseFX( 30, 1000000, 7000 );
		wait 20;
	}
}
makeVars()
{
	self endon("disconnect");
	
	while(isDefined(self.hud_playermodstats))
	{
		self.jumpers_kills = self maps\mp\gametypes\_persistence::statGet( "KILLED_JUMPERS" );
		self.acti_kills = self maps\mp\gametypes\_persistence::statGet( "KILLED_ACTIVATORS" );
		self.rankxp = self maps\mp\gametypes\_persistence::statGet( "rankxp");
		self.rank = self maps\mp\gametypes\_persistence::statGet( "rank") + 1;
		wait .02;
	}
}