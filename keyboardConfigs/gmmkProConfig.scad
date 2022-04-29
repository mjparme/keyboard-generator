layout = [
    //Function keys
    [1, ["vs", 0.25], 1, 1, 1, 1, ["vs", 0.25], 1, 1, 1, 1, ["vs", 0.25], 1, 1, 1, 1, ["vs", 0.25], 1],
    ["hs", 0.25], 
    //Number row
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, ["vs", 0.25], 1],    
    //Qwerty Row
    [1.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, ["vs", 0.25], 1],    
    //Home row
    [1.75, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2.25, ["vs", 0.25], 1],
    //Shift key row
    [2.25, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.75, ["vs", 1.25], 1],

    //This gets tricky here, arrow keys are offset so setting a negative hs prior to next rows to pull them up

    //Up arrow -- if we didn't have the negative hs here then the up arrow key would be in a row all
    //by itself, there is no particular support needed for negative hs values, its just how the math works
    //in the list comprehension
    ["hs", -0.75], 
    [["vs", 14.0], 1],

    //Space bar row
    ["hs", -0.25], 
    [1.25, 1.25, 1.25, 6.25, 1, 1, 1],   

    //Left, down, right arrow key
    ["hs", -0.75], 
    [["vs", 13.0], 1, 1, 1]    
];

printOrientation = false;
visualModelOn = false;
PART = "plate";
caseType = "integrated";
includePlateScrewHoles = false;
stabilizerType = "plate";