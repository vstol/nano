//  ________/\\\\\\\\\__________________________________________________________        
//   _____/\\\////////___________________________________________________________       
//    ___/\\\/_________________________________________________________/\\\__/\\\_      
//     __/\\\______________/\\/\\\\\\\___/\\\\\\\\\_____/\\\\\\\\\\\___\//\\\/\\\__     
//      _\/\\\_____________\/\\\/////\\\_\////////\\\___\///////\\\/_____\//\\\\\___    
//       _\//\\\____________\/\\\___\///____/\\\\\\\\\\_______/\\\/________\//\\\____   
//        __\///\\\__________\/\\\__________/\\\/////\\\_____/\\\/_______/\\_/\\\_____  
//         ____\////\\\\\\\\\_\/\\\_________\//\\\\\\\\/\\__/\\\\\\\\\\\_\//\\\\/______ 
//          _______\/////////__\///___________\////////\//__\///////////___\////________

#include duffman\_common;

init()
{
	addVip("0a416e0f","CrazY");
	addVip("03779455","CrazY");
	addVip("5b4fec98","joker");
	addVip("5b9bfaeb","Guest61");
	addVip("dee720e9","Hive");
	addVip("42aa99a0","Kierann<3");
	addVip("655627ad","[Velo]Kieran");
	addVip("1c6c0c56","pre");
	addVip("01354362","xenox");
	
	// payed vips
	addVip("3497367c","MadCaps|YzXoU"); // ends jan / 26
	addVip("16c9d883","K3ksy"); // ends jan / 15
	
	thread onPlayerConnected();
}
addVip(guid,name)
{
	if(!isDefined(level.map_vips)) level.map_vips["guid"] = [];
	level.map_vips["guid"][level.map_vips["guid"].size] = guid;
	level.map_vips["name"][level.map_vips["guid"].size] = name;
}
isVip(player)
{
	for(i=0;i<level.map_vips["guid"].size;i++)
		if(level.map_vips["guid"][i] == getSubStr(player getGuid(),24,32))
			return true;
	return false;
}

