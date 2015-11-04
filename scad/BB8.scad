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

$fe = 0.1;		// preview
//$fe = 0.025;	// export

use <utils.scad>
use <hardware.scad>
use <servos/parallax_continuous_rotation_servo.scad>
use <servos/LS_0006_servo.scad>
use <servos/HS_5065MG.scad>
use <motors/MN5212.scad>

section_length = 140;

body_radius = 250;
circle_body_ratio = 0.6;
body_circle_radius = body_radius * circle_body_ratio;
body_shell_thickness = 10;

internal_radius = 170;

joint_position = [197, 145, 0];

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
cover_open = false;

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
	($t * as < 10)
		? 1.0
		: ($t * as - 10) * -1 + 1.0;
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
			sphere(r = body_radius - body_shell_thickness, $fn=radial_resolution);
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

module Body_P7(){ // make me
	render(){
		difference(){
			union(){
					shell_slice_7();													// 12
					shell_slice_8();													// 13
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
			}
		}
	}
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
			}
		}
	}
}

module magnet_hole(){

	translate([0,0,250-1.5])
		cylinder(
			h=3,
			r = 6.35 / 2,
			$fa = fa(6.35 / 2));

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

module fan_assembly(){

	// MN5212-KV420
	module prop_motor(){

		blade_rotation = 0;

		color("DimGray") MN5212();

		color("LightGrey") render(){
			translate([0,0, 42.5 / 2 + 8 / 2 - 6])
				cylinder(h = 8, r = 24.5 / 2, center = true);
			translate([0,0, 42.5 / 2 + 21 / 2 - 6 + 8])
				cylinder(h = 21, r = 8 / 2, center = true);
		}

		color("Black") render(){
			rotate([0,0,0 + blade_rotation])
				translate([254/4,0, 42.5 / 2 + 10 / 2 + 2])
					cube([254/2, 20, 10], center = true);
			rotate([0,0,120 + blade_rotation])
				translate([254/4,0, 42.5 / 2 + 10 / 2 + 2])
					cube([254/2, 20, 10], center = true);
			rotate([0,0,240 + blade_rotation])
				translate([254/4,0, 42.5 / 2 + 10 / 2 + 2])
					cube([254/2, 20, 10], center = true);
		}

	}

	// Lumenier 10Ah 6s 25c Lipo Battery
	module battery_pack(){
		cube([172, 70, 48], center = true);
	}

	module motor_mount(){

		rotate([0,0,0]){
			rotate([90, 0, 0])
				difference(){
					linear_extrude(
						height = 24.8 + 8,
						center = true,
						convexity = 2
						)
						pie_slice(243.95, 24, 31.25, radial_resolution);
						//pie_slice(243.95, 4.7, 37.7, radial_resolution);
					linear_extrude(
						height = 24.8 + 8 + 1,
						center = true,
						convexity = 2
						)
						pie_slice(238.95, 4.7, 55, radial_resolution);
				}

		}

	}

	module tbar_servos_latch(){

		translate([143,-65,125])
			rotate([-90,0,0]){
				color("Magenta") render() parallax_continuous_rotation_servo();
				color("Indigo") render() round_servo_attachment();
				color("Purple"){
					render(){
						translate_shaft(){
							translate([0,0,9]){
								cylinder(h=2.5, r=12, center = true);
								translate([0,0,5])
									cylinder(h=7.5, r=10, center = true);
								translate([0,0,10])
									cylinder(h=2.5, r=12, center = true);
							}
						}
					}
				}
			}

		dist = 
			sqrt(
				pow((cos(latch_angle) - 1) * -8, 2)
			+ pow((sin(-latch_angle) + 1) * 12.7, 2)
			) - 3.5;

		translate([153,-55,154])
			rotate([180,0,0]){
				color("Magenta") render() ls_0006_servo();
				translate_ls_0006_attachment()
					rotate([0,0,latch_angle])
						color("Indigo") render() bar_attachment();
			}

