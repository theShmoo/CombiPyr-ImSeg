import direction as d


class Node(object):
    """Node of a combinatorial Map with Darts"""

    _ID = 0

    def __init__(self, comb_map, h_pos, w_pos):
        super(Node, self).__init__()
        self.darts_out = {}
        self.darts_in = {}
        self.comb_map = comb_map
        self.h_pos = h_pos
        self.w_pos = w_pos
        Node._ID = Node._ID + 1
        self.node_id = Node._ID

    def addOutgoing(self, dart):
        dart.setFrom(self)
        self.darts_out[dart.direction] = dart
        self.comb_map.darts.append(dart)

    def addIngoing(self, dart):
        dart.setTo(self)
        self.darts_in[dart.direction] = dart

    def calcPermutation(self):
        darts = self.getAllOut()
        next_dart = darts[-1]
        for dart in darts:
            next_dart.next = dart
            next_dart = dart

    def getOut(self, direction):
        if direction in self.darts_out:
            return self.darts_out[direction]
        else:
            return None

    def getIn(self, direction):
        return self.darts_in[direction]

    def getAllOut(self):
        return d.getValuesInDictionaryInCW(self.darts_out)

    def getAllIn(self):
        return self.darts_in.values()

    def getPosition(self):
        return (self.w_pos, self.h_pos)

    def __repr__(self):
        s = str(self.node_id)
        s += " ("
        s += str(self.h_pos) + "," + str(self.w_pos)
        s += "(" + str(self.darts_out) + ")"
        s += ")"
        return s