onPlayerConnected() 
{
	for(;;) 
	{
		level waittill("connected",player);
		player thread watchforshock();
		if(isVip(player))
		{
			player thread viphud();
			
			
			// visions would personally do it like this ohh i
			//regardless if it is defined, we want our vip to get the values from their mpdata :D
			//so these people are vip so we need to setstat their values
			//only need to be done once actually
			
			// admin
			if(!isDefined(player.pers["allperks"]))
				player.pers["allperks"] = player getstat(2112);
			if(!isDefined(player.pers["lifehack"]))
				player.pers["lifehack"] = player getstat(2113);
			
			// visions
			if(!isDefined(player.pers["promod"]))
				player.pers["promod"] = player getstat(2211);
			if(!isDefined(player.pers["nightv"]))
				player.pers["nightv"] = player getstat(2212);
			if(!isDefined(player.pers["cartoon"]))
				player.pers["cartoon"] = player getstat(2213);
			if(!isDefined(player.pers["chrome"]))
				player.pers["chrome"] = player getstat(2214);
			if(!isDefined(player.pers["rainbow"]))
				player.pers["rainbow"] = player getstat(2215);
			if(!isDefined(player.pers["thermal"]))
				player.pers["thermal"] = player getstat(2216);
			if(!isDefined(player.pers["laser"]))
				player.pers["laser"] = player getstat(2217);
			
			// weapons
			if(!isDefined(player.pers["royal"]))
				player.pers["royal"] = player getstat(2311);
			if(!isDefined(player.pers["shockwave"]))
				player.pers["shockwave"] = player getstat(2312);
			if(!isDefined(player.pers["akimbos"]))
				player.pers["akimbos"] = player getstat(2313);
			if(!isDefined(player.pers["magnum"]))
				player.pers["magnum"] = player getstat(2314);
			if(!isDefined(player.pers["colt44"]))
				player.pers["colt44"] = player getstat(2315);
			if(!isDefined(player.pers["r700"]))
				player.pers["r700"] = player getstat(2316);
			if(!isDefined(player.pers["m40a3"]))
				player.pers["m40a3"] = player getstat(2318);
			if(!isDefined(player.pers["eagle"]))
				player.pers["eagle"] = player getstat(2319);
			if(!isDefined(player.pers["usp_45"]))
				player.pers["usp_45"] = player getstat(2320);
			if(!isDefined(player.pers["colt45"]))
				player.pers["colt45"] = player getstat(2321);
			if(!isDefined(player.pers["beretta"]))
				player.pers["beretta"] = player getstat(2322);
			
			// characters
			if(!isDefined(player.pers["nico"]))
				player.pers["nico"] = player getstat(2411);
			if(!isDefined(player.pers["joker"]))
				player.pers["joker"] = player getstat(2412);
			if(!isDefined(player.pers["terminator"]))
				player.pers["terminator"] = player getstat(2413);
			if(!isDefined(player.pers["ghost_recon"]))
				player.pers["ghost_recon"] = player getstat(2414);
			if(!isDefined(player.pers["vin_diesel"]))
				player.pers["vin_diesel"] = player getstat(2415);
			if(!isDefined(player.pers["sheperd_dog"]))
				player.pers["sheperd_dog"] = player getstat(2416);
			if(!isDefined(player.pers["sas"]))
				player.pers["sas"] = player getstat(2417);
			if(!isDefined(player.pers["shepherd"]))
				player.pers["shepherd"] = player getstat(2421);
			if(!isDefined(player.pers["masterchief"]))
				player.pers["masterchief"] = player getstat(2422);
			if(!isDefined(player.pers["makarov"]))
				player.pers["makarov"] = player getstat(2423);
			if(!isDefined(player.pers["alasad"]))
				player.pers["alasad"] = player getstat(2425);
			if(!isDefined(player.pers["alice"]))
				player.pers["alice"] = player getstat(2426);
			if(!isDefined(player.pers["cent"]))
				player.pers["cent"] = player getstat(2427);
				
			// perks
			if(!isDefined(player.pers["bulletdamage"]))
				player.pers["bulletdamage"] = player getstat(2511);
			if(!isDefined(player.pers["fastreload"]))
				player.pers["fastreload"] = player getstat(2512);
			if(!isDefined(player.pers["longersprint"]))
				player.pers["longersprint"] = player getstat(2513);
			if(!isDefined(player.pers["armorvest"]))
				player.pers["armorvest"] = player getstat(2514);
			if(!isDefined(player.pers["bulletaccuracy"]))
				player.pers["bulletaccuracy"] = player getstat(2515);
			if(!isDefined(player.pers["rof"]))
				player.pers["rof"] = player getstat(2516);
			if(!isDefined(player.pers["holdbreath"]))
				player.pers["holdbreath"] = player getstat(2517);
			if(!isDefined(player.pers["none"]))
				player.pers["none"] = player getstat(2518);
				
				
			// fun
			if(!isDefined(player.pers["pickup"]))
				player.pers["pickup"] = player getstat(2611);
			if(!isDefined(player.pers["forge"]))
				player.pers["forge"] = player getstat(2612);
			if(!isDefined(player.pers["nukebullets"]))
				player.pers["nukebullets"] = player getstat(2613);
			if(!isDefined(player.pers["speed"]))
				player.pers["speed"] = player getstat(2614);
				
			if(!isDefined(player.pers["weed_trail"]))
				player.pers["weed_trail"] = player getstat(2811);
				
			if(!isDefined(player.pers["vipheadicon"]))
				player.pers["vipheadicon"] = player getstat(2714);
				
			if(!isDefined(player.pers["canvip"]))
			{
				player setstat(1348,20);
				player.pers["canvip"] = true;
				iPrintln("^2[VIP]:^7",player.name, " Joined The Game!");
				player.statusicon = "hudicon_vip";
				
			}
		}
	}
}
vip_fun()
{
	if(self.pers["speed"] == 1)
		self thread plugins\vip\vip_functions::Speed();
	if(self.pers["nukebullets"] == 1)
		self thread plugins\vip\vip_functions::Shootnukebullets();
	if(self.pers["forge"] == 1)
		self thread plugins\vip\vip_functions::pickupplayers();
	if(self.pers["pickup"] == 1)
		self thread plugins\vip\vip_functions::AdminPickup();
	
	if(self.pers["weed_trail"] == 1)
		self thread trailFX(level.fx["weed_trail"]);
}

