---
title: Using R Packages
teaching: 15
exercises: 0
questions:
- "How do find packages that will help us with our work?"
objectives:
- "Describe the process of using CRAN to find, and evaluate, suitable packages for our analysis, and work out how to use them" 
keypoints:
- "Keypoints go here"
source: Rmd
---

## Using CRAN 

At the start of the course we showed how to install packages in R, and installed some packages that we've been using in the rest of the course.  In this lesson we will cover finding packages that will be useful in *your* research.

## CRAN

[CRAN](https://cran.r-project.org) is the main repository of packages for R.  All the packages have undergone basic quality assurance when they were submitted.  There are over 10,000 packages in the archive; there is a lot of overlap between some packages.  Working out _what_ the most appropriate package to use isn't always straightforward.   

> ## Research topics
>
> Discuss your area of research with your neighbour, and think about the analyses you might do in R.   We will go through these as a group, and then pick an example to use.
>
{: .challenge}

## Finding packages to help with your research

There are various ways of finding packages that might be useful in your research:


* The [CRAN task view](https://cran.r-project.org/web/views/) provides an overview of the packages available for various research fields.   

* Journal articles should cite the R packages they used in their analysis. 

* [The Journal of Statistical Software](https://www.jstatsoft.org/index) contains peer-reviewed articles for R packages (and other statistical software)

* [The R Journal](https://journal.r-project.org/) contains articles about new packages in R.

* Asking colleagues

## Example

Meta analysis -

Overview of what it is

Assume we've been given some data that we have to meta-analyse.   

[R task view](https://cran.r-project.org/web/views/MetaAnalysis.html) - convenient.  Let's assume we want to fit using the inverse-variance method - 4 packages.  How do we choose?


Look at the package page for each of the 4 packages:

* [epiR](https://cran.r-project.org/web/packages/epiR/index.html)
* [meta](https://cran.r-project.org/web/packages/meta/index.html)
* [metafor](https://cran.r-project.org/web/packages/metafor/index.html)
* [rmeta](https://cran.r-project.org/web/packages/rmeta/index.html)

Any of these packages should be able to do the task we want.  Useful things to look for when deciding:

* Package updated regularly (look at version number, publication date)
* How easy it will be to use -- the reference manual is not a tutorial.  Package vignettes are often tutorials.
* Colleagues' recommendations





