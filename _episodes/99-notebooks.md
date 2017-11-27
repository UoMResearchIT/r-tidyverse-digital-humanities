---
title: "Combining your code with text"
teaching: 15
exercises: 0
questions:
- "How can I organise my work using a notebook"
objectives:
- "To understand the RMarkdown syntax"
- "To understand how to create and use a notebook"
- "To understand how to use Knitr to write reports"

keypoints:
- "Document what and why, not how."
source: Rmd
---



## Introduction

So far today we've written scripts to load, analyze and plot data.   We've also discussed how to save data and plots.  It can often be useful to combine our analysis and a written explaination of what we've done.    This is different from commenting our code (which we shoudld be doing anyway); instead we're talking about writing up our analyis while doing it.

## Jupyter / Python notebooks 
This is a similar idea to a [Jupyter notebook](http://jupyter.org/), but is integrated within RStudio.
{:.callout}

Let's get started by making a new notebook.  From the `File` menu, choose `New file` and then `Rnotebook`.   A new window will open containing an example notebook.
This produces an example notebook:

FIXME Include screenshot


The notebook includes "chunks" of text, and chunks of R code.   The start and end of an R code region is marked with xxxxx.  Before we go any further, save the notebook using `File`, `Save`. 

Lets preview the notebook.  As the example notebook by pressing <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>K</kbd>.   You should find that a new window pops up containing the results of running the R code chunks in the notebook.   

We can also run the notebook interactively within RStudio.  Press the "Run" button (at the top of the editor window) and choose "Run all" (or press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>R</kbd>).   

We can use notebooks to talk the reader through our analysis process. The reader may be someone else, or our future self.


Let's modify the example notebook to start using our own data.

Demo:

* printing a table
* printing a graph
* hiding the code
* hiding messages
* Markdown formatting - cheatsheet
* Different output formats

## Formatting our text

We can format our notebook using _markdown_.  For example, to make some text bold, we use:

<pre>
_This text is italic._ This text isn't
</pre>
Which will appear as:

_This text is italic._ This text isn't

RStudio has a quick reference quide to common markdown formatting codes. This can be found under "Help", "Markdown quick reference".  There is also a more comprehensive cheat sheet under the help menu, and an even more comprehensive reference guide.

## Controling how our code and graphs are displayed



## More complicated formatting

It is also possible to combine R code and LaTeX text.  This approach is better suited to producing a "static" document, such as a paper, rather than a notebook.  To do this, choose "File", "New", "R Sweave".   R Studio will produce a skelton document. As with notebooks, <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd> will insert a new R code chunk.  To display inline R code use:
<pre>
The cos of 0 is \Sexpr{cos(0)}
</pre>
which will display as "The cos of 0 is 1".

{: .callout}



## Controlling how our R code is run



##  Doing more with Markdown

In this episode we've looked at how to make notebooks, and how to compile these into Word, PDF and HTML files.   We can use a similar approach to produce other types of outputs.  For example, _all_ of this course was written in RStudio.  The slides I used to introduce the course at the start were written as a RMarkdown document.  Each episode of this course is written as an RMarkdown doucment (although the conversion to an HTML page is a little more complex than for the examples we looked at - this is so that the formatting of the challenges etc. works properly).   You can see all of the underlying RMarkdown for this course on [Github](https://github.com/uomresearchit/r-tidyverse-intro/), in the `_episodes_rmd` directory.  

The [RMarkdown gallery](http://rmarkdown.rstudio.com/gallery.html) contains examples of the many different types of document you can produce (some of these may require a newer version of RStudio than the one installed on the PC clusters).

