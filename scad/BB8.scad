// Author Michael Marques (DrYerzinia)

// Lulzbot Mini tolerances
// x/y 0.1mm
// z   0.05mm
//
// 0.1mm   preview tolerance
// 0.025mm export  tolerance

$fs = 0.01;
$fn = undef;
$fa = 360 / 5;

//$fe = 0.1;		// preview
//$fe = 0.025;	// export

use <utils.scad>
use <hardware.scad>
use <servos/parallax_continuous_rotation_servo.scad>
use <servos/LS_0006_servo.scad>
use <servos/HS_5065MG.scad>
use <servos/TGY_4805_2PA.scad>
use <motors/MN5212.scad>

section_length = 140;

body_radius = 250;
circle_body_ratio = 0.6;
body_circle_radius = body_radius * circle_body_ratio;
body_shell_thickness = 10;

internal_radius = 170;

joint_position = [197, 145, 0];
prop_joint_position = [176, 0, 142.5];

// servo throw = 25
// 25 = sqrt((12.5 + x * sin(70)) ^ 2 + (x * cos(70)) ^ 2)
// x = 12.8
// round down to 12.5
door_servo_lever_position = 
	[
		joint_position[0], 
		joint_position[1] - 12.5,
		joint_position[2]
	];

radial_resolution = 64; // Set low for editing, High for render

// Animation

as = 11;

animating = false;

prop_deployed = false;
cover_open = true;

arm_angle =
	animating
		? ($t * as < 2) 
			? -90
			: ($t * as >= 2 && $t * as < 3)
					? ($t * as - 2) * 30 - 90
					: ($t * as >= 3 && $t * as < 7)
						? -60
						: ($t * as >= 7 && $t * as < 8)
							? ($t * as - 7) * -30 - 60
							: ($t * as >= 8 && $t * as < 9)
								? -90
								: ($t * as >= 9 && $t * as < 10)
									? ($t * as - 9) * 90 - 90
									: 0
		: prop_deployed
			? -90
			: 0
	;

open_angle = 70;
close_shift = -5;
open_shift = 7.5;

cover_angle =
	animating
		? ($t * as < 1) 
			? 0
			: ($t * as >= 1 && $t * as < 2)
				? ($t * as - 1) * open_angle
				: ($t * as >= 2 && $t * as < 10)
					? open_angle
					: ($t * as >= 10 && $t * as < 11)
						? ($t * as - 10) * -open_angle + open_angle
						: 0
		: cover_open
			? 70
			: 0
	;

shift =
	animating
		? ($t * as < 1) 
			? close_shift
			: ($t * as >= 1 && $t * as < 2)
				? ($t * as - 1) * (open_shift-close_shift) + close_shift
				: ($t * as >= 2 && $t * as < 10)
					? open_shift
					: ($t * as >= 10 && $t * as < 11)
						? ($t * as - 10)
							* -(open_shift - close_shift)
							+ open_shift
						: close_shift
		: cover_open
			? open_shift
			: close_shift
	;

prop_angle = 
	animating
		? ($t * as < 1) 
			? ($t * as - 0) * 90 - 90
			: ($t * as >= 1 && $t * as < 3)
				? 0 // -90
				: ($t * as >= 3 && $t * as < 4)
					? ($t * as - 3) * 22
					: ($t * as >= 4 && $t * as < 5)
						? ($t * as - 4) * 90 + 22
						: ($t * as >= 5 && $t * as < 6)
							? ($t * as - 5) * -130 + 112
							: ($t * as >= 6 && $t * as < 7)
								? ($t * as - 6) * -90 - 18
								: ($t * as >= 7 && $t * as < 8)
									? -108
									: ($t * as >= 8 && $t * as < 9)
										?($t * as - 8) * -72 - 108
										: -180
		: prop_deployed
			? -90
			: -180
	;

blade_1_angle =
	animating
		? ($t * as < 4)
			? -90
			: ($t * as >= 4 && $t * as < 5)
				? ($t * as - 4) * -90 - 90
				: -180
		: prop_deployed
			? -90
			: -180
	;

blade_2_angle =
	animating
		? ($t * as < 6)
			? 90
			: ($t * as >= 6 && $t * as < 7)
				? ($t * as - 6) * 90 + 90
				: 180
		: prop_deployed
			? 90
			: 180
	;

rot_amt =
	animating
	? ($t * as < 10)
			? 1.0
			: ($t * as - 10) * -1 + 1.0
	: 0
	;

/*
deployed = false;
extension =
	animating ?
		$t < 0.5 ?
				$t * 30 * 2 :
				30
		:
		deployed ?
			30 : 
			0;

hinge_angle =
	animating ?
		$t < 0.5 ?
				$t * -55 * 2 :
				-55
		:
		deployed ?
			-55 : 
			0;

latch_angle =
	animating ?
		$t < 0.5 ?
				60 :
				60 - (($t - 0.5) * 90 * 2)
		:
		deployed ?
			-30 : 
			60;
*/

module body_circles(){

	rotate([90,0,0])
		cylinder(
			h = body_radius * 2,
			r = body_circle_radius,
			$fa = fa(body_circle_radius),
			center = true);
	rotate([0,90,0])
		cylinder(
			h = body_radius * 2,
			r = body_circle_radius,
			$fa = fa(body_circle_radius),
			center = true);
	rotate([0,0,90])
		cylinder(
			h = body_radius * 2,
			r = body_circle_radius,
			$fa = fa(body_circle_radius),
			center = true);

}

module body(shell_thickness, shell_shrink){

	difference(){

		r = body_radius - shell_shrink;
		sphere(
        r = r,
				$fa = fa(r));

		union(){
		
			r = body_radius - shell_shrink - shell_thickness;
			sphere(
				r = r,
				$fa = fa(r));

			body_circles();

		}

	}

}

//cube([body_radius, body_radius, body_radius]);

module body_segment(shell_thickness, shell_shrink){
	intersection(){
		body(shell_thickness, shell_shrink);
		cube([body_radius, body_radius, body_radius]);
	}
}

module section_cube(){
	cube(
		[
			section_length,
			section_length,
			section_length
		],
		center = true);
}