		// Motor Mount Latch
		translate([0,dist,0]){
			color("Red"){
				render(){
					union(){
						translate([171, -27, 141])
							rotate([90,0,0])
								cylinder(
									h = 20,
									r = 2.5,
									$fn = radial_resolution / 4,
									center = true);
						translate([171, -17, 141])
							sphere(r = 2.5, $fn = radial_resolution / 4 );
					}
				}
			}
		}

	}

	module slide_bearing_hole(ang){
		translate([118, -17, 138.1])
			rotate([90,0,ang]){
				cylinder(h=17,r= 3/2, $fn = radial_resolution/4, center=true);
				translate([0,0,-2.26])
					cylinder(h = 1.5, r2 = 3/2, r1 = 6/2, $fn = radial_resolution/4, center=true);
			}
	}

	module slide_bearing_holes(first, ang){
		if(first) slide_bearing_hole(ang);
		translate([20,0,0]) slide_bearing_hole(ang);
		translate([42.5,0,0]) slide_bearing_hole(ang);
	}

	module slide_bearing_holder(){
			translate([118, -18, 138.1])
				rotate([90,0,0])
					cylinder(h=8,r= 8/2, $fn = radial_resolution/4, center=true);
	}

	module slide_bearing_holders(first){
			if(first) slide_bearing_holder();
			translate([20,0,0]) slide_bearing_holder();
			translate([42.5,0,0]) slide_bearing_holder();
	}

	module slide_bearing_slot(angle){
		translate([118, -18, 138.6])
			rotate([angle,0,0])
				cube([8, 2 + 0.5 * 2 + 1, 8], center = true);
	}

	module slide_bearing_slots(angle, last){
		if(last)
			slide_bearing_slot(angle);
		translate([20, 0, 0])
			slide_bearing_slot(angle);
		translate([42.5, 0, 0])
			slide_bearing_slot(angle);

	}

	module slide_bearing_nut(){
		translate([118, -22, 138.1]){
			rotate([90,0,0])
				cylinder(h = 1.8,r= 6.35 / 2, $fn = 6, center=true);
			translate([0,0,6.35 / 2])
				cube([6.35, 1.8, 6.35], center = true);
		}
	}

	module slide_bearing_nuts(first){

		if(first) slide_bearing_nut();
		translate([20,0,0]) slide_bearing_nut();
		translate([42.5,0,0]) slide_bearing_nut();

	}

	module side_slide_bearing_nut(){
		translate([158, 7 + 6.35 / 2, 118.6])
			rotate([90,0,0])
				cube([6.35, 1.8, 6.35], center = true);
		translate([158, 7, 118.6])
			rotate([0,0,0])
				cylinder(h = 1.8, r = 6.35 / 2, $fn = 6, center = true);
	}

	module side_slide_bearing_hole(){
		translate([138, 8.5, 123.6]){
			cylinder(h = 10, r = 3 / 2, $fn = radial_resolution / 4, center = true);
			translate([0,0,4.2])
				cylinder(
					h = 1.5,
					r1 = 3/2,
					r2 = 6/2,
					$fn = radial_resolution/4,
					center=true);
			}
	}

	module side_slide_bearing_holder(){
		translate([138, 8.5, 122])
			cylinder(h =10, r = 7 / 2, $fn = radial_resolution / 4, center = true);
	}

	module side_slide_bearing_holders(){
		side_slide_bearing_holder();
		translate([20,0,0]) side_slide_bearing_holder();
	}

	module side_slide_bearing_holes(){
		side_slide_bearing_hole();
		translate([20,0,0]) side_slide_bearing_hole();
	}

	module slide_bearing_washer(){
		color("White"){
			translate([0,0,1 + 0.25 + 0.1])
				washer_M3_7x3_2x0_5mm();
			translate([0,0, - 1 - 0.25 - 0.1])
				washer_M3_7x3_2x0_5mm();
		}
		color("Blue")
			bearing_3x7x2mm();
	}

	module slide_bearing_top(angle){
		translate([118, -18, 138.1])
			rotate([90-angle,0,angle])
				slide_bearing_washer();
	}

	module slide_bearings_top(angle, last){
		if(last)
			slide_bearing_top(angle);
		translate([20, 0, 0])
			slide_bearing_top(angle);
		translate([42.5, 0, 0])
			slide_bearing_top(angle);
	}

