---
layout: page
title: Setup
permalink: /setup/
---
## Files
*We will be using some example data in the lesson.  Download the file from [here]({{ page.root }}/data/r-novice.zip) and extract it to your computer*

## Software
This lesson assumes you have the R and RStudio software installed on your computer. This should already be the case if you are using the University computers.

R can be downloaded [here](https://www.stats.bris.ac.uk/R/).

RStudio is an environment for developing using R.
It can be downloaded [here](https://www.rstudio.com/products/rstudio/download/).
You will need the Desktop version for your computer; scroll to the bottom of the page for links.

The course teaches the [tidyverse](https://www.tidyverse.org), which is a collection of R packages that are designed to make many common data analysis tasks easier.    The computers in G11 already have the tidyverse installed.  If you are using your own laptop *please* install this before the course.  You can do this by starting RStudio, and typing:

```{r}
install.packages("tidyverse")
```

At the `>` prompt in the left hand window of RStudio.   You may be prompted to select a mirror to use; either select one in the UK, or the "cloud" option at the start of the list.

R will download the packages that consitute the tidyverse, and then install them.  This can take some time.  

If you are using a mac you may be prompted whether you wish to install binary or source versions of the packages; you should select binary.

On Linux several of the packages will be compiled from source.  This can take several minutes.  You may find that you need to install additional development libraries to allow this to happen.  

After the installation has completed you should see a message containing

```
** testing if installed package can be loaded
* DONE (tidyverse)
```

## Testing your installation

Type the following commands at the `>` prompt:

```{r}
library(tidyverse)
ggplot(cars, aes(x=speed, y=dist)) + geom_point()
```

(the message about conflicts can be safely ignored)

This should produce a plot in the lower right hand window of RStudio.

If you encounter difficulties installing R, RStudio or the Tidyverse please contact me at david.mawdsley@manchester.ac.uk before the course starts. There is little time to resolve installation problems on the day.