module slice_1(vert_off){
	translate([140, 140, 35 + vert_off])
		section_cube();
}

module slice_2(vert_off){
	translate([150, 40, 35 + vert_off + section_length])
		section_cube();
}

module slice_3(vert_off){
	translate([40, 180, 35 + vert_off + section_length])
		section_cube();
}

module slice_4(vert_off){
	translate([180, 180, 35 + vert_off + section_length])
		section_cube();
	
}

module slice_5(vert_off){
	translate([140, 0, 35 + vert_off])
		section_cube();
}

module slice_6(vert_off){
	translate([0, 140, 35 + vert_off])
		section_cube();
}
module slice_7(vert_off){
	translate([70, 70, 35 + vert_off])
		section_cube();
}

module slice_8(vert_off){
	translate([35*3/2, 100, 35 + vert_off])
		cube([section_length-35,section_length,section_length], center = true);
}

module slice_9(vert_off){
	translate([100, 35*3/2, 35 + vert_off])
		cube([section_length, section_length-35,section_length], center = true);
}

module inner_segment(){
		body_segment(body_shell_thickness / 2, body_shell_thickness / 2);
}

module outer_segment(){
		body_segment(body_shell_thickness / 2, 0);
}

module outer_internal_sphere(){
	difference(){

		sphere(
			r = internal_radius,
			$fa = fa(internal_radius));

		union(){
			translate([0,0,-internal_radius])
				cube(
					[
						internal_radius * 2,
						internal_radius * 2,
						internal_radius * 2
					],
					center=true);

			sphere(
				r = internal_radius - body_shell_thickness / 2,
				$fa = fa(internal_radius - body_shell_thickness / 2));
		}
	}
}

module inner_internal_sphere(expand){
	difference(){
		sphere(
			r = internal_radius - body_shell_thickness / 2 + expand,
			$fa = fa(internal_radius - body_shell_thickness / 2 + expand));
		union(){
			translate([0,0,-internal_radius])
				cube([internal_radius*2,internal_radius*2,internal_radius*2], center=true);
			sphere(
				r = internal_radius - body_shell_thickness - expand,
				$fa = fa(internal_radius - body_shell_thickness - expand));
		}
	}
}

module internal_sphere_space(){
	sphere(
		r = internal_radius - body_shell_thickness / 2,
		$fa = fa(internal_radius - body_shell_thickness / 2));
}

module slice_1_connector(){
	test =  body_radius-6;
	difference(){
		linear_extrude(
			height = 5,
			center = false,
			convexity = 2,
			twist = 0
		){
			polygon(
				points = [
					[0,0],
					[test*cos(38.75),test*sin(38.75)],
					[test*cos(51.25),test*sin(51.25)]
				]);
		}
		internal_sphere_space();
	}
}

module shell_slice_1(){
	intersection(){
		union(){
			outer_internal_sphere();
			slice_1_connector();
			inner_segment();
		}
		slice_1(25);
	}
}
module shell_slice_2(){
	intersection(){
		outer_segment();
		slice_1(-45);
	}
}
module Body_P8(){ // make me
	render(){
		intersection(){
			inner_segment();
			//slice_2(25);
			translate([150, 40+30, 35 + 25 + section_length])
				cube([section_length,section_length-60,section_length], center = true);
		}
	}
}

module shell_slice_4(){
	intersection(){
		union(){
			outer_segment();
			//rotate([0,0,-90])
			//	outer_segment();
		}
		slice_2(-45);
	}
}
module Body_P10(){ // make me
	render(){
		intersection(){
			union(){
				inner_segment();
				intersection(){
					difference(){
						rotate([-45,0,0])
							translate([0,0,250-10])
								rotate([0,45,0])
									cube([20,55,20], center = true);

						union(){
							test =  body_radius-7;
							rotate([90,0,90]){
								linear_extrude(
									height = 10,
									center = true,//false,
									convexity = 2,
									twist = 0
								){
									polygon(
										points = [
											[0,0],
											[test*cos(38.75),test*sin(38.75)],
											[test*cos(51.25),test*sin(51.25)]
										]
									);
								}
								body_circles();
							}
						}
					}
					sphere(
				 r = body_radius - 10/2,
				$fn=radial_resolution);
				}
				rotate([0,0,90])
					inner_segment();
			}
			slice_3(25);
		}
	}
}
module shell_slice_6(){
	intersection(){
		outer_segment();
		slice_3(-45);
	}
}
module shell_slice_7(){
	intersection(){
		inner_segment();
		slice_4(25);
	}
}
module shell_slice_8(){
	intersection(){
		outer_segment();
		slice_4(-45);
	}
}

module inner_shell_slice_1(){
	intersection(){
		union(){
			difference(){
				union(){
					rotate([-45.5,0,-90])
						translate([0,0,250*0.6+18])
							rotate([0,45,0])
								cube([20,35,20], center = true);
					rotate([-51.3,0,-90])
						translate([0,0,250*0.6+13.5])
							rotate([45,0,0])
								cube([10,20,20], center = true);
					intersection(){
						rotate([-45.5,0,-90])
							translate([0,0,250*0.6+18])
								rotate([0,45,0])
									cube([20,55,20], center = true);
						rotate([-51.3,0,-90])
							translate([0,0,250*0.6+13.5])
								rotate([45,0,0])
									cube([30,20,20], center = true);
					}
				}
				union(){
					rotate([0,0,-90]) Body_P12();
					sphere(
						r = internal_radius-10/2,
						$fa = fa(internal_radius-10/2));
				}
			}
			outer_internal_sphere();
		}
		slice_5(25);
	}
}

module Body_P2(){ // make me
	render(){
		intersection(){
			inner_internal_sphere(0);
			slice_7(95);
		}
	}
}

module angle_slice(dir){
translate([175, 175, 35]){
	difference(){
	cube([section_length,section_length,section_length], center = true);
	rotate([0,0,45]){
		side_len = sqrt(pow(section_length, 2) * 2 + 1);
		translate([0,-side_len/2*dir,0])
			cube([side_len, side_len, side_len], center = true);
	}}
}
}

