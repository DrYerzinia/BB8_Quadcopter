use <../utils.scad>

module TGY_4805_2PA(){

	length = 40;
	width = 20;
	depth = 36.4;
	wing_width = 58;
	wing_thick = 2.45;
	wing_height = 27.7;
	shaft_offset = 9.5;
	hole_seperation = 9.2;
	hole_spacing = 50;
	shaft_height = 40;
	shaft_length = 3.6;
	hole_diameter = 4.8;

	module mounting_hole(){
		mh_rad = hole_diameter / 2;
		translate(
			[
				hole_spacing / 2,
				0,
				-depth / 2 + wing_height - wing_thick / 2
			])
			cylinder(h = 5, r = mh_rad, $fa = fa(mh_rad), center = true);
	}

	difference(){
		union(){
			cube([length, width, depth], center = true);
			translate([0, 0, -depth / 2 + wing_height - wing_thick / 2])
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

			translate([0, hole_seperation / 2, 0]){
				mounting_hole();
				mirror() mounting_hole();
			}
			translate([0, -hole_seperation / 2, 0]){
				mounting_hole();
				mirror() mounting_hole();
			}
		}
	}
}

module TGY_4805_2PA_translate(){
	length = 40;
	shaft_offset = 9.5;
	shaft_height = 40;
	shaft_length = 3.6;
	translate(
		[
				- length / 2 + shaft_offset,
				0,
				shaft_height - length / 2 + shaft_length / 2
		]) children();
}

TGY_4805_2PA();