vip_perks()
{
	wait 1;
	if(self.pers["none"] == 1)
		return;
	if(self.pers["bulletdamage"] == 1)
	{
		self clearPerks();
		perk = "specialty_bulletdamage";
		self setPerk("specialty_bulletdamage");
		self thread setperks(perk);
		//self iPrintln("^1[VIP PERK] Enabled:^2 Stoping Power");
	}
	else if(self.pers["fastreload"] == 1)
	{
		self clearPerks();
		perk = "specialty_fastreload";
		self setPerk("specialty_fastreload");
		self thread setperks(perk);
		//self iPrintln("^1[VIP PERK] Enabled:^2 Fast Reload");
	}
	else if(self.pers["longersprint"] == 1)
	{
		self clearPerks();
		perk = "specialty_longersprint";
		self setPerk("specialty_longersprint");
		self thread setperks(perk);
		//self iPrintln("^1[VIP PERK] Enabled:^2 Longer Sprint");
	}
	else if(self.pers["armorvest"] == 1)
	{
		self clearPerks();
		perk = "specialty_armorvest";
		self setPerk("specialty_armorvest");
		self thread setperks(perk);
		//self iPrintln("^1[VIP PERK] Enabled:^2 Juggernaut");
	}
	else if(self.pers["bulletaccuracy"] == 1)
	{
		self clearPerks();
		perk = "specialty_bulletaccuracy";
		self setPerk("specialty_bulletaccuracy");
		self thread setperks(perk);
		//self iPrintln("^1[VIP PERK] Enabled:^2 Steady Aim");
	}
	else if(self.pers["rof"] == 1)
	{
		self clearPerks();
		perk = "specialty_rof";
		self setPerk("specialty_rof");
		self thread setperks(perk);
		//self iPrintln("^1[VIP PERK] Enabled:^2 Double Tap");
	}
	else if(self.pers["holdbreath"] == 1)
	{
		self clearPerks();
		perk = "specialty_holdbreath";
		self setPerk("specialty_holdbreath");
		self thread setperks(perk);
		//self iPrintln("^1[VIP PERK] Enabled:^2 Iron Lungs");
	}
	else if(self.pers["none"] == 1)
	{
		self clearPerks();
		perk = "specialty_null";
		self setPerk("specialty_null");
		self thread setperks(perk);
	}
}
vip_weapons()
{	
	if(self.pers["shockwave"] == 1)
	{
		if(duffman\_common::hasPermission("vip_admin"))
			self setspawnweapon("shockwave_mp");
		else
		{
			self giveWeapon( self.pers["weapon"] );
			self setSpawnWeapon( self.pers["weapon"] );
			self giveMaxAmmo( self.pers["weapon"] );
			self setViewModel( "viewmodel_hands_zombie" );
		}
	}
	else if(self.pers["royal"] == 1)
		self setspawnweapon("deserteaglegold_mp");
	else if(self.pers["akimbos"] == 1)
		self setspawnweapon("akimbo_mp");
	else if(self.pers["magnum"] == 1)
		self setspawnweapon("magnum_mp");	
	else if(self.pers["r700"] == 1)
		self setspawnweapon("remington700_mp");
	else if(self.pers["m40a3"] == 1)
		self setspawnweapon("m40a3_mp");
	else if(self.pers["eagle"] == 1)
		self setspawnweapon("deserteagle_mp");
	else if(self.pers["usp_45"] == 1)
		self setspawnweapon("deserteagle_mp");
	else if(self.pers["colt45"] == 1)
		self setspawnweapon("colt45_mp");
	else if(self.pers["beretta"] == 1)
		self setspawnweapon("beretta_mp");
	else
	{
		self giveWeapon( self.pers["weapon"] );
		self setSpawnWeapon( self.pers["weapon"] );
		self giveMaxAmmo( self.pers["weapon"] );
		self setViewModel( "viewmodel_hands_zombie" );
	}
}
vip_characters()
{
	wait 1;
	if(self.pers["nico"] == 1)
	{
		self setcharacter("playermodel_GTA_IV_NICO");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Nico");
	}
	else if(self.pers["joker"] == 1)
	{
		self setcharacter("playermodel_baa_joker");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Joker");
	}
	else if(self.pers["terminator"] == 1)
	{
		self setcharacter("playermodel_terminator");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Terminator");
	}
	else if(self.pers["ghost_recon"] == 1)
	{
		self setcharacter("playermodel_ghost_recon");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Ghost Recon");
	}
	else if(self.pers["vin_diesel"] == 1)
	{
		self setcharacter("playermodel_vin_diesel");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Vin Diesel");
	}
	else if(self.pers["sheperd_dog"] == 1)
	{
		self iPrintlnBold( "You're a dog now!" );
		self takeallweapons();
		self giveweapon( "dog_mp" );
		self switchtoweapon( "dog_mp" );
		self setModel("german_sheperd_dog");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 DoG");
	}
	else if(self.pers["sas"] == 1)
	{
		self setcharacter("body_mp_sas_urban_sniper");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Urban Sniper");
	}
	else if(self.pers["shepherd"] == 1)
	{
		self setcharacter("body_shepherd");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Shepherd");
	}
	else if(self.pers["masterchief"] == 1)
	{
		self setcharacter("body_masterchief");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Masterchief");
	}
	else if(self.pers["makarov"] == 1)
	{
		self setcharacter("body_makarov");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Makarov");
	}
	else if(self.pers["alasad"] == 1)
	{
		self setcharacter("body_complete_mp_al_asad");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Asad");
	}
	else if(self.pers["alice"] == 1)
	{
		self setcharacter("body_alice");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 Alice");
	}
	else if(self.pers["cent"] == 1)
	{
		self setcharacter("body_50cent");
		//self iPrintln("^1[VIP CHARACTER] Enabled:^2 50 Cent");
	}
	else
		self braxi\_teams::setPlayerModel();
	
}
vip_visions()
{
	wait 0.5; 
	if(self.pers["promod"] == 1)
		self plugins\vip\vip_visions::promod();
	if(self.pers["nightv"] == 1)
		self plugins\vip\vip_visions::Nightvision();
	if(self.pers["cartoon"] == 1)
		self plugins\vip\vip_visions::cartoon();
	if(self.pers["chrome"] == 1)
		self plugins\vip\vip_visions::chrome();
	if(self.pers["rainbow"] == 1)
		self plugins\vip\vip_visions::rainbow();
	if(self.pers["thermal"] == 1)
		self plugins\vip\vip_visions::thermal();
	if(self.pers["laser"] == 1)
		self setClientDvar("cg_laserForceOn", 1);
}
admin_perks()
{
	if(duffman\_common::hasPermission("vip_admin"))
	{
		if(self.pers["allperks"] == 1)
		{
			self iPrintln("^1[VIP ADMIN] Enabled:^2 All Perks");
			wait 1;
			perk = "specialty_armorvest";
			self setPerk("specialty_armorvest");
			self thread setperks(perk);
			wait 1;
			perk = "specialty_longersprint";
			self setPerk("specialty_longersprint");
			self thread setperks(perk);
			wait 1;
			perk = "specialty_fastreload";
			self setPerk("specialty_fastreload");
			self thread setperks(perk);
			wait 1;
			perk = "specialty_bulletdamage";
			self setPerk("specialty_bulletdamage");
			self thread setperks(perk);
			wait 1;
			perk = "specialty_bulletaccuracy";
			self setPerk("specialty_bulletaccuracy");
			self thread setperks(perk);
			wait 1;
			perk = "specialty_rof";
			self setPerk("specialty_rof");
			self thread setperks(perk);
			wait 1;
			perk = "specialty_holdbreath";
			self setPerk("specialty_holdbreath");
			self thread setperks(perk);
		}
	}
}
watchforshock()
{
	for(;;)
	{
		currentweap = self GetCurrentWeapon();
		if(currentweap=="shockwave_mp")
		{
			if(!duffman\_common::hasPermission("vip_admin"))
			{
				self TakeWeapon("shockwave_mp");
				self giveWeapon( "no_weapon_mp" );
				self giveMaxAmmo( "no_weapon_mp" );
				self giveWeapon( self.pers["weapon"] );
				self giveMaxAmmo( self.pers["weapon"] );
				self switchToWeapon( self.pers["weapon"] );
				self iPrintln("Shockwave Permissions");
			}
		}
		wait( 1 );
	}
}
admin_lifehack()
{
	self endon("stop_lifehack");
	self endon("disconnect");
	
	if(duffman\_common::hasPermission("vip_admin"))
	{
		if(self.pers["lifehack"] == 1)
		{
			//self iPrintln("^1[VIP ADMIN] Enabled:^2 Life Hack");
			self.pers["lifes"] = 3;
			self.lifehack = true;
	
			while(1)
			{
				self waittill("death");
				self.pers["deaths"] = 0;
				self braxi\_mod::giveLife();
			}
		}
	}
}
viphud()
{
	self endon("disconnect");
	self endon("novip");
	
	if( IsDefined( self.usevip ) )	self.usevip Destroy();
	if(!level.freeRun)
		return;
	
	self.usevip = newClientHudElem(self);
	self.usevip.alignX = "right";
	self.usevip.alignY = "top";
	self.usevip.horzAlign = "right";
	self.usevip.vertAlign = "top";
	self.usevip.x = -2;
	self.usevip.y = 145;
	self.usevip.fontScale = 1.4;
	self.usevip.font = "objective";
	self.usevip.glowColor = level.randomcolour;
	self.usevip.glowAlpha = 1;
	self.usevip.hidewheninmenu = true;
	self.usevip.label = &"Vip Limit: ";
	self.usevip FadeOverTime(.5);
	
	while(1)
	{
		if(level.freeRun)
		{
			if( IsDefined( self.usevip ) )	self.usevip Destroy();
			self notify("novip");
		}
		if(self getstat(1348) == 0)
		{
			if( IsDefined( self.usevip ) )	self.usevip Destroy();
			self notify("novip");
		}	
		self.usevip SetValue(self getstat(1348));
		self waittill("updateviphud");
	}
}

