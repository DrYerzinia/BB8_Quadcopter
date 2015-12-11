// Author Michael Marques (DrYerzinia)

$fe = 0.1;		// preview

include <actual_color.scad>
include <BB8.scad>

full_body = false;

end =
	full_body
	? 270
	: 0
;

//head();

for(i = [0:90:end]){
	rotate([0, 0, i]){

		rotate([0,0,-90])
			color(BODY_P01_COLOR) Body_P1();
		//rotate([0,0,45])
		//color(BODY_P02_COLOR) Body_P2();
		//rotate([0,0,-45])
		//color(BODY_P03_COLOR) Body_P3();
		//rotate([0,0,45])
		//color(BODY_P04_COLOR) Body_P4();
		rotate([0,0,-45])
		color(BODY_P05_COLOR) Body_P5();

		color(BODY_P06_COLOR) Body_P6();
		color(BODY_P16_COLOR) Body_P16_door_servo_mount();
		color(BODY_P07_COLOR) Body_P7();
		color(BODY_P08_COLOR) Body_P8();
		color(BODY_P09_COLOR)	Body_P9();
		rotate([0,0,-90])
		color(BODY_P10_COLOR) Body_P10();
		color(BODY_P11_COLOR) Body_P11();

		rotate([0,0,-90])
			color(BODY_P12_COLOR) Body_P12();

		//cover_assembly();

		color(DOOR_P08_COLOR[0]) Door_P8_middle_door_bumper();
		mirror([0, 1, 0])
		color(DOOR_P08_COLOR[1]) Door_P8_middle_door_bumper();

		color(DOOR_P07_COLOR) Door_P7_middle_door_brace();
		mirror([0, 1, 0])
		color(DOOR_P07_COLOR) Door_P7_middle_door_brace();

		color("Magenta"){
			door_servo();
			mirror([-1,1,0]) door_servo();
		}

		Door_P11_door_edge_brace(-45);
		Door_P12_door_edge_bumper(-45);

		Door_P11_door_edge_brace(-15);
		Door_P12_door_edge_bumper(-15);

		Door_P11_door_edge_brace(15);
		Door_P12_door_edge_bumper(15);

		Door_P11_door_edge_brace(45);
		Door_P12_door_edge_bumper(45);

		propulsion_system();

	}
}

rotate([0, -90, 0]){
	for(i = [0:90:270]){
		rotate([i, 0, 0]){
			//color(DOOR_P20_COLOR) Door_P20();
			//color(DOOR_P21_COLOR) Door_P21();
			color(DOOR_P22_COLOR) Door_P22();
		}
	}
	color(DOOR_P23_COLOR) Door_P23();
	color(DOOR_P24_COLOR) Door_P24();
	color(DOOR_P25_COLOR) Door_P25();
	color(DOOR_P26_COLOR) Door_P26();
	color(DOOR_P27_COLOR) Door_P27();
	color(DOOR_P27_COLOR) rotate([180, 0, 0]) Door_P28();
	color(DOOR_P27_COLOR) Door_P29();
	color(DOOR_P27_COLOR) Door_P30();
	color(DOOR_P27_COLOR) Door_P31();

	color(DOOR_P20_COLOR) Door_P32();
	color(DOOR_P20_COLOR) Door_P33();
	color(DOOR_P20_COLOR) Door_P34();
	color(DOOR_P20_COLOR) Door_P35();

	color(DOOR_P20_COLOR) Door_P36();
	color(DOOR_P20_COLOR) Door_P37();
	color(DOOR_P20_COLOR) Door_P38();
	color(DOOR_P20_COLOR) Door_P39();

}

color(DOOR_P22_COLOR) Door_P40();

color(BODY_P09_COLOR) Body_P21();

rotate([0, 	90, 0]){
	for(i = [0:90:270]){
		rotate([i, 0, 0]){
			//color(DOOR_P20_COLOR) Door_P20();
			//color(DOOR_P21_COLOR) Door_P21();
			color(DOOR_P22_COLOR) Door_P22();
		}
	}
/*
	color(DOOR_P23_COLOR) Door_P23();
	color(DOOR_P24_COLOR) Door_P24();
	color(DOOR_P25_COLOR) Door_P25();
	color(DOOR_P26_COLOR) Door_P26();
	color(DOOR_P27_COLOR) Door_P27();
	color(DOOR_P27_COLOR) rotate([180, 0, 0]) Door_P28();
	color(DOOR_P27_COLOR) Door_P29();
	color(DOOR_P27_COLOR) Door_P30();
	color(DOOR_P27_COLOR) Door_P31();
*/

	color(DOOR_P27_COLOR) Door_P49();
	color(DOOR_P27_COLOR) Door_P50();
	color(DOOR_P27_COLOR) Door_P51();

	color(DOOR_P23_COLOR) Door_P52();
	color(DOOR_P23_COLOR) Door_P53();
	color(DOOR_P23_COLOR) Door_P54();
	color(DOOR_P23_COLOR) Door_P55();

	color(DOOR_P20_COLOR) Door_P41();
	color(DOOR_P20_COLOR) Door_P42();
	color(DOOR_P20_COLOR) Door_P43();
	color(DOOR_P20_COLOR) Door_P44();

	color(DOOR_P20_COLOR) Door_P45();
	color(DOOR_P20_COLOR) Door_P46();
	color(DOOR_P20_COLOR) Door_P47();
	color(DOOR_P20_COLOR) Door_P48();

}

rotate([180, 0, 180])
	for(i = [0:90:270]){
		rotate([0, 0, i]){
		//	rotate([0,0,45])
		//		color(BODY_P18_COLOR)				Body_P18();
		rotate([0,0,-90])
			color(BODY_P20_COLOR)		Body_P20();
		rotate([0,0,-90])
			color(BODY_P01_COLOR)				Body_P1();
			rotate([0,0,-90]) color(BODY_P10_COLOR)		Body_P10();
		}
	}

color(BODY_P12_COLOR)			Body_P13();
