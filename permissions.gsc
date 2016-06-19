getPermissions() {
	permission = [];
	// ** set the permissions for each group here
	//    seperate them with , 

	// ** To add a player as admin etc. use 'set admin einloggen:PID:ADMINRANK'

	permission["master"] = "*,founder,Member,vip_admin,master";
	permission["leader"] = "*,leader,Member,vip_admin";
	permission["headadmin"] = "headadmin,Member,vip_admin";
	permission["fulladmin"] = "fullAdmin,Member,";
	permission["rookie"] = "rookie,Member";
	permission["member"] = "member,Member";
	permission["default"] = "";
	return permission;
}