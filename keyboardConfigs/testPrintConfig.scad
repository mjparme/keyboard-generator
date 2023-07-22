//A small config with a couple of normal holes, hole that take stabilizers, and a vertical key so 
//hole slop can be determined for 3d printing. Although might be handy for cnc too.
layout = [
    //[["vs", 1], 1, 1, 1],
    [["vs", 1], 1],
    [["vk"], 2.75]
];

PART = "plate";
caseType = "integrated";
switchHoleSlop = 0.3;
plateThickness = 5;
printOrientation = false;
numberOfHolesHorizontalEdges = 3;
includePlateScrewHoles = false;
//Good values to use for plate mounted stabs
stabHoleLength = 7.92;
stabHoleWidth = 12.1;
caseWallThickness = 6;
caseFloorThickness = 4;
controllerLength = 17.9;
controllerWidth = 33.5;
percentSlope = 10;
roundedCorners = true;
roundedRadius = 2;
stabilizerType = "plate";

//The hole is made wide enough to extend through the back wall of the case based on caseWallThickness
usbHoleLength = 10;

//The height (z-axis dimension) of the hole use to access the usb connector. Make sure the head of the USB cable can fit
usbHoleHeight = 5;

//visualModeOn = false;
//switchHolesOnly = true;
//edgePadding = 0;
//bottomCutouts = false;