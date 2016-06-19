//  ________/\\\\\\\\\__________________________________________________________        
//   _____/\\\////////___________________________________________________________       
//    ___/\\\/_________________________________________________________/\\\__/\\\_      
//     __/\\\______________/\\/\\\\\\\___/\\\\\\\\\_____/\\\\\\\\\\\___\//\\\/\\\__     
//      _\/\\\_____________\/\\\/////\\\_\////////\\\___\///////\\\/_____\//\\\\\___    
//       _\//\\\____________\/\\\___\///____/\\\\\\\\\\_______/\\\/________\//\\\____   
//        __\///\\\__________\/\\\__________/\\\/////\\\_____/\\\/_______/\\_/\\\_____  
//         ____\////\\\\\\\\\_\/\\\_________\//\\\\\\\\/\\__/\\\\\\\\\\\_\//\\\\/______ 
//          _______\/////////__\///___________\////////\//__\///////////___\////________

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include braxi\_common;

Speed()
{
	self endon("disconnect");
	self endon( "stop_speed" );
	
	self SetMoveSpeedScale(1.6);
	self setClientDvar("g_gravity", 70 );
	
	while(isDefined(self) && self.sessionstate == "playing" && game["state"] != "round ended")
	{
		if(!self isOnGround() && !self.doingBH)
		{
			while(!self isOnGround())
				wait 0.05;
				
			playfx(level.fx[2], self.origin - (0, 0, 10)); 
			earthquake (0.3, 1, self.origin, 100); 
		}
		wait .2;
	}
	
	if(isDefined(self))
	{
		self setClientDvar("g_gravity", 70 );
		self SetMoveSpeedScale(1);
	}
}

Clone()
{	
	self endon("death");
	level endon( "endround" );
	
	while( self.sessionstate == "playing")
	{
		if(self getStance() == "stand" && isDefined( self.clon ))
		{
			for(j=0;j<8;j++)
			{
				if(isDefined( self.clon[j] ))
					self.clon[j] hide();
			}
				
			self notify("newclone");
		}
		else
		{
			self notify("newclone");
			self thread hideClone();

			while(self getStance() != "stand")
				wait .05;
		}
		wait .05;
	}
}

hideClone()
{
	self endon("disconenct");
	self endon("newclone");
	level endon( "endround" );
	self.clon = [];
	
	for(k=0;k<8;k++)
		self.clon[k] = self cloneplayer(10);
				
	while( self.sessionstate == "playing" )
	{
		if(isDefined(self.clon[0]))
		{
			self.clon[0].origin = self.origin + (0, 60, 0);
			self.clon[1].origin = self.origin + (-41.5, 41.5, 0);
			self.clon[2].origin = self.origin + (-60, 0, 0);
			self.clon[3].origin = self.origin + (-41.5, -41.5, 0);
			self.clon[4].origin = self.origin + (0, -60, 0);
			self.clon[5].origin = self.origin + (41.5, -41.5, 0);
			self.clon[6].origin = self.origin + (60, 0, 0);
			self.clon[7].origin = self.origin + (41.5, 41.5, 0);
			
			for(j=0;j<8;j++)
				self.clon[j].angles = self.angles;
		}
		wait .05;
	}
	
	for(i=0;i<8;i++)
	{
		if(isDefined(self.clon[i]))
			self.clon[i] delete();
	}
}
ninja()
{
	self endon( "disconnect" );
	self endon( "death" );

	self.newhide.origin = self.origin;
	self hide();
	self linkto(self.newhide);
	for(i=0;i<260;i++)
	{
		if(self getStance() == "stand")
		{
			playFx( level.fx["tank_fire_engine"], self.origin );
		}
		wait 1;			
	}
	self show();
	self unlink();
	self iPrintlnBold("^1You are visible");
}
Shootnukebullets()
{
	self endon("disconnect");
	self endon("stop_nukeBullets");
	
    for(;;)
    {
        self waittill ( "weapon_fired" );
        vec = anglestoforward(self getPlayerAngles());
        end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
        SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
		explode = loadfx( "explosions/tanker_explosion" );
        playfx(explode, SPLOSIONlocation);
        RadiusDamage( SPLOSIONlocation, 500, 700, 180, self );
        earthquake (0.3, 1, SPLOSIONlocation, 100);
		playsoundonplayers("exp_suitcase_bomb_main");
    }
}
AdminPickup()
{
	self endon("disconnect");
	self endon("stop_pickup");
 
	while(1)
	{        
		while(!self secondaryoffhandButtonPressed())
		{
			wait 0.05;
		}
		start = self getEye();
		end = start + maps\mp\_utility::vector_scale(anglestoforward(self getPlayerAngles()), 999999);
		trace = bulletTrace(start, end, true, self);
		dist = distance(start, trace["position"]);
		ent = trace["entity"];
		if(isDefined(ent) && ent.classname == "player")
		{
			if(isPlayer(ent))
			ent IPrintLn("^1You've been picked up by the admin ^2" + self.name + "^1!");
			ent.godmode = true;
			self IPrintLn("^1You've picked up ^2" + ent.name + "^1!");
			self iPrintln( "You picked" + ent.name + "^1!");
			linker = spawn("script_origin", trace["position"]);
			ent linkto(linker);
			while(self secondaryoffhandButtonPressed())
			{
				wait 0.05;
			}
			while(!self secondaryoffhandButtonPressed() && isDefined(ent))
			{
				start = self getEye();
				end = start + maps\mp\_utility::vector_scale(anglestoforward(self getPlayerAngles()), dist);
				trace = bulletTrace(start, end, false, ent);
				dist = distance(start, trace["position"]);
				if(self fragButtonPressed() && !self adsButtonPressed())
				dist -= 15;
				else if(self fragButtonPressed() && self adsButtonPressed())
				dist += 15;
				end = start + maps\mp\_utility::vector_Scale(anglestoforward(self getPlayerAngles()), dist);
				trace = bulletTrace(start, end, false, ent);
				linker.origin = trace["position"];
				wait 0.05;
			}
			if(isDefined(ent))
			{
				ent unlink();
				if(isPlayer(ent))
				ent IPrintLn("^1You've been dropped by the admin ^2" + self.name + "^1!");
				ent.godmode = false;
				self IPrintLn("^1You've dropped ^2" + ent.name + "^1!");
				self iPrintln( "You dropped" + ent.name + "^1!");
			}
			linker delete();
		}
		while(self secondaryoffhandButtonPressed())
		{
			wait 0.05;
		}
	}
}
pickupplayers()
{
	self endon("disconnect");
	self endon("stop_forge");
	
	for(;;)
	{
		while(self adsbuttonpressed())
		{
			trace = bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*1000000,true,self);
			while(self adsbuttonpressed())
			{
				trace["entity"] freezeControls( true );
				trace["entity"] setorigin(self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200);
				trace["entity"].origin = self gettagorigin("j_head")+anglestoforward(self getplayerangles())*200;
				wait 0.05;
			}
			trace["entity"] freezeControls( false );
		}
		wait 0.05;
	}
}
tracer()
{
	self endon("disconnect");
	
	iPrintln("^1[VIP]:^2",self.name, " ^1got slower tracer speed!!!");
	
	self setClientDvar( "cg_tracerSpeed", "300" );
	self setClientDvar( "cg_tracerwidth", "9" );
	self setClientDvar( "cg_tracerlength", "500" );
}
messageln(msg)
{
	if(isdefined(getdvar("scr_pass_messages")) && getdvarint("scr_pass_messages") == 0)
		return;
	self iprintln(msg);
}