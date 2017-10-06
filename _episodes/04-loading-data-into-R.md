---
title: "Loading data into R"
teaching: 45
exercises: 15
questions:
- "How can I read and write tabular data in R?"
- "What are the basic data types in R?"
- "How do I represent categorical information in R?"
objectives:
- "To be aware of the different types of data."
- "To begin exploring tibbles"
keypoints:
- "Tibbles let us store tabular data in R.  Tibbles are an extension of the base R data.frame."
- "Use `read_csv` to read tabular data into a tibble R."
- "User `write_csv` to write tabular data to a comma separated value file."
- "Use factors to represent categorical data in R. You should specify the levels of your factors."
source: Rmd
---



One of R's most powerful features is its ability to deal with tabular data -
such as you may already have in a spreadsheet or a CSV file. 

The [course data](https://github.com/mawds/r-novice-gapminder/raw/gh-pages/data/r-novice.zip) contains a .csv file
called `feline-data.csv`, which you copied to the `data/` folder when we discussed managing projects in RStudio.


~~~
coat,weight,likes_string
calico,2.1,1
black,5.0,0
tabby,3.2,1
~~~
{: .r}



We can view the contents of the file by selecting it from the "Files" window in RStudio, and selecting "View File".  This will display the contents of the file in a new window in RStudio.  We can see that the variables names are given in the first line of the file, and that the remaining lines contain the data itself.  Each observation is on a separate line, and variables are separated by commas. Note that viewing the file  _doesn't_ make its contents available to R; to do this we need to _import_ the data.

FIXME - Introduce packages by this point

We can import the data into R using the `read_csv()` function; this is part of the `readr` package, which is part of the `tidyverse`.   In order to make the function available to us, we need to first load the `readr` library, before calling
the read_csv() function to import the data, which we store in the variable named `cats`:



~~~
library(readr)
cats <- read_csv(file = "data/feline-data.csv")
~~~
{: .r}



~~~
Parsed with column specification:
cols(
  coat = col_character(),
  weight = col_double(),
  likes_string = col_integer()
)
~~~
{: .output}



~~~
cats
~~~
{: .r}



~~~
# A tibble: 3 x 3
    coat weight likes_string
   <chr>  <dbl>        <int>
1 calico    2.1            1
2  black    5.0            0
3  tabby    3.2            1
~~~
{: .output}

When we enter `cats` by itself on the command line, it will print the contents of `cats`; we see that it consists of a 3 by 3 "tibble". A tibble is a way of storing tabular data, which is part of the tidyverse.   We see the variable names, and an (abbreviated) string indicating what type of data is stored in each variable.

FIXME demonstrate autocomplete / popup help in Rstudio by this point

> ## read_csv() vs read.csv()
>
> You may notice that RStudio suggests `read.csv()` as a function to load a comma separated 
> value file.  This function is included as part of base R, and performs a similar job 
> to `read_csv()`.  We will be using `read_csv()` in this course; it is part of the tidyverse,
> so works well with other parts of the tidyverse, is faster than `read.csv()` and handles 
> strings in a way that is usually more useful than `read.csv()`
{: .callout}

> ## Loading other types of data
>
> * Another type of file you might encounter are tab-separated value files (.tsv); these can be read with the `read_tsv()` function in the `readr` package.  To read files with other delimeters, use the `read_delim()` function. If files are fixed width format (i.e. the variable is defined by its position on the line), then use the `read_fwf()` function.
> * You can read directly from excel spreadsheets without
> converting them to plain text first by using the [readxl](http://readxl.tidyverse.org) package, which is part of the tidyverse (although not loaded by default).
{: .callout}

We see that the `read_csv()` table reports a "column specification".  This shows the variable names that were read in, and the type of data that each column was interpreted as.

## Data types

Every piece of data in R is stored as either `double`, `integer`, `complex`, `logical` and `character`.   `integer` variables can only store whole numbers; `double` variables can store floating point numbers (i.e. with a decimal part), `complex` variables can store complex numbers (i.e. of the form `1+2i`), `logical` variables can store `TRUE` or `FALSE`.  `character` variables can store strings of characters.

When we read the data into
r using `read_csv()` it tries to work out what data type each variable is, which it does by looking at the data contained in the first 1000 rows of the data file.   We can see from the displayed message that read_csv() has treated the `coat` variable as a character variable, the `weight` variable as a floating point number and `likes_string` as an integer variable.

This is almost correct; `likes_string` is, however a logical (or boolean) value - the cat either likes string (which is represented in the data file as a `1`, or doesn't (represented by `0`)).  We can specify how we would like `read_csv()` to treat the data in each variable using the `col_types` option; let's tell `read_csv()` to treat `likes_string` as a logical variable:


~~~
cats <- read_csv("data/feline-data.csv", col_types = cols(
  coat = col_character(),
  weight = col_double(),
  likes_string = col_logical()
) )
~~~
{: .r}

That's a lot of typing!  Fortunately, we don't have to type everything by hand.  The `cols()` function above may look familiar; if we load a file using `read_csv()` without specifying the `col_types` option, it will print out the `cols()` function it has generated during the import process.  We can copy and paste this into our script, and modify it as required.   

If we look at the imported data, we will now see that the `likes_string` variable is recorded as a logical.  The strict approach to specifying data types has another benefit, as we'll see...

A user has added details of another cat. This information is in the file
`data/feline-data_v2.csv`, included in the course data download.


~~~
file.show("data/feline-data_v2.csv")
~~~
{: .r}


~~~
coat,weight,likes_string
calico,2.1,1
black,5.0,0
tabby,3.2,1
tabby,2.3 or 2.4,1
~~~
{: .r}

Let's load this in, using the `read_csv()` command we have just written:


~~~
cats2 <- read_csv("data/feline-data_v2.csv", col_types = cols(
  coat = col_character(),
  weight = col_double(),
  likes_string = col_logical()
) )
~~~
{: .r}



~~~
Warning in rbind(names(probs), probs_f): number of columns of result is not
a multiple of vector length (arg 2)
~~~
{: .error}



~~~
Warning: 1 parsing failure.
row # A tibble: 1 x 5 col     row    col               expected  actual                      file expected   <int>  <chr>                  <chr>   <chr>                     <chr> actual 1     4 weight no trailing characters  or 2.4 'data/feline-data_v2.csv' file # A tibble: 1 x 5
~~~
{: .error}

We see that a `parsing failure` message has been printed when we load the data.   If we look at the `cats2` data, we will see that the invalid weight `2.3 or 2.4` has been replaced with an `NA`.  This illustrates one of the benefits of
specifying the column types when we load the data; it alerts us when something has gone wrong with the data-import. If we hadn't specified the type of data that we expect to be stored in each column, `read_csv()` will read the `weight` variable as a character variable.

We don't *have* to specify a column type for each variable; the `cols()` function will guess the data types for the columns we don't specify.  It is, however, a good idea to be explicit about the type of data we expect to be in each column.

> ## Importing data using RStudio
> 
> You may have noticed when we viewed the `feline-data.csv` file in RStudio, before importing it, that another option  appeared, labelled "Import Dataset".  This lets us import the data interactively.   It can be more convenient to use this approach, rather than manually writing the required code.   If you do this, you will find that the code RStudio has written is put into the console and run (and will appear in the history tab in RStudio).  *You should copy the generated code to your script, so that you can reproduce your analysis*. FIXME - introduce history window by this point
{: .callout}

## Exploring tibbles

We can "unpick" the contents of a tibble in several ways.  We can return a vector containing the values
of a variable using the `$`:


~~~
cats$weight
~~~
{: .r}



~~~
[1] 2.1 5.0 3.2
~~~
{: .output}

We can also use the subsetting operator `[]` directly on tibbles.  In contrast to a vector, a tibble
is two dimensional.   We pass two arguments to the `[]` operator; the first indicates the row(s) we 
require and the second indicates the columns.  So to return rows 1 and 2, and columns 2 and 3 we can use:


~~~
cats[1:2,2:3]
~~~
{: .r}



~~~
# A tibble: 2 x 2
  weight likes_string
   <dbl>        <lgl>
1    2.1         TRUE
2    5.0        FALSE
~~~
{: .output}

If we leave in index blank, it acts as a wildcard and matches all of the rows or columns:


~~~
cats[1,]
~~~
{: .r}



~~~
# A tibble: 1 x 3
    coat weight likes_string
   <chr>  <dbl>        <lgl>
1 calico    2.1         TRUE
~~~
{: .output}



~~~
cats[,1]
~~~
{: .r}



~~~
# A tibble: 3 x 1
    coat
   <chr>
1 calico
2  black
3  tabby
~~~
{: .output}

Subsetting a tibble returns another tibble; using `$` to extract a variable returns a vector:


~~~
cats$coat
~~~
{: .r}



~~~
[1] "calico" "black"  "tabby" 
~~~
{: .output}



~~~
cats[,1]
~~~
{: .r}



~~~
# A tibble: 3 x 1
    coat
   <chr>
1 calico
2  black
3  tabby
~~~
{: .output}



## Categorical data

Another important data structure is called a *factor*. Factors usually look like
character data, but are used to represent categorical information.

Let's work with the coat colours of the cats in our dataset


~~~
catCoats <- cats$coat
catCoats
~~~
{: .r}



~~~
[1] "calico" "black"  "tabby" 
~~~
{: .output}

Let's assume that only specific values of coat colour are allowed:


~~~
validCoatColours <- c("white", "black", "calico", "tabby")
~~~
{: .r}

We can convert our character vector of coat colours into a factor using the `parse_factor()` function:


~~~
coatFactor <- parse_factor(catCoats, levels = validCoatColours)
coatFactor 
~~~
{: .r}



~~~
[1] calico black  tabby 
Levels: white black calico tabby
~~~
{: .output}

You might be wondering what the point of defining a factor is.  If we're fitting, e.g. a linear regression with
a categorical variable we would need to generate indicator variables for it.   By defining our data as categorical,
R will take care of this for us.   The factor levels will be defined in the order we specify in the vector we pass as the `levels` argument to parse_factor; so the baseline treatment would usually be specified as the first level.

Defining variables as factors also helps us to ensure data integrity.   Consider the vector below:


~~~
catCoats2 <- c("calic0", "black", "tabby")
~~~
{: .r}

If we try to convert this to a factor it won't work:

~~~
parse_factor(catCoats2, levels = validCoatColours)
~~~
{: .r}



~~~
Warning: 1 parsing failure.
row # A tibble: 1 x 4 col     row   col           expected actual expected   <int> <int>              <chr>  <chr> actual 1     1    NA value in level set calic0
~~~
{: .error}



~~~
[1] <NA>  black tabby
attr(,"problems")
# A tibble: 1 x 4
    row   col           expected actual
  <int> <int>              <chr>  <chr>
1     1    NA value in level set calic0
Levels: white black calico tabby
~~~
{: .output}

Remember that we specifcied the column types when we loaded the data using `read_csv()`; we can 
take this idea a step further, and define `coat` as a factor when we load the data.

> ## Challenge 1
>
> Assume that the valid values for the coats variable are black, white, calico and tabby.
> Read in the cats data, treating the  `coat` variable as a factor with these levels.
> 
> Hint: `col_factor()` and its help page may be useful
>
> > ## Solution to challenge 1
> >  
> >
> >~~~
> > cats <- read_csv("data/feline-data.csv", col_types = cols(
> >  coat = col_factor(levels = c("black", "white", "calico",  "tabby")),
> >  weight = col_double(),
> >  likes_string = col_logical()
> > ) )
> > cats
> >~~~
> >{: .r}
> >
> >
> >
> >~~~
> ># A tibble: 3 x 3
> >    coat weight likes_string
> >  <fctr>  <dbl>        <lgl>
> >1 calico    2.1         TRUE
> >2  black    5.0        FALSE
> >3  tabby    3.2         TRUE
> >~~~
> >{: .output}
> >  You may have noticed while reading the help file for `col_factor()` and `parse_factor()` that we can pass
the option `levels = NULL`.  This will cause R to generate the factor levels automatically.  In general this
is a bad idea, since invalid data (such as "calic0" in the example above) will get their own factor level.
> {: .solution}
{: .challenge}

> ## Doing more with factors
> 
> If you wish to perform more complex operations on factors, such as recoding 
> level names, changing level order, and collapsing multiple levels into one,
> the [forcats](http://forcats.tidyverse.org/) package, which is part of the tidyverse
> makes this easy.  Note that `forcats` isn't loaded by default, so you will
> need to use `library("forcats")` before using it.
{: .callout}

## Writing data in R

We can save a tibble (or data frame) to a csv file, using `readr`'s `write_csv()` function.  For example, to save the cat data to `mycats.csv`:


~~~
write_csv(cats, "data/mycats.csv")
~~~
{: .r}

## Matrices

We can also define matrices in R.  We don't cover this in this course, since we are focussing
on data-analysis, rather than maths and algorithms.   For details of the matrix class, you can refer to the [original Software Carpentry version of these notes](http://swcarpentry.github.io/r-novice-gapminder/04-data-structures-part1/#matrices).


> ## Differences with base R
> 
> In this lesson we've taught you how to read files and make factors using the functionality in the
> `readr` package, which is part of the tidyverse.  
> This section highlights some of the differences between the tidyverse and its equivalent
> functionality in base R.
>
> R's standard data structure for tabular data is the `data.frame`.  In
> contrast, `read_csv()` creates a `tibble` (also referred to, for historic
> reasons, as a `tbl_df`).  This extends the functionality of  a `data.frame`,
> and can, for the most part, be treated like a `data.frame`
> 
> You may find that some older functions don't work on tibbles.   A tibble
> can be converted to a dataframe using `as.data.frame(mytibble)`.  To convert
> a data frame to a tibble, use `as.tibble(mydataframe)`
> 
> Tibbles behave more consistently than data frames when subsetting with `[]`; 
> this will always return another tibble.  This isn't the case when working with 
> data.frames.  You can find out more about the differences  between data.frames and 
> tibbles by typing `vignette("tibble")`.
> 
> `read_csv()` will always read variables containing text as character variables.  In contrast,
> the base R function `read.csv()` will, by default, convert any character variable to a factor.
> This is often not what you want, and can be overridden by passing the option `stringsAsFactors = FALSE` > to `read.csv()`.  
>
> We used `parse_factor()` to define factors.  The base R equivalent is the `factor()` function.
> the main differences between the two approaches are:
>
> * `factor()` will assign factor levels automatically; it does not require us to pass `levels = NULL`.
> * The automatic levels generated by `factor()` will be alphabetical (rather than according to the order
> that each level is encountered in `parse_factor()`)
> * `factor()` does not warn us if we have data that doesn't match any of the levels we have specified
> 
> It is chiefly for the final reason that we recommend using `parse_factor()` instead of `factor()`.  You
> should be aware that the default ordering of factor levels differs between `factor()` and `parse_factor()`
{: .callout}


