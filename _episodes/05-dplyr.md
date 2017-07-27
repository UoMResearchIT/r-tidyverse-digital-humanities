---
title: Manipulating tibbles with dplyr
teaching: 40
exercises: 15
questions:
- "How can I manipulate tibbles without repeating myself?"
objectives:
- " To be able to use the six main `dplyr` data manipulation 'verbs' with pipes."
keypoints:
- "Use the `dplyr` package to manipulate tibbles."
- "Use `select()` to choose variables from a tibbles."
- "Use `filter()` to choose data based on values."
- "Use `group_by()` and `summarize()` to work with subsets of data."
- "Use `mutate()` to create new variables."
source: Rmd
---



We used the `readr` package to load tabular data into a tibble within R.  The `readr` package is part of a family of packages known as the   [tidyverse](http://tidyverse.org/).  As with `readr`, much of of the functionality of the `tidyverse` already exists in base R, or in other libraries.  What differentiates the tidyverse from a mixture of base R and ad-hoc libraries is that it its packages are designed to work well togeher.  They provide a modern and streamlined approach to data-analysis, and deal with some of the idiosyncracies of base R.

If yuu are using a university PC the tidyverse should already be installed.  If not, it can be installed like any other R package:


~~~
install.packages("tidyverse")
~~~
{: .r}

We load the core libraries in the tidyverse with:


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

There are other [libraries included](https://github.com/tidyverse/tidyverse) but these are less widely used, and must be loaded manually if they are required.  We won't cover most of these in the course. 

Let's dive in and look at how we can use the tidyverse to analyse and plot data from the [gapminder data](https://www.gapminder.org/).   Download the csv data from _xxx_, and take a look at it using a text editor such as notepad.   The first line contains variable names, and values are separated by commas.  Each record starts on a new line. 

We will discuss loading other data formats later, and how to "tidy" data that isn't in a suitable form for analysis.

We use the `read_csv()` function to load data from a comma separated file:



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

> ## Setting column types
> 
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

In contrast to R's data frame, only a small subset of the data are shown.  We can also look at the data via the "Environment" panel in RStudio (by default this is one of the tabs in the top right window); clicking the name of the data-set (or the table icon to the right) will show the data.  C:w
licking the arrow icon to the left of the name will show the attributes of the data-set.

## Manipulating data frames

Manipulation of dataframes means many things to many researchers, we often
select certain observations (rows) or variables (columns), we often group the
data by a certain variable(s), or calculating sumary statistics. 

## The `dplyr` package

The  [`dplyr`](https://cran.r-project.org/web/packages/dplyr/dplyr.pdf)
package is part of the tidyverse.  It provides a number of very useful functions for manipulating dataframes
in a way that will reduce the above repetition, reduce the probability of making
errors, and probably even save you some typing. As an added bonus, you might
even find the `dplyr` grammar easier to read.

We will cover:

1. selecting variables with `select()`
2. subsetting observations with `filter()`
3. grouping observations with `group_by()`
4. generating summary statistics using `summarize()`
5. generating new variables using `mutate()`
6. chaining operations together using pipes `%>%` 

## Loading dplyr

dplyr is loaded as part of the tidyverse.  It can also be loaded on its own, using:


~~~
library("dplyr")
~~~
{: .r}

## Using select()

If, for example, we wanted to move forward with only a few of the variables in
our dataframe we use the `select()` function. This will keep only the
variables you select.


~~~
year_country_gdp <- select(gapminder,year,country,gdpPercap)
~~~
{: .r}

![](../fig/13-dplyr-fig1.png)

## Using pipes and dplyr

The pipe operator ` %>% ` lets us pipe the output of one command into the next.  
This allows us to build up a data-processing pipeline.  This approach has several advantages:

* We can build the pipeline piecemeal - building the pipeline step-by-step is easier than trying to 
perform a complex series of operations in one go
* It is easy to modify and reuse the pipeline
* We don't have to make temporary tibbles as the analysis progresses
* Although we don't cover it in this course, dplyr can interact with SQL databases; this can be very useful if we are working with data-sets that are too large to load in memory.

> ## Pipelines and the shell
>
> If you're familiar with the Unix shell, you may already have used pipes to
> pass the output from one command to the next.  The concept is the same, except
> we use the `|` character rather than R's pipe operator ` %>% `
{: .callout}


> ## Keyboard shortcuts and getting help
> 
> The pipe operator can be tedious to type.  In Rstudio pressing `ctrl+shift+m` under
> Windows / Linux will insert the pipe operator.  On the mac, use xxxx.
>
> We can use tab completion to complete variable names when entering commands.
> This saves typing and reduces the risk of error.
> 
> RStudio includes a helpful "cheat sheet", which summarises the main functionality
> and syntax of `dplyr` and `tidyr` (covered in the next lesson).  This can be accessed via the
> help menu --> cheatsheets --> data manipulation with dplyr, tidyr 
{: .callout}

Let's rewrite the previous command using the pipe operator:


~~~
year_country_gdp <- gapminder %>% select(year,country,gdpPercap)
~~~
{: .r}

To help you understand why we wrote that in that way, let's walk through it step
by step. First we summon the gapminder dataframe and pass it on, using the pipe
symbol `%>%`, to the next step, which is the `select()` function. In this case
we don't specify which data object we use in the `select()` function since in
gets that from the previous pipe. 

## Using filter()

If we now wanted to move forward with the above, but only with European
countries, we can combine `select` and `filter`


~~~
year_country_gdp_euro <- gapminder %>%
    filter(continent=="Europe") %>%
    select(year,country,gdpPercap)
~~~
{: .r}

> ## Challenge 1
>
> Write a single command (which can span multiple lines and includes pipes) that
> will produce a dataframe that has the African values for `lifeExp`, `country`
> and `year`, but not for other Continents.  How many rows does your dataframe
> have and why?
>
> > ## Solution to Challenge 1
> >
> >~~~
> >year_country_lifeExp_Africa <- gapminder %>%
> >                            filter(continent=="Africa") %>%
> >                            select(year,country,lifeExp)
> >~~~
> >{: .r}
> {: .solution}
{: .challenge}

As with last time, first we pass the gapminder dataframe to the `filter()`
function, then we pass the filtered version of the gapminder dataframe to the
`select()` function. **Note:** The order of operations is very important in this
case. If we used 'select' first, filter would not be able to find the variable
continent since we would have removed it in the previous step.

## Generating new variables

The `mutate()` function lets us add new variables to our tibble.  It will often be the case that these are variables we derive from existing variables in the data-frame. 

As an example, the gapminder data contains the population of each country, and its gdp per capita.  We can use this to calculate the total gdp of each country:


~~~
gapminder_totalgdp <- gapminder %>% 
  mutate(gdp = gdpPercap * pop)
~~~
{: .r}

*Introduce lagging and leading variables, to do % change?  Or ranking countries?*

## Calculating summary statistics

We often wish to calculate a summary statistic (the mean, standard deviation, etc.)
for a variable.  We frequently want to calculate a separate summary statistic for several
groups of data (e.g. the experiment and control group).    We can calculate a summary statistic
for the whole data-set using the dplyr's `summarise()` function:


~~~
gapminder %>% 
  filter(year == 2007) %>% 
  summarise(meanlife = mean(lifeExp), medianlife = median(lifeExp))
~~~
{: .r}



~~~
# A tibble: 1 x 2
  meanlife medianlife
     <dbl>      <dbl>
1 67.00742    71.9355
~~~
{: .output}

To generate summary statistics for each value of another variable we use the 
`group_by()` function:


~~~
gapminder %>% 
  filter(year == 2007) %>% 
  group_by(continent) %>% 
  summarise(meanlife = mean(lifeExp), medianlife = median(lifeExp))
~~~
{: .r}



~~~
# A tibble: 5 x 3
  continent meanlife medianlife
      <chr>    <dbl>      <dbl>
1    Africa 54.80604    52.9265
2  Americas 73.60812    72.8990
3      Asia 70.72848    72.3960
4    Europe 77.64860    78.6085
5   Oceania 80.71950    80.7195
~~~
{: .output}

> ## Challenge 2
>
> Calculate the average life expectancy in each continent, for each year.
>
> ## Solution to Challenge 2
> >
> >~~~
> > lifeExp_bycontinentyear <- gapminder %>% 
> >    group_by(continent, year) %>% 
> >   summarise(mean_lifeExp = mean(lifeExp))
> >~~~
> >{: .r}
> {: .solution}
{: .challenge}

## count() and n()

A very common operation is to count the number of observations for each
group. The `dplyr` package comes with two related functions that help with this.

For instance, if we wanted to check the number of countries included in the
dataset for the year 2002, we can use the `count()` function. It takes the name
of one or more columns that contain the groups we are interested in, and we can
optionally sort the results in descending order by adding `sort=TRUE`:


~~~
gapminder %>%
    filter(year == 2002) %>%
    count(continent, sort = TRUE)
~~~
{: .r}



~~~
# A tibble: 5 x 2
  continent     n
      <chr> <int>
1    Africa    52
2      Asia    33
3    Europe    30
4  Americas    25
5   Oceania     2
~~~
{: .output}

If we need to use the number of observations in calculations, the `n()` function
is useful. For instance, if we wanted to get the standard error of the life
expectency per continent:


~~~
gapminder %>%
    group_by(continent) %>%
    summarize(se_pop = sd(lifeExp)/sqrt(n()))
~~~
{: .r}



~~~
# A tibble: 5 x 2
  continent    se_pop
      <chr>     <dbl>
1    Africa 0.3663016
2  Americas 0.5395389
3      Asia 0.5962151
4    Europe 0.2863536
5   Oceania 0.7747759
~~~
{: .output}

## Using mutate()
*Make this an exercise? - combining summary stats and mutate*

We can also create new variables prior to (or even after) summarizing information using `mutate()`.


~~~
gdp_pop_bycontinents_byyear <- gapminder %>%
    mutate(gdp_billion=gdpPercap*pop/10^9) %>%
    group_by(continent,year) %>%
    summarize(mean_gdpPercap=mean(gdpPercap),
              sd_gdpPercap=sd(gdpPercap),
              mean_pop=mean(pop),
              sd_pop=sd(pop),
              mean_gdp_billion=mean(gdp_billion),
              sd_gdp_billion=sd(gdp_billion))
~~~
{: .r}

## Connect mutate with logical filtering: ifelse

*Not sure about this example - would ideally use if_else, but cannot for 1st one
since it returns NA for false.*

When creating new variables, we can hook this with a logical condition. A simple combination of 
`mutate()` and `ifelse()` facilitates filtering right where it is needed: in the moment of creating something new.
This easy-to-read statement is a fast and powerful way of discarding certain data (even though the overall dimension
of the data frame will not change) or for updating values depending on this given condition.


~~~
## keeping all data but "filtering" after a certain condition
# calculate GDP only for people with a life expectation above 25
gdp_pop_bycontinents_byyear_above25 <- gapminder %>%
    mutate(gdp_billion = ifelse(lifeExp > 25, gdpPercap * pop / 10^9, NA)) %>%
    group_by(continent, year) %>%
    summarize(mean_gdpPercap = mean(gdpPercap),
              sd_gdpPercap = sd(gdpPercap),
              mean_pop = mean(pop),
              sd_pop = sd(pop),
              mean_gdp_billion = mean(gdp_billion),
              sd_gdp_billion = sd(gdp_billion))

## updating only if certain condition is fullfilled
# for life expectations above 40 years, the gpd to be expected in the future is scaled
gdp_future_bycontinents_byyear_high_lifeExp <- gapminder %>%
    mutate(gdp_futureExpectation = ifelse(lifeExp > 40, gdpPercap * 1.5, gdpPercap)) %>%
    group_by(continent, year) %>%
    summarize(mean_gdpPercap = mean(gdpPercap),
              mean_gdpPercap_expected = mean(gdp_futureExpectation))
~~~
{: .r}

