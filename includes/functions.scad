//Sums up a vector from position 0 up to (but not including) the provided max position
//list -- the vector to derive the sum from
function vectorPositionSum(vector, index = 0, maxPosition, result = 0) = index >= maxPosition ? result : vectorPositionSum(vector, index + 1, maxPosition, result + vector[index]);

//Finds the maximum value in the given vector
function maxVectorValue(vector, index = 0) = (index < len(vector) - 1) ? max(vector[index], maxVectorValue(vector, index + 1)) : vector[index];

//index 0 = 2, 2.25, and 2.75u keys, index 1 = 3u keys, index 2 = 6.25 keys, index 3 = 7u keys, index 4 = 8, 9, and 10u keys
//There doesn't appear to be a formula to calculate these, just hardcodes values from the datasheet
//2.x u keys share stab distance, so using floor to adjust down to 2
function stabilizerDistance(keyUSize) = let (adjustedUSize = floor(keyUSize), stabilizerDistances = [23.88, 38.1, 100.0, 114.3, 133.35])
    adjustedUSize == 2
        ? stabilizerDistances[0]
        : keyUSize == 3
            ? stabilizerDistances[1]
            : keyUSize == 6.25
                ? stabilizerDistances[2]
                : keyUSize == 7
                    ? stabilizerDistances[3]
                    : keyUSize > 7 && keyUSize < 11
                        ? stabilizerDistances[4]
                        : 0;