module Body_P3(){ // make me
	render(){
		difference(){
			intersection(){
				inner_internal_sphere(0);
				union(){
				slice_8(-15);angle_slice(1);}
			}
			intersection(){
				inner_internal_sphere(5);
				translate([65, 70, 35 + 95])
					cube([section_length,section_length,section_length], center = true);
			}
		}
	}
}
module Body_P4(){ // make me
	render(){
		difference(){
			intersection(){
				inner_internal_sphere(0);
				union(){slice_9(-15);angle_slice(-1);}
			}
			intersection(){
				inner_internal_sphere(5);
				translate([70, 65, 35 + 95])
					cube([section_length,section_length,section_length], center = true);
			}
		}
	}
}

module Body_P5(){ // make me
	render(){
		difference(){
			intersection(){
				outer_internal_sphere();
				off = (sqrt(pow(section_length, 2)*2) - section_length) / 2;
				translate([0, 70 + off, 35 + 165])
					rotate([0,0,45])
						cube([section_length,section_length,section_length], center = true);
			}
			translate([0, 0, 160])
				cylinder(
					h = 30,
					r = 60,
					$fn = 8,
					center = true);
		}
	}
}

module Body_P13(){
	render(){
		intersection(){
			outer_internal_sphere();
			translate([0, 0, 160])
				cylinder(
					h = 30,
					r = 60,
					$fn = 8,
					center = true);
		}
	}
}

module Body_P12(){
	render(){
		test =  body_radius-6;
		difference(){
			union(){
				intersection(){
					difference(){
						rotate([90,0,90]){
							linear_extrude(
								height = 10,
								center = true,//false,
								convexity = 2,
								twist = 0
							){
								polygon(
									points = [
										[0,0],
										[test*cos(38.75),test*sin(38.75)],
										[test*cos(51.25),test*sin(51.25)]
									]
								);
							}
						}
						sphere(r = internal_radius, $fn=radial_resolution);
					}
					sphere(
						r = body_radius - body_shell_thickness,
						$fa = fa(body_radius - body_shell_thickness));
				}
				translate([0, 176, 142.5])
					rotate([0,90,0])
						cylinder(
							r = 10 / 2,
							h = 10,
							$fa = fa(10 / 2),
							center = true);

			}
			union(){
				translate([0, 176, 142.5])
					rotate([0,90,0]){
						cylinder(
									r = 5 / 2,
									h = 20,
									$fa = fa(5 / 2),
									center = true);

						translate([0, 0, - 5 + 2.5 / 2 - 0.1])
							cylinder(
										r = 8 / 2,
										h = 2.5,
										$fa = fa(8 / 2),
										center = true);

						translate([0, 0, 5 - 2.5 / 2 + 0.025])
							cylinder(
										r = 8 / 2,
										h = 2.5,
										$fa = fa(8 / 2),
										center = true);

						translate([0, 0,  - 5 + 0.6 / 2 - 0.025])
							cylinder(
										r = 9.2 / 2,
										h = 0.6,
										$fa = fa(9.2 / 2),
										center = true);

						translate([0, 0, 5 - 0.6 / 2 + 0.025])
							cylinder(
										r = 9.2 / 2,
										h = 0.6,
										$fa = fa(9.2 / 2),
										center = true);

					}
			}
		}
	}
}

module Body_P6(){ // make me

	test =  body_radius-6;

	module joint_attach(){
		intersection(){
			translate(joint_position){
				h = 7.5;
				translate([-12.5 / 2 - 11, 0, h / 2]){
					cube([12.5, 10, h], center = true);
				}
			}
			linear_extrude(
					height = 30,
					center = false,
					convexity = 2,
					twist = 0
				){
					polygon(
						points = [
							[0,0],
							[test*cos(38.75),test*sin(38.75)],
							[test*cos(51.25),test*sin(51.25)]
						]);
				}
		}
	}

	render(){
		difference(){
			union(){
					shell_slice_1();													// 6
					shell_slice_2();
					intersection(){
						difference(){
							linear_extrude(
								height = 5,
								center = false,
								convexity = 2
								)
								pie_slice(170+15, 20, 70, radial_resolution);
							sphere(
								r = internal_radius,
								$fa = fa(internal_radius));
						}
						slice_1(-45);
					}
			}
			union(){
				rotate([-40,85,00]) magnet_hole();
				rotate([-38,77,00]) magnet_hole();
				rotate([-50,84,00]) magnet_hole();
				rotate([-50,74,00]) magnet_hole();
				lip_holes();
				M5_hole(42, 250 - 20);
				M5_hole(48, 250 - 20);
			}
		}

		joint_attach();
		mirror([-1,1,0]) joint_attach();
	}
}

module Body_P15(){

	Body_P6();
	Body_P16_door_servo_mount();

}

module Body_P16_door_servo_mount(){

	servo_height = 6;

	hole_diameter = 2;
	hole_spacing = 28.32;
	hole_spacing_2 = 27;
	hole_2_wide = 6;
	depth = 20.32;
	wing_thick = 2;
	mh_rad = hole_diameter / 2;
	lift = 18.3;

	module holes(){
		translate(
			[
				hole_spacing / 2,
				0,
				lift - 12 / 2
			])
			cylinder(h = 12, r = mh_rad, $fa = fa(mh_rad), center = true);
		translate(
			[
				hole_spacing_2 / 2,
				hole_2_wide / 2,
				lift - 12 / 2
			])
			cylinder(h = 12, r = mh_rad, $fa = fa(mh_rad), center = true);
		translate(
			[
				hole_spacing_2 / 2,
				- hole_2_wide / 2,
				lift - 12 / 2
			])
			cylinder(h = 12, r = mh_rad, $fa = fa(mh_rad), center = true);
	}

	module servo_mount(){
		translate([139, 135, 0]){
			difference(){
				union(){
					translate([0, - 2, 5 + lift - servo_height / 2])
						cube([4, 16, servo_height], center = true);
					translate([0, 4, 5 + lift / 2])
						cube([4, 4, lift], center = true);
					translate([28.25 - 0.3, - 7 / 2, 5 + lift - servo_height / 2])
						cube([4, 13, servo_height], center = true);
					translate([28.25 - 0.3, 3, 5 + lift / 2])
						cube([4, 4, lift], center = true);
					translate([28.25 - 25 / 2, 3, 5 + 4 / 2])
						cube([29 - 0.6, 4, 4], center = true);
				}
				union(){
					translate([14, -5,8]){
						holes();
						mirror() holes();
					}
				}
			}
		}
	}

