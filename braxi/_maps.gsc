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

#include braxi\_common;

/*getMapNameString( mapName ) 
{
	tokens = strTok( toLower( mapName ), "_" ); // mp 0, deathrun/dr 1, name 2, (optional)version 3

	if( tokens.size < 2  || !tokens.size )
		return mapName;

//	if( tokens[1] != "deathrun" && tokens[1] != "dr" )
//	{
//		iPrintlnBold( "Map '" + mapName + " is not for use with Death Run Mod, please contact server administrator" );
//		level.wrongMap = true;
//	}
	
	return tokens[2];
}*/

getMapNameString( mapName ) 
{
	switch( toLower( mapName ) )
	{
		case "mp_deathrun_factory":
			mapName = "factory";
			break;
			
		case "mp_deathrun_framey_v2":
			mapName = "framey v2";
			break;
			
		case "mp_deathrun_underworld":
			mapName = "underworld";
			break;
			
		case "mp_dr_stonerun":
			mapName = "stonerun";
			break;
			
		case "mp_dr_steel":
			mapName = "steel";
			break;
			
		case "mp_dr_trapntrance":
			mapName = "trapntrance";
			break;
			
		case "mp_deathrun_clockwork":
			mapName = "clockwork";
			break;
			
		case "mp_deathrun_colourful":
			mapName = "colourful";
			break;
			
		case "mp_deathrun_fluxx":
			mapName = "fluxx";
			break;
			
		case "mp_dr_bounce":
			mapName = "bounce";
			break;
			
		case "mp_dr_darmuhv2":
			mapName = "darmuhv2";
			break;
			
		case "mp_dr_deadzone":
			mapName = "deadzone";
			break;
			
		case "mp_dr_sewers":
			mapName = "sewers";
			break;
			
		case "mp_dr_sheox":
			mapName = "sheox";
			break;
			
		case "mp_deathrun_diehard":
			mapName = "diehard";
			break;
			
		case "mp_deathrun_dungeon":
			mapName = "dungeon";
			break;
			
		case "mp_deathrun_easy":
			mapName = "easy";
			break;
			
		case "mp_deathrun_portal_v3":
			mapName = "portal v3";
			break;
			
		case "mp_deathrun_semtex":
			mapName = "semtex";
			break;
			
		case "mp_deathrun_zero":
			mapName = "zero";
			break;
			
		case "mp_dr_watercity":
			mapName = "watercity";
			break;
			
		case "mp_deathrun_amazon":
			mapName = "amazon";
			break;
			
		case "mp_deathrun_backlot":
			mapName = "backlot";
			break;
			
		case "mp_deathrun_oreo":
			mapName = "oreo";
			break;
			
		case "mp_deathrun_skypillar":
			mapName = "skypillar";
			break;
			
		case "mp_deathrun_wicked2":
			mapName = "wicked2";
			break;
			
		case "mp_dr_blade":
			mapName = "blade";
			break;
			
		case "mp_dr_bladev2":
			mapName = "bladev2";
			break;
			
		case "mp_dr_holyshiet":
			mapName = "holyshiet";
			break;
			
		case "mp_dr_jurapark":
			mapName = "jurapark";
			break;
			
		case "mp_dr_meatboy":
			mapName = "meatboy";
			break;
			
		case "mp_dr_royals":
			mapName = "royals";
			break;
			
		case "mp_dr_style":
			mapName = "style";
			break;
			
		case "mp_deathrun_epicfail":
			mapName = "epicfail";
			break;
			
		case "mp_dr_bigfall":
			mapName = "bigfall";
			break;
			
		case "mp_dr_disco":
			mapName = "disco";
			break;
			
		case "mp_dr_glass2":
			mapName = "glass2";
			break;
			
		case "mp_dr_indipyramid":
			mapName = "indipyramid";
			break;
			
		case "mp_dr_rock":
			mapName = "rock";
			break;
			
		case "mp_dr_slay":
			mapName = "slay";
			break;
			
		case "mp_deathrun_flow":
			mapName = "Flow";
			break;
			
		case "mp_deathrun_maratoon":
			mapName = "Maratoon";
			break;
			
		case "mp_deathrun_max":
			mapName = "Max";
			break;
			
		case "mp_deathrun_simplist":
			mapName = "Simplist";
			break;
			
		case "mp_deathrun_watchit_v3":
			mapName = "Watchit_v3";
			break;
			
		case "mp_dr_bouncev2":
			mapName = "Bouncev2";
			break;
			
		case "mp_dr_electric":
			mapName = "Electric";
			break;
			
		case "mp_dr_highrise":
			mapName = "Highrise";
			break;
			
		case "mp_dr_hilly_v2":
			mapName = "Hilly_v2";
			break;
			
		case "mp_dr_multi":
			mapName = "Multi";
			break;
		
		case "mp_dr_crazyrun":
			mapName = "Crazyrun";
			break;
	}
	return mapName;
}
// trigger = spawn( "trigger_radius", (xyz), 0, width, hieght );
init()
{
	switch ( level.mapName )
	{
///////// Added By Crazy & Guest61
	case "mp_deathrun_saw":
		trigger = spawn( "trigger_radius", (-2173, -2035, 210), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_qube":
		trigger = spawn( "trigger_radius", (-3336, -1012, 2878), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_detained":
		trigger = spawn( "trigger_radius", (-171, -14776, -678), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_annihilation":
		trigger = spawn( "trigger_radius", (-1072, 16002, -3416), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_apollo":
		trigger = spawn( "trigger_radius", (2194, 2752, -1424), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_bangarang":
		trigger = spawn( "trigger_radius", (1920, 959, 556), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_beauty_v2":
		trigger = spawn( "trigger_radius", (-87, 1139, -52), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_black_friday":
		trigger = spawn( "trigger_radius", (-7453, -1111, -2180), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_bland":
		trigger = spawn( "trigger_radius", (1054, -4384, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_bounce_v3":
		trigger = spawn( "trigger_radius", (10340, 41, 988), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_bricky":
		trigger = spawn( "trigger_radius", (-307, 1636, 476), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_bunker":
		trigger = spawn( "trigger_radius", (3536, 1436, -82), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_chunk":
		trigger = spawn( "trigger_radius", (-155, 134, 732), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_clockwork":
		trigger = spawn( "trigger_radius", (16642, -0, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_control":
		trigger = spawn( "trigger_radius", (1107, -1578, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_cookie":
		trigger = spawn( "trigger_radius", (-3, -387, 188), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_cosmic":
		trigger = spawn( "trigger_radius", (6530, 507, 604 ), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_death":
		trigger = spawn( "trigger_radius", (-1066, 15895, -3396), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_dragonball":
		trigger = spawn( "trigger_radius", (-16876, 16850, 525), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_easy":
		trigger = spawn( "trigger_radius", (8246, -192, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_epicfail":
		trigger = spawn( "trigger_radius", (3200, -180, 164), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_eudora":
		trigger = spawn( "trigger_radius", (-5594, 1903, 100), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_factory":
		trigger = spawn( "trigger_radius", (1733, -1576, 124), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_farm":
		trigger = spawn( "trigger_radius", (2611, -2039, 24), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_flow":
		trigger = spawn( "trigger_radius", (260, 144, 190), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_fluxx":
		trigger = spawn( "trigger_radius", (-1677, 17030, -128), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_freefall":
		trigger = spawn( "trigger_radius", (6737, -7975, -8964), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_fusion":
		trigger = spawn( "trigger_radius", (1665, -78, 3772), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_gold":
		trigger = spawn( "trigger_radius", (-355, -818, 282), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_grassy_v4":
		trigger = spawn( "trigger_radius", (2917, -1336, 126), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_greenland":
		trigger = spawn( "trigger_radius", (20 ,-758, 188), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_illusion":
		trigger = spawn( "trigger_radius", (1531, 19569, 701), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_inferno":
		trigger = spawn( "trigger_radius", (3277, 1661, 332), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_islands":
		trigger = spawn( "trigger_radius", (-621, -2373, -2028), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_legend":
		trigger = spawn( "trigger_radius", (1350, -1722, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_maratoon":
		trigger = spawn( "trigger_radius", (-5051, -143, 44), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_mbox":
		trigger = spawn( "trigger_radius", (465, -1217, 604), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_metal":
		trigger = spawn( "trigger_radius", (-4165, 3772, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_mirroredge":
		trigger = spawn( "trigger_radius", (-8191, -5991, -2968), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_moustache":
		trigger = spawn( "trigger_radius", (-235, 475, 90), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_oreo":
		trigger = spawn( "trigger_radius", (13967, 508, -13736), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_royals":
		trigger = spawn( "trigger_radius", (1997, -2786, -172), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_ruin":
		trigger = spawn( "trigger_radius", (409, 1538, -2820), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_sapphire":
		trigger = spawn( "trigger_radius", (-2240, -1851, 292), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_saw_v2":
		trigger = spawn( "trigger_radius", (-467, -1198, 639), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_semtex":
		trigger = spawn( "trigger_radius", (-389, 3590, 68), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_shadow":
		trigger = spawn( "trigger_radius", (2861, 10674, -756), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_sick":
		trigger = spawn( "trigger_radius", (2045, -696, 360), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_simplist":
		trigger = spawn( "trigger_radius", (121, -8401, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_skybox":
		trigger = spawn( "trigger_radius", (-1337, -789, -20), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_slow":
		trigger = spawn( "trigger_radius", (-4010, 891, 252), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_sm_v2":
		trigger = spawn( "trigger_radius", (1156, -1447, 68), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_sonic":
		trigger = spawn( "trigger_radius", (5583, -4038, 348), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_spaceball":
		trigger = spawn( "trigger_radius", (2649, 9105, -10395), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_texx":
		trigger = spawn( "trigger_radius", (-4758, 1168, 90), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_tiger":
		trigger = spawn( "trigger_radius", (10960, -6400, -4), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_under":
		trigger = spawn( "trigger_radius", (-2966, 306, -5260), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_waterwork":
		trigger = spawn( "trigger_radius", (-1259, 31940, -1380), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_underworld":
		trigger = spawn( "trigger_radius", (-1969, 6528, 1596), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_wicked2 ":
		trigger = spawn( "trigger_radius", (-1579, -5045, 636), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_winter":
		trigger = spawn( "trigger_radius", (-11067, -13773, -5145), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_wipeout":
		trigger = spawn( "trigger_radius", (2687, 2503, 92), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_wipeout_v2":
		trigger = spawn( "trigger_radius", (1687, 3765, 524), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_android":
		trigger = spawn( "trigger_radius", (5502, 0, 176), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_apocalypse":
		trigger = spawn( "trigger_radius", (19, 3953, 993), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_beat":
		trigger = spawn( "trigger_radius", (4370, 6, 32), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_blackandwhite":
		trigger = spawn( "trigger_radius", (13590, 133, 36), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_blade":
		trigger = spawn( "trigger_radius", (-5571, 1167, 492), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_bladev2":
		trigger = spawn( "trigger_radius", (3336, 1433, 268), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_blue":
		trigger = spawn( "trigger_radius", (4582, 2556, -1714), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_bouncev2":
		trigger = spawn( "trigger_radius", (1616, 1016, -364), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_buggedlikehell":
		trigger = spawn( "trigger_radius", (3514, -5570, 304), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_caelum":
		trigger = spawn( "trigger_radius", (-2752, 180, 1724), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_darmuhv2":
		trigger = spawn( "trigger_radius", (-125, -1565, -164), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_deathyard":
		trigger = spawn( "trigger_radius", (45, 3809, -186), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_deadzone":
		trigger = spawn( "trigger_radius", (-2235, -822, 828), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_digital":
		trigger = spawn( "trigger_radius", (3689, -994, 564), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_disco":
		trigger = spawn( "trigger_radius", (2, -2933, 836), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_emerald":
		trigger = spawn( "trigger_radius", (-1130, 6640, 124), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_fallrun":
		trigger = spawn( "trigger_radius", (5626, -1647, -8131), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_framey":
		trigger = spawn( "trigger_radius", (2361, 1881, 332), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_glass2":
		trigger = spawn( "trigger_radius", (3488, 3148, 92), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_gooby":
		trigger = spawn( "trigger_radius", (328, 1018, -211), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_h2o":
		trigger = spawn( "trigger_radius", (-721, -246, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_hilly_v2":
		trigger = spawn( "trigger_radius", (7401, 2571, 54), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_holyshiet":
		trigger = spawn( "trigger_radius", (834, -1536, -243), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_imaginary":
		trigger = spawn( "trigger_radius", (-236, -2823, 1841), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_impossibru":
		trigger = spawn( "trigger_radius", (153, -2787, 204), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_levels":
		trigger = spawn( "trigger_radius", (4, 16672, -1917), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_likeaboss":
		trigger = spawn( "trigger_radius", (3725, -1656, 508), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_meatboy":
		trigger = spawn( "trigger_radius", (1345, -255, 1196), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_minerun":
		trigger = spawn( "trigger_radius", (-846, -381, 636), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_minibounce_v2":
		trigger = spawn( "trigger_radius", (1146, -333, 300), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_neon":
		trigger = spawn( "trigger_radius", (1394, -2105, 188), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_nightlight":
		trigger = spawn( "trigger_radius", (2286, 1487, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_nimble":
		trigger = spawn( "trigger_radius", (-3047, 195, 716), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_prisonv2":
		trigger = spawn( "trigger_radius", (-447, -420, 837), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_rock":
		trigger = spawn( "trigger_radius", (6840, 506, -821), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_royals":
		trigger = spawn( "trigger_radius", (-1027, -1923, 380), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_running":
		trigger = spawn( "trigger_radius", (3093, -992, 381), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_ryno":
		trigger = spawn( "trigger_radius", (-2376, 3472, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_sewers":
		trigger = spawn( "trigger_radius", (5654, 1438, -962), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_sheox":
		trigger = spawn( "trigger_radius", (4758, -6, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_simple":
		trigger = spawn( "trigger_radius", (10205, 141, 867), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_skypower":
		trigger = spawn( "trigger_radius", (1507, -871, -896), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_slay":
		trigger = spawn( "trigger_radius", (8672, -1811, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_snip":
		trigger = spawn( "trigger_radius", (-308, 1227, 493), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_spacetunnel":
		trigger = spawn( "trigger_radius", (-205, 9431, -960), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_steel":
		trigger = spawn( "trigger_radius", (12348, 143, 1272), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_stonerun":
		trigger = spawn( "trigger_radius", (2460, -1077, -196), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_takeshi":
		trigger = spawn( "trigger_radius", (-929, -14, 600), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_trapntrance":
		trigger = spawn( "trigger_radius", (-511, -12761, -100), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_trikx":
		trigger = spawn( "trigger_radius", (1933, 1283, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_tron":
		trigger = spawn( "trigger_radius", (-2928, 1949, 236), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_turnabout":
		trigger = spawn( "trigger_radius", (5122, 2284, -2356), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_unreal":
		trigger = spawn( "trigger_radius", (640, -1127, 76), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_up":
		trigger = spawn( "trigger_radius", (14991, -2500, -14), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_vector":
		trigger = spawn( "trigger_radius", (-410, -3992, -2244), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_watercity":
		trigger = spawn( "trigger_radius", (1491, 1096, 444), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_wicked":
		trigger = spawn( "trigger_radius", (-706, 1528, -108), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_wtf":
		trigger = spawn( "trigger_radius", (553, -611, 92), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_amazon":
		trigger = spawn( "trigger_radius", (10292, -3935, -406), 0, 300, 300 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_cave":
		trigger = spawn( "trigger_radius", (2226.29, 35111.81, 4.125), 0, 55, 55 );
		trigger.targetname = "endmap_trig";
		break;
		
//////////////
	
	case "mp_deathrun_supermario":
		trigger = spawn( "trigger_radius", (293.538, -1472, 8.12501), 0, 40, 50 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_glass":
		trigger = spawn( "trigger_radius", (106.077, 2241.14, 64.125), 0, 55, 50 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_azteca":
		trigger = spawn( "trigger_radius", (6.59441, -808.602, 32.125), 0, 60, 50 );
		trigger.targetname = "endmap_trig";
		break;

	case "mp_deathrun_colourful":
		trigger = spawn( "trigger_radius", (350.749, 197.533, 688.125), 0, 65, 40 );
		trigger.targetname = "endmap_trig";
		break;

	case "mp_deathrun_escape2":
		trigger = spawn( "trigger_radius", (-6464.2, -2495.73, 184.125), 0, 60, 60 );
		trigger.targetname = "endmap_trig";
		break;

	case "mp_deathrun_ruin2":
		trigger = spawn( "trigger_radius", (9329.7, 380.853, 128.125), 0, 255, 140 );
		trigger.targetname = "endmap_trig";
		break;

// ===== Thanks to DuffMan for these ===== //
	case "mp_dr_bigfall":
		trigger = spawn( "trigger_radius", (-51114.02, -123.1117, -12273.5), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_scary":
		trigger = spawn( "trigger_radius", (1.12299, -11125.81, 624.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_bounce":
		trigger = spawn( "trigger_radius", (-958.809, 5989.51, 0.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_apocalypse_v2":
		trigger = spawn( "trigger_radius", (-7.09212, 3671.36, 976.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_framey_v2":
		trigger = spawn( "trigger_radius", (-2423.35, 794.684, 4.90718), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_backlot":
		trigger = spawn( "trigger_radius", (-939.774, 222.606, 106.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_max":
		trigger = spawn( "trigger_radius", (671.125, 13371.2, 0.125002), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_terror":
		trigger = spawn( "trigger_radius", (26.0624, 1312.15, 202.402), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_pool":
		trigger = spawn( "trigger_radius", (-876.881, 678.355, 184.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_skypillar":
		trigger = spawn( "trigger_radius", (-2044.31, -338.131, 1057.13), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_ssc_nothing":
		trigger = spawn( "trigger_radius", (228.711, -81.1929, 243.998), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_diehard":
		trigger = spawn( "trigger_radius", (-1095.76, -2331.43, 643.575), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_metal2":
		trigger = spawn( "trigger_radius", (-465.821, 975.085, 16.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_sm_world":
		trigger = spawn( "trigger_radius", (-3499.54, -2704.88, 64.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_palm":
		trigger = spawn( "trigger_radius", (251.21, -256.368, 384.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_watchit_v3":
		trigger = spawn( "trigger_radius", (393.125, 1254.06, 640.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_city":
		trigger = spawn( "trigger_radius", (1271.56, -847.444, 0.124998), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_jailhouse":
		trigger = spawn( "trigger_radius", (-4908.72, 447.658, 218.524), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_crazy":
		trigger = spawn( "trigger_radius", (757.689, -2349.56, 1040.13), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_finalshuttle":
		trigger = spawn( "trigger_radius", (339.854, 2194.73, 428.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_indipyramid":
		trigger = spawn( "trigger_radius", (-2593.908, 69.884, -170.875), 0, 96, 48 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_bananaphone_v2":
		trigger = spawn( "trigger_radius", (2445.84, -424.875, 176.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_zero":
		trigger = spawn( "trigger_radius", (-1860.46, -8.91591, 16.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_wood_v3":
		trigger = spawn( "trigger_radius", (2884.08, 1041.26, 1024.06), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_takecare":
		trigger = spawn( "trigger_radius", (-701.125, 931.9111, 192.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_portal_v3":
		trigger = spawn( "trigger_radius", (-4064.87, 1593.28, -63.875), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_minecraft":
		trigger = spawn( "trigger_radius", (-656.331, 1533.39, -31.875), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_liferun":
		trigger = spawn( "trigger_radius", (-279.875, 11133.46, 168.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_grassy":
		trigger = spawn( "trigger_radius", (2917.52, -1518.72, 64.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_dungeon":
		trigger = spawn( "trigger_radius", (1855.13, -2200.61, -183.875), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_dirt":
		trigger = spawn( "trigger_radius", (-30.625, -839.474, 768.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_destroyed":
		trigger = spawn( "trigger_radius", (-9224.88, 125.72, 1114.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_darkness":
		trigger = spawn( "trigger_radius", (985.723, -587.125, 16.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_deathrun_clear":
		trigger = spawn( "trigger_radius", (-771.999, 520.011, 111.125), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_pacman":
		trigger = spawn( "trigger_radius", (41.1631, 600.943, 1033.63), 0, 333, 111 );
		trigger.targetname = "endmap_trig";
		break;
	case "mp_dr_jurapark":
		trigger = spawn( "trigger_radius", (1001.44, 2104.73, -60.875), 0, 333, 111 );
		break;
	}

//===//

	if( !isDefined( level.trapTriggers ) )
	{
		level.trapTriggers = [];
		switch ( level.mapName )
		{
		// BraXi's MAPS
		case "mp_deathrun_darkness":
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t5", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t6", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t7", "targetname" );
			break;
		case "mp_deathrun_long":
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger5", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger7", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger8", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger9", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger10", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger11", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger12", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger13", "targetname" );
			spawnCollision( (112,3440,24), 70, 16 );
			spawnCollision( (16,36333,28), 70, 16 );
			spawnCollision( (-112,3440,28), 70, 16 );
			spawnCollision( (-112,3440,28), 70, 16 );
			spawnCollision( (1136,3936,28), 110, 16 );
			spawnCollision( (304,-352,20), 110, 111 );
			break;

		// Viking's MAPS
		case "mp_deathrun_watchit_v2":
		case "mp_deathrun_watchit_v3":
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t5", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t6", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t7", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t8", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t9", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t10", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t11", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t12", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t13", "targetname" );
			break;

		// MR-X's MAPS
		case "mp_deathrun_takecare":
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_5", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_6", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_7", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_8", "targetname" );
			break;
		case "mp_deathrun_glass":
		case "mp_deathrun_dungeon":
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_5", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_6", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_7", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_8", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig_9", "targetname" );
			break;
		case "mp_deathrun_supermario":

			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig5", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig6", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig7", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig8", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trig9", "targetname" );
			break;

		// Patrick's MAPS
		case "mp_deathrun_short":
		case "mp_deathrun_short_v2":
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "t5", "targetname" );
			break;
		
		// Rednose's MAPS
		case "mp_deathrun_grassy":
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger5", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger6", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger7", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger8", "targetname" );
			break;
		case "mp_deathrun_portal":
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger1", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger2", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger3", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger4", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger5", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger6", "targetname" );
			level.trapTriggers[level.trapTriggers.size] = getEnt( "trigger7", "targetname" );
			break;
		}
	}

	if( isDefined( level.trapTriggers ) )
	{
		level thread checkTrapUsage();
	}
}


checkTrapUsage()
{

	if( !level.trapTriggers.size )
	{
		warning( "checkTrapUsage() reported that level.trapTriggers.size is -1, add trap activation triggers to level.trapTriggers array and recompile FF" );
		warning( "Map doesn't support free run and XP for activation" );
		return;
	}

	for( i = 0; i < level.trapTriggers.size; i++ )
	{
		if ( level.dvar[ "freeRunChoice" ] == 2 )
		{
			level.trapTriggers[i] thread killFreeRunIfActivated();
		}
		if ( level.dvar[ "giveXpForActivation" ] )
		{
			level.trapTriggers[i] thread giveXpIfActivated();
		}
		level.trapTriggers[i] thread processTrapChallenge();
	}
}

processTrapChallenge()
{
	level endon( "death" );
	level endon( "delete" );
	level endon( "deleted" );

	while( isDefined( self ) )
	{
		self waittill( "trigger", who );
		if( who.pers["team"] == "axis" )
		{
			if( game["state"] != "playing" )
				return;
			who braxi\_missions::processChallenge( "ch_activated", 1 );
			break;
		}
	}
}
		

killFreeRunIfActivated()
{
	level endon( "death" );
	level endon( "delete" );
	level endon( "deleted" );
	level endon( "kill_free_run_choice" );

	//level.trapsDisabled
	while( isDefined( self ) )
	{
		self waittill( "trigger", who );
		if( who.pers["team"] == "axis" )
		{
			level.canCallFreeRun = false;
			if( !level.trapsDisabled )
			{
				//who iPrintlnBold( "You have activated trap and now you can't call free run" );
				level notify( "kill_free_run_choice" );
			}
			break;
		}
	}
}


giveXpIfActivated()
{
	level endon( "death" );
	level endon( "delete" );
	level endon( "deleted" );

	while( isDefined( self ) )
	{
		self waittill( "trigger", who );
		if( who.pers["team"] == "axis" )
		{
			if( game["state"] != "playing" )
				return;
			who braxi\_rank::giveRankXP( "trap_activation" );
			break;
		}
	}
}