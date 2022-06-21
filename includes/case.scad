/*
    This file is included in keyboardGenerator.scad and depends on all the variables defined there, won't work standalone
*/
module case(subType = undef) {
    echo("***** CASE *****");
    if (subType == undef) {
        separateCase();
    } else if (subType == "integratedWalls") {
        integratedCase();
    } else if (subType == "caseBottom") {
        caseBottom();
    }
}

module separateCase() {
    difference() {
        caseWalls();
        separateCaseScrewHoles(); 
    }

    module separateCaseScrewHoles() {
        if (includeCaseScrewHoles) {
            z = caseFrontHeight - heatSetInsertHeight;
            screwHoles(z) {
                //For the separate case the heatset insert goes into the case so the holes need to be big enough to accomodate the heatset insert
                height = heatSetInsertHeight + 0.5;

                //We slightly taper these holes so the heat set insert is much easier to insert, the constant can be adjusted to change the delta between the 
                //top and bottom diameters (todo: maybe make this a variable??)
                topDiameter = heatSetInsertOutsideDiameter + 0.6; 
                taperedHole(bottomDiameter = heatSetInsertOutsideDiameter, topDiameter = topDiameter, height = height, center = false);
            }
        }
    }
}

module integratedCase() {
    z = -caseFrontHeight;
    difference() {
        translate([0, 0, z]) caseWalls(hasFloor = false);
        integratedCaseScrewHoles();
        usbConnectorHole();
    }

    module usbConnectorHole() {
        x = controllerXLocation + (controllerLength + 2 * controllerAreaWallThickness) / 2 - usbHoleLength / 2;
        y = plateWidth - caseWallThickness - 0.01;
        z = -caseFrontHeight - 0.01;
        translate([x, y, z]) hole();

        module hole() {
            cube([usbHoleLength, caseWallThickness + 1, usbHoleHeight]);
            x = usbHoleLength / 2 - controllerLength / 2; 
            //Will just use the switchHoleSlop value here as a generic slop value even though this hole has nothing to
            //do with switches
            translate([x, 0, 0]) cube([controllerLength + switchHoleSlop, caseWallThickness + 1, controllerAreaHeight]);
        }
    }

    module integratedCaseScrewHoles() {
        screwHoles(z = z - 0.1) {
            //For the separate case the heatset insert goes into the case so the holes need to be big enough to accomodate the heatset insert
            height = heatSetInsertHeight + 0.5;

            //We slightly taper these holes so the heat set insert is much easier to insert, the constant can be adjusted to change the delta between the 
            //top and bottom diameters (todo: maybe make this a variable??)
            holeOpeningDiameter = heatSetInsertOutsideDiameter + 0.6; 
            taperedHole(bottomDiameter = holeOpeningDiameter, topDiameter = heatSetInsertOutsideDiameter, height = height, center = false);
        }
    }
}

module caseBottom() {
    difference() {
        //For the case bottom the screw holes are counter-sunk through-holes and the counter sink is on the bottom
        roundedCube(length = plateLength, width = plateWidth, height = caseFloorThickness, radius = roundedRadius, center = false, roundingShape = "circle", topRoundingShape = undef);
        caseBottomScrewHoles();

        //The controller holder goes on the case bottom for an integrated case, as part of that we need cutouts for the pins (wires will poke out slightly below the controller)
        //so those need to be differenced out here
        cutoutX = controllerXLocation + controllerAreaWallThickness;
        cutoutY = plateWidth - controllerWidth;
        cutoutZ = caseFloorThickness - cutoutDepth + 0.1;
        translate([cutoutX, cutoutY, cutoutZ]) pinCutouts();
    }

    holderX = controllerXLocation;
    holderY = plateWidth - controllerWidth - controllerAreaWallThickness;
    holderZ = caseFloorThickness;
    translate([holderX, holderY, holderZ]) controllerHolder();

    module caseBottomScrewHoles() {
        screwHoles(z = -0.1) {
            cylinder(d = adjustedScrewDiameter, h = caseFloorThickness + 10);
            cylinder(d = adjustedScrewHeadDiameter, h = counterSinkDepth);
        }
    }
}

module caseWalls(hasFloor = true) {
    //slope = caseRearHeight / plateWidth * 100
    //hollowRoundedCube(length = plateLength, width = plateWidth, height = caseFrontHeight, radius = roundedRadius, wallThickness = caseWallThickness, floorThickness = caseFloorThickness, 
    //        hasFloor = hasFloor, dimensionType = "outer", roundingShape = "circle", center = false);
     slantPoints = [
        [roundedRadius,roundedRadius], //bottom left
        [roundedRadius, plateWidth - roundedRadius], //top left
        [plateLength - roundedRadius, plateWidth - roundedRadius], //top right
        [plateLength - roundedRadius, roundedRadius] //bottom right
    ];

    caseRearHeight = caseFrontHeight + (plateWidth * percentSlope) / 100;
    //Want the extra height on the rear objects (if there is a slant) to be -z (want it to slop down, not up)
    zAdjustment = caseRearHeight - caseFrontHeight; 
    echo("CaseRearHeight: ", caseRearHeight);
    echo("CaseFrontHeight: ", caseFrontHeight);
    echo("PercentSlope: ", percentSlope);
    echo("PlateWidth: ", plateWidth);
    echo("ZAdjustment: ", zAdjustment);

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
        hull() {
            translate(slantPoints[0]) objectToHull(height = caseFrontHeight);
            translate(concat(slantPoints[1], [-zAdjustment])) objectToHull(height = caseRearHeight);
            translate(concat(slantPoints[2], [-zAdjustment])) objectToHull(height = caseRearHeight);
            translate(slantPoints[3]) objectToHull(height = caseFrontHeight);
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