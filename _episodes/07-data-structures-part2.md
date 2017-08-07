---
title: "Exploring Tibbles"
teaching: 20
exercises: 10
questions:
- "How can I manipulate tibbles?"
objectives:
- "Be able to add and remove rows and columns."
- "Be able to append two tibbles"
- "Be able to articulate what a `factor` is and how to convert between `factor` and `character`."
- "Be able to find basic properties of tibles including size, class or type of the columns, names, and first few rows."
keypoints:
- "Use `bind_cols()` to add a new column to a tibble or data frame."
- "Use `bind_rows()` to add a new row to a tibble or data frame."
- "Remove rows from a data frame."
- "Use `na.omit()` to remove rows from a tibble with `NA` values."
- "Use `levels()` and `as.character()` to explore and manipulate factors"
- "Use `str()`, `nrow()`, `ncol()`, `dim()`, `colnames()`, `rownames()`, `head()` and `typeof()` to understand structure of tibbles"
- "Understand `length()` of a tibble"
source: Rmd
---



In this lesson, we'll learn a few more things about working with tibbles, using our cats example, 
which we read in setting `coat` as a factor variable, and `likes_string` as a logical variable:



## Adding columns and rows to tibbles.

We can add new rows and columns to tibbles using the `bind_rows()` and `bind_columns()` functions
in the `dplyr` package.   They require that both aruments are tibbles (or data frames).

Let's add a new column to our tibble giving the ages of the cats:


~~~
cats
~~~
{: .r}



~~~
# A tibble: 3 x 3
    coat weight likes_string
  <fctr>  <dbl>        <lgl>
1 calico    2.1         TRUE
2  black    5.0        FALSE
3  tabby    3.2         TRUE
~~~
{: .output}



~~~
age <- tibble(age = c(2,3,5))
cats <- bind_cols(cats, age)
cats
~~~
{: .r}



~~~
# A tibble: 3 x 4
    coat weight likes_string   age
  <fctr>  <dbl>        <lgl> <dbl>
1 calico    2.1         TRUE     2
2  black    5.0        FALSE     3
3  tabby    3.2         TRUE     5
~~~
{: .output}

