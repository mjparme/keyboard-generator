module plate() {
    if (visualModeOn || switchHolesOnly) {
        mainPlate(plateWidth);
    } else {
        //Uncomment this projection to render a plate into 2D for export to DXF or SVG. If you want bottom cutouts then
        //go ahead and render in 3d even if you are going to CNC
        //projection()
         difference() {
            mainShape(plateLength = plateLength, plateWidth = plateWidth, plateThickness = plateThickness);
            mainPlate(plateWidth = plateWidth);
            if (includePlateScrewHoles) {
                topMountPlateScrewHoles();
            }
        }
    }
}

module mainShape(plateLength, plateWidth, plateThickness) {
    if (roundedCorners) {
        roundedCube(length = plateLength, width = plateWidth, height = plateThickness, radius = roundedRadius, center = false, roundingShape = "circle", topRoundingShape = roundingShape);
    } else {
        cube([plateLength, plateWidth, plateThickness]);
    }
}

module mainPlate(plateWidth) {
    numberOfRows = len(layout);
    echo("Number of Rows: ", numberOfRows);
    for (rowNum = [0 : len(layout) - 1]) {
        rowValues = layout[rowNum];
        echo(str("Row: ", rowNum, ", RowValues: ", rowValues, ", Row Y Size: ", yRowSizes[rowNum]));
        //Skip rows just adding blank space
        if (rowValues[0] != "hs") {
            for (colNumber = [0 : len(rowValues) - 1]) {
                //The size of the area available for a keycap for this position, the switch hole should be centered
                //within this area, and an actual keycap should be slightly smaller so two adjacent keycaps don't touch
                keyUSize = layout[rowNum][colNumber];

                //For vectors with "vs" in them there is nothing to draw because it is a blank space; however, "vk" vectors
                //do result in a hole being drawn
                isVerticalKey = keyUSize[0] == "vk";
                isDrawn = !isVector(keyUSize) || (isVector(keyUSize) && isVerticalKey);

                if (isDrawn) {
                    keyAreaXSize = keyAreaXSizes[rowNum][colNumber];
                    keyAreaX = keyAreaXPositions[rowNum][colNumber];

                    //Need to position rows top to bottom so subtract the Y position of the row from the plate width. Also subtract
                    //row size because cubes (representing key area) are drawn from bottom left so have to account for the size of the row
                    yRowSize = yRowSizes[rowNum];
                    keyAreaY = plateWidth - keyAreaYPositions[rowNum] - yRowSize;
                    echo(str("RowNumber: ", rowNum, ", ColumnNumber: ", colNumber, ", Key U Size: ", keyUSize, ", Key Area X Size: ", keyAreaXSize, ", YRowSize: ", yRowSize, ", X Position: ", keyAreaX, ", Y Position: ", keyAreaY));

                    //visualModeOn block is just for visualization of the keyboard layout
                    if (visualModeOn) {
                        keyAreaYSize = isVerticalKey ? 2 * 1uSize : 1uSize;
                        keyArea(keyAreaXSize, keyAreaYSize, colNumber, [keyAreaX, keyAreaY, 0]);
                        //Need to center the visualization of the key cap in the keyArea in the X and Y axis
                        //Just centering an object in an arbitrary area but taking into account the position of each keycap first
                        keyCapX = keyAreaX + (keyAreaXSize / 2 - (keyAreaXSize - deltaFromKeyArea) / 2);
                        keyCapY = keyAreaY + ((yRowSize) / 2 - (yRowSize - deltaFromKeyArea) / 2);
                        keyCap(keyAreaXSize, keyAreaYSize, position = [keyCapX, keyCapY, keyAreaHeight]);
                    } else {
                        //See if this key requires a stabilizer, the return value will be non-zero if it does
                        stabDistance = stabilizerDistance(isVerticalKey ? 2 : keyUSize);

                        if (stabDistance == 0) {
                            //This is for a normal switch hole that doesn't require a stabilizer
                            switchHoleX = keyAreaX + (keyAreaXSize / 2 - adjustedSwitchHoleSize / 2);
                            switchHoleY = keyAreaY + (yRowSize / 2 - adjustedSwitchHoleSize / 2);
                            bottomCutoutLength = adjustedSwitchHoleSize + switchClipAreaSize;
                            bottomCutoutWidth = adjustedSwitchHoleSize + switchClipAreaSize;
                            position = [switchHoleX, switchHoleY, 0];
                            translate(position) switchHole(length = adjustedSwitchHoleSize, width = adjustedSwitchHoleSize, stabDistance = stabDistance, bottomCutoutLength = bottomCutoutLength, bottomCutoutWidth = bottomCutoutWidth);
                        } else {
                            //This else handles keys that require a stabilizer. For PCB mounted stabilizers we just make the hole long enough to fit the stabilizers. 
                            //The length of a hole that requires a stabilizer is the stab distance from the datasheet plus one stab width plus a hardcoded 2 units
                            //to make sure the stab will fit and not be pushed cock-eyed (especially if the case is painted, the paint will add thickness)
                            length = stabilizerType == "pcb" ? (stabDistance + adjustedStabHoleLength + 2) : adjustedSwitchHoleSize;
                            width = adjustedSwitchHoleSize;
                            bottomCutoutLength =  stabDistance + adjustedStabHoleLength + switchClipAreaSize; 
                            bottomCutoutWidth = width + switchClipAreaSize;
                            echo(str("Stabilizer hole, Length: ", length, " Width: ", width));
                            switchHoleX = keyAreaX + (keyAreaXSize / 2 - length / 2);

                            //The vertical key stuff is a little confusing, basically yRowSize is always 1u (for rows that aren't just blank space), vertical 
                            //keys simply span two rows, So in the Y axis it needs to be centered in a 2u area. Vertical keys are 1u in the X so nothing 
                            //special has to happen
                            switchHoleY = isVerticalKey ? keyAreaY + ((yRowSize * 2 ) / 2 - width / 2) : keyAreaY + (yRowSize / 2 - width / 2);
                            rotation = isVerticalKey ? [0, 0, 90] : [0, 0, 0]; 
                            point = isVerticalKey ? [length / 2, width / 2] : [0, 0, 0];

                            //rotateAboutPoint only does something for vertical keys, for non vertical keys rotation is [0, 0, 0]
                            //For vertical keys we want to rotate about the center of the switch key hole, to accomplish that we need to move that point to 
                            //the origin, then rotate, then move it back where it was, that is what the "rotateAboutPoint()" module does
                            position = [switchHoleX, switchHoleY, 0];
                            translate(position) rotateAboutPoint(rotation, point) 
                                switchHole(length = length, width = width, stabDistance = stabDistance, bottomCutoutLength = bottomCutoutLength, bottomCutoutWidth = bottomCutoutWidth);
                        }
                    }
                }
            }
        }
    }
}

