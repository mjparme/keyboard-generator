//This layout has the arrow keys which requires a change to a 1u 0 key in the numpad
//and a 1.75u right shift key so the up arrow can be to the right of it
layout = [
    //Function key row
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    //Number key row
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1],
    //QWERTY row
    [1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, 1, 1, 1],
    //Home row
    [1.75, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2.25, 1, 1, 1, ["vk"]],
    //Shift row
    [2.25, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.75, 1, 1, 1, 1],
    //Space bar row
    [1.25, 1.25, 1.25, 6.25, 1.5, 1.5, 1, 1, 1, 1, 1, ["vk"]]
];

PART = "plate";
printOrientation = true;
caseType = "separate";
includePlateScrewHoles = true;
includeCaseScrewHoles = true;
edgePadding = 8.5;

/*
Ctrl/cmd/alt - 1.25u
SpaceBar - 6.25u
Left Shift - 2.25u
Right Shift - 2.75u
Caps Lock - 1.75u
Tab - 1.5u
Backspace - 2u
Pipe Key - 1.5u
Enter - 2.25
NumPad: +, enter, 0 - 2u
*/