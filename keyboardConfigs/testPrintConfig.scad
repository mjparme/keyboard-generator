//A small config with a couple of normal holes, hole that take stabilizers, and a vertical key so 
//hole slop can be determined for 3d printing. Although might be handy for cnc too.
layout = [
    //[["vs", 1], 1, 1, 1],
    [["vs", 1], 1],
    [["vk"], 2.75]
];

switchHoleSlop = 0.3;
plateThickness = 3;
printOrientation = false;
stabilizerType = "plate";
caseType = "integrated";
numberOfHolesHorizontalEdges = 3;
includePlateScrewHoles = false;
//Good values to use for plate mounted stabs
stabHoleLength = 7.92;
stabHoleWidth = 12.1;
caseWallThickness = 7;
caseFloorThickness = 4;
PART = "case";
controllerLength = 17.9;
controllerWidth = 33.5;