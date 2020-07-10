insideLength = 15;
outsideLength =
    39; // Keep in mind that only half of the outside length will be empty
insideDiameter =
    18.10; // Make this tight to avoid the extension slipping from the bar
outsideDiameter = 22.2; // Standard for bike handlebars

hollowJunction    = true; // Set false to make the inside juction hollow
junctionThichness = 2.5;    // Wall thichness for inside junction

difference() {
    cylinder(h = outsideLength, r = outsideDiameter / 2, $fn = 360);
    translate([ 0, 0, -1 ])
        cylinder(h = outsideLength + 2, r = insideDiameter / 2, $fn = 360);
}
// Inside Cylinder
translate([ 0, 0, outsideLength / 2 ]) {
    difference() {
        cylinder(h = insideLength + (outsideLength / 2),
                 r = insideDiameter / 2, $fn = 360);
        if (hollowJunction) {
            cylinder(h = insideLength + (outsideLength / 2),
                     r = (insideDiameter / 2) - junctionThichness, $fn = 360);
        }
    }
}
