#include braxi\_dvar;

init( modVers )
{
	addDvar( "pi_tt", "plugin_tomahawk_enable", 1, 0, 1, "int" );
	addDvar( "pi_tt_acti_a", "plugin_tomahawk_activator_amount", 2, 0, 8, "int" );
	addDvar( "pi_tt_jumper", "plugin_tomahawk_jumper", 1, 0, 1, "int" );
	addDvar( "pi_tt_jumper_a", "plugin_tomahawk_jumper_amount", 2, 0, 8, "int" );
	addDvar( "pi_tt_dmg", "plugin_tomahawk_damage", 150, 10, 1000, "int" );
	addDvar( "pi_tt_empty", "plugin_tomahawk_empty", 1, 0, 1, "int" );
	addDvar( "pi_tt_emptygun", "plugin_tomahawk_emptygun", "knife", "", "", "string" );
	addDvar( "pi_tt_switch", "plugin_tomahawk_autoswitch", 1, 0, 1, "int" );
	addDvar( "pi_tt_collect", "plugin_tomahawk_collect", 1, 0, 1, "int" );
	addDvar( "pi_tt_last", "plugin_tomahawk_last", 20, 5, 120, "int" );
	
	if( !level.dvar["pi_tt"] )
		return;
	
	thread onJumper();
	thread onActivator();
	thread WatchTomahawkDamage();
}

onJumper()
{
	while(1)
	{
		level waittill( "jumper", jumper );
		jumper giveTomahawk();
	}
}

onActivator()
{
	level waittill( "activator", player );
	player giveTomahawk();
}

giveTomahawk()
{
	if( !isDefined( self ) || !isPlayer( self ) || !isAlive( self ) )
		return;
	
	if( self.pers["team"] == "allies" )
	{
		if( !level.dvar["pi_tt_jumper"] )
			return;
		
		if( !self hasWeapon( "tomahawk_mp" ) )
			self giveWeapon( "tomahawk_mp" );
		self setWeaponAmmoClip( "tomahawk_mp", int( level.dvar["pi_tt_jumper_a"] ) );
		self switchToWeapon( "tomahawk_mp" );
	}
	else
	{
		if( !self hasWeapon( "tomahawk_mp" ) )
			self giveWeapon( "tomahawk_mp" );
		self setWeaponAmmoClip( "tomahawk_mp", int( level.dvar["pi_tt_acti_a"] ) );
		self switchToWeapon( "tomahawk_mp" );
	}
	if( self hasWeapon( "tomahawk_mp" ) && level.dvar["pi_tt_empty"] )
		self thread RemoveTomahawk();
}

AddTomahawk( count )
{
	if( !isDefined( self ) || !isPlayer( self ) || !isAlive( self ) )
		return;
	
	if( !self hasWeapon( "tomahawk_mp" ) )
	{
		self giveWeapon( "tomahawk_mp" );
		self setWeaponAmmoClip( "tomahawk_mp", count );
	}
	else
		self setWeaponAmmoClip( "tomahawk_mp", self GetWeaponAmmoClip( "tomahawk_mp" )+count );
	
	if( level.dvar["pi_tt_empty"] )
		self thread RemoveTomahawk();
}

RemoveTomahawk()	//...when empty
{
	self notify( "remove_toma" );
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "remove_toma" );
	
	wait 0.1;
	
	while( self GetWeaponAmmoClip( "tomahawk_mp" ) > 0 )
	{
		self waittill( "grenade_fire", proj, weap );
		if( weap != "tomahawk_mp" )
			continue;
		proj thread TomahawkPickUp();
	}
	
	self DropItem( "tomahawk_mp" );
	if( !level.dvar["pi_tt_switch"] )
		return;
	
	weaps = self GetWeaponsList();
	for(i=0;i<weaps.size;i++)
	{
		if( WeaponType( weaps[i] ) == "bullet" || WeaponType( weaps[i] ) == "projectile" )
		{
			self SwitchToWeapon( weaps[i] );
			return;
		}
	}
	self iPrintln( "^1>> ^2No more weapons found you could switch to!" );
	if( isDefined( level.dvar["pi_tt_emptygun"] ) )
	{
		gun = strTok( level.dvar["pi_tt_emptygun"], ";" );
		gun = gun[RandomInt(gun.size)];
		self giveWeapon( gun+"_mp" );
		wait 0.05;
		self SwitchToWeapon( gun+"_mp" );
	}
}

TomahawkPickUp()
{
	self endon( "death" );
	
	wait 2;
	
	oldpos = self.origin;
	while(1)		//lets check if its still moving - would be pretty stupid if you could pick it up while it is in mid air xD
	{
		wait 0.25;
		if( oldpos == self.origin )
			break;
		oldpos = self.origin;
	}
	
	if( level.dvar["pi_tt_last"] < 2 )
	{
		self delete();
		return;
	}
	
	time = level.dvar["pi_tt_last"];
	players = getEntArray( "player", "classname" );
	self thread RemoveAfterTime( time );
	
	self.trig = spawn( "trigger_radius", self.origin, 0, 64, 128 );
	
	while(1)
	{
		self.trig waittill( "trigger", player );
		if( !player useButtonPressed() || player.doingBH || player GetWeaponAmmoClip( "tomahawk_mp" ) >= 8 )
			continue;
		player addTomahawk( 1 );
		player PlaySound( "grenade_pickup" );
		player iPrintln( "^1>> ^2You've picked up ^31 ^2tomahawk!" );
		self delete();
	}
}

RemoveAfterTime( time )
{
	if( !isDefined( time ) || !isDefined( self ) )
		return;
	wait time;
	if( isDefined( self.trig ) )
		self.trig delete();
	if( isDefined( self ) )
	{
		self notify( "death" );
		self delete();
	}
}

CreatePickupHud()
{
	if( isDefined( self.pickup_hud ) )
		return;
	
	self.pickup_hud = NewClientHudElem( self );
	self.pickup_hud.alignX = "center";
	self.pickup_hud.alignY = "middle";
	self.pickup_hud.horzalign = "center";
	self.pickup_hud.vertalign = "middle";
	self.pickup_hud.alpha = 0.75;
	self.pickup_hud.x = 0;
	self.pickup_hud.y = 60;
	self.pickup_hud.font = "default";
	self.pickup_hud.fontscale = 1.6;
	self.pickup_hud.glowalpha = 1;
	self.pickup_hud.glowcolor = (1,0,0);
	self.pickup_hud setText( "^1>> ^2Press ^1[{+activate}] ^2to pick up tomahawk!" );
}

WatchTomahawkDamage()
{
	while(1)
	{
		level waittill( "player_damage", victim, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		if( sWeapon != "tomahawk_mp" || sMeansOfDeath == "MOD_MELEE" || sMeansOfDeath == "MOD_FALLING" || victim.pers["team"] == eAttacker.pers["team"] )
			continue;
		victim FinishPlayerDamage( eAttacker, eAttacker, int( (level.dvar["pi_tt_dmg"]-1) ), iDFlags, sMeansOfDeath, "tomahawk_mp", vPoint, vDir, sHitLoc, psOffsetTime );
		//iPrintln( int( (level.dvar["pi_tt_dmg"]-1) ) );
	}
}