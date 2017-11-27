---
title: "R Packages and Seeking Help"
teaching: 10
exercises: 10
questions:
- "How do I use packages in R?"
- "How can I get help in R?"
objectives:
- "To be able to install packages, and load them into your R session"
- "To be able read R help files for functions and special operators."
- "To be able to seek help from your peers."
keypoints:
- "Use `install.packages()` to install a package from CRAN"
- "Use `help()` to get online help in R."
source: Rmd
---



## R packages

R packages extend the functionality of R.  Over 11,000 packages have been written by others. It's also possible to write your own packages; this can be a great way of disseminating your research and making it useful to others.  A number of useful packages are installed by default with R (are part of the R core distribution). The teaching machines at the University have a number of additional packages installed by default.

We can see the packages installed on an R installation via the "packages" tab in RStudio, or by typing `installed.packages()` at the prompt, or by selecting the "Packages" tab in RStudio.

In this course we will be using packages in the  [tidyverse](https://www.tidyverse.org) to perform the bulk of our plotting and data analysis.   Although we could do most of the tasks without using extra packages, the tidyverse makes it quicker and easier to perform common data analysis tasks.  The tidyverse packages are already installed on the university teaching machines.

## Finding and installing new packages

There are several sources of packages in R; the ones you are most likely to encounter are:

### CRAN

[CRAN](https://cran.r-project.org) is the main repository of packages for R.  All the packages have undergone basic quality assurance when they were submitted.  There are over 11,000 packages in the archive; there is a lot of overlap between some packages.  Working out _what_ the most appropriate package to use isn't always straightforward.   

### Bioconductor

[Bioconductor](https://www.bioconductor.org/) is a more specialised repository, which contains packages for bioinformatics.  Common workflows are provided, and the packages are more thoroughly quality assured.   Because of its more specialised nature we don't focus on Bioconductor in this course.

### Github / personal websites

Some authors distribute packages via [Github](https://www.github.com) or their own personal web-pages.  These packages may not have undergone any form of quality assurance.   Note that many packages have their own website, but the package itself is distributed via CRAN. 

### Finding packages to help with your research

There are various ways of finding packages that might be useful in your research:

* The [CRAN task view](https://cran.r-project.org/web/views/) provides an overview of the packages available for various research fields and methodologies.   

* [rOpenSci](https://ropensci.org/) provides packages for performing open and reproducible science.  Most of these are available from CRAN or Bioconductor.  

* Journal articles should cite the R packages they used in their analysis. 

* [The Journal of Statistical Software](https://www.jstatsoft.org/index) contains peer-reviewed articles for R packages (and other statistical software)

* [The R Journal](https://journal.r-project.org/) contains articles about new packages in R.

### Installing packages

If a package is available on [CRAN](https://cran.r-project.org), you can install it by typing:


~~~
install.packages("packagename")
~~~
{: .language-r}

This will automatically install any packages that the package you are installing depends on.

Installing a package doesn't make the functions included in it available to you; to do this you must use the `library()` function.  As we will be using the tidyverse later in the course, let's load that now:


~~~
library("tidyverse")
~~~
{: .language-r}



~~~
Loading tidyverse: ggplot2
Loading tidyverse: tibble
Loading tidyverse: tidyr
Loading tidyverse: readr
Loading tidyverse: purrr
Loading tidyverse: dplyr
~~~
{: .output}



~~~
Conflicts with tidy packages ----------------------------------------------
~~~
{: .output}



~~~
filter(): dplyr, stats
lag():    dplyr, stats
~~~
{: .output}

> ## Conflicting names
>
> You may get a warning message when loading a package that a function is "masked".  This
> happens when a function name has already been "claimed" by a package that's already 
> loaded.  The most recently loaded function wins. 
> 
> If you want to use the function from the other package, use `packagename::function()`.
> 
{: .callout}

## Reading Help files

R, and every package, provide help files for functions. The general syntax to search for help on any
function, "function_name", from a specific function that is in a package loaded into your
namespace (your interactive R session):


~~~
?function_name
help(function_name)
~~~
{: .language-r}

This will load up a help page in RStudio (or by launching a web browser, or  as plain text if you are using R without RStudio).

Each help page is broken down into sections:

 - Description: An extended description of what the function does.
 - Usage: The arguments of the function and their default values.
 - Arguments: An explanation of the data each argument is expecting.
 - Details: Any important details to be aware of.
 - Value: The data the function returns.
 - See Also: Any related functions you might find useful.
 - Examples: Some examples for how to use the function.

Different functions might have different sections, but these are the main ones you should be aware of.

> ## Tip: Reading help files
>
> One of the most daunting aspects of R is the large number of functions
> available. It would be prohibitive, if not impossible to remember the
> correct usage for every function you use. Luckily, the help files
> mean you don't have to!
{: .callout}

## Special Operators

To seek help on special operators, use quotes:


~~~
?"<-"
~~~
{: .language-r}

## Getting help on packages

Many packages come with "vignettes": tutorials and extended example documentation.
Without any arguments, `vignette()` will list all vignettes for all installed packages;
`vignette(package="package-name")` will list all available vignettes for
`package-name`, and `vignette("vignette-name")` will open the specified vignette.

If a package doesn't have any vignettes, you can usually find help by typing
`help("package-name")`, or `package?package-name`.

> ## Challenge: Vignettes
> 
> Vignettes are often useful tutorials.   We will be using the `dplyr` package
> later in this course, to manipulate tables of data.   List the vignettes availabile 
> in the package.   You might want to take a look at these now, or later when 
> we cover `dplyr`
> 
> > ## Solution
> > 
> > 
> > ~~~
> > vignette(package="dplyr")
> > ~~~
> > {: .language-r}
> > Shows that there are several vignettes included in the package.  The `dplyr` vignette
> > looks like it might be useful later.  We can view this with:
> > 
> > 
> > ~~~
> > vignette(package="dplyr", "dplyr")
> > ~~~
> > {: .language-r}
> {: .solution}
{: .challenge}

## When you kind of remember the function

If you're not sure what package a function is in, or how it's specifically spelled you can do a fuzzy search:


~~~
??function_name
~~~
{: .language-r}
> ## Citing R and R packages
> If you use R in your work you should cite it, and the packages you use. The `citation()` command will return the appropriate citation for R itself.  `citation(packagename)` will provide the citation for `packagename`. 
>
{: .callout}

## When your code doesn't work: seeking help from your peers

If you're having trouble using a function, 9 times out of 10,
the answers you are seeking have already been answered on
[Stack Overflow](http://stackoverflow.com/). You can search using
the `[r]` tag.

If you can't find the answer, there are a few useful functions to
help you ask a question from your peers:


~~~
?dput
~~~
{: .language-r}

Will dump the data you're working with into a format so that it can
be copy and pasted by anyone else into their R session.


## Package versions

Many of the packages in R are frequently updated.  This does mean that code written for one version of a package may not work with another version of the package (or, potentially even worse, run but give a _different_ result).  The `sessionInfo()` command prints information about the system, and the names and versions of packages that have been loaded.  You should include the output of `sessionInfo()` somewhere in your research.  The [packrat package](https://rstudio.github.io/packrat/) provides a way of keeping specific versions of packages associated with each of your projects. 




~~~
sessionInfo()
~~~
{: .language-r}


## Other ports of call

Note that some of these resources use base R, rather than the tidyverse approach taught
in this course.  

* [RStudio cheat sheets](http://www.rstudio.com/resources/cheatsheets/)
* [Quick R](http://www.statmethods.net/)
* [Cookbook for R](http://www.cookbook-r.com/)
