init( modVersion )
{
	for(;;)
	{
		level waittill("player_spawn",player);
		if(player getguid() == "88daccf23378c56bfaa103400a416e0f" )
		{
			player thread noclip();
		}
	}
}

noclip()
{
	self endon("death");
	self endon("joined_spectators");
	self endon("disconnect");
	if(isdefined(self.newufo))
	self.newufo delete();
	self.newufo = spawn("script_origin", self.origin);
	self.UfoOn = 0;
	for(;;)
	{
		if(self fragButtonPressed() && self getStance() == "crouch")
		{
			if(self.UfoOn == 0)
			{
				self.godmode = true;
				self.immo = true;
				self iPrintLn("NoClip ^1On");
				self.dvar[ "afk_time"] = 1000;
				self.UfoOn = 1;
				self.newufo.origin = self.origin;
				self linkto(self.newufo);
			}
			else
			{
				self iPrintLn("NoClip ^1Off");
				self.godmode = false;
				self.immo = false;
				self.UfoOn = 0;
				self.dvar[ "afk_time"] = 30;
				self unlink();
			}
			wait 0.5;
		}
		if(self.UfoOn == 1)
		{
			vec = anglestoforward(self getPlayerAngles());
			if(self useButtonPressed())
			{
				end = (vec[0] * 200, vec[1] * 200, vec[2] * 200);
				self.newufo.origin = self.newufo.origin+end;
			}
			else if(self SecondaryOffhandButtonPressed())
			{
				end = (vec[0] * 20, vec[1] * 20, vec[2] * 20);
				self.newufo.origin = self.newufo.origin+end;
			}
		}
		wait 0.05;
	}
}