	module slide_bearings(){

		slide_bearings_top(0, true);
		mirror([0,1,0]) slide_bearings_top(0, true);
		translate([0,0,-12.2]) slide_bearings_top(0);
		mirror([0,1,0]) translate([0,0,-12.2]) slide_bearings_top(0);
		translate([0,9.5,-16]) slide_bearings_top(90);
		mirror([0,1,0]) translate([0,9.5,-16]) slide_bearings_top(90);

	}

	// Motor Mount Slide
	module motor_mount_slide(){
		intersection(){
			difference(){
				union(){

					translate([132,0,123])
							cube([65,17,26], center = true);
					translate([132,0,132])
							cube([65,50,15], center = true);

					// joint latch
					translate([171,-17,140])
						cube([25,6,10], center = true);
					translate([171, 17,140])
						cube([25,6,10], center = true);

					// Outer Sphere Connector
					translate([178.5,-17,150])
						cube([10,6,25], center = true);
					translate([178.5, 17,150])
						cube([10,6,25], center = true);

					translate([166.5, -62.5,155])
						cube([5,5,15], center = true);

					// Servo Mounts
					translate([118, -38.5,120])
						cube([9,30,20], center = true);
					translate([118,-38.5,130])
						rotate([90,0,0])
							cylinder(
								h = 30,
								r = 4.5,
								$fn = radial_resolution/ 4,
								center = true);

					translate([168, -48.5,120])
						cube([7,10,20], center = true);
					translate([141.5, -48.5,112.5])
						cube([60,10,5], center = true);
					translate([168,-48.5,130])
						rotate([90,0,0])
							cylinder(
								h = 10,
								r = 3.5,
								$fn = radial_resolution / 4,
								center = true);
					translate([168,-48.5,120])
						rotate([90,0,0])
							cylinder(
								h = 10,
								r = 3.5,
								$fn = radial_resolution / 4,
								center = true);
					translate([118, -48.5,137.75])
						cube([9,10,20], center = true);
					translate([130, -48.5,142.75])
						cube([25,10,10], center = true);
					translate([137.5, -55, 142.75])
						cube([10,20,10], center = true);
					translate([153, -63,145.25])
						cube([29,4,5], center = true);
					translate([147, -63,140.25])
						cube([10,4,10], center = true);
					translate([166.5, -57.5,145.25])
						cube([5,15,5], center = true);

					// Bearing holders
					slide_bearing_holders(true);
					mirror([0,1,0]) slide_bearing_holders(true);
					translate([0,0,-12.2]){
						slide_bearing_holders();
						mirror([0,1,0]) slide_bearing_holders();
					}

					side_slide_bearing_holders();
					mirror([0,1,0]) side_slide_bearing_holders();

				}
				union(){
					translate([132,0,123])
							cube([66,9,18], center = true);
					translate([132,0,132])
							cube([66,42,7], center = true);
					translate([132,0,142])
							cube([66,28,20], center = true);
					sphere(
						r = internal_radius,
						$fn=radial_resolution);
					}

					// Servo Mount Holes
					translate([153,-55,145.5])
						rotate([180,0,0]){
							translate([25.4 / 2,0,0])
								cylinder(h = 6, r = 1 / 2, center = true);
							translate([-25.4 / 2,0,0])
								cylinder(h = 6, r = 1 / 2, center = true);
						}

					translate([143,-48,125])
						rotate([-90,0,0]){
							translate([50.75 / 2,-5,0])
								cylinder(h = 12, r = 1.6 / 2, center = true);
							translate([-50.75 / 2,-5,0])
								cylinder(h = 12, r = 1.6 / 2, center = true);
							translate([50.75 / 2,5,0])
								cylinder(h = 12, r = 1.6 / 2, center = true);
							translate([-50.75 / 2,5,0])
								cylinder(h = 12, r = 1.6 / 2, center = true);
						}

					// Bearing slots
					slide_bearing_slots(0, true);
					mirror([0,1,0]) slide_bearing_slots(0, true);
					translate([0,0,-13.2]) slide_bearing_slots(0);
					mirror([0,1,0])	translate([0,0,-13.2])
						slide_bearing_slots(0);
					translate([0,9,-16.5]) slide_bearing_slots(90);
					mirror([0,1,0]) translate([0,9,-16.5])
						slide_bearing_slots(90);

					// Bearing Nuts
					slide_bearing_nuts(true);
					mirror([0,1,0]) slide_bearing_nuts(true);

					translate([0,8,-12.2])
						slide_bearing_nuts();		
					translate([0,-8,-12.2])
						mirror([0,1,0]) slide_bearing_nuts();

					side_slide_bearing_nut();
					translate([-20,0,0]) side_slide_bearing_nut();
					mirror([0,1,0]){
						side_slide_bearing_nut();
						translate([-20,0,0]) side_slide_bearing_nut();
					}

					slide_bearing_holes(true);
					mirror([0,1,0]) slide_bearing_holes(true);
					side_slide_bearing_holes();
					mirror([0,1,0]) side_slide_bearing_holes();

					translate([0,-5.1,-12.2])
						slide_bearing_holes(false, 180);
					translate([0,5.1,-12.2])
						mirror([0,1,0]) slide_bearing_holes(false, 180);

					// Endstop Slot
						translate([145,0,116])
							cube([32.5,40,2], center = true);
					// joint latch hole
					translate([171,0,141])
						rotate([90,0,0])
							cylinder(
								h = 50,
								r = 2.5,
								$fn = radial_resolution / 4,
								center=true);
			}
			sphere(
        r = body_radius - body_shell_thickness,
				$fn = radial_resolution);
		}
	}

