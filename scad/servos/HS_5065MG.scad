use <../utils.scad>

module HS_5065MG(){

	length = 23.75;
	width = 11.68;
	depth = 20.32;
	wing_width = 32.38;
	wing_thick = 3.43;
	shaft_offset = 6;
	hole_spacing = 28.32;
	shaft_height = 26.16;
	shaft_length = 2;

	module mounting_hole(){
		mh_rad = 2 / 2;
		translate(
			[
				hole_spacing / 2,
				0,
				depth / 2 - wing_thick / 2
			])
			cylinder(h = 5, r = mh_rad, $fa = fa(mh_rad), center = true);
	}

	difference(){
		union(){
			cube([length, width, depth], center = true);
			translate([0, 0, depth / 2 - wing_thick / 2])
				cube([wing_width, width, wing_thick], center = true);
			translate(
				[
					- length / 2 + shaft_offset,
					0,
					shaft_height - length / 2 + shaft_length / 2
				])
				cylinder(
					h = shaft_length,
					r = 1.5,
					$fa = fa(1.5),
					center = true);
		}	union(){

			mounting_hole();
			mirror() mounting_hole();
		}
	}
}

HS_5065MG();