include <caseCommon.scad>

//This file is included in keyboardGenerator.scad and depends on all the variables defined there, won't work standalone

module integratedCase() {
    echo("******** Integrated Case ********");

    //slope = (rise / run) * 100
    //rise = (run * slope) / 100
    //We know the slope (from config) and run (plateWidth), to find caseRearHeight need to solve for rise and add it to caseFrontHeight 
    caseRearHeight = caseFrontHeight + (plateWidth * percentSlope) / 100;

    //If rounded corners aren't wanted make the radius be super small, this will effectively be non-rounded corners
    roundedRadius = roundedCorners ? roundedRadius : 0.00000001;
    echo("Corner Radius: ", roundedRadius);

    cornerPoints = [
        [roundedRadius,roundedRadius], //bottom left
        [roundedRadius, plateWidth - roundedRadius], //top left
        [plateLength - roundedRadius, plateWidth - roundedRadius], //top right
        [plateLength - roundedRadius, roundedRadius] //bottom right
    ];

    difference() {
        translate([0, 0, -caseFrontHeight]) caseWalls();
        integratedCaseScrewHoles();
        usbConnectorHole();
    }

    module caseWalls() {
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

    module usbConnectorHole() {
        x = controllerXLocation + (controllerLength + 2 * controllerAreaWallThickness) / 2 - usbHoleLength / 2;
        y = plateWidth - caseWallThickness - 0.01;
        z = -caseRearHeight - 0.01;
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
        //For the separate case the heatset insert goes into the case so the holes need to be big enough to accomodate the heatset insert
        //For height the holes need to be long enough to extend out of the bottom of the back wall of the case which may be longer if a sloped
        //case was wanted 
        height = caseRearHeight * 2;

        screwHoles(z = -height - 1) {
            //We slightly taper these holes so the heat set insert is much easier to insert, the constant can be adjusted to change the delta between the 
            //top and bottom diameters (todo: maybe make this a variable??)
            //holeOpeningDiameter = heatSetInsertOutsideDiameter + 0.6; 
            //taperedHole(bottomDiameter = holeOpeningDiameter, topDiameter = heatSetInsertOutsideDiameter, height = height, center = false);
            holeDiameter = heatSetInsertOutsideDiameter + switchHoleSlop;
            cylinder(d = holeDiameter, h = height);
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

