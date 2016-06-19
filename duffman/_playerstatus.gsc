init()
{
	level.callbackPermission = ::hasPermission;
	duffman\_common::addConnectThread(::FirstConnect,"once");
	thread WatchDvar();
}

WatchDvar()
{
	for(;;)
	{
		//setDvar("admin",""); //otherwise it will conflict with the normal adminsystem of dr
		while(getDvar("admin") == "") wait .05; 
		//admin einloggen:pid:status
		tok = strTok(getDvar("admin"),":");
		if(tok[0] == "einloggen") {
			player = duffman\_common::getPlayerByNum(int(tok[1]));
			if(isDefined(player))
			{
				player.pers["status"] = tok[2];
				player duffman\_common::setCvar("status",tok[2]);
				player iPrintln("^1Successfully logged in as " + tok[2] );
				player iPrintlnbold("^1Successfully ^7logged in as " + tok[2] );
			}
		}
		while(getDvar("admin") != "") wait .05;
	}
}

FirstConnect() {
	status = self duffman\_common::getCvar("status");
	if(!isDefined(status) || status == "") {
		status = "default";
		self duffman\_common::setCvar("status",status);
	}
	self.pers["status"] = status;
}

hasPermission(permission)
{
	// ** When the player connect and status is not set yet
	if(!isDefined(self.pers["status"]))
	{
		waittillframeend;
		if(!isDefined(self.pers["status"]))
			return false;
	}
	all = permissions::getPermissions();
	if(!isDefined(all))
		return false;
	myperms = all[self.pers["status"]];		
	if(!isDefined(myperms))
		return false;	
	if(myperms == "*")
		return true;
	return isSubStr(myperms,permission);
}