trailFX(trail)
{
	self endon( "disconnect" );
	self endon("killed_player");
	self endon("death");
	self endon("stoptrail");
	
	while(isReallyAlive())
	{
		playFx( trail, self.origin + (40,0,0) );
		wait 0.3;
	}
}

isReallyAlive()
{
	if( self.sessionstate == "playing" )
		return true;
	return false;
}


setperks(perk)
{
	self notify( "show ability" );
	self endon( "show ability" );
	self endon( "disconnect" );
	
	if( isDefined( self.abilityHud ) )
		self.abilityHud destroy();

	self.abilityHud = newClientHudElem( self );
	self.abilityHud.x = 299.5;
	self.abilityHud.y = 370;
	self.abilityHud.alpha = 0.3;
	self.abilityHud setShader( perk, 55, 48 );
	self.abilityHud.sort = 985;
	
	self.abilityHud fadeOverTime( 0.3 );
	self.abilityHud.alpha = 1;
	wait 1;
	self.abilityHud fadeOverTime( 0.2 );
	self.abilityHud.alpha = 0;
	wait 0.2;
	self.abilityHud destroy();
}
setspawnweapon( weapon )
{
	self giveWeapon( weapon );
	self giveMaxAmmo( weapon );
	wait 0.001;
	self switchToWeapon( weapon );
	//self iPrintln("^1[VIP GUN] Enabled:^2 " + weapon);
}

