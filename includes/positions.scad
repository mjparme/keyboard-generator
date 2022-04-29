/*
    This file contains the list comprehensions that examine the layout vector and calculates sizes and locations of everything.
    The magic is in this file and everything else pretty much just draws stuff in the locations calculated in this file.
*/

//List comprehension that calculates the size of each key in the X axis. If a position contains a vector it is either vertical blank
//space or a vertical key. Checking for being a vector is using a heuristic that could break in a future version of OpenSCAD, it 
//is using a dirty hack rather than using a language feature
keyAreaXSizes = [ for (rowNum = [ 0 : len(layout) - 1 ]) [
                        for (colNum = [ 0 : len(layout[rowNum]) - 1])
                            if (layout[rowNum][0] == "hs") (
                                //For horizontal space just need to put hs in the vector, when row heights are calculated it is a marker
                                //to let that list comprehension know to go to the layout to get the usize of this horizontal space
                                "hs"
                            ) else if (isVector(layout[rowNum][colNum])) (
                                if (layout[rowNum][colNum][0] == "vs") (
                                    //This is vertical space, the 2nd position in the vector indicates the uSize of the space
                                    layout[rowNum][colNum][1] * 1uSize
                                ) else if (layout[rowNum][colNum][0] == "vk") (
                                    //Vertical keys can only be 1u in the X direction
                                    1uSize 
                                )  
                            ) else (
                                layout[rowNum][colNum] * 1uSize
                            ) 
                    ]
                ];

//A list comprehension using a recursive function as its expression to calculate the position of each key, the recursive function
//is needed because the position of a key depends on the position of all keys before it in the row
//Don't calcluate rows that start with "hs", just there to add space between rows, so only care about it when calculating y positions
keyAreaXPositions = [ for (rowNum = [ 0 : len(layout) - 1 ]) [
                            for (colNum = [ 0 : len(layout[rowNum]) - 1]) (
                                //Rows of horizontal space have no need for x positions, so no need to calculate anything
                                if (keyAreaXSizes[rowNum][0] == "hs") (
                                    0
                                ) else (
                                    vectorPositionSum(vector = keyAreaXSizes[rowNum], maxPosition = colNum) + edgePadding
                                )
                            )
                        ]
                    ];

//There is only one size per row in the y axis, unlike x sizes which has a per key size. Note, that a vertical key doesn't 
//change a row's size in the y-axis, a vertical key simply spans 2 rows
yRowSizes = [ for (rowNum = [ 0 : len(layout) - 1 ]) 
                    if (layout[rowNum][0] == "hs") (
                        layout[rowNum][1] * 1uSize
                    ) else (
                        1uSize
                    )
            ] ;

//The y position of a row depends on the y position of all rows before it including uSize of blank rows
keyAreaYPositions = [ for (colNum = [ 0 : len(yRowSizes) - 1]) vectorPositionSum(vector = yRowSizes, maxPosition = colNum) + edgePadding];

//The width of the plate is the last Y position plus its size along the y-axis plus any configured edge padding
plateWidth = keyAreaYPositions[len(keyAreaYPositions) - 1] + yRowSizes[len(yRowSizes) - 1] + edgePadding;

//List comprehension that calculates the lengths of the rows, a row length is the x position of the last key plus that keys 
//size, (size is: 1uSize * keys u size). Won't handle the special case of the rows in the layout that just add horizontal 
//space since they have 0 length so won't matter in determining longest row.
//The row lengths are used for determining longest row so we know the length of the plate
//Also need to support the fact the last element in a row can be a vector with vk in it, if so use 1uSize as its size since 
//for now we are only supporting vertical keys of 1u size in the X direction
rowLengths = [ for (rowNum = [ 0 : len(keyAreaXPositions) - 1 ]) 
                    let (
                            lastLayoutColumnValue = layout[rowNum][len(layout[rowNum]) - 1],
                            keyXPosition = keyAreaXPositions[rowNum][len(keyAreaXPositions[rowNum]) - 1]       
                        ) 

                        //If the last column value isn't a vector this will be "undef" which evaluates to false
                        //so no need to use our isVector function here
                        if (lastLayoutColumnValue[0] ==  "vk") (
                            keyXPosition + 1uSize
                        ) else (                                
                            keyXPosition + (lastLayoutColumnValue * 1uSize)
                        )
            ];

//Plate length is the longest row plus some edge padding. The length of the last X position in each row is (xPosition + its u size). Just 
//because the X position of the last key is the greatest doesn't mean it is the longest row. Have to also examine the last keys u size. 
//(e.g. a row with a 2u key at the end will be longer than a row with a 1u key at the same x position)
plateLength = maxVectorValue(rowLengths) + edgePadding;

horizontalScrewHolePositions = [ for (position = [ 0 : 1 ]) for (i = [0 : numberOfHolesHorizontalEdges - 1]) 
                        let (startX = caseWallThickness / 2, 
                            y = caseWallThickness / 2,
                            y2 = plateWidth - (caseWallThickness / 2),
                            endX = plateLength - (caseWallThickness / 2),
                            totalDistance = endX - startX,
                            distanceBetweenHoles = totalDistance / (numberOfHolesHorizontalEdges - 1),
                            x = startX + i * distanceBetweenHoles
                            )

                            if (position == 0) (
                                //Bottom horizontal edge holes
                                [x, y]
                            ) else if (position == 1) (
                                //Top horizontal edge holes
                                [x, y2]
                            )
                    ];

verticalScrewHolePositions = [[caseWallThickness / 2, plateWidth / 2], [plateLength - caseWallThickness / 2, plateWidth / 2]]; 
screwHolePositions = concat(horizontalScrewHolePositions, verticalScrewHolePositions);