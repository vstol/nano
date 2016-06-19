///////////////////////////////////////////////////////////////
////|         |///|        |///|       |/\  \/////  ///|  |////
////|  |////  |///|  |//|  |///|  |/|  |//\  \///  ////|__|////
////|  |////  |///|  |//|  |///|  |/|  |///\  \/  /////////////
////|          |//|  |//|  |///|       |////\    //////|  |////
////|  |////|  |//|         |//|  |/|  |/////    \/////|  |////
////|  |////|  |//|  |///|  |//|  |/|  |////  /\  \////|  |////
////|  |////|  |//|  | //|  |//|  |/|  |///  ///\  \///|  |////
////|__________|//|__|///|__|//|__|/|__|//__/////\__\//|__|////
///////////////////////////////////////////////////////////////
/*
	BraXi's Death Run Mod
	
	Website: www.braxi.org
	E-mail: paulina1295@o2.pl

	[DO NOT COPY WITHOUT PERMISSION]
*/

#include braxi\_common;

init()
{
	game["menu_team"] = "team_select";
	game["menu_callvote"] = "callvote";
	game["menu_muteplayer"] = "muteplayer";
	game["menu_characters"] = "character_select";
	game["menu_customize"] = "character_stuff";
	game["menu_weapons"] = "weapon_select";
	game["menu_quickstuff"] = "quickstuff";
	game["menu_droptions"] = "dr_options";
	
	precacheMenu(game["menu_weapons"]);
	precacheMenu(game["menu_characters"]);
	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_muteplayer"]);
	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_customize"]);
	precacheMenu(game["menu_quickstuff"]);
	precacheMenu( game["menu_droptions"] );

	precacheMenu( "weapon_select" );
	precacheMenu( "character_select" );
	precacheMenu( "dr_help" );
	precacheMenu( "dr_characters" );
	precacheMenu( "dr_characters1" );
	precacheMenu( "dr_characters2" );
	precacheMenu( "dr_sprays" );
	precacheMenu( "dr_weapons" );
	precacheMenu( "dr_weapons1" );
	precacheMenu( "dr_abilities" );
	precacheMenu( "dr_abilities1" );
	precacheMenu( "dr_rules" );
	precacheMenu( "quit_menu" );
	precacheMenu( "vip" );
	precacheMenu( "vipadmin" );
	precacheMenu( "vip_models" );
	precacheMenu( "vip_weapons" );
	precacheMenu( "vip_vision" );
	precacheMenu( "vip_fun" );

	precacheString( &"MP_HOST_ENDED_GAME" );
	precacheString( &"MP_HOST_ENDGAME_RESPONSE" );

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		
		player setClientDvar("ui_3dwaypointtext", "1");
		player.enable3DWaypoints = true;
		player setClientDvar("ui_deathicontext", "1");
		player.enableDeathIcons = true;
		player.classType = undefined;
		player.selectedClass = false;
		player thread onMenuResponse();
	}
}
onMenuResponse()
{
	self endon("disconnect");
	
	if( !isDefined( self.pers["failedLogins"] ) )
		self.pers["failedLogins"] = 0;

	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		///#
		//iprintln( self getEntityNumber() + " menuresponse: " + menu + " '" + response +"'" );
		//#/
		if( response == "dog" )
		{
			if( !self.pers["isDog"] )
			{
				if ( self.pers["team"] == "allies" )
				{
					self.pers["isDog"] = true;
					self iPrintlnBold( "You're a dog now!" );
					self takeallweapons();
					self giveweapon( "dog_mp" );
					self switchtoweapon( "dog_mp" );
					self setModel("german_sheperd_dog");
					self setClientDvar( "cg_thirdperson", 1 );
				}
				else if ( self.pers["team"] == "axis" )
					self iPrintlnBold( "^1Activator can't be a dog!" );
				else
					self iPrintlnBold( "^1Specator can't be a dog!" );
			}
			else
			{
				self.pers["isDog"] = false;
				self iPrintlnBold( "dog now Removed" );
			}
		}

		tokens = strTok( response, ":" );

		if( tokens.size && tokens[0] == "authorize" && !self.pers["admin"] )
		{
			if( !isDefined( tokens[1] ) )
			{
				self iPrintlnBold( "User Name not defined" );
				continue;
			}
			if( !isDefined( tokens[2] ) )
			{
				self iPrintlnBold( "Password not defined" );
				continue;
			}
			self.pers["login"] = tokens[1];
			self.pers["password"] = tokens[2];

			for( i = 0; i < 32; i++ )
			{
				dvar = getDvar( "dr_admin_loginpass_"+i );
				if( dvar == "" )
					break;
				
				self braxi\_admin::parseAdminInfo( dvar );

				if( self.pers["admin"] )
					break;
			}
			if( !self.pers["admin"] )
			{
				self iPrintlnBold( "Incorrect user name or password" );
				self.pers["failedLogins"]++;

				if( self.pers["failedLogins"] >= 3 )
					braxi\_common::dropPlayer( self, "kick", "Too many failed login attempts.", "Your actions will be investigated by server administration." );
			}

		}
		if( response == "vip_menu")
		{
			if( self.pers["team"] == "allies" )
			{
				if(isDefined(self.pers["canvip"]))
				{
					if(self getStat(1348) >= 1)
					{
						self openMenu( "vip" );
						win=1;
						current=self getstat(1348);
						newamount=(current-win);
						self setstat(1348,newamount);
						self notify("updateviphud");
					}
					else
					{
						self closeMenu();
						self iPrintlnBold("You have reach the maximum Limit");
					}
				}
				else
				{
					self closeMenu();
					self closeInGameMenu();
					self iPrintlnBold( "No permissions" );
				}
			}
			else if( self.pers["team"] == "axis" )
			{
				self closeMenu();
				self iPrintlnBold("Activator Cannot Use VIP");
			}
		}
		
		
		if( response == "weedtrail")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2811)==0)
				{
					self plugins\vip\_vip::resettrail();
					iPrintln("^1[VIP]:^2",self.name, " ^7Weed Trail Enabled");
					self setstat(2811,1);
					self.pers["weed_trail"] = 1;
					self notify("stoptrail");
					self plugins\vip\_vip::trailFX(level.fx["weed_trail"]);
				}
				else if(self getstat(2811)==1)
				{
					self plugins\vip\_vip::resettrail();
					iPrintln("^1[VIP]:^2",self.name, " ^7Weed Trail Disabled");
					self notify("stoptrail");
					self setstat(2811,0);
					self.pers["weed_trail"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2811)==0)
				{
					self plugins\vip\_vip::resettrail();
					self iPrintlnBold( "Weed Trail will Enable On Spawn" );
					self setstat(2811,1);
					self.pers["weed_trail"] = 1;
				}
				else if(self getstat(2811)==1)
				{
					self notify("stoptrail");
					self plugins\vip\_vip::resettrail();
					iPrintln("^1[VIP]:^2",self.name, " ^7Weed Trail Disabled");
					self setstat(2811,0);
					self.pers["weed_trail"] = 0;
				}
			}
		}
		
		
		
		if( response == "vip_headicon")
		{
			if(self.pers["vipheadicon"] == 0)
			{
				self.headicon = "headicon_admin";
				self iPrintln( "Vip Headicon Enabled" );
				self setstat(2714,1);
				self.pers["vipheadicon"] = 1;
			}
			else if(self.pers["vipheadicon"] == 1)
			{
				self.headicon = "";
				self iPrintln( "Vip Headicon Disabled" );
				self setstat(2714,0);
				self.pers["vipheadicon"] = 0;
			}
		}	
		if( response == "vip_admin")
		{
			if(duffman\_common::hasPermission("vip_admin"))
			{
				self closeMenu();
				self openMenu( "vipadmin" );
			}
			else
			{
				self closeMenu();
				self iPrintlnBold("No permissions");
				wait 1;
				self openMenu( "vip" );
			}
		}
		if( response == "nico")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2411)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Nico");
					self detachAll();
					self setmodel("playermodel_GTA_IV_NICO");
					self setstat(2411,1);
					self.pers["nico"] = 1;
				}
				else if(self getstat(2411)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Nico");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2411,0);
					self.pers["nico"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2411)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Nico");
					self setstat(2411,1);
					self.pers["nico"] = 1;
				}
				else if(self getstat(2411)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Nico");
					self setstat(2411,0);
					self.pers["nico"] = 0;
				}
			}
		}
		if( response == "joker")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2412)==0)
				{
					self plugins\vip\_vip:: resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Joker");
					self detachAll();
					self setmodel("playermodel_baa_joker");
					self setstat(2412,1);
					self.pers["joker"] = 1;
				}
				else if(self getstat(2412)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Joker");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2412,0);
					self.pers["joker"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2412)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To joker");
					self setstat(2412,1);
					self.pers["joker"] = 1;
				}
				else if(self getstat(2412)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Joker");
					self setstat(2412,0);
					self.pers["joker"] = 0;
				}
			}
		}
		if( response == "terminator")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2413)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Terminator");
					self detachAll();
					self setmodel("playermodel_terminator");
					self setstat(2413,1);
					self.pers["terminator"] = 1;
				}
				else if(self getstat(2413)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Terminator");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2413,0);
					self.pers["terminator"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2413)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Terminator");
					self setstat(2413,1);
					self.pers["terminator"] = 1;
				}
				else if(self getstat(2413)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Terminator");
					self setstat(2413,0);
					self.pers["terminator"] = 0;
				}
			}
		}
		if( response == "ghost_recon")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2414)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Ghost Recon");
					self detachAll();
					self setmodel("playermodel_ghost_recon");
					self setstat(2414,1);
					self.pers["ghost_recon"] = 1;
				}
				else if(self getstat(2414)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Ghost Recon");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2414,0);
					self.pers["ghost_recon"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2414)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Ghost Recon");
					self setstat(2414,1);
					self.pers["ghost_recon"] = 1;
				}
				else if(self getstat(2414)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Ghost Recon");
					self setstat(2414,0);
					self.pers["ghost_recon"] = 0;
				}
			}
		}
		if( response == "vin_diesel")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2415)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Vin Diesel");
					self detachAll();
					self setmodel("playermodel_vin_diesel");
					self setstat(2415,1);
					self.pers["vin_diesel"] = 1;
				}
				else if(self getstat(2415)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Vin Diesel");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2415,0);
					self.pers["vin_diesel"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2415)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Vin Diesel");
					self setstat(2415,1);
					self.pers["vin_diesel"] = 1;
				}
				else if(self getstat(2415)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Vin Diesel");
					self setstat(2415,0);
					self.pers["vin_diesel"] = 0;
				}
			}
		}
		if( response == "dog")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2416)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Dog");
					self detachAll();
					self takeallweapons();
					self giveweapon( "dog_mp" );
					self switchtoweapon( "dog_mp" );
					self setModel("german_sheperd_dog");
					self setstat(2416,1);
					self.pers["sheperd_dog"] = 1;
				}
				else if(self getstat(2416)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Dog");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2416,0);
					self.pers["sheperd_dog"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2416)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Dog");
					self setstat(2416,1);
					self.pers["sheperd_dog"] = 1;
				}
				else if(self getstat(2416)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Dog");
					self setstat(2416,0);
					self.pers["sheperd_dog"] = 0;
				}
			}
		}
		if( response == "sas")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2417)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Sas");
					self detachAll();
					self setmodel("body_mp_sas_urban_sniper");
					self setstat(2417,1);
					self.pers["sas"] = 1;
					
				}
				else if(self getstat(2417)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Sas");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2417,0);
					self.pers["sas"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2417)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Sas");
					self setstat(2417,1);
					self.pers["sas"] = 1;
				}
				else if(self getstat(2417)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Sas");
					self setstat(2417,0);
					self.pers["sas"] = 0;
				}
			}
		}
		if( response == "shepherd")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2421)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Shepherd");
					self detachAll();
					self setmodel("body_shepherd");
					self setstat(2421,1);
					self.pers["shepherd"] = 1;
				}
				else if(self getstat(2421)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Shepherd");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2421,0);
					self.pers["shepherd"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2421)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Shepherd");
					self setstat(2421,1);
					self.pers["shepherd"] = 1;
				}
				else if(self getstat(2421)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Shepherd");
					self setstat(2421,0);
					self.pers["shepherd"] = 0;
				}
			}
		}
		if( response == "masterchief")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2422)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Masterchief");
					self detachAll();
					self setmodel("body_masterchief");
					self setstat(2422,1);
					self.pers["masterchief"] = 1;
				}
				else if(self getstat(2422)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Masterchief");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2422,0);
					self.pers["masterchief"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2422)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Masterchief");
					self setstat(2422,1);
					self.pers["masterchief"] = 1;
				}
				else if(self getstat(2422)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Masterchief");
					self setstat(2422,0);
					self.pers["masterchief"] = 0;
				}
			}
		}
		if( response == "makarov")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2423)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Makarov");
					self detachAll();
					self setmodel("body_makarov");
					self setstat(2423,1);
					self.pers["makarov"] = 1;
				}
				else if(self getstat(2423)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Makarov");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2423,0);
					self.pers["makarov"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2423)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Makarov");
					self setstat(2423,1);
					self.pers["makarov"] = 1;
				}
				else if(self getstat(2423)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Makarov");
					self setstat(2423,0);
					self.pers["makarov"] = 0;
				}
			}
		}
		if( response == "alasad")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2425)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Alasad");
					self detachAll();
					self setmodel("body_complete_mp_al_asad");
					self setstat(2425,1);
					self.pers["alasad"] = 1;
				}
				else if(self getstat(2425)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Alasad");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2425,0);
					self.pers["alasad"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2425)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Alasad");
					self setstat(2425,1);
					self.pers["alasad"] = 1;
				}
				else if(self getstat(2425)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Alasad");
					self setstat(2425,0);
					self.pers["alasad"] = 0;
				}
			}
		}
		if( response == "alice")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2426)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Alice");
					self detachAll();
					self setmodel("body_alice");
					self setstat(2426,1);
					self.pers["alice"] = 1;
				}
				else if(self getstat(2426)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Alice");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2426,0);
					self.pers["alice"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2426)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To Alice");
					self setstat(2426,1);
					self.pers["alice"] = 1;
				}
				else if(self getstat(2426)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character Alice");
					self setstat(2426,0);
					self.pers["alice"] = 0;
				}
			}
		}
		if( response == "50cent")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2427)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To 50cent");
					self detachAll();
					self setmodel("body_50cent");
					self setstat(2427,1);
					self.pers["cent"] = 1;
				}
				else if(self getstat(2427)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character 50cent");
					id = self getStat( 980 );
					mod = level.characterInfo[id]["model"];
					self setmodel(mod);
					self setstat(2427,0);
					self.pers["cent"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2427)==0)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Changed character To 50cent");
					self setstat(2427,1);
					self.pers["cent"] = 1;
				}
				else if(self getstat(2427)==1)
				{
					self plugins\vip\_vip::resetcharacters();
					self iPrintlnBold( "Your character will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Removed character 50cent");
					self setstat(2427,0);
					self.pers["cent"] = 0;
				}
			}
		}
		if( response == "beretta")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2322)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Beretta");
					self giveWeapon("beretta_mp");
					self givemaxammo("beretta_mp");
					self switchtoweapon( "beretta_mp" );
					self setstat(2322,1);
					self.pers["beretta"] = 1;
				}
				else if(self getstat(2322)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Beretta");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2322,0);
					self.pers["beretta"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2322)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Beretta");
					self setstat(2322,1);
					self.pers["beretta"] = 1;
				}
				else if(self getstat(2322)==1)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Beretta");
					self setstat(2322,0);
					self.pers["beretta"] = 0;
				}
			}
		}
		if( response == "colt45")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2321)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Colt 45");
					self giveWeapon("colt45_mp");
					self givemaxammo("colt45_mp");
					self switchtoweapon( "colt45_mp" );
					self setstat(2321,1);
					self.pers["colt45"] = 1;
				}
				else if(self getstat(2321)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Colt 45");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2321,0);
					self.pers["colt45"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2321)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Colt 45");
					self setstat(2321,1);
					self.pers["colt45"] = 1;
				}
				else if(self getstat(2321)==1)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Colt 45");
					self setstat(2321,0);
					self.pers["colt45"] = 0;
				}
			}
		}
		if( response == "usp_45")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2320)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Usp 45");
					self giveWeapon("usp_mp");
					self givemaxammo("usp_mp");
					self switchtoweapon( "usp_mp" );
					self setstat(2320,1);
					self.pers["usp_45"] = 1;
				
				}
				else if(self getstat(2320)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Usp 45");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2320,0);
					self.pers["usp_45"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2320)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Usp 45");
					self setstat(2320,1);
					self.pers["usp_45"] = 1;
				}
				else if(self getstat(2320)==1)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Usp 45");
					self setstat(2320,0);
					self.pers["usp_45"] = 0;
				}
			}
		}
		if( response == "desert_eagle")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2319)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Desert Eagle");
					self giveWeapon("deserteagle_mp");
					self givemaxammo("deserteagle_mp");
					self switchtoweapon( "deserteagle_mp" );
					self setstat(2319,1);
					self.pers["eagle"] = 1;
				}
				else if(self getstat(2319)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Desert Eagle");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2319,0);
					self.pers["eagle"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2319)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Desert Eagle");
					self setstat(2319,1);
					self.pers["eagle"] = 1;
				}
				else if(self getstat(2319)==1)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Desert Eagle");
					self setstat(2319,0);
					self.pers["eagle"] = 0;
				}
			}
		}
		if( response == "m40a3")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2318)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon M40a3");
					self giveWeapon("m40a3_mp");
					self givemaxammo("m40a3_mp");
					self switchtoweapon( "m40a3_mp" );
					self setstat(2318,1);
					self.pers["m40a3"] = 1;
				}
				else if(self getstat(2318)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon M40a3");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2318,0);
					self.pers["m40a3"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2318)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon M40a3");
					self setstat(2318,1);
					self.pers["m40a3"] = 1;
				}
				else if(self getstat(2318)==1)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon M40a3");
					self setstat(2318,0);
					self.pers["m40a3"] = 0;
				}
			}
		}
		if( response == "remington700")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2316)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon R700");
					self giveWeapon("remington700_mp");
					self givemaxammo("remington700_mp");
					self switchtoweapon( "remington700_mp" );
					self setstat(2316,1);
					self.pers["r700"] = 1;
				}
				else if(self getstat(2316)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon r700");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2316,0);
					self.pers["r700"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2316)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon R700");
					self setstat(2316,1);
					self.pers["r700"] = 1;
				}
				else if(self getstat(2316)==1)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon R700");
					self setstat(2316,0);
					self.pers["r700"] = 0;
				}
			}
		}
		if( response == "magnum")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2314)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Magnum");
					self giveWeapon("magnum_mp");
					self givemaxammo("magnum_mp");
					self switchtoweapon( "magnum_mp" );
					self setstat(2314,1);
					self.pers["magnum"] = 1;
				}
				else if(self getstat(2314)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Magnum");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2314,0);
					self.pers["magnum"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2314)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Magnum");
					self setstat(2314,1);
					self.pers["magnum"] = 1;
				}
				else if(self getstat(2314)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Magnum");
					self setstat(2314,0);
					self.pers["magnum"] = 0;
				}
			}
		}
		
		if( response == "royalpistol")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2311)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Royal Pistol");
					self giveWeapon("deserteaglegold_mp");
					self givemaxammo("deserteaglegold_mp");
					self switchtoweapon( "deserteaglegold_mp" );
					self setstat(2311,1);
					self.pers["royal"] = 1;
				}
				else if(self getstat(2311)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Royal Pistol");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2311,0);
					self.pers["royal"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2311)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Royal Pistol");
					self setstat(2311,1);
					self.pers["royal"] = 1;
				}
				else if(self getstat(2311)==1)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Royal Pistol");
					self setstat(2311,0);
					self.pers["royal"] = 0;
				}
			}
		}
		if( response == "akimbos")
		{
			self closeMenu();
			self closeInGameMenu();
			if( isAlive( self ) )
			{
				if(self getstat(2313)==0)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Akimbos");
					self giveWeapon("akimbo_mp");
					self givemaxammo("akimbo_mp");
					self switchtoweapon( "akimbo_mp" );
					self setstat(2313,1);
					self.pers["akimbos"] = 1;
				}
				else if(self getstat(2313)==1)
				{
					self plugins\vip\_vip::gunsreset();
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Akimbos");
					self giveWeapon( self.pers["weapon"] );
					self givemaxammo( self.pers["weapon"] );
					self switchtoweapon( self.pers["weapon"] );
					self setstat(2313,0);
					self.pers["akimbos"] = 0;
				}
			}
			else if( !isAlive( self ) )
			{
				if(self getstat(2313)==0)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Akimbos");
					self setstat(2313,1);
					self.pers["akimbos"] = 1;
				}
				else if(self getstat(2313)==1)
				{
					self plugins\vip\_vip::gunsreset();
					self iPrintlnBold( "Your weapon will change next time you spawn" );
					iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Akimbos");
					self setstat(2313,0);
					self.pers["akimbos"] = 0;
				}
			}
		}
		if( response == "shockwave")
		{
			self closeMenu();
			self closeInGameMenu();
			if(duffman\_common::hasPermission("vip_admin"))
			{
				if( isAlive( self ) )
				{
					if(self getstat(2312)==0)
					{
						self plugins\vip\_vip::gunsreset();
						iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Shockwave");
						self giveWeapon("shockwave_mp");
						self givemaxammo("shockwave_mp");
						self switchtoweapon( "shockwave_mp" );
						self setstat(2312,1);
						self.pers["shockwave"] = 1;
					}
					else if(self getstat(2312)==1)
					{
						self plugins\vip\_vip::gunsreset();
						iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Shockwave");
						self giveWeapon( self.pers["weapon"] );
						self givemaxammo( self.pers["weapon"] );
						self switchtoweapon( self.pers["weapon"] );
						self setstat(2312,0);
						self.pers["shockwave"] = 0;
					}
				}
				else if( !isAlive( self )  )
				{
					if(self getstat(2312)==0)
					{
						self plugins\vip\_vip::gunsreset();
						self iPrintlnBold( "Your weapon will change next time you spawn" );
						iPrintln("^1[VIP]:^2",self.name, " ^7Received Weapon Shockwave");
						self setstat(2312,1);
						self.pers["shockwave"] = 1;
					}
					else if(self getstat(2312)==1)
					{
						self plugins\vip\_vip::gunsreset();
						self iPrintlnBold( "Your weapon will change next time you spawn" );
						iPrintln("^1[VIP]:^2",self.name, " ^7Droped Weapon Shockwave");
						self setstat(2312,0);
						self.pers["shockwave"] = 0;
					}
				}
			}
			else
				self IprintlnBold("^1No Permissions");
		}
		if( menu == "character_select" )
		{
			self braxi\_character::OnResponse( response );
		}
		if( response == "monkey")
		{
			self iprintlnbold("Monkey Bomb");
			self iprintlnbold("Right mouse click to fire");
			self giveWeapon("monkey_mp");
			self switchtoweapon( "monkey_mp" );
		}
		if( response == "nprestige")
		{
			if( !isDefined( self.pers["rank"] ) || !isDefined( self.pers["rankxp"] ) || !isDefined( self.pers["prestige"] ) )
				break;
				
			if( self.pers["prestige"] >= level.maxprestige )
			{
				self iPrintlnBold( "You've already reached the highest prestige!" );
				break;
			}
			if( self.pers["rankxp"] < braxi\_rank::getRankInfoMaxXp( level.maxrank ) )
			{
				self closeMenu();
				self closeInGameMenu();
				self iPrintlnBold( "You can't enter the next prestige yet!" );
				//self iPrintlnBold(self.pers["rankxp"],"/",self.pers["rank"],"/",level.maxrank);
				break;
			}
			self closeMenu();
			self closeInGameMenu();
			self.pers["rankxp"] = 1;
			self.pers["rank"] = 0;
			self.pers["prestige"]++;
			self setRank( 0, self.pers["prestige"] );
			self maps\mp\gametypes\_persistence::statSet( "rankxp", 1 );
			braxi\_rank::updateRankStats( self, 0 );
			self iPrintlnBold( "^2You've entered the next prestige! ^1(" + self.pers["prestige"] + "/" + level.maxprestige + ")" );
			thread plugins\_advertisement::saytxt("^7" + self.name + " has entered the next prestige! ^1(" + self.pers["prestige"] + "/" + level.maxprestige + ")");
			self setstat(1338,255);
			self notify("updateCreditsTotal");
			self iprintlnbold("prestige Reward 255 Credit");
		}
		if( response == "jetpack")
		{
			if( isAlive( self ) )
			{
				self thread plugins\_rtd::jetpack_fly();
			}
			else
				self IprintlnBold("^1Soft Ass How can You fly if You Are Dead");
		}
		if( response == "lifehack")
		{
			if(self.pers["lifehack"] == 0)
			{
				self setstat(2113,1);
				self.pers["lifehack"] = 1;
				self IprintlnBold("^3Life Hack ^1[ON]");
				self thread plugins\vip\_vip::admin_lifehack();
			}
			else if(self.pers["lifehack"] == 1)
			{
				self IprintlnBold("^3Life Hack ^1[OFF]");
				self notify("stop_lifehack");
				self.pers["lifes"] = 3;
				self setstat(2113,0);
				self.pers["lifehack"] = 0;
			}
		}
		if( response == "dopickup")
		{
			if(self.pers["pickup"] == 0)
			{
				iPrintln("^1[VIP]:^2",self.name, " ^2Can Now PickUp Objects!!!");
				self thread plugins\vip\vip_functions::AdminPickup();
				self setstat(2611,1);
				self.pers["pickup"] = 1;
			}
			else if(self.pers["pickup"] == 1)
			{
				iPrintln("^1[VIP]:^2",self.name, " ^1disabled PickUp Objects!!!");
				self notify("stop_pickup");
				self.pickup = false;
				self setstat(2611,0);
				self.pers["pickup"] = 0;
			}
		}
		if( response == "forge")
		{
			if(self.pers["forge"] == 0)
			{
				iPrintln("^1[VIP]:^2",self.name, " ^2Can Now PickUp Players!!!");
				self thread plugins\vip\vip_functions::pickupplayers();
				self setstat(2612,1);
				self.pers["forge"] = 1;
			}
			else if(self.pers["forge"] == 1)
			{
				iPrintln("^1[VIP]:^2",self.name, " ^1disabled PickUp Player!!!");
				self notify("stop_forge");
				self setstat(2612,0);
				self.pers["forge"] = 0;
			}
		}
		if( response == "nukebullets")
		{
			if(self.pers["nukebullets"] == 0)
			{
				iPrintln("^1[VIP]:^2",self.name, " ^2Turned ^1NukeBullets ON!!!");
				self thread plugins\vip\vip_functions::Shootnukebullets();
				self setstat(2613,1);
				self.pers["nukebullets"] = 1;
			}
			else if(self.pers["nukebullets"] == 1)
			{
				iPrintln("^1[VIP]:^2",self.name, " ^2Turned ^1NukeBullets Off!!!");
				self notify("stop_nukeBullets");
				self setstat(2613,0);
				self.pers["nukebullets"] = 0;
			}
		}
		if( response == "speed")
		{
			if(self.pers["speed"] == 0)
			{
				iPrintln("^1[VIP]:^2",self.name, " ^2Turned ^1Speed ON!!!");
				self thread plugins\vip\vip_functions::Speed();
				self setstat(2614,1);
				self.pers["speed"] = 1;
			}
			else if(self.pers["speed"] == 1)
			{
				iPrintln("^1[VIP]:^2",self.name, " ^2Turned ^1Speed Off!!!");
				self notify("stop_speed");
				self SetMoveSpeedScale(1);
				self setstat(2614,0);
				self.pers["speed"] = 0;
			}
		}
		if( response == "tracer")
			self thread plugins\vip\vip_functions::tracer();
		if( response == "clone")
			self thread plugins\vip\vip_functions::clone();
		if( response == "party")
			self thread partymode();
		if( response == "ninja")
			self thread plugins\vip\vip_functions::ninja();
			
		if( response == "laser")
		{
			if(self.pers["laser"] == 0)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Laser ^7[^3ON^7]");
				self setClientDvar("cg_laserForceOn", 1);
				self setstat(2217,1);
				self.pers["laser"] = 1;
			}
			else if(self.pers["laser"] == 1)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Laser ^7[^3OFF^7]");
				self setClientDvar("cg_laserForceOn", 0);
				self setstat(2217,0);
				self.pers["laser"] = 0;
			}
		}
		if( response == "thermal")
		{
			if(self.pers["thermal"] == 0)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Thermal Vision ^7[^3ON^7]");
				self plugins\vip\vip_visions::Thermal();
				self setstat(2216,1);
				self.pers["thermal"] = 1;
			}
			else if(self.pers["thermal"] == 1)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Thermal Vision ^7[^3OFF^7]");
				self plugins\vip\vip_visions::Default();
				self setstat(2216,0);
				self.pers["thermal"] = 0;
			}
		}
		if( response == "promod")
		{
			if(self.pers["promod"] == 0)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Promod Vision ^7[^3ON^7]");
				self plugins\vip\vip_visions::promod();
				self setstat(2211,1);
				self.pers["promod"] = 1;
			}
			else if(self.pers["promod"] == 1)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Promod Vision ^7[^3OFF^7]");
				self plugins\vip\vip_visions::Default();
				self setstat(2211,0);
				self.pers["promod"] = 0;
			}
		}
		if( response == "nightvision")
		{
			if(self.pers["nightv"] == 0)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Nightvision Vision ^7[^3ON^7]");
				self plugins\vip\vip_visions::Nightvision();
				self setstat(2212,1);
				self.pers["nightv"] = 1;
			}
			else if(self.pers["nightv"] == 1)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Nightvision Vision ^7[^3OFF^7]");
				self plugins\vip\vip_visions::Default();
				self setstat(2212,0);
				self.pers["nightv"] = 0;
			}
		}
		if( response == "cartoon")
		{
			if(self.pers["cartoon"] == 0)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Cartoon Vision ^7[^3ON^7]");
				self plugins\vip\vip_visions::cartoon();
				self setstat(2213,1);
				self.pers["cartoon"] = 1;
			}
			else if(self.pers["cartoon"] == 1)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Cartoon Vision ^7[^3OFF^7]");
				self plugins\vip\vip_visions::Default();
				self setstat(2213,0);
				self.pers["cartoon"] = 0;
			}
		}
		if( response == "chrome")
		{
			if(self.pers["chrome"] == 0)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Chrome Vision ^7[^3ON^7]");
				self plugins\vip\vip_visions::chrome();
				self setstat(2214,1);
				self.pers["chrome"] = 1;
			}
			else if(self.pers["chrome"] == 1)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Chrome Vision ^7[^3OFF^7]");
				self plugins\vip\vip_visions::Default();
				self setstat(2214,0);
				self.pers["chrome"] = 0;
			}
		}
		if( response == "rainbow")
		{
			if(self.pers["rainbow"] == 0)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Rainbow Vision ^7[^3ON^7]");
				self plugins\vip\vip_visions::rainbow();
				self setstat(2215,1);
				self.pers["rainbow"] = 0;
			}
			else if(self.pers["rainbow"] == 1)
			{
				self plugins\vip\_vip::resetvisions();
				iPrintln("^1[VIP]:^2",self.name, " ^7Turned Rainbow Vision ^7[^3OFF^7]");
				self plugins\vip\vip_visions::Default();
				self setstat(2215,0);
				self.pers["rainbow"] = 1;
			}
		}
		if( response == "allperks")
		{
			if(duffman\_common::hasPermission("vip_admin"))
			{
				if(self.pers["allperks"] == 0)
				{
					self thread plugins\vip\_vip::admin_perks();
					self setstat(2112,1);
					self.pers["allperks"] = 1;
				}
				else if(self.pers["allperks"] == 1)
				{
					self iPrintlnBold( "Perks Removed On Next Spawn" );
					self plugins\vip\_vip::setPerks("specialty_null");
					self setstat(2112,0);
					self.pers["allperks"] = 0;
				}
			}
			else
				self iPrintlnBold( "No permissions" );
		}
		if( response == "stopingpower")
		{
			self clearPerks();
			self plugins\vip\_vip::resetperks();
			perk = "specialty_bulletdamage";
			self setPerk("specialty_bulletdamage");
			self thread plugins\vip\_vip::setperks(perk);
			self setstat(2511,1);
			self.pers["bulletdamage"] = 1;
		}
		else if( response == "fastreload")
		{
			self clearPerks();
			self plugins\vip\_vip::resetperks();
			perk = "specialty_fastreload";
			self setPerk("specialty_fastreload");
			self thread plugins\vip\_vip::setperks(perk);
			self setstat(2512,1);
			self.pers["fastreload"] = 1;
		}
		else if( response == "longersprint")
		{
			self clearPerks();
			self plugins\vip\_vip::resetperks();
			perk = "specialty_longersprint";
			self setPerk("specialty_longersprint");
			self thread plugins\vip\_vip::setperks(perk);
			self setstat(2513,1);
			self.pers["longersprint"] = 1;
		}
		else if( response == "armorvest")
		{
			self clearPerks();
			self plugins\vip\_vip::resetperks();
			perk = "specialty_armorvest";
			self setPerk("specialty_armorvest");
			self thread plugins\vip\_vip::setperks(perk);
			self setstat(2514,1);
			self.pers["armorvest"] = 1;
		}
		else if( response == "bulletaccuracy")
		{
			self clearPerks();
			self plugins\vip\_vip::resetperks();
			perk = "specialty_bulletaccuracy";
			self setPerk("specialty_bulletaccuracy");
			self thread plugins\vip\_vip::setperks(perk);
			self setstat(2515,1);
			self.pers["bulletaccuracy"] = 1;
		}
		else if( response == "rof")
		{
			self clearPerks();
			self plugins\vip\_vip::resetperks();
			perk = "specialty_rof";
			self setPerk("specialty_rof");
			self thread plugins\vip\_vip::setperks(perk);
			self setstat(2516,1);
			self.pers["rof"] = 1;
			
		}
		else if( response == "holdbreath")
		{
			self clearPerks();
			self plugins\vip\_vip::resetperks();
			perk = "specialty_holdbreath";
			self setPerk("specialty_holdbreath");
			self thread plugins\vip\_vip::setperks(perk);
			self setstat(2517,1);
			self.pers["holdbreath"] = 1;
		}
		else if( response == "none")
		{
			self clearPerks();
			self plugins\vip\_vip::resetperks();
			perk = "specialty_null";
			self setPerk("specialty_null");
			self thread plugins\vip\_vip::setperks(perk);
			self setstat(2518,1);
			self.pers["none"] = 1;
		}
		if( response == "adminmenu" && self.pers["admin"] )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( "dr_admin" );
		}
		
		// client side commands
		if( response == "2doff" )
		{
			self setClientDvar( "cg_draw2d", 0 );
		}

		if( response == "2don" )
		{
			self setClientDvar( "cg_draw2d", 1 );
		}

		if( isSubStr( response, "whois:" ) )
		{
			str = strTok( response, ":" );
			if( !isDefined( str[1] ) || isDefined( str[1] ) && str[1] == "" )
				continue;
				
			player = braxi\_admin::getPlayerByName( str[1] );
			str = player.name + "^7 :: ";
			str = str + "Health: ^2" + player.health + "^7, ";
			str = str + "Team: ^2" + player.pers["team"] + "^7, ";
			str = str + "State: ^2" + player.sessionstate + "^7, ";
			str = str + "Warnings: ^2" + player getStat( level.warnsStat ) + "^7, ";
			str = str + "Guid: ^2" + player getGuid() + "^7.";
			self iPrintln( "^3[dvar] ^7Who is: " +str );
		}
		// ==============================
		
		if( menu == "character_select" )
		{
			self braxi\_character::OnResponse( response );
			
		}
		if( menu == "weapon_select" )
		{
			self braxi\_weapons::OnResponse( response );
			
		}
		
		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();
			//if ( menu == "changeclass" && self.pers["team"] == "allies" )
			//{
			//	self openMenu( game["menu_changeclass_allies"] );
			//}
			//else if ( menu == "changeclass" && self.pers["team"] == "axis" )
			//{
			//	self openMenu( game["menu_changeclass_axis"] );			
			//}
			continue;
		}
		else if( menu == "dr_sprays" )
		{
			spray = int(response)-1;
			if( self braxi\_rank::isSprayUnlocked( spray ) )
			{
				self setStat( 979, spray );
				self setClientDvar( "drui_spray", spray );
			}
		}
		else if( menu == "dr_characters" )
		{
			character = int(response)-1; // scripting hacks everywhere :o
			if( self braxi\_rank::isCharacterUnlocked( character ) )
			{
				self iPrintlnBold( "Your character will be changed to ^3" + level.characterInfo[character]["name"] + "^7 next time you spawn" );
				self setStat( 980, character );
				self setClientDvar( "drui_character", character );
			}
		}		
		else if( menu == "dr_characters1" )
		{
			character = int(response)-1; // scripting hacks everywhere :o
			if( self braxi\_rank::isCharacterUnlocked( character ) )
			{
				self iPrintlnBold( "Your character will be changed to ^3" + level.characterInfo[character]["name"] + "^7 next time you spawn" );
				self setStat( 980, character );
				self setClientDvar( "drui_character", character );
			}
		}
		else if( menu == "dr_characters2" )
		{
			character = int(response)-1; // scripting hacks everywhere :o
			if( self braxi\_rank::isCharacterUnlocked( character ) )
			{
				self iPrintlnBold( "Your character will be changed to ^3" + level.characterInfo[character]["name"] + "^7 next time you spawn" );
				self setStat( 980, character );
				self setClientDvar( "drui_character", character );
			}
		}
		else if( menu == "dr_weapons" )
		{
			item = int(response)-1;
			if( self braxi\_rank::isItemUnlocked( item ) )
			{
				self iPrintlnBold( "Your weapon will change next time you spawn" );
				self setStat( 981, item );
				self setClientDvar( "drui_weapon", item );
			}
		}
		else if( menu == "dr_weapons1" )
		{
			item = int(response)-1;
			if( self braxi\_rank::isItemUnlocked( item ) )
			{
				self iPrintlnBold( "Your weapon will change next time you spawn" );
				self setStat( 981, item );
				self setClientDvar( "drui_weapon", item );
			}
		}
		else if( menu == "dr_abilities" || menu == "dr_abilities1" )
		{
			ability = int(response)-1;
			if( self braxi\_rank::isAbilityUnlocked( ability ) )
			{
				self setStat( 982, ability );
				self setClientDvar( "drui_ability", ability );
			}
		}
		else if( menu == game["menu_quickstuff"] )
		{
			switch(response)
			{
			case "3rdperson":
				if( self getStat( 988 ) == 0 )
				{
					self iPrintln( "Third Person Camera Enabled" );
					self setClientDvar( "cg_thirdperson", 1 );
					self setStat( 988, 1 );
				}
				else
				{
					self iPrintln( "Third Person Camera Disabled" );
					self setClientDvar( "cg_thirdperson", 0 );
					self setStat( 988, 0 );
				}	
				break;
			case "suicide":
				if( !game["roundStarted"] )
					continue;
				if( self.pers["team"] == "allies" )
				{
					if (self.suicide)
					{
						self iPrintlnbold( "AntiSpawn Spam Wait" );
						continue;
					}
					self suicide();
					self.suicide = true;
					wait 5;
					self.suicide = false;
				}
				else
					self iPrintln( "^1Activator cannot suicide!" );
				break;
			
			case "nprestige":
				if( !isDefined( self.pers["rank"] ) || !isDefined( self.pers["rankxp"] ) || !isDefined( self.pers["prestige"] ) )
					break;
					
				if( self.pers["prestige"] >= level.maxprestige )
				{
					self iPrintlnBold( "You've already reached the highest prestige!" );
					break;
				}
				if( self.pers["rankxp"] < braxi\_rank::getRankInfoMaxXp( level.maxrank ) )
				{
					self iPrintlnBold( "^2You can't enter the next prestige yet!" );
					//self iPrintlnBold(self.pers["rankxp"],"/",self.pers["rank"],"/",level.maxrank);
					break;
				}
				self.pers["rankxp"] = 1;
				self.pers["rank"] = 0;
				self.pers["prestige"]++;
				self setRank( 0, self.pers["prestige"] );
				self maps\mp\gametypes\_persistence::statSet( "rankxp", 1 );
				braxi\_rank::updateRankStats( self, 0 );
				self iPrintlnBold( "^2You've entered the next prestige! ^1(" + self.pers["prestige"] + "/" + level.maxprestige + ")" );
				thread plugins\_advertisement::saytxt("^7" + self.name + " has entered the next prestige! ^1(" + self.pers["prestige"] + "/" + level.maxprestige + ")");
				self setstat(1338,255);
				self notify("updateCreditsTotal");
				self iprintlnbold("prestige Reward 255 Credit");
				break;
			default:
				break;
			}
		}
		else if( menu == game["menu_team"] || menu == game["menu_customize"] || menu == game["menu_weapons"])
		{
			switch(response)
			{
			case "allies":
			case "axis":
			case "autoassign":

				if( self.pers["team"] == "axis" )
					continue;
				if( self.pers["team"] == "allies" )
				{
					if( isAlive( self ) )
					{
						self closeMenu();
						self closeInGameMenu();
						continue;
					}
					else
					{
						self closeMenu();
						self closeInGameMenu();
					}
				}
				

				self braxi\_teams::setTeam( "allies" );

				if( self.pers["team"] == "allies" && self.sessionstate != "playing" && self.pers["lifes"] )
				{
					self braxi\_mod::useLife();
					continue;
				}

				if( self canSpawn() )
					self braxi\_mod::spawnPlayer();
				break;

			case "spectator":
				if( self.pers["team"] == "axis" )
				{
					iPrintln("Spectator is not allowed when ^1Activator!");
					return;
				}
				self closeMenu();
				self closeInGameMenu();
				self braxi\_teams::setTeam( "spectator" );
				self braxi\_mod::spawnSpectator( level.spawn["spectator"].origin, level.spawn["spectator"].angles );
				break;
				
				
				
			case "weapon_menu":
				if( self.pers["team"] != "spectator" )
				{
					self closeMenu();
					self closeInGameMenu();
					self iPrintlnBold( "^1You must be spectator to customize Weapon" );
					continue;
				}
				self allowSpectateTeam( "allies", false );
				self allowSpectateTeam( "axis", false );
				self allowSpectateTeam( "none", true );

				self closeMenu();
				self closeInGameMenu();
				self openMenu( game["menu_weapons"] );
				break;
				
			case "character_menu":
				
				if( self.pers["team"] != "spectator" )
				{
					self closeMenu();
					self closeInGameMenu();
					self iPrintlnBold( "^1You must be spectator to customize character" );
					continue;
				}
				self allowSpectateTeam( "allies", false );
				self allowSpectateTeam( "axis", false );
				self allowSpectateTeam( "none", true );

				self closeMenu();
				self closeInGameMenu();
				self openMenu( game["menu_characters"] );
				break;
			}
		}
		else if ( !level.console )
		{
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
		}

	}
}