	render(){
		servo_mount();
		mirror([1, -1, 0])
			servo_mount();
	}
}

module Body_P7(){ // make me
	render(){
		difference(){
			union(){
					shell_slice_7();													// 12
					shell_slice_8();													// 13
					intersection(){
						outer_segment();													// 13
						upper_binding_slice();
					}
			}
			union(){
				rotate([-35,70,00]) magnet_hole();
				rotate([-50,64,00]) magnet_hole();
				rotate([-30,61.5,00]) magnet_hole();
				rotate([-49,50.5,00]) magnet_hole();
				//rotate([-32.5,65.5,00]) magnet_hole();
				//rotate([-49.5,57,00]) magnet_hole();
			}
		}
	}
}

module Body_P9(){ // make me
	render(){
		difference(){
			shell_slice_4();
			union(){
				rotate([-24,56,00]) magnet_hole();
				rotate([-17,52,00]) magnet_hole();
				rotate([-10,50,00]) magnet_hole();
				rotate([-10,50,00]) magnet_hole();
				rotate([-4,49,00]) magnet_hole();
				rotate([-4,41,00]) magnet_hole();
				rotate([-11,40,00]) magnet_hole();
				rotate([-18,38,00]) magnet_hole();
				rotate([-24,35,00]) magnet_hole();
				upper_binding_slice();
			}
		}
	}
}

module upper_binding_slice(){
translate([120, 120, 190])
	rotate([0, 0, 45])
		cube([50, 50, 50], center = true);
}

module Body_P11(){ // make me
	render(){
		difference(){
			shell_slice_6();
			union(){
				rotate([-49,39,00]) magnet_hole();
				rotate([-49,28,00]) magnet_hole();
				rotate([-49,17,00]) magnet_hole();
				rotate([-49,6,00]) magnet_hole();
				rotate([-41,5,00]) magnet_hole();
				rotate([-39.5,13.5,00]) magnet_hole();
				rotate([-36.5,21,00]) magnet_hole();
				rotate([-31.5,28,00]) magnet_hole();
				upper_binding_slice();
			}
		}
	}
}

module magnet_hole(){
/*
	translate([0,0,250-1.5])
		cylinder(
			h=3,
			r = 6.35 / 2,
			$fa = fa(6.35 / 2));*/

}

module Body_P1(){ // make me
	render(){
		union(){
			rotate([0,0,90]) inner_shell_slice_1();
			intersection(){
				difference(){
					linear_extrude(
						height = 5,
						center = false,
						convexity = 2
						)
						pie_slice(170+15, 65.6, 114.4, radial_resolution);
					union(){
						sphere(
							r = internal_radius,
							$fn = radial_resolution);
						lip_holes();
						translate([0,185,0])
							scale([0.6,1,1])
								cylinder(
									h = 20,
									r = 15,
									$fa = fa(15),
									center = true);
					}
				}
				rotate([0,0,90]) slice_5(25);
			}
		}
	}
}

module M5_hole(angle, radius){
	rotate([0,0,angle])
		translate([radius, 0, 2.5])
			cylinder(
				h = 50,
				r = 2.5,
				$fa = fa(2.5),
				center = true);
}

module lip_holes(){
	M5_hole(30, 170+7.5);
	M5_hole(40, 170+7.5);
	M5_hole(50, 170+7.5);
	M5_hole(60, 170+7.5);
	M5_hole(70, 170+7.5);
	M5_hole(80, 170+7.5);
	M5_hole(90, 170+7.5);
	M5_hole(100, 170+7.5);
	M5_hole(110, 170+7.5);
}

// Lumenier 10Ah 6s 25c Lipo Battery
module battery_pack(){
	cube([172, 70, 48], center = true);
}

module hole_cover(){

	intersection(){
		difference(){
				sphere(
					r = body_radius,
					$fa = fa(body_circle_radius));
				sphere(
					r = body_radius - body_shell_thickness / 2,
					$fa = fa(body_radius - body_shell_thickness / 2));
			}
			rotate([0,90,0])
			cylinder(
				h = body_radius * 2,
				r = body_circle_radius,
				$fa = fa(body_circle_radius));
	}
}

module rounded_hole_cover(){
	rotate([0, 90, 0]){
		rotate_extrude(
			convexity = 3,
			$fa = fa(250)){
			difference(){
				intersection(){
					difference(){
						circle(
							r = 250,
							$fa = fa(250));
						circle(
							r = 250 - 5,
							$fa = fa(250 - 5));
					}
					translate([150/2, 250])
						square(size = [150, 150], center = true);
				}
					translate([147.5, 198]){
					difference(){
						translate([5 / 2, -5 / 2])
							square(size = 5, center = true);
						circle(
							r = 5 / 2,
							$fa = fa(5 / 2));
					}
				}
			}
		}
	}
}

module cover(angle, joint_position, shift, inner){

	module hinge_connector(h){
		r2 = 7.5 / 2;
		cylinder(
			h = h,
			r = r2,
			$fa = fa(r2),
			center = true);
		translate([8 / 2, 0, 0])
			cube([8, 7.5, h], center = true);
	}

	module cover_body(){
		difference(){
			union(){
				translate(joint_position){
					translate([-5, 0, 0]){
						hinge_connector(14);
						translate([0, 0,  15.5]) hinge_connector(5);
						translate([0, 0, -15.5]) hinge_connector(5);
					}
				}
				difference(){
					intersection(){
						rounded_hole_cover();
						translate([150,150, 0])
							cube([300,300,300], center = true);
					}
					translate([-5, 0, 0]){
						translate(joint_position){
							rotate([0, 0, -70]){
								translate([-6 / 2, 0, 10])
									cube([6, 7.5, 5 + 0.5 * 2], center = true);
								translate([-6 / 2, 0, -10])
									cube([6, 7.5, 5 + 0.5 * 2], center = true);
							}
						}
					}
				}
			}
			translate([-5, 0, 0]){
				translate(joint_position){
					r = 2.5 / 2;
					cylinder(
						h = 40,
						r = r,
						$fa = fa(r),
						center = true);
				}
			}
		}
	}

