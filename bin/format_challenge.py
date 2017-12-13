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


def markblock(inlist, blocktype,  startmarker=r'^##'):
    """ "> "ise a block of text from startmarker to endmarker """
    outlist = inlist[:] 
    # If we match the blocktype
    # We need to check if the next line is already "> "ed
    linessinceblock = 0
    inblock = False
    for i,l in enumerate(outlist):
#        print(l)
        if re.search(blocktype, l):
            print("*** Found " + blocktype)
            print("**** " + outlist[i+1])
            if not(re.search(r"^>", outlist[i+1])):
                print("*** Not already indented")
                inblock = True
            else:
                print("*** Already indented")


       
        if linessinceblock == 1:
            if blocktype == "^{: .challenge}" and re.search("^> ",l):
                print "*** Found  formatted"
                print(l)

        if linessinceblock >= 1 :
            outlist[i] = "> " + l

        if inblock:
            linessinceblock = linessinceblock + 1

        if re.search(startmarker, l) :
            print("*** Found startmarker")
            inblock = False
            linessinceblock = 0

    return outlist

        
# Run function on {: .solution}
lesson = markblock(lesson, r"^\{: \.solution\}")
# Run function on {: .challenge}
lesson = markblock(lesson, r"^\{: \.challenge\}")

lesson = lesson[::-1]
# Output file
outfile.writelines(lesson)




