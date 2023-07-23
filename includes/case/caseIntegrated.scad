include <caseCommon.scad>

//This file is included in keyboardGenerator.scad and depends on all the variables defined there, won't work standalone

module integratedCase() {
    echo("******** Integrated Case ********");

    connectorZ = -caseRearHeight - 0.01;
    difference() {
        translate([0, 0, -caseFrontHeight]) caseWalls();
        integratedCaseScrewHoles();
        usbConnectorHole(z = connectorZ);
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