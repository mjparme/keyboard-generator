use <./lib/cubes.scad>
use <./lib/connectors.scad>
use <./lib/paths.scad>

//NOTE: In this design "length" refers to x-axis and "width" refers to y-axis (prior to any rotation), "height" or "thickness" refers to z-axis

//The default configuration values, any value in here can be overridden if it is set in a keyboard config (because the keyboard config
//is included after this file). Note: there is no default layout vector, your keyboard config must have a layout vector 
include <commonConfigValues.scad>
$fn = 100;

//Uncomment the keyboard config containing the keyboard to generate. Any variable in commonConfigValues.scad can be overridden in the included configs
include <./keyboardConfigs/testPrintConfig.scad>
//include <./keyboardConfigs/tenkeylessWithFunctionKeysConfig.scad>
//include <./keyboardConfigs/standardKeyboardConfig.scad>
//include <./keyboardConfigs/splitErgonomic-leftConfig.scad>
//include <./keyboardConfigs/splitErgonomic-rightConfig.scad>
//include <./keyboardConfigs/melody96NoArrowsConfig.scad>
//include <./keyboardConfigs/gmmkProConfig.scad>

//************* Includes for organization ***********
include <./includes/positions.scad>
include <./includes/functions.scad>
include <./includes/plate.scad>
include <./includes/visualMode.scad>
include <./includes/case.scad>

//**********Calculated*********
adjustedSwitchHoleSize = switchHoleSize + switchHoleSlop;
adjustedStabHoleLength = stabHoleLength + switchHoleSlop;
adjustedStabHoleWidth = stabHoleWidth + switchHoleSlop;
adjustedScrewDiameter = screwDiameter + screwHoleSlop; 
adjustedScrewHeadDiameter = screwHeadDiameter + screwHoleSlop;

echo("HorizontalScrewHolePositions: ", horizontalScrewHolePositions);
echo("VerticalScrewHolePositions: ", verticalScrewHolePositions);
echo("CombinedScrewHolePositions: ", screwHolePositions);
echo("AdjustedSwitchHoleSize: ", adjustedSwitchHoleSize);
echo("AdjustedStabHoleLength: ", adjustedStabHoleLength);
echo("AdjustedStabHoleWidth: ", adjustedStabHoleWidth);
echo("Layout: ", layout);
echo("keyAreaXSizes: ", keyAreaXSizes);
echo("KeyAreaXPositions: ", keyAreaXPositions);
echo("yRowSizes: ", yRowSizes);
echo("keyAreaYPositions: ", keyAreaYPositions);
echo("RowLengths: ", rowLengths);
echo("PlateAndCaseLength: ", plateLength);
echo("PlateAndCaseWidth: ", plateWidth);
echo("PlateThickness: ", plateThickness);
echo("CaseType: ", caseType);
echo("StabilizerType: ", stabilizerType);
echo("PART: ", PART);

//**********Draw**************
if (PART == "plate") {
    isIntegratedCase = caseType == "integrated";

    //If we have bottom cutouts or integrated case then print orientation is upside down
    isFlipPlate = printOrientation == true && (bottomCutouts == true || isIntegratedCase);
    rotation = isFlipPlate ? [180, 0, 0]: [0, 0, 0];

    //If we rotated the plate then it was rotated about the x axis and it is in a weird postiion
    //put it back so bottom left corner is at the origin, if we didn't rotate then nothing needs to happen 
    //and our position is already 0,0,0 and we will just stay there
    position = isFlipPlate == true ? [0, plateWidth, plateThickness]: [0, 0, 0];

    translate(position) rotate(rotation) union() {
        plate();  
        //For an integrated case the walls are part of the plate
        if (isIntegratedCase) {
            case(subType = "integratedWalls");
        }
    }
} else if (PART == "case") {
    //For an integrated case the caseBottom needs to be rendered as separate part
    if (caseType == "integrated") {
        case(subType = "caseBottom");
    } else {
        //case() with no subType parameter will be the separateCase
        case();
    }
} else {
    echo("Unrecognized PART name, not rendering anything, current PART name: ", PART);
}