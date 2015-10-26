// Author Michael Marques (DrYerzinia)

use <../utils.scad>

module ls_0006_servo(){
	
	length = 21.4;
	depth = 19.9;
	thickness = 11.65;

	gear_height = 2.6;
	gear_bump_height = 0.7;
	gear_bump_diameter = 1.97;
	gear_outer_bump_diameter = 6;
	gear_bump_offset = 12.2;

	shaft_height = 2.4;
	shaft_diameter = 3.74;
	shaft_offset = thickness / 2;
	shaft_screw_diameter = 1.3;
	
	wing_outer_width = 8.5;
	wing_top_off = 3.8;
	wing_length = 3.8;
	wing_thickness = 1.2;
	wing_hole_diameter = 1.85;
	wing_hole_edge_dist = 2;

	module wing_hole(){
		translate(
			[
				length / 2 + wing_hole_edge_dist,
				0,
				depth/2 - wing_top_off - wing_thickness / 2
			])
			cylinder(
				h = wing_thickness + 1,
				r = wing_hole_diameter / 2,
				$fn = 16,
				center = true);
	}

	module wing(){
		translate(
			[
				length / 2,
				thickness / 2,
				depth/2 - wing_top_off - wing_thickness
			])
			rotate([0,0,-90])
				trapezoid(
					thickness,
					wing_outer_width,
					wing_length,
					wing_thickness);
	}

	// Body
	cube([length, thickness, depth], center = true);

	difference(){
		union(){

			wing();
			mirror() wing();

			// Gear Bumps
			translate([0, 0, depth/2 + gear_height / 2]){
				translate([length / 2 - gear_bump_offset, 0, 0])
					cylinder(
						h = gear_height,
						r = gear_outer_bump_diameter / 2,
						$fn = 16,
						center = true);
				translate([length / 2 - gear_bump_offset, 0, gear_height/2 + gear_bump_height / 2])
					cylinder(
						h = gear_bump_height,
						r = gear_bump_diameter / 2,
						$fn = 16,
						center = true);
				translate([length / 2 - shaft_offset, 0, 0])
					cylinder(
						h = gear_height,
						r = thickness / 2,
						$fn = 32,
						center = true);
				// Shaft
				translate([length / 2 - shaft_offset, 0, gear_height])
					cylinder(
						h = shaft_height,
						r = shaft_diameter / 2,
						$fn = 16,
						center = true);
			}

		}
		union(){

			wing_hole();
			mirror() wing_hole();

			// Shaft_hole
			translate(
				[
					length / 2 - shaft_offset,
					0,
					depth/2 + gear_height * (3 / 2) + 0.5])
				cylinder(
					h = shaft_height + 1,
					r = shaft_screw_diameter / 2,
					$fn = 16,
					center = true);

		}
	}

}

module translate_ls_0006_attachment(){

	length = 21.4;
	thickness = 11.65;
	shaft_offset = thickness / 2;
	depth = 19.9;
	float = 3.3;

	translate([length / 2 - shaft_offset, 0, depth / 2 + float])
		children();

}

module bar_attachment(){

	height = 3.75;
	bar_length = 14.7;
	bar_thickness = 1.6;
	inner_radius = 5.9;
	outer_radius = 3.95;
	shaft_diameter = 3.7;
	upper_void_diameter = 4.8;
	screw_diameter = 2;
	hole_spacing = 2;
	hole_4_diameter = 1.2;
	hole_diameter = 1;
	hole_start_off = 4.7;
	top_void_depth = 0.67;
	bottom_void_depth = 1.84;

	translate([0, 0, height / 2]){
		difference(){
			union(){

				translate([0, inner_radius / 2, height / 2 - bar_thickness])
					rotate([0,0,-90])
						trapezoid(
							inner_radius,
							outer_radius,
							bar_length,
							bar_thickness);

				cylinder(
					h = height,
					r = inner_radius / 2,
					$fn = 16,
					center = true);

				translate([bar_length, 0, height / 2 - bar_thickness / 2])
					cylinder(
						h = bar_thickness,
						r = outer_radius / 2,
						$fn = 16,
						center = true);

			}
			union(){
				// screwhole
				cylinder(
					h = height + 1,
					r = screw_diameter / 2,
					$fn = 16,
					center = true);
				// voids
				translate([0, 0, height / 2 - top_void_depth / 2 + 0.5])
					cylinder(
						h = top_void_depth + 1,
						r = upper_void_diameter / 2,
						$fn = 16,
						center = true);
				translate([0, 0,  - bottom_void_depth / 2 - 0.5])
					cylinder(
						h = bottom_void_depth + 1,
						r = shaft_diameter / 2,
						$fn = 16,
						center = true);

				for(i = [0:4]){
					dia = (i != 3) ? hole_diameter : hole_4_diameter;
					translate(
						[
							hole_start_off + hole_spacing * i,
							0,
							height / 2 - bar_thickness / 2])
						cylinder(
							h = bar_thickness + 1,
							r = dia / 2,
							$fn = 16,
							center = true);
				}

			}
		}
	}

}

ls_0006_servo();
translate_ls_0006_attachment() bar_attachment();
