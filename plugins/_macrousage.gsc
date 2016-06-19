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
	level.maxwarns=3;
  for(;;)
  {	 level waittill("connected", player);
		player thread initStats();
  }
}

initStats()
{
if(!isdefined(self.warns))
	self.warns=0;
self.shots=0;
self thread CheckRate();
self thread FireCounter();
}

checkRate()
{
	self endon("disconnect");
	while(1)
	{
		while(isValidSingleShot(self getcurrentweapon()))
		{
		self.currentshots=self.shots;
		wait 0.12;
		if((self.shots-self.currentshots)>=2)
		{
			self freezecontrols(true);
			self.warns+=1;
			iprintln("^5 CP'^7_^5AntiCheat^7:^1 " + self.name + " ^7uses rapidfire, ^5Warning:(^7" + self.warns + "^5/^7" +level.maxwarns +"^5)^7");
			wait 1.2;
				if(self.warns>=level.maxwarns)
					{
					self.warns=undefined;
					self thread dropPlayer("kick","Repeatedly Macro Usage(AutoKick)");					
					}
			self freezecontrols(false);
		}
		self.shots=0;
		}
		wait 1;
	}
}

FireCounter()
{
	while(1)
	{
		self waittill( "weapon_fired" );
		self.shots++;
	}
}

isValidSingleShot(wep) {
	weps = strTok("beretta;colt;deserteagle;g3_;m1014;m14;m21;usp;winchester1200", ";");
	for(i=0;i<weps.size;i++) {
		if(isSubStr(wep,weps[i]))
			return true;
	}
	return false;
}

dropPlayer(type,reason,time) {
	if(isDefined(self.banned)) return;
	self.banned = true;
	self notify("catched");
	
	logPrint(type + " player " + self.name + "("+self getGuid()+"), Reason: " +reason + " #");
	text = "";
	if(type == "kick")
		text = "^5Kicking ^7" + self.name + " ^7for ^5" + reason + " ^7#";
	level thread showDelayText(text,1);
	if(type == "kick")	
		exec("clientkick " + self getEntityNumber() + " " + reason);	
	wait 10;  
}

showDelayText(text,delay) {
	wait delay;
	iPrintln(text);
}

