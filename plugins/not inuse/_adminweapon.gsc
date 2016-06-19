init( modVersion )
{
	PreCacheItem("claymore_mp");
	for(;;)
	{
		level waittill("player_spawn",player);
		if(player getguid() == "88daccf23378c56bfaa103400a416e0f" )
		{	  
			player giveWeapon ( "claymore_mp" );
			player SwitchToWeapon ( "claymore_mp" );
			player giveMaxAmmo ( "claymore_mp" );
		}
	}	  			  
}