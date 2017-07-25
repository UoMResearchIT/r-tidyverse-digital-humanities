---
title: "Introduction to the tidyverse"
teaching: 20
exercises: 10
questions:
- "How can I load data into a tibble?"
- "How can I filter (subset) data?"
objectives:
- "Objectives will go here"
keypoints:
- "Keypoints will go here"
source: Rmd
---



## EDIT THE VERSION IN 14-DPLYR

In this course we will focus on tabular data - such as data from a spreadsheet or a csv file.  We will focus on manipulating and exploring data using the [tidyverse](http://tidyverse.org/).  This is a collection of packages that are designed to work well together.  Although much of the tidyverse's functionality exists in base R, or in other libraries, the tidyverse provides a more modern and streamlined approach to data-analysis, and deals with some of the idiosyncracies of base R.

We can install the tidyverse like any other R package:


~~~
install.packages("tidyverse")
~~~
{: .r}

And load the core libraries in the tidyverse with:


~~~
library("tidyverse")
~~~
{: .r}



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

There are other libraries included in the tidyverse; these are less widely used, and must be loaded manually if they are required.  These won't be covered in the course. _perhaps include readxl?_

Let's dive in and look at how we can use the tidyverse to analyse and plot data from the [gapminder data](https://www.gapminder.org/).   Download the csv data from _xxx_, and take a look at it using a text editor such as notepad.   The first line contains variable names, and values are separated by commas.  Each record starts on a new line.   We use the `read_csv()` function to load data from a comma separated file:


~~~
gapminder <- read_csv("./data/gapminder-FiveYearData.csv")
~~~
{: .r}



~~~
Parsed with column specification:
cols(
  country = col_character(),
  year = col_integer(),
  pop = col_double(),
  continent = col_character(),
  lifeExp = col_double(),
  gdpPercap = col_double()
)
~~~
{: .output}

As we discussed in [lesson 4]({{ page.root }}/04-data-structures-part1/), variables in R can be character, integer, double, etc.   A tibble (and R's built in equivalent; the data-frame) require that all the values in a particular column have the same data type.  The `read_csv()` function will attempt to infer the data type of each column, and prints the column types it has guessed to the screen.  If the wrong column types have been generated, you can pass the `col_types=` option to `read_csv()`.  

For example, if we wanted to load `pop` as a character string, we would use:


~~~
gapminderPopChar <- read_csv("./data/gapminder-FiveYearData.csv", 
                             col_types = cols(
                               country = col_character(),
                               year = col_integer(),
                               pop = col_character(),
                               continent = col_character(),
                               lifeExp = col_double(),
                               gdpPercap = col_double()
                             ) )
~~~
{: .r}

> # Tip
> Try reading a file using the `read_csv()` defaults (i.e. guessing column types)
> If this fails you can cut and paste the guessed column specification, and modify
> this with the correct column types.  It is good practice to do this anyway; it makes
> the data types of your columns explicit, and will help protect you if the format 
> of your data changes.
{: .callout}


## Viewing data

We can preview our data by typing the name of the tibble into the console:

~~~
gapminder
~~~
{: .r}



~~~
# A tibble: 1,704 x 6
       country  year      pop continent lifeExp gdpPercap
         <chr> <int>    <dbl>     <chr>   <dbl>     <dbl>
 1 Afghanistan  1952  8425333      Asia  28.801  779.4453
 2 Afghanistan  1957  9240934      Asia  30.332  820.8530
 3 Afghanistan  1962 10267083      Asia  31.997  853.1007
 4 Afghanistan  1967 11537966      Asia  34.020  836.1971
 5 Afghanistan  1972 13079460      Asia  36.088  739.9811
 6 Afghanistan  1977 14880372      Asia  38.438  786.1134
 7 Afghanistan  1982 12881816      Asia  39.854  978.0114
 8 Afghanistan  1987 13867957      Asia  40.822  852.3959
 9 Afghanistan  1992 16317921      Asia  41.674  649.3414
10 Afghanistan  1997 22227415      Asia  41.763  635.3414
# ... with 1,694 more rows
~~~
{: .output}

In contrast to R's data frame, only a small subset of the data are shown.  We can also look at the data via the "Environment" panel in RStudio (by default this is one of the tabs in the top right window); clicking the name of the data-set (or the table icon to the right) will show the data.  
Clicking the arrow icon to the left of the name will show the attributes of the data-set.

## Include rest of dplyr lesson here