	if(inner){
		intersection(){
			cover_body();
			sphere(
				r = body_radius - 2.5,
				$fa = fa(body_circle_radius));
		}
	} else {
		difference(){
			cover_body();
			sphere(
				r = body_radius - 2.5,
				$fa = fa(body_circle_radius));
		}
	}
}

module door_hinge_pin(){
	r = 2.5 / 2;
	cylinder(
		h = 40,
		r = r,
		$fa = fa(r),
		center = true);
}

module Door_P6_servo_lever(){

	render(){

		outer_rad = body_radius - 5;
		inner_rad = 4 / 2;
		hole_rad = 1.5 / 2;

		intersection(){
			translate(door_servo_lever_position){
				difference(){
					hull(){
						translate([-5, 0, 0])
							cylinder(
								h = 5,
								r = inner_rad,
								$fa = fa(inner_rad),
								center = true);
						translate([11, 0, 0])
							cube([0.1, 5, 5], center = true);
					}
					translate([-5, 0, 0])
						cylinder(
							h = 6,
							r = hole_rad,
							$fa = fa(hole_rad),
							center = true);
				}
			}
			sphere(
				r = outer_rad,
				$fa = fa(outer_rad));
		}
	}
}

module slide_bars(){

	r2 = 2.5 / 2;
	translate([-25 / 2 - 6, 1.75, 0])
		rotate([0, 90, 0])
			cylinder(
				h = 25 + 4,
				r = r2,
				$fa = fa(r2),
				center = true);
	translate([-25 / 2 - 6, -1.75, 0])
		rotate([0, 90, 0])
			cylinder(
				h = 25 + 4,
				r = r2,
				$fa = fa(r2),
				center = true);
}

module Door_P9_cover_slide_hinge(){
	color("Aqua") render(){
		difference(){
			union(){
				r = 7.5 / 2;
				cylinder(
					h = 5,
					r = r,
					$fa = fa(r),
					center = true);
				translate([-6 / 2, 0, 0])
					cube([6, 7.5, 5], center = true);
			}
			union(){
				slide_bars();
				door_hinge_pin();
			}
		}
	}
}

module Door_P10_cover_slide_brace(){
	color("Lime") render(){
		difference(){
			translate([-3 / 2 - 25 - 6, 0, 0])
				cube([3, 7.5, 5], center = true);
			slide_bars();
		}
	}
}

module cslide(){

	difference(){
		union(){
			r = 7.5 / 2;
			cylinder(
				h = 5,
			r = r,
				$fa = fa(r),
				center = true);
			translate([-6 / 2, 0, 0])
				cube([6, 7.5, 5], center = true);

			translate([-3 / 2 - 25 - 6 - 1.75, 0, 2.75])
				cube([6, 8, 10.5], center = true);

			translate([-4, -8 + 8 / 2, 0])
				cube([4, 12 - 8, 4], center = true);
			translate([-20 + 4, -6 + 5.5, 6])
				cube([4 + 2, 18 - 11, 4], center = true);
			//translate([-20, -13, 6 - 10])
			//	cube([4, 4, 20], center = true);
			translate([-4 - 8/2, -13 + 5, 6 - 10])
				cube([4+8, 4, 12+12], center = true);
			translate([-12 + 2, -13 + 10, 0 + 6])
				cube([20 - 12, 4 + 8, 4], center = true);
			translate([-26, 0, 6])
				cube([16, 8, 4], center = true);
		}

		union(){

			r2 = 2.5 / 2;
			translate([-25 / 2 - 6 - 2.5, 1.75, 0])
				rotate([0, 90, 0])
					cylinder(
						h = 25 + 4 + 4,
						r = r2,
						$fa = fa(r2),
						center = true);
			translate([-25 / 2 - 6 - 2.5, -1.75, 0])
				rotate([0, 90, 0])
					cylinder(
						h = 25 + 4 + 4,
						r = r2,
						$fa = fa(r2),
						center = true);

			door_hinge_pin();

			translate([-3 / 2 - 25 - 6 - 1.75 + 0.5, 0, 2.75])
				cube([2, 6, 12], center = true);

		}
	}

}

module Door_P11_cover_slide(){
	color("Cyan"){
		//render(){
			translate([0,0,-10]){
				translate([0,0,10]){
					cslide();
				}
				mirror([0, 0, 1]) translate([0,0,10]){
					cslide();
				}
			}
		//}
	}
}

module Body_P14_slide_body(){

	color("White") render() {
		translate(joint_position){
			difference(){
				translate([-12.5 / 2 - 11, 0, 0]){
					cube([12.5, 10, 5], center = true);
				}
				slide_bars();
			}
		}
	}
}

module cover_slide(){

	//color("Silver") slide_bars();

	Door_P11_cover_slide();

}

module cover_slides(shift, joint_position){
	translate([shift, 0, 0]){
		translate(joint_position){
			r = 7.5 / 2;
			translate([0,0, 10]) cover_slide(shift, joint_position);
			//translate([0,0,-10]) cover_slide(shift, joint_position);
		}
	}
}

module shaft_cutout(){
	translate([200, 0, 144.5 + 12.5 / 2]){
		cube([20, 12.5, 10], center = true);
		translate([0, 0, -5.2]){
			rotate([0, 90, 0]){
				r = 12.5 / 2;
				cylinder(
					h = 20,
					r = r,
					$fa = fa(r),
					center = true);
			}
		}
	}
}

module Door_P1(){
	render(){
		union(){
			intersection(){
				cover(cover_angle, joint_position, shift, true);
				translate([220,90,0])
					cube([140, 140 - 0.1, 140], center = true);
			}
			difference(){
				intersection(){
					cover(cover_angle, joint_position, shift, false);
					translate([220, 90, 0])
						cube([140, 140, 140], center = true);
				}
				union(){
					translate([220,90 - 25,  90])
						cube([140, 140, 140], center = true);
					translate([220,90 - 25, -90])
						cube([140, 140, 140], center = true);
				}
			}
			Door_P6_servo_lever();
		}
	}
}