If we wish to add the details of another cat, we can make a tibble containing its information,
and then use `bind_rows()` to append this to the tibble (note that we don't know the age of this cat, so we use `NA`):


~~~
newRow <- tibble(coat = "tortoiseshell", 
               weight = 3.3, 
               likes_string = TRUE, 
               age = NA)
fourcats <- bind_rows(cats, newRow)
~~~
{: .r}



~~~
Warning in bind_rows_(x, .id): binding factor and character vector,
coercing into character vector
~~~
{: .error}



~~~
Warning in bind_rows_(x, .id): binding character and factor vector,
coercing into character vector
~~~
{: .error}

## Factors

Another thing to look out for has emerged - when we loaded the data, we set the `coat`
variable to be a factor, and specified its levels. In our new row, `coat` is defined as
a character variable; when we append the two, the `coat` column gets coerced to a 
character variable.

How can we handle this?  One approach might be to define the `coat` variable as a factor, and
then join:


~~~
newRow$coat <- parse_factor(newRow$coat, levels = "tortoiseshell")
fourcats <- bind_rows(cats, newRow)
~~~
{: .r}



~~~
Warning in bind_rows_(x, .id): Unequal factor levels: coercing to character
~~~
{: .error}



~~~
Warning in bind_rows_(x, .id): binding character and factor vector,
coercing into character vector
Warning in bind_rows_(x, .id): binding character and factor vector,
coercing into character vector
~~~
{: .error}

We see that the `coat` variable is again coerced to a charater variable, owing to "unequal factor levels".
Because R cannot tell _how_ it should combine the two factors, the variable is converted to a character variable.

There are two approaches to handling this issue.  The safest, although more work, is to 
make sure that both factors have the same levels before calling `bind_rows()`: 


~~~
coatFactorLevels <- c(levels(cats$coat), "tortoiseshell")

cats$coat <- parse_factor(cats$coat,levels = coatFactorLevels)
newRow$coat <- parse_factor(newRow$coat,levels = coatFactorLevels)

fourcats <- bind_rows(cats, newRow)
fourcats
~~~
{: .r}



~~~
# A tibble: 4 x 4
           coat weight likes_string   age
         <fctr>  <dbl>        <lgl> <dbl>
1        calico    2.1         TRUE     2
2         black    5.0        FALSE     3
3         tabby    3.2         TRUE     5
4 tortoiseshell    3.3         TRUE    NA
~~~
{: .output}

Alternatively, we can let R change a factor column to a character vector, and then convert the entire column to a factor once we are done appending data.

> ## Discussion point
>
> Why is it better to define the factor levels beforehand?
>
> > ## Solution
> >  
> > If we define the factor levels beforehand we will be warned if there is data
> > that does not match any of the factor levels.  This helps protect against reading
> > in unexpected data.
> > 
> {: .solution}
{: .discussion}

## Removing rows

We now know how to add rows and columns to our data frame in R. How do we delete them?


~~~
fourcats
~~~
{: .r}



~~~
# A tibble: 4 x 4
           coat weight likes_string   age
         <fctr>  <dbl>        <lgl> <dbl>
1        calico    2.1         TRUE     2
2         black    5.0        FALSE     3
3         tabby    3.2         TRUE     5
4 tortoiseshell    3.3         TRUE    NA
~~~
{: .output}

Let's delete the cat we just added:


~~~
fourcats[-4,]
~~~
{: .r}



~~~
# A tibble: 3 x 4
    coat weight likes_string   age
  <fctr>  <dbl>        <lgl> <dbl>
1 calico    2.1         TRUE     2
2  black    5.0        FALSE     3
3  tabby    3.2         TRUE     5
~~~
{: .output}

Notice the comma with nothing after it to indicate we want to drop the entire fourth row.

Note: We could remove several values at once by putting the row numbers inside a vector
inside of a vector: `fourcats[c(-1,-4),]`

Alternatively, we can drop all rows with `NA` values:


~~~
na.omit(fourcats)
~~~
{: .r}



~~~
# A tibble: 3 x 4
    coat weight likes_string   age
  <fctr>  <dbl>        <lgl> <dbl>
1 calico    2.1         TRUE     2
2  black    5.0        FALSE     3
3  tabby    3.2         TRUE     5
~~~
{: .output}

We could also drop rows using the `filter()` command in `dplyr`, as described in xxx

## Appending to a tibble

The key to remember when adding data to a data frame is that *columns are
vectors or factors, and rows are lists.* We can also glue two data frames
together with `bind_rows`:


~~~
sevencats <- bind_rows(fourcats, cats)
sevencats
~~~
{: .r}



~~~
# A tibble: 7 x 4
           coat weight likes_string   age
         <fctr>  <dbl>        <lgl> <dbl>
1        calico    2.1         TRUE     2
2         black    5.0        FALSE     3
3         tabby    3.2         TRUE     5
4 tortoiseshell    3.3         TRUE    NA
5        calico    2.1         TRUE     2
6         black    5.0        FALSE     3
7         tabby    3.2         TRUE     5
~~~
{: .output}

> ## Challenge 1
>
> You can create a new data frame right from within R with the following syntax:
> 
> ~~~
> df <- data.frame(id = c('a', 'b', 'c'),
>                  x = 1:3,
>                  y = c(TRUE, TRUE, FALSE),
>                  stringsAsFactors = FALSE)
> ~~~
> {: .r}
> Make a data frame that holds the following information for yourself:
>
> - first name
> - last name
> - lucky number
>
> Then use `rbind` to add an entry for the people sitting beside you.
> Finally, use `cbind` to add a column with each person's answer to the question, "Is it time for coffee break?"
>
> > ## Solution to Challenge 1
> > 
> > ~~~
> > df <- data.frame(first = c('Grace'),
> >                  last = c('Hopper'),
> >                  lucky_number = c(0),
> >                  stringsAsFactors = FALSE)
> > df <- rbind(df, list('Marie', 'Curie', 238) )
> > df <- cbind(df, coffeetime = c(TRUE,TRUE))
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}

## Realistic example
So far, you've seen the basics of manipulating data frames with our cat data;
now, let's use those skills to digest a more realistic dataset. Lets read in the
gapminder dataset that we downloaded previously:


~~~
gapminder <- read.csv("data/gapminder-FiveYearData.csv")
~~~
{: .r}