	module motor_mount_tbar(){

		translate([extension, 0, 0]){
			render(){
				difference(){
					union(){
						// T-Bar
						translate([132,0,123])
							cube([70,7,16], center = true);
						difference(){
							translate([132,0,123])
								cube([85,7,16], center = true);
							translate([170,0,131])
								rotate([0,-30,0])
									translate([0,0,-10])
										cube([10,10,40], center = true);
						}
						translate([132.5,0,132])
							cube([65,40,5], center = true);

						// Bar holder
						translate([175,5,131])
							cube([20,4,32], center = true);
						// Bar holder left
						translate([175,-5,131])
							cube([20,4,32], center = true);
						// Endstop
						translate([130.25,0,116])
							cube([2.5,18,2], center = true);
					}
					union(){
						sphere(
							r = internal_radius,
							$fn=radial_resolution);
						translate(hinge_point)
							translate([0,0,0])
								rotate([90,0,0])
									cylinder(
										h = 50,
										r = 5 / 2,
										$fn = radial_resolution / 4,
										center=true);
						translate(hinge_point_3)
							translate([0,0,0])
								rotate([90,0,0])
									cylinder(
										h = 50,
										r = 5 / 2,
										$fn = radial_resolution / 4,
										center=true);
						// counter sink
						translate(hinge_point_3)
							translate([0,7 - 1.25 + 0.1,0])
								rotate([90,0,0])
									cylinder(
										h = 2.5,
										r1 = 5,
										r2 = 5 / 2,
										$fn = radial_resolution / 4,
										center=true);
						// bolt recesse sink
						translate(hinge_point_3)
							translate([0,-7,0])
								rotate([90,0,0])
									cylinder(
										h = 2.7 * 2,
										r = 8.8 / 2,
										$fn = 6,
										center=true);
					}
				}
			}
		}
	}

	module tbar_assembly(){

		color("Lime") render() motor_mount_slide();
		color("Cyan") motor_mount_tbar();
		slide_bearings();
		tbar_servos_latch();

	}

	module bars_motor_mount(){

		shifted_hp = [hinge_point[0] + extension, hinge_point[1], hinge_point[2]];
		shifted_hp_3 = [hinge_point_3[0] + extension, hinge_point_3[1], hinge_point_3[2]];

		bar_thickness = 15;

		angle = -67.2 - hinge_angle;
		r = 15;
		R = 125.7; // Inner Bar Length
		r3 = 131.3;

