main()
{
	LoadPlugin( plugins\_Togglebinds::init, "Bind Fullbright", "CrazY" );
	LoadPlugin( plugins\_antispec::init, "Fix spectator spawn crash bug", "Dunciboy" );
	LoadPlugin( plugins\_hostname::init, "HS", "Rycoon" );
	LoadPlugin( plugins\_hitmarker::init, "hitmarker", "Rycoon" );
	LoadPlugin( plugins\_welcome::init, "Welcome Message", "BraXi" );
	LoadPlugin( plugins\_antiwallbang::init, "Anti-Wallbang", "Viking" );
	LoadPlugin( plugins\_pickup::init, "pickup", "xD" );
	LoadPlugin( plugins\_map_settings::init, "Advanced deathrun map settings", "DuffMan" );
	LoadPlugin( plugins\ammorestore::init, "Auto-AmmoRefill", "Wingzor" );
	LoadPlugin( plugins\_doublexp::init, "Client Doublexp", "Wingzor" );
	LoadPlugin( plugins\_rtd::init, "Roll The Dice", "Duffman" );
	LoadPlugin( plugins\_advertisement::init, "advertisement", "Duffman" );
	LoadPlugin( plugins\_anticheat::init, "anticheat", "Wingzor" );
	LoadPlugin( plugins\_shop::init, "Shop", "Wingzor" );
	LoadPlugin( plugins\_slotmachine::init, "Slotmachine/Credits v1", "Wingzor" );
	LoadPlugin( plugins\srvbrowser::init, "InGame Serverbrowser", "DuffMan" );
	LoadPlugin( plugins\_quickscope::init, "'noscope", "wingzor" );
	LoadPlugin( plugins\mismatch_fix::init, "'Fix' for mismatch errors", "unkowen" );
	LoadPlugin( plugins\vip\_vip::init, "Vip Menu", "CrazY" );
	LoadPlugin( plugins\_antiglitch::init, "'antiglitch", "Wingzor" );
	LoadPlugin( plugins\_showfps::init, "'antiglitch", "Wingzor" );
	LoadPlugin( plugins\_dynamic_rotations::init, "dynamic rotations", "CrazY" );
	LoadPlugin( plugins\_geo::init, "welcome geo", "CrazY" );
	LoadPlugin( plugins\_ghostrun::init, "ghostrun", "Wingzor & CrazY" );
	LoadPlugin( plugins\_sounds::init, "dr sounds", "CrazY" );
	LoadPlugin( plugins\_monkeybomb::init, "'monkey bomb", "CrazY" );
	
	if(getDvar("mapname") == "mp_dr_sm_world")
	{
		LoadPlugin( plugins\mariobugfix::init, "Mario Cloud bugfix", "DuffMan" );
	}
	if(getDvar("mapname") != "mp_deathrun_qube")setDvar("g_knockback",1000);
	if(getDvar("mapname") == "mp_dr_gooby")setDvar("bg_fallDamageMaxHeight",275);
	if(getDvar("mapname") == "mp_dr_stonerun")setDvar("bg_fallDamageMaxHeight",275);
	
	//LoadPlugin( plugins\_menu_update::init, "menu hud update", "CrazY" );
}

LoadPlugin( pluginScript, name, author )
{
	thread [[ pluginScript ]]();
	println( "" + name + " ^7plugin created by " + author + "\n" );
}