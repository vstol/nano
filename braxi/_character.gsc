#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;
 
#include braxi\_common;
#include braxi\_dvar;
 
SetCharacter( Character )
{
        self detachAll();
        self setModel( Character );
}
RotatePreview()
{
        self endon( "disconnect" );
        self endon( "end customization" );
        self notify( "stop preview rotation" );
        self endon( "stop preview rotation" );
 
        wait 0.05;
        while( isDefined( self.previewModel ) )
        {
                self.previewModel rotateYaw( 360, 6 );
                wait 6;
        }
}
 
OnResponse( response , menu )
{
	spawnAngles = (0,level.spawn["spectator"].angles[1],0);
	self setPlayerAngles( spawnAngles );
 
	torsoChangePos = ( level.spawn["spectator"].origin + (-5,0,-30) + vector_scale(anglesToForward(spawnAngles), 100 ) );
       
	headAngles = (0,158,0);
       
	if( !isDefined( self.previewModel ) && response == "character_open" )
	{
		self setPlayerAngles( spawnAngles );
		self setOrigin( level.spawn["spectator"].origin );
		self.previewModel = spawn( "script_model", torsoChangePos );
		self.previewModel.angles = headAngles;
		self.previewModel hide();
		self.previewModel showToPlayer( self );
		self thread RotatePreview();
		id = self getStat( 980 );
		self.previewModel SetCharacter( level.characterInfo[id]["model"] );
	}
	else if( response == "character_close" && isDefined( self.previewModel ) )
	{
			self notify( "end customization" );
			self.previewModel delete();
	}
	if( menu == "character_select" )
	{
		character = int(response)-1;
		charactername = tableLookup( "mp/characterTable.csv", 0, character+1, 4 );
		if( !self braxi\_rank::isCharacterUnlocked( character ) )
			self.previewModel SetCharacter(charactername);
		else
		{
			self iPrintlnBold( "Your character will be changed to ^3" + level.characterInfo[character]["name"] + "^7 next time you spawn" );
			self setStat( 980, character );
			self setClientDvar( "drui_character", character );
			self.previewModel SetCharacter(charactername);
		}
	}
}