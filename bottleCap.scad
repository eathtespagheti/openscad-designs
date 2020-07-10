tolerance     = 0.1;
BUMP_WIDTH    = 0.8 + tolerance;
CAP_DIAMETER  = 57.38 + (BUMP_WIDTH / 2) + tolerance;
BUMP_DIAMETER = CAP_DIAMETER + BUMP_WIDTH;
BUMP_HEIGHT   = 1.90 + tolerance;
CAP_HEIGHT    = 35;

MAX_COVER_BUMP        = 1.17 - tolerance;
COVER_HEIGHT_FROM_CAP = 2;
COVER_HEIGHT          = COVER_HEIGHT_FROM_CAP + CAP_HEIGHT + MAX_COVER_BUMP;
COVER_WALL_THICKNESS  = 1.2;

module cover() {
    difference() {
        difference() {
            cylinder(r = (BUMP_DIAMETER / 2) + COVER_WALL_THICKNESS,
                     h = COVER_WALL_THICKNESS + COVER_HEIGHT, $fn = 360);
            translate([ 0, 0, COVER_WALL_THICKNESS ]) {
                cylinder(r = (CAP_DIAMETER / 2), h = COVER_HEIGHT, $fn = 360);
            }
        }
        translate([ 0, 0, COVER_HEIGHT - MAX_COVER_BUMP ]) {
            cylinder(r = (BUMP_DIAMETER / 2), h = MAX_COVER_BUMP, $fn = 360);
        }
    }
}

module fitTest(diameter = BUMP_DIAMETER, height = COVER_HEIGHT / 10) {
    difference() {
        difference() {
            cylinder(r = (diameter / 2) + COVER_WALL_THICKNESS,
                     h = COVER_WALL_THICKNESS + height, $fn = 360);
            cylinder(r = (CAP_DIAMETER / 2), h = COVER_WALL_THICKNESS + height,
                     $fn = 360);
        }
        translate([ 0, 0, height - MAX_COVER_BUMP ]) {
            cylinder(r = (diameter / 2), h = MAX_COVER_BUMP, $fn = 360);
        }
    }
}

cover();
