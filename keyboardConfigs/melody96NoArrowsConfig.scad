//This layout removes the arrow keys and instead has a standard 2u 0 key in the num pad
//It stays with the 1.75u right shift key, so there is an extra 1u key next to it to do
//what you want with
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
    [1.25, 1.25, 1.25, 6.25, 1.25, 1.25, 1.25, 1.25, 2, 1, ["vk"]]
];

PART = "plate";
printOrientation = true;
caseType = "separate";
includePlateScrewHoles = true;
includeCaseScrewHoles = true;
edgePadding = 8.5;
plateThickness = 5;
roundedCorners = true;
roundedRadius = 2;

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