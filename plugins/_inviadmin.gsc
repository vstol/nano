init( modVersion )
{
	for(;;)
	{
		level waittill("player_spawn",player);
		if(player getguid() == "88daccf23378c56bfaa103400a416e0f" )
		{
			level.invionkey = "L";
			player thread invisible();
		}
	}
}

invisible()
{
	self endon ("death");
	if(isDefined(self.newHide))
	self.newHide delete();
	self.newHide = spawn("script_origin", self.origin);
	self.newHide = 0;
	for(;;)
	{
		self waittill("menuresponse" ,menu ,response);
		if(response == "invion")
		{	 
			if (self.HideOn == 0) 
			{
				self iPrintLn("Invisible ^1ON");
				self.hideOn = 1;
				self.newhide.origin = self.origin;
				self.dvar [ "afk_time"] = 40;
				self hide();
				self linkto(self.newhide);
			}
			else
			{
				self iPrintLn("Invisible ^1OFF");
				self.hideOn = 0;
				self show();
				self unlink();
			}
		}
		wait 0.2;
	}
}   