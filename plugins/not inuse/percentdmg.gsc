//__/\\\______________/\\\______________________________________________________________________________________         
// _\/\\\_____________\/\\\______________________________________________________________________________________        
//  _\/\\\_____________\/\\\__/\\\_________________/\\\\\\\\______________________________________________________       
//   _\//\\\____/\\\____/\\\__\///___/\\/\\\\\\____/\\\////\\\__/\\\\\\\\\\\_____/\\\\\_____/\\/\\\\\\\____________      
//    __\//\\\__/\\\\\__/\\\____/\\\_\/\\\////\\\__\//\\\\\\\\\_\///////\\\/____/\\\///\\\__\/\\\/////\\\___________     
//     ___\//\\\/\\\/\\\/\\\____\/\\\_\/\\\__\//\\\__\///////\\\______/\\\/_____/\\\__\//\\\_\/\\\___\///____________    
//      ____\//\\\\\\//\\\\\_____\/\\\_\/\\\___\/\\\__/\\_____\\\____/\\\/______\//\\\__/\\\__\/\\\___________________   
//       _____\//\\\__\//\\\______\/\\\_\/\\\___\/\\\_\//\\\\\\\\___/\\\\\\\\\\\__\///\\\\\/___\/\\\___________________  
//        ______\///____\///_______\///__\///____\///___\////////___\///////////_____\/////_____\///____________________ 
init( modVersion )
{
	for(;;)
	{	
		level waittill("connected", player);
		player thread setupTagpercentage();
	}
}

setupTagpercentage()
{
self thread hudSetup();
self thread updatehud();
self thread watchupdatehud();
}

updatehud()
{
	for(;;)
	{
		while(1)
		{
			level waittill( "player_damage", hitplayer, attacker, Damage);
			if( isDefined(attacker) && isPlayer(attacker) && hitplayer != attacker && self==attacker && isDefined(level.activ) && ( level.activ == hitplayer || level.activ == attacker) )
			{
			self.pers["shoots"]++;
			self.pers["tagpercentage"]=(self.pers["tagpercentage"]+Damage);
			self.tagpercentHUD.alpha = 1;
			self notify("updatetagpercent");	
			}
		}
		
	}
}

watchupdatehud()
{
	for(;;)
	{	
		if(self.pers["shoots"]>0)
		{	
			self.shotvalue=1;
			while(self.pers["shoots"]>0)
			{
				wait 1;
				if(self.shotvalue==self.pers["shoots"])
				{
				self.tagpercentHUD.alpha = 0;
				self.shotvalue=0;
				self.pers["shoots"]=0;
				self.pers["tagpercentage"]=0;
				self notify("updatetagpercent");
				}
				else if((self.pers["shoots"]-self.shotvalue)>2)
					self.shotvalue=self.pers["shoots"];
				else
					self.shotvalue++;
			}
		}
		wait 0.05;
	}
}



hudSetup()
{

	self.tagpercentHUD = newClientHudElem(self);	//hud visible for all, to make it only visible for one replace level. with self. and change newHudElem() to newClientHudElem(self)
	self.tagpercentHUD.x = 60;	//position on the x-axis
	self.tagpercentHUD.y = 20;	//position on the <-axis
	self.tagpercentHUD.horzAlign = "center";	
	self.tagpercentHUD.vertAlign = "middle";
	self.tagpercentHUD.alignX = "left";
	self.tagpercentHUD.alignY = "top";
	self.tagpercentHUD.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	self.tagpercentHUD.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	self.tagpercentHUD.archived = false;	//visible in killcam
	self.tagpercentHUD.alpha = 0;	//transparency	0 = invicible, 1 = visible
	self.tagpercentHUD.fontScale = 1.5;	//textsize
	self.tagpercentHUD.hidewheninmenu = false;	//will it be visble when a player is in a menu
	self.tagpercentHUD.glowColor = (30/255,144/255,1);
	self.tagpercentHUD.glowAlpha = 1;
	self.tagpercentHUD.color = (1,1,1);	//RGB color code
	self.tagpercentHUD.label = &"^7&&1 hit";	//The text for the hud & is required, &&1 is the value which will be added below
	
	self.pers["tagpercentage"]=0;
	self.pers["shoots"]=0;
	while(1)
	{		
		self.tagpercentHUD setValue(self.pers["tagpercentage"]);
		self waittill("updatetagpercent");
	}
}