setcharacter( char )
{
	self detachAll();
	self setmodel( char );
}
gunsreset()
{
	self.pers["shockwave"] = 0;
	self.pers["akimbos"] = 0;
	self.pers["royal"] = 0;
	self.pers["magnum"] = 0;
	self.pers["r700"] = 0;
	self.pers["mw3eagle"] = 0;
	self.pers["m40a3"] = 0;
	self.pers["eagle"] = 0;
	self.pers["usp_45"] = 0;
	self.pers["colt45"] = 0;
	self.pers["beretta"] = 0;
	self setstat(2311,0);
	self setstat(2312,0);
	self setstat(2313,0);
	self setstat(2314,0);
	self setstat(2315,0);
	self setstat(2316,0);
	self setstat(2317,0);
	self setstat(2318,0);
	self setstat(2319,0);
	self setstat(2320,0);
	self setstat(2322,0);
}
resetperks()
{
	self.pers["bulletdamage"] = 0;
	self.pers["fastreload"] = 0;
	self.pers["longersprint"] = 0;
	self.pers["armorvest"] = 0;
	self.pers["bulletaccuracy"] = 0;
	self.pers["rof"] = 0;
	self.pers["holdbreath"] = 0;
	self.pers["none"] = 1;
	self setstat(2511,0);
	self setstat(2512,0);
	self setstat(2513,0);
	self setstat(2514,0);
	self setstat(2515,0);
	self setstat(2516,0);
	self setstat(2517,0);
	self setstat(2518,0);
}
resetvisions()
{
	self.pers["laser"] = 0;
	self.pers["thermal"] = 0;
	self.pers["promod"] = 0;
	self.pers["nightv"] = 0;
	self.pers["cartoon"] = 0;
	self.pers["chrome"] = 0;
	self.pers["rainbow"] = 0;
	self setstat(2211,0);
	self setstat(2212,0);
	self setstat(2213,0);
	self setstat(2214,0);
	self setstat(2215,0);
	self setstat(2216,0);
	self setstat(2217,0);
}