module Door_P2(){
	render(){
		difference(){
			union(){
				difference(){
					intersection(){
						cover(cover_angle, joint_position, shift, false);
						translate([220,90 - 25, 90])
							cube([140, 140, 140], center = true);
					}
					translate([220,90 - 140,0])
						cube([140, 140, 140], center = true);
				}
				difference(){
					intersection(){
						cover(cover_angle, joint_position, shift, true);
						translate([220,90 - 25, 90])
							cube([140, 140, 140], center = true);
					}
					translate([220,90,0])
						cube([140, 140 - 0.1, 140], center = true);
				}
			}
			//shaft_cutout();
		}
	}
}

module Door_P3(){
	render(){
		union(){
			difference(){
				intersection(){
					cover(cover_angle, joint_position, shift, false);
					translate([220,90 - 25, -90])
						cube([140, 140, 140], center = true);
				}
				translate([220,90 - 140,0])
				cube([140, 140, 140], center = true);
			}
			difference(){
				intersection(){
					cover(cover_angle, joint_position, shift, true);
					translate([220,90 - 25, -90])
						cube([140, 140, 140], center = true);
				}
				translate([220,90,0])
					cube([140, 140 - 0.1, 140], center = true);
			}
		}
	}
}

module Door_P4(){
	render(){
		union(){
			intersection(){
				cover(cover_angle, joint_position, shift, false);
				translate([220,90 - 140,0])
					cube([140, 140, 140], center = true);
			}
			intersection(){
				cover(cover_angle, joint_position, shift, true);
				translate([220,90 - 140,0])
					cube([140, 140, 40], center = true);
			}
		}
	}
}

module Door_P5(){
	render(){
		intersection(){
			rounded_hole_cover();
			shaft_cutout();
		}
	}
}

module cover_assembly(){

	translate([shift, 0, 0]){
		rotate_about(joint_position, [0, 0, cover_angle]){
		translate([193 + 5,6.25,148]){
			rotate([0, -38, 0])
			cylinder(
				h = 1,
				r = 3 / 2,
				$fa = fa(2.5),
				center = true);
		}
		}
	}

	translate([shift, 0, 0]){
		rotate_about(joint_position, [0, 0, cover_angle]){
			translate([5, 0, 0]){
				color("Red")					Door_P1();
				color("Green")				Door_P2();
				color("Blue")					Door_P3();
				color("Magenta")			Door_P4();

				rotate_about_axis(
					[193,6.25,148],
					-180*rot_amt,
					[sin(-38), 0, cos(-38)]){
					color("DeepSkyBlue")	Door_P5();
				}
			}
		}
	}

	mirror([0, 1, 0]){
		translate([shift, 0, 0]){
			rotate_about(joint_position, [0, 0, cover_angle]){
				translate([5, 0, 0]){
					color("SpringGreen")	Door_P1();
					color("Crimson")			Door_P2();
					color("DarkGreen")		Door_P3();
					color("Navy")					Door_P4();
				}
			}
		}
	}

	translate([0,0, 10]) Body_P14_slide_body();
	translate([0,0,-10]) Body_P14_slide_body();
	mirror([0,1,0]){
		translate([0,0, 10]) Body_P14_slide_body();
		translate([0,0,-10]) Body_P14_slide_body();
	}

	cover_slides(shift, joint_position);
	mirror([0,1,0]) cover_slides(shift, joint_position);

	color("Silver")
		translate([shift, 0, 0]) 
			translate(joint_position)
				door_hinge_pin();

}

module flight_motor_hinge_pin(){
		rotate([90, 0, 0])
			cylinder(
				r = 5 / 2,
				h = 30,
				$fa = fa(5 / 2),
				center = true);
}

module hinge_pull_relief(){
	center_width = 2.5;
	rotate_extrude(convexity = 3, $fa = fa(5)){
		difference(){
			translate([center_width / 2, - 5 / 8])
				square(size = [center_width, 5 / 4], center = true);
			translate([center_width, 0])
				circle(
					r = 2.5 / 2,
					$fa = fa(2.5));
		}
	}
}

module end_piece(){
	difference(){
		union(){
			translate([0, -8, 0])
				rotate([0,-40,0])
					translate([0, 0, 40 / 2])
						cube([15, 5, 40], center = true);
			translate([0, -8, 0])
				rotate([90,-40,0])
					translate([0, 40,0])
						cylinder(
							r = 15 / 2,
							h = 5,
							$fa = fa(15 / 2),
							center = true);
		}
		union(){
			translate([0,-5,5])
				rotate([0,-44,0])
					rotate([0,0,45])
						translate([5, -2, 15])
							cube([10,20,80], center = true);
			translate([0, -8, 0])
				rotate([90,-40,0])
					translate([0, 44,0])
						cylinder(
							r = 2 / 2,
							h = 10,
							$fa = fa(2 / 2),
							center = true);
		}
	}
}

module flybar_hinge_side(){
	difference(){
		union(){
			translate([0, -8, 0])
				rotate([-90,0,0])
					cylinder(
						r = 15 / 2,
						h = 5,
						$fa = fa(15 / 2),
						center = true);
			translate([-7.5, -10.5, 0])
				rotate([-90,0,0])
					trapezoid(15, 10, 25, 5);
				end_piece();
			}
			union(){
				translate([0, -8, 0])
					rotate([90,-40,0])
						translate([0, 40,0])
							rotate([0,90,0]){
								cylinder(
									r = 2.5 / 2,
									h = 20,
									$fa = fa(5),
									center = true);
								translate([0,0,-6.26])
								hinge_pull_relief();
							}
				}
		}
}

module Prop_P1_hinge(){
	color("Blue"){
		//render(){
			translate(prop_joint_position){
				difference(){
					union(){
						translate([-0.5, 0, -25])
							cylinder(
								r = 15 / 2,
								h = 20,
								$fa = fa(15 / 2),
								center = true);
						flybar_hinge_side();
						mirror([0,1,0])
							flybar_hinge_side();
					}
					union(){
						translate([-0.5, 0, -25 - 5])
							cylinder(
								r = 10 / 2,
								h = 20,
								$fa = fa(15 / 2),
								center = true);
						translate([-0.5, 0, -25 - 5])
							rotate([90, 0, 0])
								cylinder(
									r = 5 / 2,
									h = 30,
									$fa = fa(5 / 2),
									center = true);
						flight_motor_hinge_pin();
					}
				}
			}
		//}
	}
}