module switchHole(length, width, stabDistance = 0, bottomCutoutLength = 0, bottomCutoutWidth = 0) {
    cube([length, width, plateThickness + 1]);

    x = length / 2 - bottomCutoutLength / 2;
    y = width / 2 - bottomCutoutWidth / 2;
    if (bottomCutouts) {
        //This is a cutout on the bottom of the plate so the thickness of the area the switch clips into is a smaller size (1.5 mm by default) 
        //but the rest of the plate is the configured thickness of the plate
        translate([x, y, -switchClipAreaThickness]) cube([bottomCutoutLength, bottomCutoutWidth, plateThickness]);
    }

    needsStablizers = stabDistance > 0;
    if (needsStablizers) {
        //Both PCB and plate mounted stabs get this extra cutout on the bottom of the plate (if bottomCutouts are wanted)
        if (bottomCutouts) {
            translate([x, y, -switchClipAreaThickness]) extraStabilizerCutout();
        }

        if (stabilizerType == "plate") {
            //stabDistance is the distance between centers of the stab holes
            stabsTotalLength = adjustedStabHoleLength + stabDistance;
            stabX = length / 2 - stabsTotalLength / 2;
            stabY = (width / 2 - adjustedStabHoleWidth / 2) - 0.9; //magic value to get plate mount stabs and swith to line up
            echo("Stab Distance: ", stabDistance, "StabsTotalLength ", stabsTotalLength, "StabX: ", stabX, ", StabY: ", stabY);
            translate([stabX, stabY, -switchClipAreaThickness]) plateMountedStabCutouts(stabDistance);
        }
    }

    module extraStabilizerCutout() {
        //If this key needs a stabilizer just remove the border between keys on the bottom, this makes room for stabilizers, 
        //just chopping it off with a cube
        translate([0, -cutoutSize + 0.01, 0]) cube([bottomCutoutLength, cutoutSize, plateThickness]);
        translate([0, bottomCutoutWidth - 0.01, 0]) cube([bottomCutoutLength, cutoutSize, plateThickness]);
    }

    module plateMountedStabCutouts(distance) {
        thickness = plateThickness + 2;
        dimension = [adjustedStabHoleLength, adjustedStabHoleWidth, thickness]; 
        cube(dimension);
        translate([distance, 0, 0]) cube(dimension);
        gapWidth = 8;
        //A gap for the wire for plate mounted stabs
        gapX = adjustedStabHoleLength / 2;
        gapY = adjustedStabHoleWidth / 2 - gapWidth / 2;
        translate([gapX, gapY, 0]) cube([distance, gapWidth, thickness]);
    }
}

module topMountPlateScrewHoles() {
    for (position = [0 : len(screwHolePositions) - 1]) {
        x = screwHolePositions[position][0];
        y = screwHolePositions[position][1];
        z = -1;
        translate([x, y, z]) topMountPlateScrewHole(); 
    }

    module topMountPlateScrewHole() {
        cylinder(d = adjustedScrewDiameter, h = plateThickness + 10);
        translate([0, 0, plateThickness - (counterSinkDepth / 2) + 0.01]) counterSink(); 

        module counterSink() {
            cylinder(d = adjustedScrewHeadDiameter, h = counterSinkDepth);
        }
    }
}