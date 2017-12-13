#! /usr/bin/env python
""" Generate challenge and solution environments """

import sys
import re

if len(sys.argv) > 1:
    print "Reading files"
    infile = open(sys.argv[1])
    outfile = open(sys.argv[2], "w")
else:
    print "Using stdin"
    infile = sys.stdin
    outfile = sys.stdout

# Read in file
lesson = infile.readlines()

lesson = lesson[::-1]


def needsformatting(inline, blocktype):
    """ Check if a block is already formatted
    solutions should be at level 2,
    challenged at level 0

    Return True if the line needs formatting """

    


    return True

def markblock(inlist, blocktype,  startmarker=r'^##'):
    """ "> "ise a block of text from startmarker to endmarker """
    outlist = inlist[:] 
    # If we match the blocktype
    # We need to check if the next line is already "> "ed
    linessinceblock = 0
    inblock = False
    alreadyformatted = False
    for i,l in enumerate(outlist):
        print(l)
        if re.search(blocktype, l):
            print("*** Found " + blocktype)
            inblock = True
       
        if linessinceblock == 1:
            if blocktype == "^{: .challenge}" and re.search("^> ",l):
                print "*** Found  formatted"
                alreadyformatted = True

        if linessinceblock >= 1 and not(alreadyformatted):
            outlist[i] = "> " + l

        if inblock:
            linessinceblock = linessinceblock + 1

        if re.search(startmarker, l) and not(inblock):
            print("*** Found startmarker")
            inblock = False
            alreadyformatted = False
            linessinceblock = 0

    return outlist

        
# Run function on {: .solution}
lesson = markblock(lesson, "^{: .solution}")
# Run function on {: .challenge}
lesson = markblock(lesson, "^{: .challenge}")

lesson = lesson[::-1]
# Output file
outfile.writelines(lesson)




