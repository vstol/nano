main()
{
//thread laser();
thread text();
//thread trap0();
thread trap1();
thread trap2();
thread trap3();
thread trap4();
thread trap5();
thread trap6();
thread trap7();


//level._effect[ "redflash" ] = loadfx( "misc/icbm_post_light_red" );
//level._effect[ "jed" ] = loadfx( "impacts/water_leak" );
//level._effect[ "dym2" ] = loadfx( "smoke/car_damage_whitesmoke" );
//level._effect[ "blesk" ] = loadfx( "misc/blesky2" );
//level._effect[ "laser" ] = loadfx( "misc/laser" );
}


text()
{
while(1)
{
	iprintln ("^3Map by ^1Col!ar ^3& ^1PetX");
	wait 10;
	iprintln ("^3Script by ^1PetX");
	iprintln ("^4Thanks: ^2K4r3l01, R3MIEN");
	wait 10;
	iprintln ("^2www.4gf.cz");
    wait 10;
	iprintln ("^5For Gamers Fusion");
	wait 60;
}
}


trap0()
{
start = getent( "start" , "targetname" );
v = getent( "vrtula" , "targetname" );
wait 15;
start movez (-193, 1);
wait 10;

while (1)
  {
  v RotateYaw( 360, 2, 0.5, 0.5 );
  wait 10;
  }
}

trap1()
{
t1 = getent ("t1" , "targetname");
kill = getent ("t1_kill" , "targetname");

t1 waittill ("trigger");
t1 delete ();
//fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );

if(!level.trapsDisabled)
{
kill movez ( -100, 1 );
wait 5;
kill movez ( 100, 5 );
}
}

trap2()
{
rotate = getent( "t2_kill" , "targetname" );
t2 = getent ("t2" , "targetname");
//red = getent ("red5" ,"targetname"); //origin

t2 waittill ("trigger");
t2 delete ();
//fx = PlayLoopedFX( level._effect["redflash"], 1, red.origin );

if(!level.trapsDisabled)
{
    while( 1 )
	{
    cas = 7;
	rotate rotateroll( -360, cas );
    wait cas;
	}
	}
}

trap3()
{
part1 = getentarray ("t3_1" ,"targetname");
part2 = getentarray ("t3_2" ,"targetname");

//red = getent ("red7" ,"targetname"); //origin
t3 = getent ("t3" , "targetname");

t3 waittill ("trigger");
t3 delete ();
//fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );
if(!level.trapsDisabled)
{
part1[randomInt(part1.size)] notsolid();
part2[randomInt(part2.size)] notsolid();
}
}

trap4()
{
part1 = getentarray ("t4_1" ,"targetname");

//red = getent ("red7" ,"targetname"); //origin
t4 = getent ("t4" , "targetname");

t4 waittill ("trigger");
t4 delete ();
//fx = PlayLoopedFX(level._effect["redflash"], 1, red.origin );
if(!level.trapsDisabled)
{
part1[randomInt(part1.size)] notsolid();
}
}

trap5()
{
kill = getent( "t5_kill" , "targetname" );
trig = getent( "t5_trig" , "targetname" );
trig_door = getent( "t5_door_trig" , "targetname" );
m = getent( "t5_mac" , "targetname" );
door = getent( "t5_door" , "targetname" );
t5 = getent ("t5" , "targetname");

trig_door enableLinkTo();
trig_door linkTo( door );
door movez ( 84, 1 );

t5 waittill ("trigger");
t5 delete ();
if(!level.trapsDisabled)
{
door movez ( -96, 5 , 0.5, 0.5 );
trig_door thread killtrigger();
earthquake( 0.5, 5, door.origin, 512 );
wait 5;
trig_door unlink();
trig_door delete();

m movey (-284, 5);
wait 4.4;
trig enableLinkTo();
trig linkTo( kill );
kill movez ( 80, 0.01 );
wait 0.5;
trig unlink();
trig delete();
kill delete();
m waittill ("movedone");
wait 2;
m movey (284, 5);
door movez ( 96, 5 , 0.5, 0.5 );
earthquake( 0.5, 5, door.origin, 512 );
}
}

trap6()
{
t6 = getent ("t6" , "targetname");
m1 = getent ("t6_m1" ,"targetname");
m2 = getent ("t6_m2" ,"targetname");
kill = getent ("t6_kill" ,"targetname");
trig = getent ("t6_trig" ,"targetname");

m1 movey (82,0.5);
m2 movey (-78,0.5);

t6 waittill ("trigger");
t6 delete ();
if(!level.trapsDisabled)
{
m1 movey (-210,1);
m2 movey (210,1);

wait 0.9;
trig enableLinkTo();
trig linkTo( kill );
kill movez (84, 0.05);

wait 0.5;

trig unLink();
trig delete();
kill delete();

m1 movey (210,3);
m2 movey (-210,3);
}
}

trap7()
{
gula = getent ("t7_gula" ,"targetname");
trig = getent ("gula_trig" ,"targetname");
origin = getent ("gula_origin" ,"targetname");
door = getent ("t7_door" ,"targetname");
desky = getent ("t7_desky" ,"targetname");
trig_door = getent ("t7_door_trig" ,"targetname");
t7 = getent ("t7" , "targetname");

trig enableLinkTo();
trig linkTo( origin );
gula moveto (origin.origin,0.05);

trig_door enableLinkTo();
trig_door linkTo( door );
door movey ( 53, 1 );
wait 1;
door movez ( 196, 1 );

t7 waittill ("trigger");
t7 delete ();
if(!level.trapsDisabled)
{
trig thread killtrigger();
door movez ( -196, 3 );
trig_door thread killtrigger();
earthquake( 0.5, 3, door.origin, 512 );
wait 2;

gula movey (-98,1);
origin movey (-98,1);
gula rotateroll (50, 1);
earthquake( 0.5, 1, gula.origin, 512 );
wait 1;
gula movez (-240, 0.5);
origin movez (-240, 0.5);
wait 0.5;
earthquake( 2, 1, gula.origin, 1024 );
gula movey (-408,5);
origin movey (-408,5);
gula rotateroll (310,5);
earthquake( 0.5, 5, gula.origin, 512 );
wait 4.9;
desky delete();
wait 0.1;
gula movez (-136,0.5);
origin movez (-136,0.5);
wait 0.5;
earthquake( 2, 1, gula.origin, 1024 );
trig_door unlink();
trig_door delete();

trig unLink();
trig delete();

wait 2;

door movez ( 196, 10 );
earthquake( 0.5, 10, door.origin, 512 );
}
}

killtrigger()
{
while (1)
{
self waittill ("trigger", player);
player suicide();
}
}


