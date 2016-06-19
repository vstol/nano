/*---------------------------------------------------------------------------
|///////////////////////////////////////////////////////////////////////////|
|///\  \/////////  ///|  |//|  |///  ///|  |//|   \////|  |//|          |///|
|////\  \///////  ////|  |//|  |//  ////|  |//|    \///|  |//|  ________|///|
|/////\  \/////  /////|  |//|  |/  /////|  |//|  \  \//|  |//|  |///////////|
|//////\  \///  //////|  |//|     //////|  |//|  |\  \/|  |//|  |//|    |///|
|///////\  \/  ///////|  |//|     \/////|  |//|  |/\  \|  |//|  |//|_   |///|
|////////\    ////////|  |//|  |\  \////|  |//|  |//\  \  |//|  |////|  |///|
|/////////\  /////////|  |//|  |/\  \///|  |//|  |///\    |//|          |///|
|//////////\//////////|__|//|__|//\__\//|__|//|__|////\___|//|__________|///|
|///////////////////////////////////////////////////////////////////////////|
|---------------------------------------------------------------------------|
|				   Do not copy or modify without permission				    |
|--------------------------------------------------------------------------*/

init()
{
	if( getDvarInt("scr_disable_antiwallbang") != 1 )
		thread AntiWallbang();
}

AntiWallbang()
{
	level waittill("activator", player);
	player thread CheckActiDamaged();
	
	players = getentarray("player", "classname");
	for(i=0;i<players.size;i++)
		players[i] thread CheckFiring();
}

onConnected()
{
	while(1)
	{
		level waittill("connected", player );
		player thread CheckFiring();
	}
}

CheckActiDamaged()
{
	self notify("check_damaged");
	self endon("check_damaged");
	
	if( !isDefined( self ) )
		return;
	
	level.actiDamaged = false;
	
	while(1)
	{
		self waittill("damage");
		if( !isDefined( self ) || !isAlive( self ) )
			return;
		level.actiDamaged = true;
		wait 0.07;
		level.actiDamaged = false;
	}
}

CheckFiring()
{
	self endon("disconnect");
	
	self notify("check_firing");
	self endon("check_firing");

	while(1)
	{
		self waittill("begin_firing");
		if( !isAlive( self ) || level.freeRun )
			continue;
		wait 0.05;
		if( level.actiDamaged )
			self CheckWallbang();
	}
}

CheckWallbang()
{
	trace = BulletTrace( self getEye(), level.activ GetEye(), true, self);
	trace2 = BulletTrace( self.origin, level.activ.origin, true, self);
	trace3 = BulletTrace( self GetTagOrigin("j_spinelower"), level.activ GetTagOrigin("j_spinelower"), true, self);

	if( ( isdefined(trace["entity"]) && isplayer(trace["entity"]) && !isDefined( trace["surface"] ) ) || ( isdefined(trace2["entity"]) && isplayer(trace2["entity"]) && !isDefined( trace2["surface"] ) ) || ( isdefined(trace3["entity"]) && isplayer(trace3["entity"]) && !isDefined( trace3["surface"] ) ) )
		return;
	else
		self thread WasWallbanging();
}

WasWallbanging()
{
	self suicide();
	self iprintlnbold("^1Do not wallbang!");
	iprintlnbold("^1" + self.name + " tried to wallbang!");
	level.activ iprintln("^2" + self.name + "tried to wallbang you!");
	level.activ iprintln("^2You health got restored!");
	level.activ.health = level.activ.maxhealth;
	level.activ notify("damage");		//to update the health bar ;)
	level.actiDamage = false;
}