> ## Miscellaneous Tips
>
> * Another type of file you might encounter are tab-separated value files (.tsv). To specify a tab as a separator, use `"\\t"` or `read.delim()`.
>
> * Files can also be downloaded directly from the Internet into a local
> folder of your choice onto your computer using the `download.file` function.
> The `read.csv` function can then be executed to read the downloaded file from the download location, for example,
> 
> ~~~
> download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder-FiveYearData.csv", destfile = "data/gapminder-FiveYearData.csv")
> gapminder <- read.csv("data/gapminder-FiveYearData.csv")
> ~~~
> {: .r}
>
> * Alternatively, you can also read in files directly into R from the Internet by replacing the file paths with a web address in `read.csv`. One should note that in doing this no local copy of the csv file is first saved onto your computer. For example,
> 
> ~~~
> gapminder <- read.csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder-FiveYearData.csv")
> ~~~
> {: .r}
>
> * You can read directly from excel spreadsheets without
> converting them to plain text first by using the [readxl](https://cran.r-project.org/web/packages/readxl/index.html) package.
{: .callout}

Let's investigate gapminder a bit; the first thing we should always do is check
out what the data looks like with `str`:


~~~
str(gapminder)
~~~
{: .r}



~~~
'data.frame':	1704 obs. of  6 variables:
 $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
 $ pop      : num  8425333 9240934 10267083 11537966 13079460 ...
 $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
 $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
 $ gdpPercap: num  779 821 853 836 740 ...
~~~
{: .output}

We can also examine individual columns of the data frame with our `typeof` function:


~~~
typeof(gapminder$year)
~~~
{: .r}



~~~
[1] "integer"
~~~
{: .output}



~~~
typeof(gapminder$country)
~~~
{: .r}



~~~
[1] "integer"
~~~
{: .output}



~~~
str(gapminder$country)
~~~
{: .r}



~~~
 Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
~~~
{: .output}

We can also interrogate the data frame for information about its dimensions;
remembering that `str(gapminder)` said there were 1704 observations of 6
variables in gapminder, what do you think the following will produce, and why?


~~~
length(gapminder)
~~~
{: .r}



~~~
[1] 6
~~~
{: .output}

A fair guess would have been to say that the length of a data frame would be the
number of rows it has (1704), but this is not the case; remember, a data frame
is a *list of vectors and factors*:


~~~
typeof(gapminder)
~~~
{: .r}



~~~
[1] "list"
~~~
{: .output}

When `length` gave us 6, it's because gapminder is built out of a list of 6
columns. To get the number of rows and columns in our dataset, try:


~~~
nrow(gapminder)
~~~
{: .r}



~~~
[1] 1704
~~~
{: .output}



~~~
ncol(gapminder)
~~~
{: .r}



~~~
[1] 6
~~~
{: .output}

Or, both at once:


~~~
dim(gapminder)
~~~
{: .r}



~~~
[1] 1704    6
~~~
{: .output}

We'll also likely want to know what the titles of all the columns are, so we can
ask for them later:


~~~
colnames(gapminder)
~~~
{: .r}



~~~
[1] "country"   "year"      "pop"       "continent" "lifeExp"   "gdpPercap"
~~~
{: .output}

At this stage, it's important to ask ourselves if the structure R is reporting
matches our intuition or expectations; do the basic data types reported for each
column make sense? If not, we need to sort any problems out now before they turn
into bad surprises down the road, using what we've learned about how R
interprets data, and the importance of *strict consistency* in how we record our
data.

Once we're happy that the data types and structures seem reasonable, it's time
to start digging into our data proper. Check out the first few lines:


~~~
head(gapminder)
~~~
{: .r}



~~~
      country year      pop continent lifeExp gdpPercap
1 Afghanistan 1952  8425333      Asia  28.801  779.4453
2 Afghanistan 1957  9240934      Asia  30.332  820.8530
3 Afghanistan 1962 10267083      Asia  31.997  853.1007
4 Afghanistan 1967 11537966      Asia  34.020  836.1971
5 Afghanistan 1972 13079460      Asia  36.088  739.9811
6 Afghanistan 1977 14880372      Asia  38.438  786.1134
~~~
{: .output}

To make sure our analysis is reproducible, we should put the code
into a script file so we can come back to it later.

> ## Challenge 2
>
> Go to file -> new file -> R script, and write an R script
> to load in the gapminder dataset. Put it in the `scripts/`
> directory.
>
> Run the script using the `source` function, using the file path
> as its argument (or by pressing the "source" button in RStudio).
>
> > ## Solution to Challenge 2
> > The contents of `script/load-gapminder.R`:
> > 
> > ~~~
> > download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder-FiveYearData.csv", destfile = "data/gapminder-FiveYearData.csv")
> > gapminder <- read.csv(file = "data/gapminder-FiveYearData.csv")
> > ~~~
> > {: .r}
> > To run the script and load the data into the `gapminder` variable:
> > 
> > ~~~
> > source(file = "scripts/load-gapminder.R")
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}

> ## Challenge 3
>
> Read the output of `str(gapminder)` again;
> this time, use what you've learned about factors, lists and vectors,
> as well as the output of functions like `colnames` and `dim`
> to explain what everything that `str` prints out for gapminder means.
> If there are any parts you can't interpret, discuss with your neighbors!
>
> > ## Solution to Challenge 3
> >
> > The object `gapminder` is a data frame with columns
> > - `country` and `continent` are factors.
> > - `year` is an integer vector.
> > - `pop`, `lifeExp`, and `gdpPercap` are numeric vectors.
> >
> {: .solution}
{: .challenge}
