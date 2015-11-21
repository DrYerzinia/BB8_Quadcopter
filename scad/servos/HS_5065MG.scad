use <../utils.scad>

module HS_5065MG(){

	length = 23.75;
	width = 11.68;
	depth = 20.32;
	wing_width = 32.38;
	wing_thick = 2;
	wing_offset = 1;
	shaft_offset = 6;
	hole_spacing = 28.32;
	hole_spacing_2 = 27;
	hole_2_wide = 6;
	hole_diameter = 2;
	shaft_height = 26.16;
	shaft_length = 2;

	module mounting_hole(){
		mh_rad = hole_diameter / 2;
		translate(
			[
				hole_spacing / 2,
				0,
				depth / 2 - wing_thick / 2
			])
			cylinder(h = 5, r = mh_rad, $fa = fa(mh_rad), center = true);
		translate(
			[
				hole_spacing_2 / 2,
				hole_2_wide / 2,
				depth / 2 - wing_thick / 2
			])
			cylinder(h = 5, r = mh_rad, $fa = fa(mh_rad), center = true);
		translate(
			[
				hole_spacing_2 / 2,
				- hole_2_wide / 2,
				depth / 2 - wing_thick / 2
			])
			cylinder(h = 5, r = mh_rad, $fa = fa(mh_rad), center = true);
	}

	difference(){
		union(){
			cube([length, width, depth], center = true);
			translate([0, 0, depth / 2 - wing_thick / 2 - wing_offset])
				cube([wing_width, width, wing_thick], center = true);
			translate(
				[
					- length / 2 + shaft_offset,
					0,
					depth / 2 + 3.8 + 1.9 + shaft_length / 2
				])
				cylinder(
					h = shaft_length,
					r = 1.5,
					$fa = fa(1.5),
					center = true);
			translate(
				[
					- length / 2 + shaft_offset,
					0,
					depth / 2 + 3.8 / 2
				])
				cylinder(
					h = 3.8,
					r = 11.3 / 2,
					$fa = fa(11.3 / 2),
					center = true);
			translate(
				[
					- length / 2 + shaft_offset,
					0,
					depth / 2 + 3.8 + 1.9 / 2
				])
				cylinder(
					h = 1.9,
					r1 = 11.3 / 2,
					r2 = 8 / 2,
					$fa = fa(11.3 / 2),
					center = true);
		}	union(){

			mounting_hole();
			mirror() mounting_hole();
		}
	}
}

module HS_5065MG_arm(){

	hole_size = 1.5;
	hole_spacing = 3;
	hole_offset = 9.6;

	difference(){
		union(){
			translate([0, 0, 4.4 / 2])
				cylinder(
					h = 4.4,
					r = 8 / 2,
					$fa = fa(8 / 2),
					center = true);
			hull(){
				translate([0, 0, 4.4 - 1.8 / 2])
					cylinder(
						h = 1.8,
						r = 8 / 2,
						$fa = fa(8 / 2),
						center = true);
				translate([18.8, 0, 4.4 - 1.8 / 2])
					cylinder(
						h = 1.8,
						r = 5 / 2,
						$fa = fa(5 / 2),
						center = true);
			}
		}
		union(){
			for(i = [0:3]){
				translate([hole_offset + hole_spacing * i, 0, 4.4 - 1.8 / 2])
					cylinder(
						h = 5,
						r = hole_size / 2,
						$fa = fa(hole_size / 2),
						center = true);
			}
		}
	}
}

module HS_5065MG_shaft_translate(){
	translate(
		[
			- 23.75 / 2 + 6,
			0,
			20.32 / 2 + 3.8 + 1.9
		])
			children();
}

HS_5065MG();
HS_5065MG_shaft_translate() HS_5065MG_arm();
