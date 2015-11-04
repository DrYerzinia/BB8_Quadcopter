module DJI_4216(){

	cylinder(
		h = 35,
		r = 48.7 / 2,
		$fn = radial_resolution,
		center = true);

	translate([0,0,48.7 / 2 - 7 / 2])
		cylinder(
			h = 7,
			r = 6 / 2,
			$fn = radial_resolution,
			center = true);

}