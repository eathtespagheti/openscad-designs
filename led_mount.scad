function nutRadius(nutDiameter) = nutDiameter / 2 / sin(60);

BASE_WIDTH         = 20.35;
HANDLEBAR_DIAMETER = 22.2;
PIN_DIAMETER       = 3.1;
PIN_RADIUS         = PIN_DIAMETER / 2;
JOIN_OFFSET        = 0.01;

// Connector
CONNECTOR_TOLERANCE   = .3;
FRONT_HEIGHT          = 11.44;
CONNECTOR_HEIGHT      = 4;
THREAD_DIAMETER       = 3 + CONNECTOR_TOLERANCE;   // For a M3
NUT_SIZE              = 5.5 + CONNECTOR_TOLERANCE; // For a M3
NUT_HEIGHT            = 2.40;                      // Max for M3
THREAD_RADIUS         = THREAD_DIAMETER / 2;
NUT_HOUSING_THICKNESS = 1.5;
EXTRA_SIDE_SPAN       = nutRadius(NUT_SIZE + NUT_HOUSING_THICKNESS) * 2;

// Front variables
FRONT_BASE_LENGTH = NUT_SIZE + NUT_HOUSING_THICKNESS;
FRONT_PIN_WIDTH   = 8.68;
FRONT_BASE_HEIGHT = 6.2 - PIN_DIAMETER;

// Rear variables
REAR_PIN_WIDTH                 = 5.6;
REAR_PIN_DIAMETER              = 4;
REAR_PIN_RADIUS                = REAR_PIN_DIAMETER / 2;
REAR_PIN_HEIGTH                = 8;
REAR_PIN_HEIGTH_FROM_CURVATURE = 4.40;
REAR_SPACERS_WIDTH             = 3.85;

itemType = "rear"; // front, rear, top, pin

module nut(diameter, height) {
    cylinder(r = nutRadius(diameter), h = height, $fn = 6);
}

module nutHousing(diameter, height, wallThickness) {
    difference() {
        nut(diameter + wallThickness, height);
        nut(diameter, height);
    }
}

module frontCylinderPin() {
    // Half pin
    difference() {
        translate([ -JOIN_OFFSET / 2, 0, 0 ]) {
            // Complete pin
            union() {
                // Round pin
                rotate([ 0, 90, 0 ]) {
                    cylinder(r = PIN_RADIUS, h = BASE_WIDTH + JOIN_OFFSET,
                             $fn = 360);
                }
                // Limit cube
                cube(size = [ PIN_RADIUS, PIN_RADIUS, PIN_RADIUS ]);
            }
            translate([ 0, -PIN_RADIUS, -PIN_RADIUS ]) {
                cube(size = [
                    BASE_WIDTH + JOIN_OFFSET, PIN_DIAMETER,
                    PIN_RADIUS
                ]);
            }
        }
    }
}

module screwConnector(length) {
    translate([ 0, 0, -CONNECTOR_HEIGHT ]) {
        union() {
            difference() {
                cube(size = [ EXTRA_SIDE_SPAN, length, CONNECTOR_HEIGHT ]);
                translate([ EXTRA_SIDE_SPAN / 2, length / 2, 0 ]) {
                    cylinder(r = THREAD_RADIUS, h = CONNECTOR_HEIGHT,
                             $fn = 360);
                }
            }
            translate([ EXTRA_SIDE_SPAN / 2, length / 2, -NUT_HEIGHT ]) {
                nutHousing(NUT_SIZE, NUT_HEIGHT, NUT_HOUSING_THICKNESS);
            }
        }
    }
}

module screwPads(length, height) {
    translate([ -EXTRA_SIDE_SPAN, 0, height ]) {
        union() {
            screwConnector(length);
            translate([ BASE_WIDTH + EXTRA_SIDE_SPAN, 0, 0 ]) {
                screwConnector(length);
            }
        }
    }
}

module front() {
    rotate([ -90, 0, 0 ]) {
        union() {
            difference() {
                // Main structure
                union() {
                    cube(size = [
                        BASE_WIDTH, FRONT_BASE_LENGTH,
                        FRONT_BASE_HEIGHT
                    ]);                                      // Base
                    translate([ 0, 0, FRONT_BASE_HEIGHT ]) { // Top
                        difference() {
                            cube(size = [
                                BASE_WIDTH, FRONT_BASE_LENGTH, FRONT_HEIGHT -
                                FRONT_BASE_HEIGHT
                            ]);
                            translate([
                                (BASE_WIDTH - FRONT_PIN_WIDTH) / 2, 0, 0
                            ]) { // Empty space in the middle
                                cube(size = [
                                    FRONT_PIN_WIDTH, FRONT_BASE_LENGTH,
                                    FRONT_HEIGHT -
                                    FRONT_BASE_HEIGHT
                                ]);
                            }
                        }
                    }
                }
                // Cylinder hole
                translate([ 0, FRONT_BASE_LENGTH / 2, FRONT_BASE_HEIGHT ]) {
                    frontCylinderPin();
                }
            }
            screwPads(FRONT_BASE_LENGTH, FRONT_HEIGHT);
        }
    }
}

module rearPin() {
    translate([ 0, REAR_PIN_RADIUS, 0 ]) {
        difference() {
            rotate([ 0, 90, 0 ]) {
                cylinder(r   = REAR_PIN_RADIUS,
                         h   = REAR_PIN_WIDTH + REAR_SPACERS_WIDTH * 2,
                         $fn = 360);
            }
            translate([ 0, -REAR_PIN_RADIUS, -REAR_PIN_RADIUS]) {
                cube(size = [
                    REAR_PIN_WIDTH + REAR_SPACERS_WIDTH * 2, REAR_PIN_DIAMETER,
                    REAR_PIN_RADIUS
                ]);
            }
        }
    }
}

module rearBar() {
    translate([ REAR_SPACERS_WIDTH / 2, REAR_SPACERS_WIDTH / 2, 0 ]) {
        union () {
            cylinder(r = REAR_SPACERS_WIDTH / 2, h = REAR_PIN_HEIGTH, $fn = 360);
            translate([-REAR_SPACERS_WIDTH / 2, 0, 0]) {
            cube(size=[REAR_SPACERS_WIDTH, REAR_PIN_RADIUS + 0.08, REAR_PIN_HEIGTH]);
                
            }
        }
    }
}

module rearBars() {
    union() {
        rearBar();
        translate([ REAR_PIN_WIDTH + REAR_SPACERS_WIDTH, 0, 0 ]) { rearBar(); }
    }
}

module rear() {
    union() {
        rearPin();
        rearBars();
        screwPads(REAR_PIN_DIAMETER, REAR_PIN_HEIGTH);
    }
}

module top() { cube(size = [ 10, 10, 10 ], center = true); }

if (itemType == "front") {
    front();
} else if (itemType == "rear") {
    rear();
} else if (itemType == "top") {
    top();
} else if (itemType == "pin") {
    scale([ 1, .8, .8 ]) { frontCylinderPin(); }
} else {
    rearBars();
}
