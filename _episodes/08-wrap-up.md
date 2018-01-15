---
title: "Writing Good Software"
teaching: 15
exercises: 0
questions:
- "How can I write software that other people can use?"
- "What are the next steps in learning and using R?"
objectives:
- "Describe best practices for writing R and explain the justification for each."
- "To be aware of additioanl resources for learning R"
keypoints:
- "Document what and why, not how."
- "Break programs into short single-purpose functions."
- "Write re-runnable tests."
- "Don't repeat yourself."
- "Be consistent in naming, indentation, and other aspects of style."
source: Rmd
---



## Make code readable

The most important part of writing code is making it readable and understandable.
You want someone else to be able to pick up your code and be able to understand
what it does: more often than not this someone will be you 6 months down the line,
who will otherwise be cursing past-self.

## Documentation: tell us what and why, not how

When you first start out, your comments will often describe what a command does,
since you're still learning yourself and it can help to clarify concepts and
remind you later. However, these comments aren't particularly useful later on
when you don't remember what problem your code is trying to solve. Try to also
include comments that tell you *why* you're solving a problem, and *what* problem
that is. The *how* can come after that: it's an implementation detail you ideally
shouldn't have to worry about.

R Notebooks make it easier to keep your code and analysis together.

## Keep your code modular

Our recommendation is that you should separate your functions from your analysis
scripts, and store them in a separate file that you `source` when you open the R
session in your project. This approach is nice because it leaves you with an
uncluttered analysis script, and a repository of useful functions that can be
loaded into any analysis script in your project. It also lets you group related
functions together easily. It will also make it easier to 
[write an R package](http://r-pkgs.had.co.nz/), if you decide to distribute your
code more widely.

## Break down problem into bite size pieces

When you first start out, problem solving and function writing can be daunting
tasks, and hard to separate from code inexperience. Try to break down your
problem into digestible chunks and worry about the implementation details later:
keep breaking down the problem into smaller and smaller functions until you
reach a point where you can code a solution, and build back up from there.

## Know that your code is doing the right thing

Make sure to test your functions!  We haven't had time to cover testing in 
this course.  The [testthat](https://github.com/hadley/testthat) package makes
testing your code much easier (and even claims to make it "fun").

Another approach
is to test assumptions in your code, and print an error if they are untrue.  For example,
if the inbuilt constant `letters` had been redefined to use the [Italien alphabet](https://en.wikipedia.org/wiki/Italian_orthography), which consists of 21 letters:


~~~
letters <- letters[!(letters %in% c("j","k","x","y"))]

if (length(letters) != 26) {
  stop("Letters is not the expected length.")
}
~~~
{: .language-r}



~~~
Error in eval(expr, envir, enclos): Letters is not the expected length.
~~~
{: .error}

## Don't repeat yourself

Functions enable easy reuse within a project. If you see blocks of similar
lines of code through your project, those are usually candidates for being
moved into functions.

If your calculations are performed through a series of functions, then the
project becomes more modular and easier to change. This is especially the case
for which a particular input always gives a particular output.

## Remember to be stylish

Apply consistent style to your code.

## Final points

That concludes the course. We've only begun to scratch the surface of what you can do with R,
but hopefully the course has taught you enough to begin using R for your data
analysis work, and _how_ to find out more about using R.  

There are a huge number of resources for using and learning R online.  Links to resources related to the course episodes are included in the notes.  Some more general useful resources are:

* [R for Data Science, by Garette Grolemund and Hadley Wickham](http://r4ds.had.co.nz/) - this is the online version of the book with the same title ([the university library has a physical copy](https://www.librarysearch.manchester.ac.uk/primo-explore/fulldisplay?docid=44MAN_ALMA_DS21302877580001631&context=L&vid=MU_NUI&search_scope=BLENDED&tab=local&lang=en_US)).  It's an excellent tutorial on using R for data-science, and uses the tidyverse.
* [R weekly](https://rweekly.org/) - a weekly newsletter about R.  This contains links to lots of example uses of R (typically including full source code).  
* [The John Hopkins Coursera Data Science notes](http://sux13.github.io/DataScienceSpCourseNotes/)
* [Advanced R, by Hadley Wickham](http://adv-r.had.co.nz/) is particularly useful if you are coming to R from another programming language.  It is focussed on base-R rather than the tidyverse, and is a useful reference on the lower-level aspects of R.

*Please* complete the [course feedback survey](http://bit.ly/2xP95Ef).  The material for the course is modified
in response to this; if anything was unclear, or we didn't cover anything you thought 
would be useful please let us know.  We also use the feedback survey to complete the course register!
