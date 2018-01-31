#! /usr/bin/env python
""" Generate challenge and solution environments 

This script will generate the blockquote environments
for challenges and solutions.  The start of each challenge/solution should 
be maked with a level two heading.  The end of the challenge/solution should
be marked with the appropriate challenge/solution blockquote end. For example

Here's some lesson

## Challenge title

What's the answer to life the universe and everything?

## Solution title

42

{: .solution}
{: .challenge}

This script will apply markdown blockquotes ">" as required

"""

import sys
import re


def markblock(inlist, blocktype,  startmarker=r'^##'):
    """ "> "ise a block of text from startmarker to endmarker """
    outlist = inlist[:] 
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

# Reverse lines
lesson = lesson[::-1]


# Run function on {: .solution}
# This must be run first as it ends up a 2nd level blockquote
lesson = markblock(lesson, r"^\{: \.solution\}")
# Ordering of remaining blockquotes is arbitary - they are all 
# level 1
lesson = markblock(lesson, r"^\{: \.challenge\}")
lesson = markblock(lesson, r"^\{: \.callout\}")

# Put lines back in the correct order
lesson = lesson[::-1]

# Output file
outfile.writelines(lesson)




