/*
 * 
 * Made by: Justin
 * Xfire: rumabatu
 * 
 */

init()
{
	if(!isDefined( level.event )) //Singleton
	{
		level.event = [];
		level.event[ "connecting" ] = [];
		level.event[ "connected" ] = [];
		level.event[ "spawned" ] = [];
		level.event[ "death" ] = [];
		level.event[ "killed" ] = [];
		
		level.on = ::addEvent; //create callback pointer for addEvent( event, proces )

		thread onPlayerConnecting();
		thread onPlayerConnected();
	}
}

addEvent( event, process )
{
	if( !isdefined( level.event[ event ] ) || !isdefined( process ))
		return;
	level.event[ event ][ level.event[ event ].size ] = process;
	
}

onPlayerConnecting()
{
	while(1)
	{
		level waittill( "connecting", player );
		for( i=0; i<level.event[ "connecting" ].size; i++ )
			player thread [[level.event[ "connecting" ][i]]]();
	}	
}

onPlayerConnected()
{
	while(1)
	{
		level waittill( "connected", player );

		player thread onPlayerSpawned();
		player thread onPlayerDeath();
		player thread onPlayerKilled();
		for( i=0; i<level.event[ "connected" ].size; i++ )
			player thread [[level.event[ "connected" ][i]]]();
	}	
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "player_spawn" );
		for( i=0; i<level.event[ "spawned" ].size; i++ )
			self thread [[level.event[ "spawned" ][i]]]();
	}
}

onPlayerDeath()
{
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "death" );
		for( i=0; i<level.event[ "death" ].size; i++ )
			self thread [[level.event[ "death" ][i]]]();
	}
}

onPlayerKilled()
{
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "killed_player" );
		for( i=0; i<level.event[ "killed" ].size; i++ )
			self thread [[level.event[ "killed" ][i]]]();
	}
}