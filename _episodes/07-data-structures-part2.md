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
in the `dplyr` package.   They require that both arguments are tibbles, data frames or lists that could be made tibbles or data frames.  In practice this means that, if we are adding a row from a list, the list elements must have the same names as the columns in the tibble we are joining the list to.

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

We can also add additional rows to a tibble by defining a list with namesd elements (recall that each row of a tibble is a list).  This is demonstrated in the solution to challenge 1.



## Removing rows

We now know how to add rows and columns to our tibble. How do we delete them?


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


> ## Challenge 1
>
> You can create a new tibble from within R with the following syntax:
> 
> ~~~
> tib <- tibble(id = c('a', 'b', 'c'),
>                  x = 1:3,
>                  y = c(TRUE, TRUE, FALSE))
> ~~~
> {: .r}
> Make a tibble that holds the following information for yourself:
>
> - first name
> - last name
> - lucky number
>
> Then use `bind_rows()` to add entries the people sitting beside you.
> Finally, use `bind_cols()` to add a column with each person's answer to the question, "Is it time for coffee break?"
>
> > ## Solution to Challenge 1
> > 
> > ~~~
> > people <- tibble(first = 'Grace',
> >                  last = 'Hopper',
> >                  lucky_number = 0)
> > # We can add an extra row by defining a tibble containing the row:
> > people <- bind_rows(people, tibble(first = 'Marie',
> >                                        last = 'Curie',
> >                                        lucky_number = 238))
> > # Or by adding a named list to the tibble
> > # Note that tibble columns are bound by name
> > people <- bind_rows(people, list(
> >                                      last = 'Turing',
> >                                      first = 'Alan',
> >                                      lucky_number = 1) )
> > # When columns are added they are joined by *position*                              
> > people <- bind_cols(people, coffeetime = c(TRUE, FALSE, TRUE))
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}

Let's investigate gapminder a bit; the first thing we should always do is check
out what the data looks like with `str`:


~~~
str(gapminder)
~~~
{: .r}



~~~
Error in str(gapminder): object 'gapminder' not found
~~~
{: .error}

We can also examine individual columns of the data frame with our `typeof` function:


~~~
typeof(gapminder$year)
~~~
{: .r}



~~~
Error in typeof(gapminder$year): object 'gapminder' not found
~~~
{: .error}



~~~
typeof(gapminder$country)
~~~
{: .r}



~~~
Error in typeof(gapminder$country): object 'gapminder' not found
~~~
{: .error}



~~~
str(gapminder$country)
~~~
{: .r}



~~~
Error in str(gapminder$country): object 'gapminder' not found
~~~
{: .error}

We can also interrogate the data frame for information about its dimensions;
remembering that `str(gapminder)` said there were 1704 observations of 6
variables in gapminder, what do you think the following will produce, and why?


~~~
length(gapminder)
~~~
{: .r}



~~~
Error in eval(expr, envir, enclos): object 'gapminder' not found
~~~
{: .error}

A fair guess would have been to say that the length of a data frame would be the
number of rows it has (1704), but this is not the case; remember, a data frame
is a *list of vectors and factors*:


~~~
typeof(gapminder)
~~~
{: .r}



~~~
Error in typeof(gapminder): object 'gapminder' not found
~~~
{: .error}

When `length` gave us 6, it's because gapminder is built out of a list of 6
columns. To get the number of rows and columns in our dataset, try:


~~~
nrow(gapminder)
~~~
{: .r}



~~~
Error in nrow(gapminder): object 'gapminder' not found
~~~
{: .error}



~~~
ncol(gapminder)
~~~
{: .r}



~~~
Error in ncol(gapminder): object 'gapminder' not found
~~~
{: .error}

Or, both at once:


~~~
dim(gapminder)
~~~
{: .r}



~~~
Error in eval(expr, envir, enclos): object 'gapminder' not found
~~~
{: .error}

We'll also likely want to know what the titles of all the columns are, so we can
ask for them later:


~~~
colnames(gapminder)
~~~
{: .r}



~~~
Error in is.data.frame(x): object 'gapminder' not found
~~~
{: .error}

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
Error in head(gapminder): object 'gapminder' not found
~~~
{: .error}

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
