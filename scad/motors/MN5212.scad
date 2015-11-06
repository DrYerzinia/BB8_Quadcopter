use <../utils.scad>

module MN5212(){

	//render(){
		difference(){
			union(){
				translate([0,0, 42.5 / 2 - 23 / 2 - 4.9 - 6])
					cylinder(
						h = 23,
						r = 59 / 2,
						$fa = fa(59 / 2),
						center = true);
				translate([0,0, 42.5 / 2 - 4.9 / 2 - 6])
					cylinder(
						h = 4.9,
						r1 = 59 / 2,
						r2 = 24.8 / 2,
						$fa = fa(59 / 2),
						center = true);
				translate([0,0, - 42.5 / 2 + 5.6 / 2 + 3])
					cylinder(
						h = 5.6,
						r1 = 44 / 2,
						r2 = 59 / 2,
						$fa = fa(59 / 2),
						center = true);
				translate([0, 0, 42.5 / 2 - 3])
					cylinder(
						h = 6,
						r = 4 / 2,
						$fa = fa(4 / 2),
						center = true);
				translate([0, 0, - 42.5 / 2 + 1.5])
					cylinder(
						h = 3,
						r = 6 / 2,
						$fa = fa(6 / 2),
						center = true);
			}
			union(){
				for(i = [0:90:270])
					rotate([0, 0, i])
						translate([0, 25 / 2, -16.25 - 0.025])
							cylinder(
								h = 4,
								r = 3 / 2,
								$fa = fa(3 / 2),
								center = true);
				for(i = [0:120:240])
					rotate([0, 0, i])
						translate([0, 17 / 2, 12.75 + 0.025])
							cylinder(
								h = 5,
								r = 3 / 2,
								$fa = fa(3 / 2),
								center = true);
				rotate([0, 0, 30])
					translate([0, 12 / 2, 12.75 + 0.025])
						cylinder(
							h = 5,
							r = 3 / 2,
							$fa = fa(3 / 2),
							center = true);
				rotate([0, 0, 30 + 180])
					translate([0, 12 / 2, 12.75 + 0.025])
						cylinder(
							h = 5,
							r = 3 / 2,
							$fa = fa(3 / 2),
							center = true);
			}
		}

	//}

}

MN5212();
