/*
    Configuration values used in keyboardGenerator.scad. The values of all parameters in this file can be overridden in the keyboard 
    configuration files.  Any parameter not overridden in the keyboard config files get the value in this file. This file also serves
    as the source of truth for the available configuration parameters. 
*/

//If true will flip the plate upside down if botomCutouts are used since that is print orientation for a plate with bottom cutouts, if 
//false it is not flipped over. Probably should set to true for final rendering, and false when configuring a keyboard. Trying to configure
//a keyboard in print orientation will probably lead to confusion. Has no effet on case orientation. 
printOrientation = false;

//One of "plate" or "case"
PART = "plate"; 
//PART = "case";

//***** Plate Parameters *******
//Distance from center of one key to the next. 19.05 is the value from the Cherry MX data sheet
1uSize = 19.05;

//Size of the hole that contains the switch
switchHoleSize = 14;

//Any additional dimension to add to the hole, a 3d printed plate probably needs some slop because of printer calibration and elephants foot.
//A plate intended to be CNC'd might not need any slop. This is simply added to switchHoleSize so if you need negative slop that is fine 
//as well. You might also need slop if the plate is going to be painted because the thickness of the paint will make the holes slightly smaller.
switchHoleSlop = 0.3;

//Padding around the edge of all the rows and columns
edgePadding = 8.5;

//The thickness of the plate the switch holes will be differenced out of
plateThickness = 5;

//true to include bottom cutouts on the underside of the plate. This makes the area just around the hole on the
//underside be thinner than the rest of the plate (controlled by switchClipAreaThickness and switchClipAreaSize) 
//If the plate should just be plateThickness thick everywhere, set this to false. If you use stabilizers
//and you have a thick plate you probably want this to be true. If you are just doing a 1.5 mm plate you don't 
//need cutouts 
bottomCutouts = true;

//The type of stablizers you are using. One of "pcb" or "plate". 
stabilizerType = "pcb"; 

//The dimension of stablizers, these values come from the cherry MX datasheet, but should be the same for 
//all cherry like stabilizers (if you put the costar hole dimensions here it should work just fine). For
//plate mounted stabs a length of 7.92 and width of 12.1 works well.
stabHoleLength = 6.65;
stabHoleWidth = 12.3; 

//the thickness of the area just around the bottom of the hole, only matters if bottomCutouts is true
switchClipAreaThickness = 1.5;

//The size of the switchClipAreaThickness, it is how far switchClipAreaThickness extends around the hold, 
//only matters if bottomCutous is true 
switchClipAreaSize = 3.5; 

//If you change the value of switchClipAreaSize from 3.5 this value will have to be adjusted, goal is to 
//have the cutout wall disappear for a key that requires a stablizer. 
cutoutSize = 1.3; 

//If you don't want the plate or case and just want the switch holes set this to true. You might want 
//this if you are creating your own plate and/or case and just need the holes to integrate into your 
//design. This will cause the holes to be rendered with the assumption you will diff them out of something.
//If bottomCutous is true then the bottomCutous are also rendered, can set bottomCutouts to false if you
//don't want this. Also, visualModeOn = true has priority over switchHolesOnly i.e. visualModeOn = true 
//and switchHolesOnly = true results in visualMode being rendered.
switchHolesOnly = false;

//******Plate and Case parameters***********
//Whether to round the corners of the plate and case or not, true to round the corners, false otherwise
roundedCorners = true;

//If the corners are rounded what is the radius of the rounding, otherwise ignored
roundedRadius = 4;

//******Case Parameters********
//One of "integrated" or "separate", the integrated type means the case walls is integrated with the plate
caseType = "separate"; 

//Indicates whether to put screw holes in the case, true to include screw holes, false otherwise
includeCaseScrewHoles = true;

//How thick the case walls are (thickness here doesn't refer to Z dimension, this is the only place in the design
//it refers to something other than Z). By default it is the same as edgePadding but if you want a little extra 
//space between switch holes and wall you can make it a little smaller than the edgePadding (1 to 1.5mm smaller works well)
caseWallThickness = edgePadding;

//How how in the Z axis the case will be
caseHeight = 12;

//For a seperate case this is how thick to make the floor. For an integrated case this is how thick to make the case bottom. For an 
//integrated case the screws go up through the bottom so make sure to make the case bottom thick enough to be able to counter-sink
//the screws. 
caseFloorThickness = 3;

//*******Screw Hole Parameters (for plate and case) ******
//true to include screw holes, false otherwise
includePlateScrewHoles = true;

//This is the number of holes on the horizontal edges
numberOfHolesHorizontalEdges = 4; 

//The diameter of the screws that will be used. This should of course be equal to the inner diameter of any heatset 
//inserts being used
screwDiameter = 2.0;

//Any extra dimensions needed to be added to the diameter of the screw holes. It is just added to screwDiameter so negative
//slop is fine as well if you need to make holes slightly smaller. This value is also add to the screwHeadDiameter which is used
//to size the counter sink for the screw head
screwHoleSlop = 1.0;

//The diameter of the screw head. Used to size the counter sink for the screw head
screwHeadDiameter = 4;

//How deep to make the counter sink area. Should be a smidge bigger than the height of the screw head
counterSinkDepth = 2.1;

//The outside diameter of the heatset insert.
heatSetInsertOutsideDiameter = 3.5;

//The height of the heat set inserts, controls the depth of the screw holes
heatSetInsertHeight = 8;

//********* Visual Mode Parameters ***********
//If visual mode is on a visual representation of the keyboard is shown. The colored area is the total area given to key, the 
//switch hole will be centered in this area. Just helps visualizing what the layout will look like. 
visualModeOn = false;

//For visual representation only, has nothing to do with rendered plate, the height of the visual representation of
//the key area. Only matters if visual mode is on.
keyAreaHeight = 2;

//When using visualMode this is how much smaller the visualization of the keycap is than the actual keyAreaXSize, 2 works
//well and there is probably no reason to change it
deltaFromKeyArea = 2;

//********* Electronics related parameters ***************
//The length (x-axis dimension) of the controller
controllerLength = 18.5;

//The width (y-axis dimension) of the controller
controllerWidth = 33.5;

//The height of the walls that will surround the controller
controllerAreaHeight = 3;

//The thickness of the walls that will surround the controller
controllerAreaWallThickness = 3;

//The location in the x-axis where the controller will be located on the bottom of the case
//the controller will be accesible from the rear of the case
controllerXLocation = 15;

//The length (x-axis dimension) of the hole use to access the usb connector. Make sure the head of the USB cable can fit
//The hole is made wide enough to extend through the back wall of the case based on caseWallThickness
usbHoleLength = 14;

//The height (z-axis dimension) of the hole use to access the usb connector. Make sure the head of the USB cable can fit
usbHoleHeight = 10;
cutoutDepth = 2;

//Not supported yet
includeTrrsHole = false;
includeHdmiHole = false;
includeCableHole = false;