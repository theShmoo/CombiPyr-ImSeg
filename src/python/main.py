from combinatorialmap import CombinatorialMap


def printDirection(direction):
    if direction is "all":
        print ("all directions:")
        printDirection("N")
        printDirection("S")
        printDirection("E")
        printDirection("W")
    else:
        print(direction)
        for n in map.nodes:
            o = n.getOut(direction)
            if o:
                print(o)


def printNumDirection(direction):
    i = 0
    for n in map.nodes:
        o = n.getOut(direction)
        if o:
            i += 1
    print (direction + ": " + str(i))


def printCombination():
    s = "combinations:\n"
    for n in map.nodes:
        s += 'Node %2d (' % n.node_id
        all_out = n.getAllOut()
        for out in all_out[:-1]:
            s += '%s, ' % out.dart_id
        s += str(all_out[-1].dart_id)
        s += ")\n"
    print(s)


def printInvolutions(direction):
    s = "Involutions: \n"
    for dart in map.darts:
        if dart.direction is direction:
            inv = dart.getInvolution()
            s += '%d %d (%s)\n' % (dart.dart_id,
                                   inv.dart_id, inv.direction)
    print(s)


# init here
map = CombinatorialMap()
w = 3
h = 3
map.setSize(w, h)
map.printNodes()
map.printNextDarts()

# printCombination()
# printDirection("all")
# printDirection("E")
# printDirection("W")
# printDirection("S")
# printInvolutions("E");
# printInvolutions("W");
# map.printDarts()
# map.printNextDarts()