module Body_P14_motor_lift_servo_mount(){
	color("Cyan")
	render(){
		difference(){
			union(){
				translate([140, -30, 110]){
					rotate([0, -35, 0]){
						difference(){
							union(){
								translate([-9, -3.6, -25]){
									cube([14, 5, 50], center = true);
								}
								translate([-1, -3.6, 3]){
									cube([40, 5, 8], center = true);
								}
								translate([-1, -3.6, -47]){
									cube([40, 5, 8], center = true);
								}
								translate([4.6,-7,3.3])
									rotate([90,0,0])
									cylinder(
										r = 3,
										h = 4,
										$fa = fa(3),
										center = true);
								translate([4.6 + 9.2,-7,3.3])
									rotate([90,0,0])
									cylinder(
										r = 3,
										h = 4,
										$fa = fa(3),
										center = true);
								translate([4.6, -7,3.3 - 50])
									rotate([90,0,0])
									cylinder(
										r = 3,
										h = 4,
										$fa = fa(3),
										center = true);
								translate([4.6 + 9.2, -7,3.3 - 50])
									rotate([90,0,0])
									cylinder(
										r = 3,
										h = 4,
										$fa = fa(3),
										center = true);
							}
							union(){
								translate([4.6,0,3.3])
									rotate([90,0,0])
									cylinder(
										r = 2.2 / 2,
										h = 20,
										$fa = fa(2.2 / 2),
										center = true);
								translate([4.6 + 9.2,0,3.3])
									rotate([90,0,0])
									cylinder(
										r = 2.2 / 2,
										h = 20,
										$fa = fa(2.2 / 2),
										center = true);
								translate([4.6,0,3.3 - 50])
									rotate([90,0,0])
									cylinder(
										r = 2.2 / 2,
										h = 20,
										$fa = fa(2.2 / 2),
										center = true);
								translate([4.6 + 9.2,0,3.3 - 50])
									rotate([90,0,0])
									cylinder(
										r = 2.2 / 2,
										h = 20,
										$fa = fa(2.2 / 2),
										center = true);
							}
						}
					}
				}
				intersection(){
					translate([140, -30, 110]){
						rotate([0, -35, 0]){
							translate([-16, -3.6 - 10, -22]){
								cube([20, 20, 58], center = true);
							}
						}
					}
					sphere(r = internal_radius + 5, $fa = fa(internal_radius + 5));
				}
			}
			union(){
				sphere(r = internal_radius, $fa = fa(internal_radius));
			}
		}
	}
}

module Body_P15_motor_lift_drum(){
	top_thick = 2;
	center_thick = 5;
	bottom_thick = 2;
	render(){
		color("Salmon"){
			difference(){
				union(){
					translate([0, 0, top_thick / 2])
						cylinder(
							h = top_thick,
							r = 22 / 2,
							$fa = fa(22 / 2),
							center = true);
					translate([0, 0, top_thick + center_thick / 2])
						cylinder(
							h = center_thick,
							r = 10 / 2,
							$fa = fa(10 / 2),
							center = true);
					translate([0, 0, top_thick + center_thick + bottom_thick / 2])
						cylinder(
							h = bottom_thick,
							r = 22 / 2,
							$fa = fa(22 / 2),
							center = true);
				}
				union(){
					for(i = [0:90:270])
						rotate([0, 0, i])
							translate([0, 7.5, 0])
								cylinder(
									h = 5,
									r = 1.6 / 2,
									$fa = fa(1.6 / 2),
									center = true);				
					translate([0, 0, top_thick + center_thick / 2])
						rotate([90,0, 0])
							cylinder(
								h = 30,
								r = 2 / 2,
								$fa = fa(2 / 2),
								center = true);
					translate([0, 7.5, top_thick + center_thick + bottom_thick / 2])
						cylinder(
							h = 5,
							r = 2 / 2,
							$fa = fa(2 / 2),
							center = true);
					cylinder(
						h = 30,
						r = 3 / 2,
						$fa = fa(3/2),
						center = true);
				}
			}
		}
	}
}

module propulsion_system(){

	//flight_motor_hinge_pin();

	Body_P14_motor_lift_servo_mount();

	translate(prop_joint_position){
		translate([-16, -38, -45])
			rotate([-90,-125,0]){
				TGY_4805_2PA_translate()
					translate([0, 0, 5 / 2])
						Body_P15_motor_lift_drum();
				color("Crimson") TGY_4805_2PA();
			}
	}

	prop_spacing = 34.15;
	blade_length = 190.4;

	rotate_about(prop_joint_position, [0, arm_angle, 0]){

		Prop_P1_hinge();
		Prop_P2_motor_mount();

		color("Black"){
			translate([175.5,0,32.5 - 8]){
				cylinder(
					h = 200,
					r = 10 / 2,
					$fn = radial_resolution,
					center = true);
			}
		}

		translate([184.5, 0,-110]){
			rotate([0,-90,180]){
				color("DimGray") MN5212();
				color("Black"){
					rotate([0,0,prop_angle]){
						translate([blade_length / 2, - prop_spacing / 2,16.5])
							translate([-blade_length / 2,0,0])
							rotate([0,0,blade_1_angle])
							translate([blade_length / 2,10,0])
							cube([blade_length, 40, 2.5], center = true);
						translate([blade_length / 2, prop_spacing / 2,16.5])
							translate([-blade_length / 2,0,0])
							rotate([0,0,blade_2_angle])
							translate([blade_length / 2,10,0])
							cube([blade_length, 40, 2.5], center = true);
					}
				}
			}
		}
	}

}

