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



In the previous episode we used the `readr` package to load tabular data into a tibble within R.  The `readr` package is part of a family of packages known as the   [tidyverse](http://tidyverse.org/).  The tidyverse packages are designed to work well together; they provide a modern and streamlined approach to data-analysis, and deal with some of the idiosyncrasies of base R.


This loads the most commonly used packages in the tidyverse; we used `readr` in the previous episode.  We will cover all of the other main packages, with the exception of `purrr` in this course. There are other [libraries included](https://github.com/tidyverse/tidyverse) but these are less widely used, and must be loaded manually if they are required; these aren't covered in this course. 

The data we'll be using for the rest of the course is taken from Twitter. The data contains information on how often various new "slang" words were used in each state of the USA, over a period of time.  The data are taken from [GRIEVE, J., NINI, A., & GUO, D. (2017). Analyzing lexical emergence in Modern American English online. English Language and Linguistics, 21(1), 99-127. doi:10.1017/S1360674316000113
](https://www.cambridge.org/core/journals/english-language-and-linguistics/article/analyzing-lexical-emergence-in-modern-american-english-online-1/73E2D917856BE39ACD9EE3789E2BE597).

Let's dive in and look at how we can use the tidyverse to analyse and, in a couple of episodes' time,  plot data from twitter.    At [the start of the course]({{ page.root}}/02-project-intro), you should have copied the file `twitterData.csv` to your `data` directory.     Take a look at it using a text editor such as notepad.   The first line contains variable names, and values are separated by commas.  Each record starts on a new line. 

The data are in what's often referred to as "tidy" format; each observation is on a new line, and each column represents a variable.  This is what's sometimes known as "long" format.   The tidyverse is geared up towards working with data in tidy format.  Often (almost always in fact), your data won't be in the "shape" you need to analyse it. Transforming and cleaning your data is often one of the most time consuming (and frustrating) parts of the analysis process.   For these reasons, and because it's very problem specific we won't spend much time on it today.  I'll mention a few general teachniques and tips at the [end of the course]({{ page.root }}/08-wrap-up).
 

As we did with the [previous episode]({{ page.root }}/03-loading-data-into-R) we use the `read_csv()` function to load the comma separated file. Let's make a new script (using the file menu), and load the tidyverse: (in the previous episode we only loaded `readr`; since we'll be using several packages in the tidyverse, we load them all)


~~~
library("tidyverse")
~~~
{: .language-r}



~~~
── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──
~~~
{: .output}



~~~
✔ ggplot2 3.0.0     ✔ purrr   0.2.5
✔ tibble  1.4.2     ✔ dplyr   0.7.6
✔ tidyr   0.8.1     ✔ stringr 1.3.1
✔ readr   1.1.1     ✔ forcats 0.3.0
~~~
{: .output}



~~~
── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
~~~
{: .output}



~~~
twitterData <- read_csv("./data/twitterData.csv")
~~~
{: .language-r}



~~~
Parsed with column specification:
cols(
  date = col_date(format = ""),
  stateCode = col_character(),
  word = col_character(),
  cases = col_integer(),
  dataDay = col_integer(),
  Region = col_character(),
  totalTokens = col_double(),
  State = col_character()
)
~~~
{: .output}

As we discussed in the [previous episode]({{ page.root }}/03-loading-data-into-R), variables in R can be character, integer, double, etc.   A tibble (and R's built in equivalent; the data-frame) require that all the values in a particular column have the same data type.  The `read_csv()` function will attempt to infer the data type of each column, and prints the column types it has guessed to the screen.  If the wrong column types have been generated, you can pass the `col_types=` option to `read_csv()`.  

For example, if we wanted to load the `date` column as a character string, we would use:


~~~
twitterData <- read_csv("data/twitterData.csv", 
                             col_types = cols(
                               date = col_character(),
                               stateCode = col_character(),
                               word = col_character(),
                               cases = col_double(),
                               dataDay = col_double(),
                               Region = col_character(),
                               Division = col_character()
                             ) )
~~~
{: .language-r}

> ## Setting column types
> 
> Try reading a file using the `read_csv()` defaults (i.e. guessing column types).
> If this fails you can cut and paste the guessed column specification, and modify
> this with the correct column types.  It is good practice to do this anyway; it makes
> the data types of your columns explicit, and will help protect you if the format 
> of your data changes.
{: .callout}


You may notice from the column specification that the date column of the data has bene read in as a `col_date()`.  R has special data types for handling dates, and "date times" (e.g. 2018-01-01 00:00:01).  Dates and date times are awkward to handle in any programming language (including R); things like different ways of writing dates (day/month/year or month/day/year?) time zones, leap years (and leap seconds) complicate things.  The `lubridate` package in the tidyverse makes dates a bit easier to handle.  This isn't loaded by default.  We will be using one of the functions from it later in this episode, so we'll load it now. Add the following to the top of your script:


~~~
library(lubridate)
~~~
{: .language-r}



~~~

Attaching package: 'lubridate'
~~~
{: .output}



~~~
The following object is masked from 'package:base':

    date
~~~
{: .output}


## Manipulating tibbles 

Manipulation of tibbles means many things to many researchers. We often
select only certain observations (rows) or variables (columns). We often group the
data by a certain variable(s), or calculate summary statistics.

## The `dplyr` package

The  [`dplyr`](https://cran.r-project.org/web/packages/dplyr/dplyr.pdf)
package is part of the tidyverse.  It provides a number of very useful functions for manipulating tibbles (and their base-R cousin, the `data.frame`) 
in a way that will reduce repetition, reduce the probability of making
errors, and probably even save you some typing. 

We will cover:

1. selecting variables with `select()`
2. subsetting observations with `filter()`
3. grouping observations with `group_by()`
4. generating summary statistics using `summarize()`
5. generating new variables using `mutate()`
6. Sorting tibbles using `arrange()`
7. chaining operations together using pipes `%>%` 

## Using `select()`

If, for example, we wanted to move forward with only a few of the variables in
our tibble we use the `select()` function. This will keep only the
variables you select.


~~~
dateWordState <- select(twitterData, date, word, stateCode)
print(dateWordState)
~~~
{: .language-r}



~~~
# A tibble: 94,940 x 3
   date       word   stateCode
   <date>     <chr>  <chr>    
 1 2013-10-07 anime  AL       
 2 2013-10-07 bae    AL       
 3 2013-10-07 boi    AL       
 4 2013-10-07 bruhhh AL       
 5 2013-10-07 fleek  AL       
 6 2013-10-07 anime  AR       
 7 2013-10-07 bae    AR       
 8 2013-10-07 boi    AR       
 9 2013-10-07 bruhhh AR       
10 2013-10-07 fleek  AR       
# ... with 94,930 more rows
~~~
{: .output}

Select will select _columns_ of data.  What if we want to select rows that meet certain criteria?  

## Using `filter()`

The `filter()` function is used to select rows of data.  For example, to select only data relating to the north east states:


~~~
twitterDataNE <- filter(twitterData, Region == "Northeast")
print(twitterDataNE)
~~~
{: .language-r}



~~~
# A tibble: 16,160 x 8
   date       stateCode word   cases dataDay Region  totalTokens State    
   <date>     <chr>     <chr>  <int>   <int> <chr>         <dbl> <chr>    
 1 2013-10-07 CT        anime      1       1 Northe…      149773 Connecti…
 2 2013-10-07 CT        bae       22       1 Northe…      149773 Connecti…
 3 2013-10-07 CT        boi        4       1 Northe…      149773 Connecti…
 4 2013-10-07 CT        bruhhh     2       1 Northe…      149773 Connecti…
 5 2013-10-07 CT        fleek      0       1 Northe…      149773 Connecti…
 6 2013-10-07 MA        anime      0       1 Northe…       61205 Massachu…
 7 2013-10-07 MA        bae        5       1 Northe…       61205 Massachu…
 8 2013-10-07 MA        boi        2       1 Northe…       61205 Massachu…
 9 2013-10-07 MA        bruhhh     0       1 Northe…       61205 Massachu…
10 2013-10-07 MA        fleek      0       1 Northe…       61205 Massachu…
# ... with 16,150 more rows
~~~
{: .output}

Only rows of the data where the condition (i.e. `Region == "Northeast"`) is `TRUE` are kept.  Note that we use `==` to test for equality.

We can use numeric tests in the `filter()` function too.  For example, to only keep rows where at a word was tweeted at least once:


~~~
twitterData %>% 
  filter(cases >= 1)
~~~
{: .language-r}



~~~
# A tibble: 55,188 x 8
   date       stateCode word   cases dataDay Region totalTokens State     
   <date>     <chr>     <chr>  <int>   <int> <chr>        <dbl> <chr>     
 1 2013-10-07 AL        bae       32       1 South       184649 Alabama   
 2 2013-10-07 AL        boi        9       1 South       184649 Alabama   
 3 2013-10-07 AR        bae        5       1 South        23641 Arkansas  
 4 2013-10-07 AR        boi        1       1 South        23641 Arkansas  
 5 2013-10-07 AR        bruhhh     1       1 South        23641 Arkansas  
 6 2013-10-07 AZ        anime      1       1 West        198852 Arizona   
 7 2013-10-07 AZ        bae       22       1 West        198852 Arizona   
 8 2013-10-07 AZ        boi        5       1 West        198852 Arizona   
 9 2013-10-07 CA        anime     11       1 West       1209652 California
10 2013-10-07 CA        bae      124       1 West       1209652 California
# ... with 55,178 more rows
~~~
{: .output}

We can use the same idea to select tweets that occured on, before or after a certain date.  We need a way of providing the date to R in a way it can understand.  If we want all the tweets that occured on or after 1st Jan 2014, we might try something like:


~~~
twitterData %>% 
  filter(date >= 01012014)
~~~
{: .language-r}



~~~
# A tibble: 0 x 8
# ... with 8 variables: date <date>, stateCode <chr>, word <chr>,
#   cases <int>, dataDay <int>, Region <chr>, totalTokens <dbl>,
#   State <chr>
~~~
{: .output}

But this doesn't work.  The `dmy()` function in the lubridate function lets us specify a date to R. It is very liberal in how we format the date for example:


~~~
dmy(01012014)
~~~
{: .language-r}



~~~
[1] "2014-01-01"
~~~
{: .output}



~~~
dmy("1 Jan 2014")
~~~
{: .language-r}



~~~
[1] "2014-01-01"
~~~
{: .output}



~~~
dmy("1/1/2014")
~~~
{: .language-r}



~~~
[1] "2014-01-01"
~~~
{: .output}

will all work.  There are also `mdy()` and `ymd()` functions if you prefer to specify the parts of the date in a different order.
(If these commands don't work, check you have loaded the `lubridate` package with `library(lubridate)`)

So, to only keep tweets on or after 1 Jan 2014 we can use:

~~~
twitterData %>% 
  filter(date >= dmy("1 Jan 2014"))
~~~
{: .language-r}



~~~
# A tibble: 74,730 x 8
   date       stateCode word   cases dataDay Region totalTokens State   
   <date>     <chr>     <chr>  <int>   <int> <chr>        <dbl> <chr>   
 1 2014-01-01 AL        anime      1      87 South       315249 Alabama 
 2 2014-01-01 AL        bae      127      87 South       315249 Alabama 
 3 2014-01-01 AL        boi        5      87 South       315249 Alabama 
 4 2014-01-01 AL        bruhhh     2      87 South       315249 Alabama 
 5 2014-01-01 AL        fleek      0      87 South       315249 Alabama 
 6 2014-01-01 AR        anime      0      87 South        61134 Arkansas
 7 2014-01-01 AR        bae       22      87 South        61134 Arkansas
 8 2014-01-01 AR        boi        2      87 South        61134 Arkansas
 9 2014-01-01 AR        bruhhh     0      87 South        61134 Arkansas
10 2014-01-01 AR        fleek      0      87 South        61134 Arkansas
# ... with 74,720 more rows
~~~
{: .output}



## Using pipes and dplyr

We've now seen how to choose certain columns of data (using `select()`) and certain rows of data (using `filter()`).  In an analysis we often want to do both of these things (and many other things, like calculating summary statistics, which we'll come to shortly).    How do we combine these?

There are several ways of doing this; the method we will learn about today is using _pipes_.  

The pipe operator `%>%` lets us pipe the output of one command into the next.   This allows us to build up a data-processing pipeline.  This approach has several advantages:

* We can build the pipeline piecemeal - building the pipeline step-by-step is easier than trying to 
perform a complex series of operations in one go
* It is easy to modify and reuse the pipeline
* We don't have to make temporary tibbles as the analysis progresses

> ## Pipelines and the shell
>
> If you're familiar with the Unix shell, you may already have used pipes to
> pass the output from one command to the next.  The concept is the same, except
> the shell uses the `|` character rather than R's pipe operator `%>%`
{: .callout}


> ## Keyboard shortcuts and getting help
> 
> The pipe operator can be tedious to type.  In Rstudio pressing <kbd>Ctrl</kbd> + <kbd>Shift</kbd>+<kbd>M</kbd> under
> Windows / Linux will insert the pipe operator.  On the mac, use <kbd>&#8984;</kbd> + <kbd>Shift</kbd>+<kbd>M</kbd>.
>
> We can use tab completion to complete variable names when entering commands.
> This saves typing and reduces the risk of error.
> 
> RStudio includes a helpful "cheat sheet", which summarises the main functionality
> and syntax of `dplyr`.  This can be accessed via the
> help menu --> cheatsheets --> data transformation with dplyr. 
>
{: .callout}

Let's rewrite the select command example using the pipe operator:


~~~
dateWordStateCode<- twitterData %>% 
  select(date, word, stateCode)
print(dateWordStateCode)
~~~
{: .language-r}



~~~
# A tibble: 94,940 x 3
   date       word   stateCode
   <date>     <chr>  <chr>    
 1 2013-10-07 anime  AL       
 2 2013-10-07 bae    AL       
 3 2013-10-07 boi    AL       
 4 2013-10-07 bruhhh AL       
 5 2013-10-07 fleek  AL       
 6 2013-10-07 anime  AR       
 7 2013-10-07 bae    AR       
 8 2013-10-07 boi    AR       
 9 2013-10-07 bruhhh AR       
10 2013-10-07 fleek  AR       
# ... with 94,930 more rows
~~~
{: .output}

To help you understand why we wrote that in that way, let's walk through it step
by step. First we summon the twitterData tibble and pass it on, using the pipe
symbol `%>%`, to the next step, which is the `select()` function. In this case
we don't specify which data object we use in the `select()` function since in
gets that from the previous pipe. 

What if we wanted to combine this with the filter example? I.e. we want to select the date, word and state code, but only for countries in the north east?  We can join these two operations using a pipe; feeding the output of one command directly into the next:



~~~
NorthEastData <- twitterData %>% 
  filter(Region == "Northeast") %>% 
  select(date, word, stateCode)
print(NorthEastData)
~~~
{: .language-r}



~~~
# A tibble: 16,160 x 3
   date       word   stateCode
   <date>     <chr>  <chr>    
 1 2013-10-07 anime  CT       
 2 2013-10-07 bae    CT       
 3 2013-10-07 boi    CT       
 4 2013-10-07 bruhhh CT       
 5 2013-10-07 fleek  CT       
 6 2013-10-07 anime  MA       
 7 2013-10-07 bae    MA       
 8 2013-10-07 boi    MA       
 9 2013-10-07 bruhhh MA       
10 2013-10-07 fleek  MA       
# ... with 16,150 more rows
~~~
{: .output}

Note that the order of these operations matters; if we reversed the order of the `select()` and `filter()` functions, the `stateCode` variable wouldn't exist in the data-set when we came to apply the filter.  

What about if we wanted to match more than one item?  To do this we use the `%in%` operator:


~~~
twitterData %>% 
  filter(stateCode %in% c("WY", "UT", "CO", "AZ", "NM"))
~~~
{: .language-r}



~~~
# A tibble: 10,100 x 8
   date       stateCode word   cases dataDay Region totalTokens State   
   <date>     <chr>     <chr>  <int>   <int> <chr>        <dbl> <chr>   
 1 2013-10-07 AZ        anime      1       1 West        198852 Arizona 
 2 2013-10-07 AZ        bae       22       1 West        198852 Arizona 
 3 2013-10-07 AZ        boi        5       1 West        198852 Arizona 
 4 2013-10-07 AZ        bruhhh     0       1 West        198852 Arizona 
 5 2013-10-07 AZ        fleek      0       1 West        198852 Arizona 
 6 2013-10-07 CO        anime      0       1 West        106166 Colorado
 7 2013-10-07 CO        bae        4       1 West        106166 Colorado
 8 2013-10-07 CO        boi        1       1 West        106166 Colorado
 9 2013-10-07 CO        bruhhh     0       1 West        106166 Colorado
10 2013-10-07 CO        fleek      0       1 West        106166 Colorado
# ... with 10,090 more rows
~~~
{: .output}


> ## Another way of thinking about pipes
>
> It might be useful to think of the statement
> 
> ~~~
> NorthEastData <- twitterData %>% 
>  filter(Region == "Northeast") %>% 
>  select(date, word, stateCode)
> ~~~
> {: .language-r}
>  as a sentence, which we can read as
> "take the twitter data *and then* `filter` records where `Region == "Northeast"`
> *and then* `select` the date, word and stateCode
> 
> We can think of the `filter()` and `select()` functions as verbs in the sentence; 
> they do things to the data flowing through the pipeline.  
>
{: .callout}

> ## Splitting your commands over multiple lines
> 
> It's generally a good idea to put one command per line when
> writing your analyses.  This makes them easier to read.   When
> doing this, it's important that the `%>%` goes at the _end_ of the
> line, as in the example above.  If we put it at the beginning of a line, e.g.:
> 
> 
> ~~~
> twitterData 
>   %>% filter(stateCode %in% c("WY", "UT", "CO", "AZ", "NM"))
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> Error: <text>:2:3: unexpected SPECIAL
> 1: twitterData 
> 2:   %>%
>      ^
> ~~~
> {: .error}
> 
> the first line makes a valid R command.  R will then treat the next line 
> as a new command, which won't work.
{: .callout}


> ## Challenge 1
>
> Write a single command (which can span multiple lines and includes pipes) that
> will produce a tibble that has the values of  `cases`, `stateCode`
> and `dataDay`, for the countries in the south, but not for other regions.  How many rows does your tibble  
> have? (You can use the `nrow()` function to find out how many rows are in a tibble.)
>
> > ## Solution to Challenge 1
> >
> >~~~
> > SouthBae <- twitterData %>% 
> >   filter(Region == "South") %>% 
> >   filter(word == "bae") %>% 
> >   select(cases, stateCode, dataDay) 
> > nrow(SouthBae)
> >~~~
> >{: .language-r}
> >
> >
> >
> >~~~
> >[1] 6464
> >~~~
> >{: .output}
> > As with last time, first we pass the twitterData tibble to the `filter()`
> > function, then we pass the filtered version of the twitterData tibble  to the
> > `select()` function. **Note:** The order of operations is very important in this
> > case. If we used 'select' first, filter would not be able to find the variable
> > Region since we would have removed it in the previous step.
> {: .solution}
{: .challenge}


## Sorting tibbles

The `arrange()` function will sort a tibble by one or more of the variables in it:


~~~
twitterData %>% 
  filter(word == "anime") %>%
  arrange(cases)
~~~
{: .language-r}



~~~
# A tibble: 18,988 x 8
   date       stateCode word  cases dataDay Region   totalTokens State    
   <date>     <chr>     <chr> <int>   <int> <chr>          <dbl> <chr>    
 1 2013-10-07 AL        anime     0       1 South         184649 Alabama  
 2 2013-10-07 AR        anime     0       1 South          23641 Arkansas 
 3 2013-10-07 CO        anime     0       1 West          106166 Colorado 
 4 2013-10-07 DE        anime     0       1 South          12039 Delaware 
 5 2013-10-07 IA        anime     0       1 Midwest        73405 Iowa     
 6 2013-10-07 ID        anime     0       1 West           23522 Idaho    
 7 2013-10-07 IN        anime     0       1 Midwest       149274 Indiana  
 8 2013-10-07 KY        anime     0       1 South          45995 Kentucky 
 9 2013-10-07 LA        anime     0       1 South         180652 Louisiana
10 2013-10-07 MA        anime     0       1 Northea…       61205 Massachu…
# ... with 18,978 more rows
~~~
{: .output}
We can use the `desc()` function to sort a variable in reverse order:


~~~
twitterData %>% 
  filter(word == "anime") %>%
  arrange(desc(cases))
~~~
{: .language-r}



~~~
# A tibble: 18,988 x 8
   date       stateCode word  cases dataDay Region totalTokens State     
   <date>     <chr>     <chr> <int>   <int> <chr>        <dbl> <chr>     
 1 2014-07-05 CA        anime   367     272 West       2865511 California
 2 2014-07-03 CA        anime   293     270 West       3298513 California
 3 2014-07-04 CA        anime   286     271 West       3185266 California
 4 2014-07-06 CA        anime   260     273 West       3077657 California
 5 2014-07-16 CA        anime   180     283 West       3524572 California
 6 2014-07-07 CA        anime   145     274 West       3454158 California
 7 2014-07-09 CA        anime   144     276 West       3628779 California
 8 2014-07-02 CA        anime   117     269 West       3353831 California
 9 2014-07-08 CA        anime   115     275 West       3836043 California
10 2014-07-17 CA        anime   103     284 West       3478334 California
# ... with 18,978 more rows
~~~
{: .output}

## Generating new variables

The `mutate()` function lets us add new variables to our tibble.  It will often be the case that these are variables we _derive_ from existing variables in the data-frame. 

As an example, we can calculate the proportion of all tokens that were each of the words we are studying:


~~~
twitterData %>% 
  mutate(wordProp = cases / totalTokens)
~~~
{: .language-r}



~~~
# A tibble: 94,940 x 9
   date       stateCode word  cases dataDay Region totalTokens State
   <date>     <chr>     <chr> <int>   <int> <chr>        <dbl> <chr>
 1 2013-10-07 AL        anime     0       1 South       184649 Alab…
 2 2013-10-07 AL        bae      32       1 South       184649 Alab…
 3 2013-10-07 AL        boi       9       1 South       184649 Alab…
 4 2013-10-07 AL        bruh…     0       1 South       184649 Alab…
 5 2013-10-07 AL        fleek     0       1 South       184649 Alab…
 6 2013-10-07 AR        anime     0       1 South        23641 Arka…
 7 2013-10-07 AR        bae       5       1 South        23641 Arka…
 8 2013-10-07 AR        boi       1       1 South        23641 Arka…
 9 2013-10-07 AR        bruh…     1       1 South        23641 Arka…
10 2013-10-07 AR        fleek     0       1 South        23641 Arka…
# ... with 94,930 more rows, and 1 more variable: wordProp <dbl>
~~~
{: .output}

The dplyr cheat sheet contains many useful functions which can be used with dplyr.  This can be found in the help menu of RStudio. You will use one of these functions in the next challenge.

> ## Challenge 2
> 
> In this challenge we'll calculate a cumulative sum of how often the word "anime" occurs over time in the state of New York.   We haven't talked about how to make a cumulative sum yet; take a look at the dplyr cheat sheet for this part of the question.
> 
> There are a few steps you'll need to go through to do this.  When you're doing this, it's a really good idea to build you analysis pipeline command by command and check it's doing what you think it is after each step.  
> 
> The first thing we'll need to do is filter the rows of data we want. It's also a good idea to just select the columns of data we need for the rest of the exercise at this point. It looks like the data are sorted by date, but we don't _know_ this for sure, so it'll be a good idea to make sure.  Then we'll need to make a new column containing the cumulative sum.  
> 
> As this is quite a long challenge, the solution is split into several parts:
> 
> > ## Solution - the rows we want
> > 
> > The first thing to do is to get the rows of data we want.  We use the `filter()` function for this:
> > 
> > 
> > ~~~
> > twitterData %>% 
> >   filter(stateCode == "NY") %>% 
> >   filter(word == "anime")
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 404 x 8
> >    date       stateCode word  cases dataDay Region    totalTokens State   
> >    <date>     <chr>     <chr> <int>   <int> <chr>           <dbl> <chr>   
> >  1 2013-10-07 NY        anime     1       1 Northeast      265028 New York
> >  2 2013-10-08 NY        anime     2       2 Northeast      334360 New York
> >  3 2013-10-09 NY        anime     0       3 Northeast      333082 New York
> >  4 2013-10-10 NY        anime     4       4 Northeast      337997 New York
> >  5 2013-10-11 NY        anime     1       5 Northeast      300758 New York
> >  6 2013-10-12 NY        anime     0       6 Northeast      297587 New York
> >  7 2013-10-13 NY        anime     4       7 Northeast      346526 New York
> >  8 2013-10-14 NY        anime     0       8 Northeast      349689 New York
> >  9 2013-10-15 NY        anime     1       9 Northeast      342450 New York
> > 10 2013-10-16 NY        anime     4      10 Northeast      355594 New York
> > # ... with 394 more rows
> > ~~~
> > {: .output}
> > 
> {: .solution}
> 
> > ## Solution - the columns we want
> > 
> > We can extend the pipeline with a `select()` to get the columns we need for the rest of the challenge:
> > 
> > 
> > ~~~
> > twitterData %>% 
> >   filter(stateCode == "NY") %>% 
> >   filter(word == "anime") %>% 
> >   select(date, cases)
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 404 x 2
> >    date       cases
> >    <date>     <int>
> >  1 2013-10-07     1
> >  2 2013-10-08     2
> >  3 2013-10-09     0
> >  4 2013-10-10     4
> >  5 2013-10-11     1
> >  6 2013-10-12     0
> >  7 2013-10-13     4
> >  8 2013-10-14     0
> >  9 2013-10-15     1
> > 10 2013-10-16     4
> > # ... with 394 more rows
> > ~~~
> > {: .output}
> > 
> {: .solution}
> 
> > ## Solution - getting things in order
> > 
> > It's a good idea to check the data are in date order:
> > 
> > 
> > ~~~
> > twitterData %>% 
> >   filter(stateCode == "NY") %>% 
> >   filter(word == "anime") %>% 
> >   select(date, cases) %>% 
> >   arrange(date)
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 404 x 2
> >    date       cases
> >    <date>     <int>
> >  1 2013-10-07     1
> >  2 2013-10-08     2
> >  3 2013-10-09     0
> >  4 2013-10-10     4
> >  5 2013-10-11     1
> >  6 2013-10-12     0
> >  7 2013-10-13     4
> >  8 2013-10-14     0
> >  9 2013-10-15     1
> > 10 2013-10-16     4
> > # ... with 394 more rows
> > ~~~
> > {: .output}
> {: .solution}
> 
> 
> > ## Solution - calculating the cumulative sum
> > 
> > The last thing to do is to calculate the cumulative sum.  We need to make a new column, so we use `mutate()`; the dplyr cheat sheet lists (some of) the functions we can use with mutate, including `cumsum()`. 
> > 
> > 
> > 
> > ~~~
> > twitterData %>% 
> >   filter(stateCode == "NY") %>% 
> >   filter(word == "anime") %>% 
> >   select(date, cases) %>% 
> >   arrange(date) %>% 
> >   mutate(cumulativeUse = cumsum(cases))
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 404 x 3
> >    date       cases cumulativeUse
> >    <date>     <int>         <int>
> >  1 2013-10-07     1             1
> >  2 2013-10-08     2             3
> >  3 2013-10-09     0             3
> >  4 2013-10-10     4             7
> >  5 2013-10-11     1             8
> >  6 2013-10-12     0             8
> >  7 2013-10-13     4            12
> >  8 2013-10-14     0            12
> >  9 2013-10-15     1            13
> > 10 2013-10-16     4            17
> > # ... with 394 more rows
> > ~~~
> > {: .output}
> > 
> {: .solution}
{: .challenge}

## Calculating summary statistics

We often wish to calculate a summary statistic (the mean, standard deviation, etc.)
for a variable.  We frequently want to calculate a separate summary statistic for several
groups of data (e.g. for each state or region).    We can calculate a summary statistic
for the whole data-set using the dplyr's `summarise()` function:


~~~
twitterData %>% 
  filter(word == "anime") %>% 
  summarise(totalAnime = sum(cases))
~~~
{: .language-r}



~~~
# A tibble: 1 x 1
  totalAnime
       <int>
1         NA
~~~
{: .output}

Tells us how often "anime" occured in the whole data set

To generate summary statistics for each value of another variable we use the 
`group_by()` function:


~~~
twitterData %>% 
  group_by(word) %>% 
  summarise(total = sum(cases))
~~~
{: .language-r}



~~~
# A tibble: 5 x 2
  word   total
  <chr>  <int>
1 anime     NA
2 bae       NA
3 boi       NA
4 bruhhh    NA
5 fleek     NA
~~~
{: .output}


> ## Statistics revision
> 
> If you need to revise or learn about statistical concepts, the University Library's "My Learning Essentials" team have produced a site [Start to Finish:Statistics](https://www.escholar.manchester.ac.uk/learning-objects/mle/packages/statistics/) which covers important statistical concepts.
> 
{: .callout}

> ## Challenge 3
> 
> For each day in January 2014 calculate the number of times each word occured
> 
> Hint - first filter the data so that only observations in January 2014 are included.  Then group by date and word
> 
> > ## Solution
> > 
> > ~~~
> > twitterData %>% 
> >   filter(date >= dmy("1 Jan 2014")) %>% 
> >   filter(date < dmy("1 Feb 2014")) %>% 
> >   group_by(date, word) %>% 
> >   summarise(totalUse = sum(cases))
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 155 x 3
> > # Groups:   date [?]
> >    date       word   totalUse
> >    <date>     <chr>     <int>
> >  1 2014-01-01 anime       104
> >  2 2014-01-01 bae        4288
> >  3 2014-01-01 boi         346
> >  4 2014-01-01 bruhhh       90
> >  5 2014-01-01 fleek         0
> >  6 2014-01-02 anime       124
> >  7 2014-01-02 bae        4161
> >  8 2014-01-02 boi         379
> >  9 2014-01-02 bruhhh       84
> > 10 2014-01-02 fleek         0
> > # ... with 145 more rows
> > ~~~
> > {: .output}
> > 
> {: .solution}
{: .challenge}

## `count()` and `n()`
A very common operation is to count the number of observations for each
group. The `dplyr` package comes with two related functions that help with this.


If we need to use the number of observations in calculations, the `n()` function
is useful. For instance, if we wanted to see how many observations there were for each word we could use:


~~~
twitterData %>% 
  group_by(word) %>% 
  summarise(numObs = n())
~~~
{: .language-r}



~~~
# A tibble: 5 x 2
  word   numObs
  <chr>   <int>
1 anime   18988
2 bae     18988
3 boi     18988
4 bruhhh  18988
5 fleek   18988
~~~
{: .output}

There's a shorthand for this; the count function:


~~~
twitterData %>% 
  count(word) 
~~~
{: .language-r}



~~~
# A tibble: 5 x 2
  word       n
  <chr>  <int>
1 anime  18988
2 bae    18988
3 boi    18988
4 bruhhh 18988
5 fleek  18988
~~~
{: .output}
We can optionally sort the results in descending order by adding `sort=TRUE`:



## Connect mutate with logical filtering: `ifelse()`

When creating new variables, we can hook this with a logical condition. A simple combination of 
`mutate()` and `ifelse()` facilitates filtering right where it is needed: in the moment of creating something new.
This easy-to-read statement is a fast and powerful way of discarding certain data (even though the overall dimension
of the tibble will not change) or for updating values depending on this given condition.

The `ifelse()` function takes three parameters.  The first it the logical test.  The second is the value to use if the test is TRUE for that observation, and the third is the value to use if the test is FALSE.

For example, if we wanted to take the log of all observations where the word was mentioned at least once, and use `NA` otherwise, we could use:


~~~
twitterData %>% 
  select(date, stateCode, word, cases) %>% 
  mutate(logcases = ifelse(cases > 0, log(cases), NA))
~~~
{: .language-r}



~~~
# A tibble: 94,940 x 5
   date       stateCode word   cases logcases
   <date>     <chr>     <chr>  <int>    <dbl>
 1 2013-10-07 AL        anime      0    NA   
 2 2013-10-07 AL        bae       32     3.47
 3 2013-10-07 AL        boi        9     2.20
 4 2013-10-07 AL        bruhhh     0    NA   
 5 2013-10-07 AL        fleek      0    NA   
 6 2013-10-07 AR        anime      0    NA   
 7 2013-10-07 AR        bae        5     1.61
 8 2013-10-07 AR        boi        1     0   
 9 2013-10-07 AR        bruhhh     1     0   
10 2013-10-07 AR        fleek      0    NA   
# ... with 94,930 more rows
~~~
{: .output}


> ## Equivalent functions in base R
>
> In this course we've taught the tidyverse.  You are likely come across
> code written others in base R.  You can find a guide to some base R functions
> and their tidyverse equivalents [here](http://www.significantdigits.org/2017/10/switching-from-base-r-to-tidyverse/),
> which may be useful when reading their code.
>
{: .callout}
## Other great resources

* [Data Wrangling tutorial](https://suzan.rbind.io/categories/tutorial/) - an excellent four part tutorial covering selecting data, filtering data, summarising and transforming your data.
* [R for Data Science](http://r4ds.had.co.nz/)
* [Data Wrangling Cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
* [Introduction to dplyr](https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html) - this is the package vignette.  It can be viewed within R using `vignette(package="dplyr", "dplyr")`
* [Data wrangling with R and RStudio](https://www.rstudio.com/resources/webinars/data-wrangling-with-r-and-rstudio/)
