module caseWalls() {
     //If rounded corners aren't wanted make the radius be super small, this will effectively be non-rounded corners
    roundedRadius = roundedCorners ? roundedRadius : 0.00000001;
    echo("Corner Radius: ", roundedRadius);

    cornerPoints = [
        [roundedRadius, roundedRadius], //bottom left
        [roundedRadius, plateWidth - roundedRadius], //top left
        [plateLength - roundedRadius, plateWidth - roundedRadius], //top right
        [plateLength - roundedRadius, roundedRadius] //bottom right
    ];

    echo("CaseRearHeight: ", caseRearHeight);
    echo("CaseFrontHeight: ", caseFrontHeight);
    echo("PercentSlope: ", percentSlope);
    echo("PlateWidth: ", plateWidth);

    difference() {
        mainShape();
        hollowLength = plateLength - 2 * caseWallThickness;
        hollowWidth = plateWidth - 2 * caseWallThickness;
        hollowHeight = caseRearHeight * 3;
        echo("HollowHeight: ", hollowHeight);
        translate([caseWallThickness, caseWallThickness, -hollowHeight / 2]) roundedCube(length = hollowLength, width = hollowWidth, height = hollowHeight, radius = roundedRadius, 
            center = false, roundingShape = "circle", topRoundingShape = undef);
    }

    module mainShape() {
        //Want the extra height on the rear objects (if there is a slant) to be -z (want it to slope down, not up)
        zAdjustment = caseRearHeight - caseFrontHeight; 
        echo("ZAdjustment: ", zAdjustment);

        hull() {
            translate(cornerPoints[0]) objectToHull(height = caseFrontHeight);
            translate(concat(cornerPoints[1], [-zAdjustment])) objectToHull(height = caseRearHeight);
            translate(concat(cornerPoints[2], [-zAdjustment])) objectToHull(height = caseRearHeight);
            translate(cornerPoints[3]) objectToHull(height = caseFrontHeight);
        }
    }

    module objectToHull(height) {
        cylinder(r = roundedRadius, h = height);
    }
}

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