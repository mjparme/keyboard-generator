include <caseCommon.scad>

//This file is included in keyboardGenerator.scad and depends on all the variables defined there, won't work standalone

module separateCase() {
    difference() {
        caseWalls(slopeDirection = "up");
        separateCaseScrewHoles(); 
        usbConnectorHole(z = 0);
    }

    translate([0, 0, -caseFloorThickness + 0.001]) caseBottom(includeScrewHoles = false);

    module separateCaseScrewHoles() {
        if (includeCaseScrewHoles) {
            //z = caseFrontHeight - heatSetInsertHeight;
            z = caseFloorThickness;
            screwHoles(z) {
                //For the separate case the height of the holes have to be tall enough to make it out the top of the rear of the case
                height = caseRearHeight;

                //We slightly taper these holes so the heat set insert is much easier to insert, the constant can be adjusted to change the delta between the 
                //top and bottom diameters (todo: maybe make this a variable??)
                topDiameter = heatSetInsertOutsideDiameter + 0.6; 
                taperedHole(bottomDiameter = heatSetInsertOutsideDiameter, topDiameter = topDiameter, height = height, center = false);
            }
        }
    }
}