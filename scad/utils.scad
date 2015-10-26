// http://forum.openscad.org/Creating-pie-pizza-slice-shape-need-a-dynamic-length-array-td3148.html

module pie_slice(r, start_angle, end_angle, radial_resolution) {
    R = r * sqrt(2) + 1;
    a0 = (4 * start_angle + 0 * end_angle) / 4;
    a1 = (3 * start_angle + 1 * end_angle) / 4;
    a2 = (2 * start_angle + 2 * end_angle) / 4;
    a3 = (1 * start_angle + 3 * end_angle) / 4;
    a4 = (0 * start_angle + 4 * end_angle) / 4;
    if(end_angle > start_angle)
        intersection() {
        circle(r, $fn);
        polygon([
            [0,0],
            [R * cos(a0), R * sin(a0)],
            [R * cos(a1), R * sin(a1)],
            [R * cos(a2), R * sin(a2)],
            [R * cos(a3), R * sin(a3)],
            [R * cos(a4), R * sin(a4)],
            [0,0]
       ]);
    }
}

// https://github.com/openscad/openscad/issues/29

module rotate_about(v,a) {
	translate(v) rotate(a) translate(-v) children(0);
}

// https://github.com/robofun/openscad-utils/blob/master/trapezoid.scad

module trapezoid(width_base, width_top,height,thickness) {
	

  linear_extrude(height = thickness) polygon(points=[[0,0],[width_base,0],[width_base-(width_base-width_top)/2,height],[(width_base-width_top)/2,height]], paths=[[0,1,2,3]]); 
  
}
