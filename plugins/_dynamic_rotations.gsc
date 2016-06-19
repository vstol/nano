//  ________/\\\\\\\\\__________________________________________________________        
//   _____/\\\////////___________________________________________________________       
//    ___/\\\/_________________________________________________________/\\\__/\\\_      
//     __/\\\______________/\\/\\\\\\\___/\\\\\\\\\_____/\\\\\\\\\\\___\//\\\/\\\__     
//      _\/\\\_____________\/\\\/////\\\_\////////\\\___\///////\\\/_____\//\\\\\___    
//       _\//\\\____________\/\\\___\///____/\\\\\\\\\\_______/\\\/________\//\\\____   
//        __\///\\\__________\/\\\__________/\\\/////\\\_____/\\\/_______/\\_/\\\_____  
//         ____\////\\\\\\\\\_\/\\\_________\//\\\\\\\\/\\__/\\\\\\\\\\\_\//\\\\/______ 
//          _______\/////////__\///___________\////////\//__\///////////___\////________

#include braxi\_dvar;
	
init()
{
	addDvar( "dynamic_rotations", "dr_dynamic_rotations", 1, 0, 50, "int" );
	addDvar( "dynamic_limit", "dr_dynamic_limit", 1, 0, 50, "int" );
	
	addDvar( "dynamic_maps1", "dr_dynamic_maps1", " ", "", "", "string" );
	addDvar( "dynamic_maps2", "dr_dynamic_maps2", " ", "", "", "string" );
	addDvar( "dynamic_maps3", "dr_dynamic_maps3", " ", "", "", "string" );
	addDvar( "dynamic_maps4", "dr_dynamic_maps4", " ", "", "", "string" );
	addDvar( "dynamic_maps5", "dr_dynamic_maps5", " ", "", "", "string" );
	addDvar( "dynamic_maps6", "dr_dynamic_maps6", " ", "", "", "string" );
	addDvar( "dynamic_maps7", "dr_dynamic_maps7", " ", "", "", "string" );
	addDvar( "dynamic_maps8", "dr_dynamic_maps8", " ", "", "", "string" );
	addDvar( "dynamic_maps9", "dr_dynamic_maps9", " ", "", "", "string" );
	addDvar( "dynamic_maps10", "dr_dynamic_maps10", " ", "", "", "string" );
	addDvar( "dynamic_maps11", "dr_dynamic_maps11", " ", "", "", "string" );
	addDvar( "dynamic_maps12", "dr_dynamic_maps12", " ", "", "", "string" );
	addDvar( "dynamic_maps13", "dr_dynamic_maps13", " ", "", "", "string" );
	addDvar( "dynamic_maps14", "dr_dynamic_maps14", " ", "", "", "string" );
	addDvar( "dynamic_maps15", "dr_dynamic_maps15", " ", "", "", "string" );
	addDvar( "dynamic_maps16", "dr_dynamic_maps16", " ", "", "", "string" );
	addDvar( "dynamic_maps17", "dr_dynamic_maps17", " ", "", "", "string" );
	addDvar( "dynamic_maps18", "dr_dynamic_maps18", " ", "", "", "string" );
	addDvar( "dynamic_maps19", "dr_dynamic_maps19", " ", "", "", "string" );
	addDvar( "dynamic_maps20", "dr_dynamic_maps20", " ", "", "", "string" );
	addDvar( "dynamic_maps21", "dr_dynamic_maps21", " ", "", "", "string" );
	addDvar( "dynamic_maps22", "dr_dynamic_maps22", " ", "", "", "string" );
	addDvar( "dynamic_maps23", "dr_dynamic_maps23", " ", "", "", "string" );
	addDvar( "dynamic_maps24", "dr_dynamic_maps24", " ", "", "", "string" );
	addDvar( "dynamic_maps25", "dr_dynamic_maps25", " ", "", "", "string" );
	addDvar( "dynamic_maps26", "dr_dynamic_maps26", " ", "", "", "string" );
	addDvar( "dynamic_maps27", "dr_dynamic_maps27", " ", "", "", "string" );
	addDvar( "dynamic_maps28", "dr_dynamic_maps28", " ", "", "", "string" );
	addDvar( "dynamic_maps29", "dr_dynamic_maps29", " ", "", "", "string" );
	addDvar( "dynamic_maps30", "dr_dynamic_maps30", " ", "", "", "string" );
	addDvar( "dynamic_maps31", "dr_dynamic_maps31", " ", "", "", "string" );
	addDvar( "dynamic_maps32", "dr_dynamic_maps32", " ", "", "", "string" );
	addDvar( "dynamic_maps33", "dr_dynamic_maps33", " ", "", "", "string" );
	addDvar( "dynamic_maps34", "dr_dynamic_maps34", " ", "", "", "string" );
	addDvar( "dynamic_maps35", "dr_dynamic_maps35", " ", "", "", "string" );
	addDvar( "dynamic_maps36", "dr_dynamic_maps36", " ", "", "", "string" );
	addDvar( "dynamic_maps37", "dr_dynamic_maps37", " ", "", "", "string" );
	addDvar( "dynamic_maps38", "dr_dynamic_maps38", " ", "", "", "string" );
	addDvar( "dynamic_maps39", "dr_dynamic_maps39", " ", "", "", "string" );
	addDvar( "dynamic_maps40", "dr_dynamic_maps40", " ", "", "", "string" );
	addDvar( "dynamic_maps41", "dr_dynamic_maps41", " ", "", "", "string" );
	addDvar( "dynamic_maps42", "dr_dynamic_maps42", " ", "", "", "string" );
	addDvar( "dynamic_maps43", "dr_dynamic_maps43", " ", "", "", "string" );
	addDvar( "dynamic_maps44", "dr_dynamic_maps44", " ", "", "", "string" );
	addDvar( "dynamic_maps45", "dr_dynamic_maps45", " ", "", "", "string" );
	addDvar( "dynamic_maps46", "dr_dynamic_maps46", " ", "", "", "string" );
	addDvar( "dynamic_maps47", "dr_dynamic_maps47", " ", "", "", "string" );
	addDvar( "dynamic_maps48", "dr_dynamic_maps48", " ", "", "", "string" );
	addDvar( "dynamic_maps49", "dr_dynamic_maps49", " ", "", "", "string" );
	addDvar( "dynamic_maps50", "dr_dynamic_maps50", " ", "", "", "string" );
	
	level.dynamic_rotations = GetDvarInt( "dynamic_rotations" );
	level.dynamic_limit = GetDvarInt( "dynamic_limit" );
	
	level.dvar["dynamic_map1"] = getDvar( "dr_dynamic_maps1" );
	level.dvar["dynamic_map2"] = getDvar( "dr_dynamic_maps2" );
	level.dvar["dynamic_map3"] = getDvar( "dr_dynamic_maps3" );
	level.dvar["dynamic_map4"] = getDvar( "dr_dynamic_maps4" );
	level.dvar["dynamic_map5"] = getDvar( "dr_dynamic_maps5" );
	level.dvar["dynamic_map6"] = getDvar( "dr_dynamic_maps6" );
	level.dvar["dynamic_map7"] = getDvar( "dr_dynamic_maps7" );
	level.dvar["dynamic_map8"] = getDvar( "dr_dynamic_maps8" );
	level.dvar["dynamic_map9"] = getDvar( "dr_dynamic_maps9" );
	level.dvar["dynamic_map10"] = getDvar( "dr_dynamic_maps10" );
	level.dvar["dynamic_map11"] = getDvar( "dr_dynamic_maps11" );
	level.dvar["dynamic_map12"] = getDvar( "dr_dynamic_maps12" );
	level.dvar["dynamic_map13"] = getDvar( "dr_dynamic_maps13" );
	level.dvar["dynamic_map14"] = getDvar( "dr_dynamic_maps14" );
	level.dvar["dynamic_map15"] = getDvar( "dr_dynamic_maps15" );
	level.dvar["dynamic_map16"] = getDvar( "dr_dynamic_maps16" );
	level.dvar["dynamic_map17"] = getDvar( "dr_dynamic_maps17" );
	level.dvar["dynamic_map18"] = getDvar( "dr_dynamic_maps18" );
	level.dvar["dynamic_map19"] = getDvar( "dr_dynamic_maps19" );
	level.dvar["dynamic_map20"] = getDvar( "dr_dynamic_maps20" );
	level.dvar["dynamic_map21"] = getDvar( "dr_dynamic_maps21" );
	level.dvar["dynamic_map22"] = getDvar( "dr_dynamic_maps22" );
	level.dvar["dynamic_map23"] = getDvar( "dr_dynamic_maps23" );
	level.dvar["dynamic_map24"] = getDvar( "dr_dynamic_maps24" );
	level.dvar["dynamic_map25"] = getDvar( "dr_dynamic_maps25" );
	level.dvar["dynamic_map26"] = getDvar( "dr_dynamic_maps26" );
	level.dvar["dynamic_map27"] = getDvar( "dr_dynamic_maps27" );
	level.dvar["dynamic_map28"] = getDvar( "dr_dynamic_maps28" );
	level.dvar["dynamic_map29"] = getDvar( "dr_dynamic_maps29" );
	level.dvar["dynamic_map30"] = getDvar( "dr_dynamic_maps30" );
	level.dvar["dynamic_map31"] = getDvar( "dr_dynamic_maps31" );
	level.dvar["dynamic_map32"] = getDvar( "dr_dynamic_maps32" );
	level.dvar["dynamic_map33"] = getDvar( "dr_dynamic_maps33" );
	level.dvar["dynamic_map34"] = getDvar( "dr_dynamic_maps34" );
	level.dvar["dynamic_map35"] = getDvar( "dr_dynamic_maps35" );
	level.dvar["dynamic_map36"] = getDvar( "dr_dynamic_maps36" );
	level.dvar["dynamic_map37"] = getDvar( "dr_dynamic_maps37" );
	level.dvar["dynamic_map38"] = getDvar( "dr_dynamic_maps38" );
	level.dvar["dynamic_map39"] = getDvar( "dr_dynamic_maps39" );
	level.dvar["dynamic_map40"] = getDvar( "dr_dynamic_maps40" );
	level.dvar["dynamic_map41"] = getDvar( "dr_dynamic_maps41" );
	level.dvar["dynamic_map42"] = getDvar( "dr_dynamic_maps42" );
	level.dvar["dynamic_map43"] = getDvar( "dr_dynamic_maps43" );
	level.dvar["dynamic_map44"] = getDvar( "dr_dynamic_maps44" );
	level.dvar["dynamic_map45"] = getDvar( "dr_dynamic_maps45" );
	level.dvar["dynamic_map46"] = getDvar( "dr_dynamic_maps46" );
	level.dvar["dynamic_map47"] = getDvar( "dr_dynamic_maps47" );
	level.dvar["dynamic_map48"] = getDvar( "dr_dynamic_maps48" );
	level.dvar["dynamic_map49"] = getDvar( "dr_dynamic_maps49" );
	level.dvar["dynamic_map50"] = getDvar( "dr_dynamic_maps50" );
	
	if( !level.dynamic_rotations )
		return;

	if(!isDefined( game["dynamic_rot"] ) && !level.freeRun )
	{
		game["dynamic_rot"] = 1;
		thread dynamic_rotations();
	}
}
	

