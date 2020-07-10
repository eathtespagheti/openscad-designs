// TOLERANCES
MEASURE_TOLERANCE = 0.05;
INSIDE_TOLERANCE  = 2;

// GENERAL MEASUREMENTS
FULL_LENGTH     = 24;
INSIDE_DIAMETER = 8.35;

// OUTER DIAMETER
OUTER_DIAMETER = 17.33 - MEASURE_TOLERANCE;
OUTER_LENGTH   = 5;

// INNER DIAMETER
INNER_DIAMETER = 11.2 - MEASURE_TOLERANCE;
INNNER_LENGTH  = (FULL_LENGTH - (OUTER_LENGTH * 2) - INSIDE_TOLERANCE) / 2;

module outside_full(radius = OUTER_DIAMETER / 2,
                    length = OUTER_LENGTH + INNNER_LENGTH) {
    cylinder(r = radius, h = length, $fn = 360);
}

module inside_cutter(inside_radius = INSIDE_DIAMETER / 2,
                     length        = OUTER_LENGTH + INNNER_LENGTH) {
    cylinder(r = inside_radius, h = length, $fn = 360);
}

module inner_cutter(inner_radius = INNER_DIAMETER / 2,
                    outer_radius = OUTER_DIAMETER / 2,
                    inner_length = INNNER_LENGTH) {
    difference() {
        cylinder(r = outer_radius, h = inner_length, $fn = 360);
        cylinder(r = inner_radius, h = inner_length, $fn = 360);
    }
}

module with_inner_cut(inner_radius = INNER_DIAMETER / 2,
                      inner_length = INNNER_LENGTH,
                      outer_length = OUTER_LENGTH) {
    difference() {
        outside_full();
        translate([ 0, 0, outer_length ]) { inner_cutter(); }
    }
}

module shock_mount(inner_radius = INNER_DIAMETER / 2,
                   inner_length = INNNER_LENGTH, outer_length = OUTER_LENGTH) {
    difference() {
        with_inner_cut();
        inside_cutter();
    }
}

shock_mount();