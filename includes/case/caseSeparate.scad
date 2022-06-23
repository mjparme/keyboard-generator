include <caseCommon.scad>

//This file is included in keyboardGenerator.scad and depends on all the variables defined there, won't work standalone

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