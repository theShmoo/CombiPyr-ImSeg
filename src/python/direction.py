DIRECTIONS = ["N", "E", "S", "W"]
DIRECTION_CHANGE = {"N": (0, -1), "E": (1, 0), "S": (0, 1), "W": (-1, 0)}
CW = [0, 1, 2, 3]
CCW = [0, 3, 2, 1]


def getOppositeDirection(direction):
    assert direction in DIRECTIONS
    pos = DIRECTIONS.index(direction)
    opp = (pos + 2) % len(DIRECTIONS)
    return DIRECTIONS[opp]


def getNextDirection(direction):
    assert direction in DIRECTIONS
    pos = DIRECTIONS.index(direction)
    n = (pos + 1) % len(DIRECTIONS)
    return DIRECTIONS[n]


def getPrevDirection(direction):
    assert direction in DIRECTIONS
    pos = DIRECTIONS.index(direction)
    n = (pos + 1) % len(DIRECTIONS)
    return DIRECTIONS[n]


def getPositionChange(x_start, y_start, direction):
    (x, y) = DIRECTION_CHANGE[direction]
    return (x_start + x, y_start + y)


def getValuesInDictionaryInCW(dictionary):
    ret = []
    for i in CW:
        k = DIRECTIONS[i]
        if k in dictionary.keys():
            ret.append(dictionary[k])
    return ret


def getValuesInDictionaryInCCW(dictionary):
    ret = []
    for i in CCW:
        k = DIRECTIONS[i]
        if k in dictionary.keys():
            ret.append(dictionary[k])
    return ret
