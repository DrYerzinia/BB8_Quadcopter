// Author Michael Marques (DrYerzinia)

module parallax_continuous_rotation_servo(){

	depth = 37.7;
	length = 40.75;
	width = 19.75;

	mount_height = 2.7;
	mount_extent = 6.1;
	mount_from_top = 7.7;

	mount_hole_diameter = 4.46;
	mount_hole_spacing = 14.4 - mount_hole_diameter;

	shaft_diameter = 5.8;
	shaft_offset = 10;
	shaft_length = 3.5;

	module mounting_hole(){

			translate(
				[
					length / 2 + 5,
					mount_hole_spacing / 2,
					depth / 2 - mount_height / 2 - mount_from_top
				]
				)
				cylinder(
					h = mount_height + 1,
					r = mount_hole_diameter / 2,
					$fn=16,
					center = true);
	}

	difference(){
		union(){

			// Body
			cube([length,width,depth], center = true);

			// Mounting wings
			translate(
				[
					0,
					0,
					depth / 2 - mount_height / 2 - mount_from_top
				])
				cube(
					[
						length + mount_extent * 2,
						width,
						mount_height
					],
					center = true);

			// Shaft
			translate(
				[
					length / 2 - shaft_offset,
					0,
					depth / 2 + shaft_length / 2
				]
				)
				cylinder(
					h = shaft_length,
					r = shaft_diameter / 2,
					$fn = 16,
					center = true
				);

		}
		union(){

			// Mounting Holes
			mounting_hole();
			mirror()
				mounting_hole();

			translate([0,-mount_hole_spacing,0]){
				mounting_hole();
				mirror()
					mounting_hole();
			}
		}
	}

}

module translate_shaft(){

	depth = 37.7;
	length = 40.75;

	shaft_offset = 10;

	translate(
		[
			length / 2 - shaft_offset,
			0,
			depth / 2
		])
		children();
}

module round_servo_attachment(){

	height = 6;
	diameter = 20.8;
	inner_diameter = 8.6;
	plate_thickness = 2.45;

	float = 2;

	depth = 37.7;
	length = 40.75;

	shaft_offset = 10;

	plate_hole_spacing = 14.5;
	plate_hole_diameter = 1.4;
	plate_hole_minor_spacing = 3.5;

	screw_hole_diameter = 3;

	inner_diameter = 8;
	
	top_depth = 1.8;
	bottom_depth = 3.4;

	void_diameter = 5.8;

	module plate_hole(){
		cylinder(
			h = plate_thickness + 1,
			r = plate_hole_diameter / 2,
			$fn = 16,
			center = true
		);
	}

	module plate_hole_group(){
		translate([0, 0, height / 2 - plate_thickness / 2]){
			translate([0, plate_hole_spacing / 2, 0]){
					plate_hole();
					translate([- plate_hole_minor_spacing, 0, 0])
						plate_hole();
					translate([  plate_hole_minor_spacing, 0, 0])
						plate_hole();
			}
		}
	}

	translate(
		[
			length / 2 - shaft_offset,
			0,
			depth / 2 + height / 2 + float
		]
		)
		difference(){

			union(){

				// inner shaft
				cylinder(
					h = height,
					r = inner_diameter / 2,
					$fn = 16,
					center = true
				);

				// top
				translate([0, 0, height / 2 - plate_thickness / 2])
					cylinder(
						h = plate_thickness,
						r = diameter / 2,
						$fn = 32,
						center = true
					);
			}

			union(){

				// plate holes
				for(ang = [0:3]){
					rotate([0,0, ang * 90])
						plate_hole_group();
				}

				// screw hole
				cylinder(
					h = height + 1,
					r = screw_hole_diameter / 2,
					$fn = 16,
					center = true
				);

				// inner voids
				translate([0, 0, height / 2 - top_depth / 2 + 1])
					cylinder(
						h = top_depth + 1,
						r = void_diameter / 2,
						$fn = 16,
						center = true
					);
				translate([0, 0, -1])
					cylinder(
						h = bottom_depth + 1,
						r = void_diameter / 2,
						$fn = 16,
						center = true
					);

			}

		}

}

parallax_continuous_rotation_servo();
round_servo_attachment();
