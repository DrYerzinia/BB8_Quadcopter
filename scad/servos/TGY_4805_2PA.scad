use <../utils.scad>

module TGY_4805_2PA(){

	length = 40;
	width = 20;
	depth = 38.7;
	wing_width = 58;
	wing_thick = 4;
	shaft_offset = 6;
	hole_spacing = 50;
	shaft_height = 42;
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

TGY_4805_2PA();