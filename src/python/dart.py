import direction


class Dart(object):
    """Dart is the object in a graph"""

    _ID = 0

    def __init__(self, direction):
        super(Dart, self).__init__()
        self.direction = direction
        Dart._ID = Dart._ID + 1
        self.dart_id = Dart._ID
        self.from_node = None
        self.to_node = None
        self.next = None

    def getInvolution(self):
        assert self.to_node is not None
        opp_dir = direction.getOppositeDirection(self.direction)
        involution = self.to_node.getOut(opp_dir)
        assert involution is not None
        return involution

    def setFrom(self, node):
        assert self.from_node is None
        self.from_node = node

    def setTo(self, node):
        assert self.to_node is None
        self.to_node = node

    def __repr__(self):
        return str(str(self.dart_id))
