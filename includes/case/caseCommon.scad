//This module needs to be passed a child that draws the screw hole, this module will draw them in the correct positions
module screwHoles(z = 0) {
    for (position = [0 : len(screwHolePositions) - 1]) {
        x = screwHolePositions[position][0];
        y = screwHolePositions[position][1];
        translate([x, y, z]) children();
    }
}

module controllerHolder() {
    difference() {
        hollowCube(length = controllerLength, width = controllerWidth - caseWallThickness, height = controllerAreaHeight, wallThickness = controllerAreaWallThickness, hasFloor = false, dimensionType = "inner"); 
        //Chop off the farthest wall in the y of the hollowCube so it doesn't interfer with usb connector hole
        translate([-1, controllerWidth + controllerAreaWallThickness - caseWallThickness - 0.01, -0.01]) cube([controllerLength + (2 * controllerAreaWallThickness) + 2, controllerAreaWallThickness + 1, controllerAreaHeight + 1]);
    }
}

//Cutouts so the wire in the pin holes can stick into so the controller can sit flat
module pinCutouts() {
    cutoutLength = 3;
    pinCutout();
    translate([controllerLength - cutoutLength, 0, 0]) pinCutout();

    module pinCutout() {
        cube([cutoutLength, controllerWidth - 1.8, cutoutDepth]);
    }
}