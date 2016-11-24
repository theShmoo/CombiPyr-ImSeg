from dart import Dart
from node import Node
import direction


class CombinatorialMap(object):
    """docstring for CombinatorialMap"""

    def __init__(self):
        super(CombinatorialMap, self).__init__()
        self.darts = []
        self.nodes = []
        self.num_darts = 0
        self.num_nodes = 0
        self.width = 0
        self.height = 0

    def setSize(self, width, height):
        self.width = width
        self.height = height
        self.num_darts = 4 * width * height - 2 * width - 2 * height
        self.num_nodes = width * height

        for h in range(0, self.height):
            for w in range(0, self.width):
                node = Node(self, h, w)
                # add outgoing darts if possible
                if h > 0:
                    node.addOutgoing(Dart("N"))
                if h < self.height - 1:
                    node.addOutgoing(Dart("S"))
                if w < self.width - 1:
                    node.addOutgoing(Dart("E"))
                if w > 0:
                    node.addOutgoing(Dart("W"))
                self.nodes.append(node)

        # add ingoing darts if possible
        for n in self.nodes:
            for dart in n.getAllOut():
                (w, h) = direction.getPositionChange(
                    n.w_pos, n.h_pos, dart.direction)
                to_node = self.getNode(h, w)
                oppdir = direction.getOppositeDirection(dart.direction)
                dart_out = to_node.getOut(oppdir)
                assert dart_out is not None
                dart.from_node.addIngoing(dart_out)
            n.calcPermutation()

    def getNode(self, h_pos, w_pos):
        pos = self.width * h_pos + w_pos
        return self.nodes[pos]

    def printNodes(self):
        nodes_str = "nodes:\n"

        for h in range(0, self.height):
            if h > 0:
                nodes_str += "  "
                for w in range(0, self.width):
                    node = self.getNode(h, w)
                    south = node.darts_in["S"].dart_id
                    north = node.darts_out["N"].dart_id
                    nodes_str += '%2d,%2d' % (south, north)
                    if w < self.width - 1:
                        nodes_str += "           "

                nodes_str += "\n"

                for w in range(0, self.width):
                    nodes_str += "    |           "

                nodes_str += "\n"

            for w in range(0, self.width):
                node = self.getNode(h, w)

                if w > 0:
                    east = node.darts_in["E"].dart_id
                    west = node.darts_out["W"].dart_id
                    nodes_str += '%2d,%2d - ' % (west, east)

                # nodes_str += '%5d' % node.node_id
                nodes_str += "    O"

                if w < self.width - 1:
                    nodes_str += " - "

            if h < self.height - 1:
                nodes_str += "\n"

                for w in range(0, self.width):
                    nodes_str += "    |           "

            nodes_str += "\n"

        print(nodes_str)

    def printNodeIdsAndPosition(self):
        matrix = ""
        for i, n in enumerate(self.nodes):
            if i % self.width == 0:
                matrix += "\n"
            matrix += '%2d(%2d,%2d) ' % (n.node_id, n.h_pos, n.w_pos)

        print(matrix)

    def printDarts(self):
        darts_str = "darts: "
        for dart in self.darts[:-1]:
            darts_str += str(dart) + ", "
        darts_str += str(self.darts[-1])
        print(darts_str)

    def printNextDarts(self):
        for dart in self.darts:
            print( '%d %d %d' % (dart.dart_id,dart.next.dart_id,dart.next.dart_id-dart.dart_id ))