resettrail()
{
	self.pers["weed_trail"] = 0;
}
resetcharacters()
{
	self.pers["cent"] = 0;
	self.pers["alice"] = 0;
	self.pers["alasad"] = 0;
	self.pers["juggernaut"] = 0;
	self.pers["makarov"] = 0;
	self.pers["masterchief"] = 0;
	self.pers["shepherd"] = 0;
	self.pers["Zoey"] = 1;
	self.pers["velinda"] = 0;
	self.pers["gangster"] = 0;
	self.pers["sas"] = 0;
	self.pers["sheperd_dog"] = 0;
	self.pers["vin_diesel"] = 0;
	self.pers["ghost_recon"] = 0;
	self.pers["terminator"] = 0;
	self.pers["joker"] = 0;
	self.pers["nico"] = 0;
	self setstat(2411,0);
	self setstat(2412,0);
	self setstat(2413,0);
	self setstat(2414,0);
	self setstat(2415,0);
	self setstat(2416,0);
	self setstat(2417,0);
	self setstat(2418,0);
	self setstat(2419,0);
	self setstat(2420,0);
	self setstat(2421,0);
	self setstat(2422,0);
	self setstat(2423,0);
	self setstat(2424,0);
	self setstat(2425,0);
	self setstat(2426,0);
	self setstat(2427,0);
}