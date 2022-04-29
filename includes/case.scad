/*
    This file is included in keyboardGenerator.scad and depends on all the variables defined there, won't work standalone
*/
module case(subType = undef) {
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
            z = caseHeight - heatSetInsertHeight;
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
    z = -caseHeight;
    difference() {
        translate([0, 0, z]) caseWalls(hasFloor = false);
        integratedCaseScrewHoles();
        usbConnectorHole();
    }

    module usbConnectorHole() {
        x = controllerXLocation + (controllerLength + 2 * controllerAreaWallThickness) / 2 - usbHoleLength / 2;
        y = plateWidth - caseWallThickness - 0.01;
        z = -caseHeight - 0.01;
        translate([x, y, z])  hole();

        module hole() {
            cube([usbHoleLength, caseWallThickness + 1, usbHoleHeight]);
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
        cutoutY = plateWidth - controllerWidth - caseWallThickness;
        cutoutZ = caseFloorThickness - cutoutDepth + 0.1;
        translate([cutoutX, cutoutY, cutoutZ]) pinCutouts();
    }

    holderX = controllerXLocation;
    holderY = plateWidth - controllerWidth - caseWallThickness - controllerAreaWallThickness;
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
    hollowRoundedCube(length = plateLength, width = plateWidth, height = caseHeight, radius = roundedRadius, wallThickness = caseWallThickness, floorThickness = caseFloorThickness, 
            hasFloor = hasFloor, dimensionType = "outer", roundingShape = "circle", center = false);
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
        hollowCube(length = controllerLength, width = controllerWidth, height = controllerAreaHeight, wallThickness = controllerAreaWallThickness, hasFloor = false, dimensionType = "inner"); 
        //Chop off the farthest wall in the y of the hollowCube so it doesn't interfer will usb connector hole
        translate([-1, controllerWidth + controllerAreaWallThickness - 0.01, -0.01]) cube([controllerLength + (2 * controllerAreaWallThickness) + 2, controllerAreaWallThickness + 1, controllerAreaHeight + 1]);
    }
}
//Cutouts so the wire in the pin holes can stick into so the controller can sit flat
module pinCutouts() {
    cutoutLength = 3;
    pinCutout();
    translate([controllerLength - cutoutLength, 0, 0]) pinCutout();

    module pinCutout() {
        cube([cutoutLength, controllerWidth, cutoutDepth]);
    }
}