dynamic_rotations()
{
	if(level.dynamic_rotations == 1)
	{
		if(level.dynamic_limit == 1)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "2");
			setDvar( "sv_maprotation", level.dvar["dynamic_map2"] );
		}
	}
	else if( level.dynamic_rotations == 2 )
	{
		if(level.dynamic_limit == 2)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "3" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map3"] );
		}
	}
	else if( level.dynamic_rotations == 3)
	{
		if(level.dynamic_limit == 3)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "4" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map4"] );
		}
	}
	else if( level.dynamic_rotations == 4)
	{
		if(level.dynamic_limit == 4)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "5" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map5"] );
		}
	}
	else if( level.dynamic_rotations == 5)
	{
		if(level.dynamic_limit == 5)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "6" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map6"] );
		}
	}
	else if( level.dynamic_rotations == 6 )
	{
		if(level.dynamic_limit == 6)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "7" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map7"] );
		}
	}
	else if( level.dynamic_rotations == 7)
	{
		if(level.dynamic_limit == 7)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "8" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map8"] );
		}
	}
	else if( level.dynamic_rotations == 8)
	{
		if(level.dynamic_limit == 8)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "9" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map9"] );
		}
	}
	else if( level.dynamic_rotations == 9)
	{
		if(level.dynamic_limit == 9)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "10" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map10"] );
		}
	}
	else if( level.dynamic_rotations == 10 )
	{
		if(level.dynamic_limit == 10)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "11" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map11"] );
		}
	}
	else if( level.dynamic_rotations == 11)
	{
		if(level.dynamic_limit == 11)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "12" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map12"] );
		}
	}
	else if( level.dynamic_rotations == 12)
	{
		if(level.dynamic_limit == 12)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "13" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map13"] );
		}
	}
	else if( level.dynamic_rotations == 13)
	{
		if(level.dynamic_limit == 13)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "14" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map14"] );
		}
	}
	else if( level.dynamic_rotations == 14 )
	{
		if(level.dynamic_limit == 14)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "15" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map15"] );
		}
	}
	else if( level.dynamic_rotations == 15)
	{
		if(level.dynamic_limit == 15)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "16" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map16"] );
		}
	}
	else if( level.dynamic_rotations == 16)
	{
		if(level.dynamic_limit == 16)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "17" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map17"] );
		}
	}
	else if( level.dynamic_rotations == 17)
	{
		if(level.dynamic_limit == 17)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "18" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map18"] );
		}
	}
	else if( level.dynamic_rotations == 18)
	{
		if(level.dynamic_limit == 18)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "19" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map19"] );
		}
	}
	else if( level.dynamic_rotations == 19)
	{
		if(level.dynamic_limit == 19)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "20" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map20"] );
		}
	}
	else if( level.dynamic_rotations == 20)
	{
		if(level.dynamic_limit == 20)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "21" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map21"] );
		}
	}
	else if(level.dynamic_rotations == 21 )
	{
		if(level.dynamic_limit == 21)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "22");
			setDvar( "sv_maprotation", level.dvar["dynamic_map22"] );
		}
	}
	else if( level.dynamic_rotations == 22)
	{
		if(level.dynamic_limit == 22)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "23" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map23"] );
		}
	}
	else if( level.dynamic_rotations == 23)
	{
		if(level.dynamic_limit == 23)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "24" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map24"] );
		}
	}
	else if( level.dynamic_rotations == 24)
	{
		if(level.dynamic_limit == 24)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "25" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map25"] );
		}
	}
	else if( level.dynamic_rotations == 25 )
	{
		if(level.dynamic_limit == 25)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "26" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map26"] );
		}
	}
	else if( level.dynamic_rotations == 26 )
	{
		if(level.dynamic_limit == 26)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "27" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map27"] );
		}
	}
	else if( level.dynamic_rotations == 27)
	{
		if(level.dynamic_limit == 27)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "28" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map28"] );
		}
	}
	else if( level.dynamic_rotations == 28)
	{
		if(level.dynamic_limit == 28)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "29" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map29"] );
		}
	}
	else if( level.dynamic_rotations == 29)
	{
		if(level.dynamic_limit == 29)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "30" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map30"] );
		}
	}
	else if( level.dynamic_rotations == 30)
	{
		if(level.dynamic_limit == 30)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "31" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map31"] );
		}
	}
	else if( level.dynamic_rotations == 31 )
	{
		if(level.dynamic_limit == 31)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "32" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map32"] );
		}
	}
	else if( level.dynamic_rotations == 32 )
	{
		if(level.dynamic_limit == 32)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "33" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map33"] );
		}
	}
	else if( level.dynamic_rotations == 33 )
	{
		if(level.dynamic_limit == 33)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "34" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map34"] );
		}
	}
	else if( level.dynamic_rotations == 34 )
	{
		if(level.dynamic_limit == 34)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "35" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map35"] );
		}
	}
	else if( level.dynamic_rotations == 35)
	{
		if(level.dynamic_limit == 35)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "36" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map36"] );
		}
	}
	else if( level.dynamic_rotations == 36)
	{
		if(level.dynamic_limit == 36)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "37" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map37"] );
		}
	}
	else if( level.dynamic_rotations == 37)
	{
		if(level.dynamic_limit == 37)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "38" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map38"] );
		}
	}
	else if( level.dynamic_rotations == 38)
	{
		if(level.dynamic_limit == 38)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "39" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map39"] );
		}
	}
	else if( level.dynamic_rotations == 39)
	{
		if(level.dynamic_limit == 39)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "40" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map40"] );
		}
	}
	else if( level.dynamic_rotations == 40)
	{
		if(level.dynamic_limit == 40)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "41" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map41"] );
		}
	}
	else if( level.dynamic_rotations == 41)
	{
		if(level.dynamic_limit == 41)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "42" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map42"] );
		}
	}
	else if( level.dynamic_rotations == 42)
	{
		if(level.dynamic_limit == 42)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "43" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map43"] );
		}
	}
	else if( level.dynamic_rotations == 43)
	{
		if(level.dynamic_limit == 43)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "44" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map44"] );
		}
	}
	else if( level.dynamic_rotations == 44)
	{
		if(level.dynamic_limit == 44)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "35" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map45"] );
		}
	}
	else if( level.dynamic_rotations == 45)
	{
		if(level.dynamic_limit == 45)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "46" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map46"] );
		}
	}
	else if( level.dynamic_rotations == 46)
	{
		if(level.dynamic_limit == 46)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "47" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map7"] );
		}
	}
	else if( level.dynamic_rotations == 47)
	{
		if(level.dynamic_limit == 47)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "48" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map48"] );
		}
	}
	else if( level.dynamic_rotations == 48)
	{
		if(level.dynamic_limit == 48)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "49" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map49"] );
		}
	}
	else if( level.dynamic_rotations == 49)
	{
		if(level.dynamic_limit == 49)
		{
			SetDvar( "dynamic_rotations", "1");
			setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
		}
		else
		{
			SetDvar( "dynamic_rotations", "50" );
			setDvar( "sv_maprotation", level.dvar["dynamic_map50"] );
		}
	}
	else if( level.dynamic_rotations == 50)
	{
		SetDvar( "dynamic_rotations", "1");
		setDvar( "sv_maprotation", level.dvar["dynamic_map1"] );
	}
}