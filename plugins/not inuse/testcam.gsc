init ( ModVersion )
{
        for(;;)
        {
                level waittill("connected", player);
				player thread tracer();
        }
}
 

tracer()
{
self endon("death");
	while(1)
	{
		self waittill("weapon_fired");
		my = self gettagorigin("j_head");
		trace=bullettrace(my, (my + (anglestoforward(self getplayerangles())*100000)-100),true,self)["position"];
		iPrintlnbold(trace);
		dis=distance(self.origin, trace);
		iPrintlnbold(dis);
		if(dis>350)
		{
			self DisableWeapons();
			self freezecontrols(true);
			time=(dis/3500);
			iPrintlnbold(time);
			linker = Spawn("script_origin",self getorigin());
			cur = self getorigin();
			self linkto(linker);
			linker MoveTo(trace,(dis/3500));
			wait ((time/100)*90);
			self unlink();
			wait 1;
			self setorigin(cur);
			self EnableWeapons();
			self freezecontrols(false);
		}
	}
}