		p2 = 
			[
				shifted_hp[0] + r3 * cos(angle),
				0,
				shifted_hp[2] + r3 * sin(angle)
			];

		d =
			sqrt(
				pow(p2[0] - shifted_hp_3[0], 2) +
				pow(p2[2] - shifted_hp_3[2], 2)
			);

		echo("d=", d, ", r=", r, "R=", R);

		x = (pow(d, 2) - pow(r, 2) + pow(R, 2)) / (2 * d);
		y = sqrt(
					(
						4 * pow(d, 2) * pow(R, 2)
						- pow(
								pow(d, 2)
							- pow(r, 2)
							+ pow(R, 2),
							2)
					) / (4 * pow(d, 2))
				);

		angle2 =
			atan2(
				shifted_hp_3[2] - p2[2],
				shifted_hp_3[0] - p2[0]
			) + 180;

		echo("angle2=", angle2);

		// rotate points
		x2 = x * cos(angle2) - y * sin(angle2);
		y2 = x * sin(angle2) + y * cos(angle2);

		// shift points

		x3 = x2 + shifted_hp_3[0];
		y3 = y2 + shifted_hp_3[2];

		echo("x=", x3, " y=", y3);

		p3 = 
			[
				x3,
				0,
				y3
			];

		// inner bar angle
		angle3 = atan2(
				shifted_hp_3[0] - p3[0],
				shifted_hp_3[2] - p3[2]
			) - 90;
		/*len3 =
			sqrt(
				pow(p3[0] - shifted_hp_3[0], 2) +
				pow(p3[2] - shifted_hp_3[2], 2)
			);*/

		echo("angle3=", angle3);

		// short bar
		angle4 = atan2(
				p2[0] - p3[0],
				p2[2] - p3[2]
			) - 90;
		len4 =
			sqrt(
				pow(p3[0] - p2[0], 2) +
				pow(p3[2] - p2[2], 2)
			);

		// dual bar
		angle5 = atan2(
				shifted_hp[0] - p2[0],
				shifted_hp[2] - p2[2]
			) - 90;
		/*len5 =
			sqrt(
				pow(hinge_point[0] - p2[0], 2) +
				pow(hinge_point[2] - p2[2], 2)
			);*/

		echo("angle5=", angle5);

		module inner_bar(){

			translate(shifted_hp_3){
				rotate([0,angle3,0]){
					render(){
						difference(){
							union(){

								translate([-R / 2,0,0])
									cube([R,5,bar_thickness], center = true);

								rotate([90,0,0])
									cylinder(
										h = 5,
										r = bar_thickness / 2,
										$fn = radial_resolution / 2,
										center = true);

								translate([-R,0,0])
									rotate([90,0,0])
										cylinder(
											h = 5,
											r = bar_thickness / 2,
											$fn = radial_resolution / 2,
											center = true);
							}
							union(){
								rotate([90,0,0])
									cylinder(
										h= 6,
										r = 2.5,
										$fn = radial_resolution / 4,
										center = true);

								translate([-R,0,0])
									rotate([90,0,0])
										cylinder(
											h = 6,
											r = 2.5,
											$fn = radial_resolution / 4,
											center = true);
							}
						}
					}
				}
			}
		}

		module dual_bar(hinge_point, p2, angle5, x_off){

			lever_len = 47;
			dual_bar_angle = 167.7;

