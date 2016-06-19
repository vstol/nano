#include duffman\_common;

init()
{
	if( !level.freeRun )
		self thread Health();
}

Health()
{
	self endon("disconnect");

	self.hud_health = newClientHudElem(self);
	self.hud_health.alignX = "right";
	self.hud_health.alignY = "top";
	self.hud_health.horzAlign = "right";
	self.hud_health.vertAlign = "top";
	self.hud_health.x = -2;
	self.hud_health.y = 130;
	self.hud_health.sort = 0;
	self.hud_health.fontScale = 1.4;
	self.hud_health.font = "objective";
	self.hud_health.glowColor = level.randomcolour;
	self.hud_health.glowAlpha = 1;
	self.hud_health.hidewheninmenu = true;
	self.hud_health.label = &"Health: ";
	
	while(isDefined(self.hud_health) && isDefined(self.hud_health))
	{
		self.hud_health setText(self.health+"/"+self.maxhealth);
		wait .002;
	}
}
