 // Author Michael Marques (DrYerzinia)

// http://www.ebay.com/itm/10-PCS-683-3x7x2-mm-Metal-OPEN-PRECISION-Miniature-Ball-Bearing-3-7-2-/291206307942?hash=item43cd3fa066:m:mCi6eovrGVk_CjIUjlhw8yg
// E-Bay empire.rc

module washer_M3_7x3_2x0_5mm(){

	difference(){
		cylinder(
			h = 0.5,
			r = 7 / 2,
			$fn = 16,
			center = true);
		cylinder(
			h = 0.5 + 0.1,
			r = 3.2 / 2,
			$fn = 16,
			center = true);
	}

}

module bearing_3x7x2mm(){

	difference(){
		cylinder(
			h = 2,
			r = 7 / 2,
			$fn = 16,
			center = true);
		cylinder(
			h = 2 + 1,
			r = 3 / 2,
			$fn = 16,
			center = true);
	}

}

module bearing_5x8x2_5mm(){

	difference(){
		cylinder(
			h = 2.5,
			r = 8 / 2,
			$fn = 16,
			center = true);
		cylinder(
			h = 2.5 + 1,
			r = 5 / 2,
			$fn = 16,
			center = true);
	}

}

module bearing_8x16x5mm(){

	difference(){
		cylinder(
			h = 5,
			r = 16 / 2,
			$fn = 16,
			center = true);
		cylinder(
			h = 5 + 1,
			r = 8 / 2,
			$fn = 16,
			center = true);
	}

}


bearing_5x8x2_5mm();