module Door_P7_middle_door_brace(){
	render(){
		intersection(){
			difference(){
				union(){
					intersection(){
						translate([170, -60, 0])
							cube([30, 15, 20], center = true);
						sphere(
							r = internal_radius + 22,
							$fa = fa(internal_radius + 22));
					}
					translate([205, -56.25, 0])
						cube([85, 7.5, 15], center = true);
				}
				union(){
					sphere(
						r = internal_radius,
						$fa = fa(internal_radius));
					cylinder(
						r = internal_radius + 15,
						h = 10,
						$fa = fa(internal_radius + 15),
						center = true);
						M5_hole(-20, 170+7.5);
				}
			}
			// Leave Space for Ninjaflex bumper
			sphere(
				r = body_radius - 5 - 2.5,
				$fa = fa(body_radius - 5 - 2.5));
		}
	}

}
module Door_P8_middle_door_bumper(){
	render(){
		intersection(){
			difference(){
				translate([237, -56.25, 0])
					cube([5, 7.5, 15], center = true);
				sphere(
					r = body_radius - 5 - 2.5,
					$fa = fa(body_radius - 5 - 2.5));
			}
			sphere(
				r = body_radius - 5,
				$fa = fa(body_radius - 5));
		}
	}
}

module Door_P11_door_edge_brace(angle){

	rotate([angle, 0, 0]){
		color("Orange"){
			render(){
				intersection(){
					union(){
						intersection(){
							translate([185, 0, 150])
								rotate([0, -40, 0])
									union(){
										translate([0, 0, -5])
											cube([10, 10, 20], center = true);
										translate([0, 0, 5])
											rotate([90, 0, 0])
												cylinder(
													h = 10,
													r = 10 / 2,
													$fa = fa(10 / 2),
													center = true);
									}
							sphere(
								r = body_radius - 10,
								$fa = fa(body_radius - 10));
						}
						intersection(){
							translate([185, 0, 150])
								rotate([0, -40 - 90, 0]){
									translate([-15, 0, -2.5])
										cylinder(
											h = 15,
											r = 10 / 2,
											$fa = fa(10 / 2),
											center = true);
										translate([-5, 0, 0])
											cube([20, 10, 10], center = true);
								}
							rotate([0,90,0])
								cylinder(
									h = body_radius * 2,
									r = body_circle_radius,
									$fa = fa(body_circle_radius),
									center = true);
							}
					}
					sphere(
						r = body_radius - 7.5,
						$fa = fa(body_radius - 7.5));
				}
			}
		}
	}
}

module Door_P12_door_edge_bumper(angle){

	rotate([angle, 0, 0]){
		color("Chocolate"){
			render(){
				difference(){
					intersection(){
						translate([185, 0, 150])
							rotate([0, -40 - 90, 0])
								translate([-15, 0, -5])
									cylinder(
										h = 15,
										r = 10 / 2,
										$fa = fa(10 / 2),
										center = true);
						sphere(
							r = body_radius - 5,
							$fa = fa(body_radius - 5));
					}
					sphere(
						r = body_radius - 7.5,
						$fa = fa(body_radius - 7.5));
				}
			}
		}
	}
}

module Prop_P2_motor_mount(){
	color("SpringGreen"){
		render(){
			translate([163.75, 0, -110]){
				difference(){
					union(){
						translate([- 5 / 2, - 44 / 2, 20 - 44 / 2])
							rotate([90, 0, 90])
								trapezoid(44, 20, 39.5, 5);
						hull(){
							translate([2.5, - 20 / 2, 40 - 5 / 2])
								rotate([180, 0, 90])
									trapezoid(20, 15, 11.75 - 2.5, 0.01);
							translate([2.5, - 26 / 2, 40 - 5 / 2 - 10])
								rotate([180, 0, 90])
									trapezoid(26, 15, 11.75 - 2.5, 0.01);
						}

						translate([11.75, 0, 40])
							cylinder(
								h = 15,
								r = 15 / 2,
								$fa = fa(15 / 2),
								center = true);
						rotate([0, 90, 0])
							cylinder(
								h = 5,
								r = 44 / 2,
								$fa = fa(44 / 2),
								center = true);
					}
					union(){
						for(i = [0:90:270])
							rotate([i, 0, 0])
								translate([0, 25 / 2, 0])
									rotate([0,90,0])
									cylinder(
										h = 10,
										r = 3 / 2,
										$fa = fa(3 / 2),
										center = true);
						for(i = [0:90:270])
							rotate([i, 0, 0])
								translate([-1.75 - 0.025, 25 / 2, 0])
									rotate([0,90,0])
									cylinder(
										h = 1.5,
										r1 = 6 / 2,
										r2 = 3 / 2,
										$fa = fa(3 / 2),
										center = true);
						rotate([0,90,0])
							cylinder(
								h = 10,
								r = 15 / 2,
								$fa = fa(15 / 2),
								center = true);
						translate([11.75, 0, 40 - 12.5])
							scale([1.85, 1, 1])
							rotate([90, 0, 0])
								cylinder(
									h = 30,
									r = 10 / 2,
									$fa = fa(20 / 2),
									center = true);
						translate([11.75, 0, 42.5])
							cylinder(
								h = 10.1,
								r = 10 / 2,
								$fa = fa(10 / 2),
								center = true);
						translate([11.75, 0, 42.5])
							rotate([90, 0, 0])
								cylinder(
									h = 20,
									r = 5 / 2,
									$fa = fa(10 / 2),
									center = true);
					}
				}
			}
		}
	}
}

module door_servo(){
	translate([153,130,32.5])
		rotate([180,0,180]){
			render()
				HS_5065MG();
			render()
				HS_5065MG_shaft_translate() HS_5065MG_arm();
		}
}

module head(){
	difference(){
		translate([0, 0, 300]){
			sphere(
				r = 300 / 2,
				$fa = fa(300 / 2));
			translate([110,0,150 - 37.5 * 2]){
				sphere(
					r = 37.5,
					$fa = fa(37.5));
			}
		}
		translate([0,0, - 200 / 2 + 300]){
			cube([400, 400, 200], center = true);
		}
	}

	translate([0, 0, 300 - 25 / 2])
		cylinder(
			h = 25,
			r = 300 / 2,
			$fa = fa(300 / 2),
			center = true);
	translate([0, 0, 300 - 25 - 25 / 2])
		cylinder(
			h = 25,
			r1 = 250 / 2,
			r2 = 300 / 2,
			$fa = fa(300 / 2),
			center = true);
}

