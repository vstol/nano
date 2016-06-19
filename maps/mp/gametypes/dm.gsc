main()
{
	if(getDvar("g_gametype") != "deathrun")
	{
		wait 5;

		iPrintlnbold("^1*** ^5Incorrect Gametype Loaded ^1***");
		iPrintlnbold("^2*** ^5Loading Deathrun Gametype ^2***");
		wait 1;
		iPrintlnbold("5..");
		wait 1;
		iPrintlnbold("   4..");
		wait 1;
		iPrintlnbold("      3..");
		wait 1;
		iPrintlnbold("         2..");
		wait 1;
		iPrintlnbold("            1..");
		setDvar("g_gametype", "deathrun");
		wait 0.5;
		exitLevel(false);
	}
}