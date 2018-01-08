#! /usr/bin/env python
""" Generate challenge and solution environments 

This script will generate the blockquote environments
for challenges and solutions.

"""

import sys
import re

if len(sys.argv) == 1:
    print ("Using stdin")
    infile = sys.stdin
    outfile = sys.stdout
elif len(sys.argv) == 3:
    print ("Reading files")
    infile = open(sys.argv[1])
    outfile = open(sys.argv[2], "w")
else:
    print("Must supply input *and* output files, or use STDIN/OUT")

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
        if re.search(blocktype, l) and \
            not(re.search(r"^>", outlist[i+1])):
                inblock = True

        if linessinceblock >= 1 :
            outlist[i] = "> " + l

        if inblock:
            linessinceblock = linessinceblock + 1

        if re.search(startmarker, l) :
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




