#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
 
#include braxi\_common;
#include braxi\_dvar;
 
SetCharacter( weapon )
{
        self detachAll();
        self setModel( weapon );
}
RotatePreview()
{
        self endon( "disconnect" );
        self endon( "end customization" );
        self notify( "stop preview rotation" );
        self endon( "stop preview rotation" );
 
        wait 0.05;
        while( isDefined( self.previewWeapon ) )
        {
                self.previewWeapon rotateYaw( 360, 6 );
                wait 6;
        }
}
 
OnResponse( response , menu )
{
	spawnAngles = (0,level.spawn["spectator"].angles[1],0);
	self setPlayerAngles( spawnAngles );
 
	torsoChangePos = ( level.spawn["spectator"].origin + (-50,0,0) + vector_scale(anglesToForward(spawnAngles), 100 ) );
       
	headAngles = (0,158,0);
       
	if( !isDefined( self.previewWeapon ) && response == "weapon_open" )
	{
		self setPlayerAngles( spawnAngles );
		self setOrigin( level.spawn["spectator"].origin );
		self.previewWeapon = spawn( "script_model", torsoChangePos );
		self.previewWeapon.angles = headAngles;
		self.previewWeapon hide();
		self.previewWeapon showToPlayer( self );
		self thread RotatePreview();
		
		weaponname = self.pers["weapon"];
		weaponName = weaponname + "_mp";
		
		if(weaponName == "akimbo_mp")
			self.previewWeapon SetCharacter( "viewmodel_mp7_aki" );
		if(weaponName == "beretta_mp")
			self.previewWeapon SetCharacter( "viewmodel_beretta" );
		if(weaponName == "usp_mp")
			self.previewWeapon SetCharacter( "viewmodel_usp" );
		if(weaponName == "deserteagle_mp")
			self.previewWeapon SetCharacter( "viewmodel_desert_eagle_tactical" );	
		if(weaponName == "magnum_mp")
			self.previewWeapon SetCharacter( "viewmodel_mw2_magnum" );
		if(weaponName == "m40a3_mp")
			self.previewWeapon SetCharacter( "viewmodel_m40a3_mp" );
		if(weaponName == "remington700_mp")
			self.previewWeapon SetCharacter( "viewmodel_remington700_mp" );
		if(weaponName == "deserteaglegold")
			self.previewWeapon SetCharacter( "viewmodel_p226" );
		
	}
	else if( response == "weapon_close" && isDefined( self.previewWeapon ) )
	{
			self notify( "end customization" );
			self.previewWeapon delete();
	}
	if( menu == "weapon_select" )
	{
		weapon = int(response)-1;
		weaponname = tableLookup( "mp/itemTable.csv", 0, weapon+1, 4 );
		weaponName = weaponname + "_mp";
		if( !self braxi\_rank::isItemUnlocked( weapon ) )
		{
			if(weaponName == "akimbo_mp")
				self.previewWeapon SetCharacter( "viewmodel_mp7_aki" );
			if(weaponName == "beretta_mp")
				self.previewWeapon SetCharacter( "weapon_beretta" );
			if(weaponName == "usp_mp")
				self.previewWeapon SetCharacter( "weapon_USP" );
			if(weaponName == "deserteagle_mp")
				self.previewWeapon SetCharacter( "viewmodel_desert_eagle_tactical" );	
			if(weaponName == "magnum_mp")
				self.previewWeapon SetCharacter( "worldmodel_mw2_magnum" );
			if(weaponName == "m40a3_mp")
				self.previewWeapon SetCharacter( "weapon_m40a3" );
			if(weaponName == "remington700_mp")
				self.previewWeapon SetCharacter( "weapon_remington700" );
			if(weaponName == "deserteaglegold_mp")
				self.previewWeapon SetCharacter( "weaponl_p226" );
		}
		else
		{
			if(weaponName == "beretta_mp")
				self.previewWeapon SetCharacter( "weapon_beretta" );
			if(weaponName == "colt45_mp")
				self.previewWeapon SetCharacter( "weapon_colt1911_black" );
			if(weaponName == "usp_mp")
				self.previewWeapon SetCharacter( "weapon_usp" );
			if(weaponName == "deserteagle_mp")
				self.previewWeapon SetCharacter( "viewmodel_desert_eagle_tactical" );	
			if(weaponName == "magnum_mp")
				self.previewWeapon SetCharacter( "worldmodel_mw2_magnum" );
			if(weaponName == "m40a3_mp")
				self.previewWeapon SetCharacter( "weapon_m40a3" );
			if(weaponName == "remington700_mp")
				self.previewWeapon SetCharacter( "weapon_remington700" );
			if(weaponName == "akimbo_mp")
				self.previewWeapon SetCharacter( "viewmodel_mp7_aki" );
			if(weaponName == "deserteaglegold_mp")
			{
				self.previewWeapon SetCharacter( "weaponl_p226" );
				wait 1;
				self.previewWeapon SetCharacter( "viewmodel_p226" );
			}
			self setStat( 981, weapon );
			self setClientDvar( "drui_weapon", weapon );
		}
	}
}
//+"_mp"