			translate([extension,x_off,0] + hinge_point){
				rotate([0,angle5,0]){
					render(){
						difference(){
							union(){
								rotate([0,dual_bar_angle, 0])
									translate([-lever_len / 2, 0,0])
										cube([lever_len, 5, bar_thickness], center = true);
									translate([-r3 / 2, 0,0])
										cube([r3, 5, bar_thickness], center = true);
									rotate([90,0,0])
										cylinder(
											h = 5,
											r = bar_thickness / 2,
											$fn = radial_resolution / 2,
											center = true);
								translate([-r3, 0, 0])
									rotate([90,0,0])
										cylinder(
											h = 5,
											r = bar_thickness / 2,
											$fn = radial_resolution / 2,
											center = true);

								rotate([0,dual_bar_angle,0])
									translate([-lever_len,0,0])
										rotate([90,0,0])
											cylinder(
												h = 5,
												r = bar_thickness / 2,
												$fn = radial_resolution / 2,
												center = true);

							}
							union(){
								rotate([90,0,0])
									cylinder(
										h = 6,
										r = 2.5,
										$fn = radial_resolution / 4,
										center = true);

								rotate([0,dual_bar_angle,0])
									translate([-lever_len,0,0])
										rotate([90,0,0])
											cylinder(
												h = 6,
												r = 2.5,
												$fn = radial_resolution / 4,
												center = true);

								translate([-r3,0,0])
									rotate([90,0,0])
										cylinder(
											h = 6,
											r = 2.5,
											$fn = radial_resolution / 4,
											center = true);

								// joint latch hole
								rotate([0,dual_bar_angle,0])
									translate([-32,0,-1])
										rotate([90,0,0])
											cylinder(
												h = 50,
												r = 2.5,
												$fn = radial_resolution / 4,
												center=true);
							}
						}
					}
				}
			}
		}

		module motor_fan(position, angle){

			translate(position){
				rotate([0,angle+180,0]){
					translate([4,0,-40]){
						rotate([0,-90,0])
							translate([0,0,20.8])
								rotate([0,0,180])
									prop_motor();
					}
				}
			}
		}

		// Motor Bracket
		module motor_bracket(position, position_2, angle){
			translate(position){
				rotate([0,angle + 180,0]){
					render(){
						difference(){
							translate([4,0,-40]){
								translate([-12.5, 0, 40])
									difference(){
										cube([30, 24.8 + 8, 19], center = true);
										union(){
											translate([0,0,2])
												cube([31, 5, 20], center = true);
											translate([0, 10,2])
												cube([31, 5, 20], center = true);
											translate([0,-10,2])
												cube([31, 5, 20], center = true);
										}
									}
								// Back Plate
								difference(){
									union(){
										rotate([0, 90, 0])
											cylinder(
												h = 5,
												r = (24.8 + 8) / 2,
												center = true);
										translate([0, 0, 30 / 2 + 0.5])
											cube([5, 24.8 + 8, 31], center = true);
									}
									union(){
										rotate([0, 90, 0]){
											translate([0,   24.8 / 2, 0]){
												cylinder(
													h = 10,
													r = 3 / 2,
													$fn = radial_resolution / 4,
													center = true);
												translate([0, 0, 1.77])
													cylinder(
														h = 1.5,
														r1 = 3 / 2,
														r2 = 6/2,
														$fn = radial_resolution / 4,
														center = true);
											}
											translate([0, - 24.8 / 2, 0]){
												cylinder(
													h = 10,
													r = 3 / 2,
													$fn = radial_resolution / 4,
													center = true);
												translate([0, 0, 1.77])
													cylinder(
														h = 1.5,
														r1 = 3 / 2,
														r2 = 6 / 2,
														$fn = radial_resolution / 4,
														center = true);
											}
											translate([  24.8 / 2, 0, 0]){
												cylinder(
													h = 10,
													r = 3 / 2,
													$fn = radial_resolution / 4,
													center = true);
												translate([0, 0, 1.77])
													cylinder(
														h = 1.5,
														r1 = 3 / 2,
														r2 = 6/2,
														$fn = radial_resolution / 4,
														center = true);
											}
											translate([- 24.8 / 2, 0, 0]){
												cylinder(
													h = 10,
													r = 3 / 2,
													$fn = radial_resolution / 4,
													center = true);
												translate([0, 0, 1.77])
													cylinder(
														h = 1.5,
														r1 = 3 / 2,
														r2 = 6 /2,
														$fn = radial_resolution / 4,
														center = true);
											}
										}
									}
								}
							}
							union(){
								// bar holes
								rotate([90,0,0])
									cylinder(
										h = 40,
										r = 2.5,
										$fn = radial_resolution / 4,
										center = true);
								translate([-15,0,0])
									rotate([90,0,0])
										cylinder(
											h = 40,
											r = 2.5,
											$fn = radial_resolution / 4,
											center = true);
								//hole_cover();
							}
						}
					}
				}
			}
		}

