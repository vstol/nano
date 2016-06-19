init(modver)
{
	wait 1;
	if(getDvar("mismatch_fix") == "")
		setDvar("mismatch_fix",0);
	if(getEntArray("players","classname").size == 0 && getDvarint("mismatch_fix") != 0)
	{
		setDvar("mismatch_fix",0);
		setDvar( "sv_maprotationcurrent", "gametype " + getDvar("g_gametype") + " map " + getDvar("mapname") + "" ); 
		exitLevel( false ); 
	}	
	for(;;)
	{
		if( getEntArray("players","classname").size >= 3 )
		{
			setDvar("mismatch_fix",getEntArray("players","classname").size);
		}
		wait 5;
	}
}