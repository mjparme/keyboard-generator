//A visible representation of the area available for a particular key, switch hole position is based on this area, a keycap will be slightly 
//smaller than this area, this is generally only useful for a visual representation, for plate generation only the switch hole position 
//and stablizer position matters
module keyArea(keyAreaXSize, keyAreaYSize, colNumber, position) {
    color = colNumber % 2 == 0  ? "cyan" : "red";
    color(color) translate(position) cube([keyAreaXSize, keyAreaYSize, 2]);
}

//A visible representation of the keycap, it should be slightly smaller than the area available to a key and it should be centered within keyArea
//this is generally only useful for a visual representation, for plate generation only the switch hole position 
//and stablizer position matters
module keyCap(keyAreaXSize, keyAreaYSize = 1uSize, position = [0, 0, -1]) {
    //Make a keycap slightly smaller than the position's available area
    keyCapHeight = 10;
    bottomLength = keyAreaXSize - deltaFromKeyArea;
    bottomWidth = keyAreaYSize - deltaFromKeyArea;
    topLength = bottomLength - 5;
    topWidth = bottomWidth - 5;
    translate(position)
    taperedCube(bottomLength = bottomLength, bottomWidth = bottomWidth, topLength = topLength, topWidth = topWidth, height = keyCapHeight, hollow = false, dimensionType = "outer");
}