		color("PaleGreen") inner_bar();

		color("SteelBlue"){
			dual_bar(hinge_point, p2, angle5, -10);
			dual_bar(hinge_point, p2, angle5, 10);
		}

		color("Magenta") motor_bracket(p3, p2, angle4);
		motor_fan(p3, angle4);

	}

	hinge_point = [173,0,142];
	hinge_point_3 = [175.6, 0, 129.5];

	tbar_assembly();
	bars_motor_mount();

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

	color("Silver") slide_bars();
	Door_P9_cover_slide_hinge();
	Door_P10_cover_slide_brace();

}

module cover_slides(shift, joint_position){
	translate([shift, 0, 0]){
		translate(joint_position){
			r = 7.5 / 2;
			translate([0,0, 10]) cover_slide(shift, joint_position);
			translate([0,0,-10]) cover_slide(shift, joint_position);
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
					cube([140, 140, 140], center = true);
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
						cube([140, 140, 140], center = true);
				}
			}
			shaft_cutout();
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
					cube([140, 140, 140], center = true);
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

module propulsion_system(){

	//hole_cover();

	prop_spacing = 34.15;
	blade_length = 190.4;

	color("Black"){
		translate([175.5,0,32.5]){
			cylinder(
				h = 225,
				r = 10 / 2,
				$fn = radial_resolution,
				center = true);
		}
	}

	translate([174.5, 0,-110]){
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

module Door_P7_middle_door_brace(){
	render(){
		intersection(){
			difference(){
				union(){
					translate([170, -60, 0])
						cube([30, 15, 20], center = true);
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
	{
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

		translate([150,130,25])
			rotate([180,0,180])
				color("Magenta") render() HS_5065MG();

module body_assembly(){

	for(i = [0:90:270]){
		for(j = [0:180:180]){
			rotate([0,j,i]){
				color("Red")					Body_P1();
				color("Green")				Body_P2();
				color("Yellow")				Body_P3();
				color("Turquoise")		Body_P4();
				color("OrangeRed")		Body_P5();

				color("Blue")					Body_P6();
				color("Purple")				Body_P7();
				color("DeepPink")			Body_P8();
				color("SpringGreen")	Body_P9();
				color("DarkKhaki") 		Body_P10();
				color("LawnGreen") 		Body_P11();

				color("Fuchsia") 			Body_P12();
			}
		}
	}
}

//color("Cyan") Door_P6_servo_lever();

color("FireBrick") Door_P8_middle_door_bumper();
mirror([0, 1, 0])
	color("Lime") Door_P8_middle_door_bumper();

color("DeepSkyBlue") Door_P7_middle_door_brace();
mirror([0, 1, 0])
	color("DeepSkyBlue") Door_P7_middle_door_brace();

rotate([0,0,-90])
color("Red")					Body_P1();
color("Green")				Body_P2();
color("Yellow")				Body_P3();
color("Turquoise")		Body_P4();
color("OrangeRed")		Body_P5();

color("Blue")					Body_P6();
color("Purple")				Body_P7();
color("DeepPink")			Body_P8();
color("SpringGreen")	Body_P9();
color("DarkKhaki")		Body_P10();
color("LawnGreen")		Body_P11();

rotate([0,0,-90])
color("Fuchsia")			Body_P12();

color("Magenta")			Body_P13();

cover_assembly();
//color([0.75,0.75,0.75,0.25]) % body_assembly();

//fan_assembly();
//translate([175,0,145])
//cube([10,10,10], center = true);

/*
Fan Fold Sequence
1. Align blades to arm
2. open right door 90 deg
3. rotate blades 110 degrees one of blades will hit door
4. rotate another 90 degrees to fold blade
5. rotate back 240 degrees to other blade hits cover
6. rotate 90 degrees more to fold prop
7. rotate back 40 degress
8. fold in arms
9. fold right door
*/
/*
rotate_about([176, 0, 145], [0,arm_angle,0]){
	propulsion_system();
}
*/