// Author Michael Marques (DrYerzinia)

$fe = 0.1;		// preview

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
			color("Red")				Body_P1();
		rotate([0,0,45])
		color("Green")				Body_P2();
		rotate([0,0,-45])
		color("Yellow")				Body_P3();
		rotate([0,0,45])
		color("Turquoise")		Body_P4();
		rotate([0,0,-45])
		color("OrangeRed")		Body_P5();

		color("Blue")					Body_P6();
		color("DarkGreen")		Body_P16_door_servo_mount();
		color("Purple")				Body_P7();
		color("DeepPink")			Body_P8();
		color("SpringGreen")	Body_P9();
		rotate([0,0,-90]) color("DarkKhaki")		Body_P10();
		color("LawnGreen")		Body_P11();

		rotate([0,0,-90])
			color("Fuchsia")		Body_P12();

		cover_assembly();

		color("FireBrick") Door_P8_middle_door_bumper();
		mirror([0, 1, 0])
			color("Lime") Door_P8_middle_door_bumper();

		color("DeepSkyBlue") Door_P7_middle_door_brace();
		mirror([0, 1, 0])
			color("DeepSkyBlue") Door_P7_middle_door_brace();

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

color("Magenta")			Body_P13();
