---
title: "Data Structures"
teaching: 75
exercises: 20
questions:
- "How can I read tabular data in R?"
- "What are the basic data types in R?"
- "How do I represent categorical information in R?"
- "How do I determine the type, class and structure of an object?"
objectives:
- "To be aware of the different types of data."
- "To begin exploring tibbles, and understand how they are related to vectors, factors and lists."
- "To be able to ask questions from R about the type, class, and structure of an object."
keypoints:
- "Tibbles let us store tabular data in R.  Tibbles are an extension of the base R data.frame."
- "Use `read_csv` to read tabular data into a tibble R."
- "The basic data types in R are double, integer, complex, logical, and character."
- "Use factors to represent categories in R. You should specify the levels of your factors."
source: Rmd
---



One of R's most powerful features is its ability to deal with tabular data -
such as you may already have in a spreadsheet or a CSV file. Let's start by
making a toy dataset in your `data/` directory, called `feline-data.csv`:


~~~
coat,weight,likes_string
calico,2.1,1
black,5.0,0
tabby,3.2,1
~~~
{: .r}

> ## Tip: Editing Text files in R
>
> Alternatively, you can create `data/feline-data.csv` using a text editor (Nano),
> or within RStudio with the **File -> New File -> Text File** menu item.
{: .callout}



We can load this into R via the following:


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

We see that the `read_csv()` table reports a "column specification".  This shows the variable names that were read in, and the type of data that each column was interpreted as.  We will discuss data-types shortly.


_R comes with a built in function `read.csv()`; this has several annoying default options, and can be slow for large data-sets.  Instead we use the `read_csv()` function, which is part of the `readr` package._

> ## Miscellaneous Tips
>
> * Another type of file you might encounter are tab-separated value files (.tsv); these can be read with the `read_tsv()` function in the `readr` package.  To read files with other delimiters, use the `read_delim()` function. If files are fixed width format (i.e. the variable is defined by its position on the line), then `read_fwf()` is they way to go.
>
> * Files can also be downloaded directly from the Internet into a local
> folder of your choice onto your computer using the `download.file` function.
> The `read_csv` function can then be executed to read the downloaded file from the download location, for example,
> 
> ~~~
> download.file("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder-FiveYearData.csv", destfile = "data/gapminder-FiveYearData.csv")
> gapminder <- read_csv("data/gapminder-FiveYearData.csv")
> ~~~
> {: .r}
>
> * Alternatively, you can also read in files directly into R from the Internet by replacing the file paths with a web address in `read_csv`. One should note that in doing this no local copy of the csv file is first saved onto your computer. For example,
> 
> ~~~
> gapminder <- read_csv("https://raw.githubusercontent.com/swcarpentry/r-novice-gapminder/gh-pages/_episodes_rmd/data/gapminder-FiveYearData.csv")
> ~~~
> {: .r}
>
> * You can read directly from excel spreadsheets without
> converting them to plain text first by using the [readxl](http://readxl.tidyverse.org) package, which is part of the tidyverse (although not loaded by default).
{: .callout}

As we're using RStudio, we can preview our data-set by selecting it from the "Environment" tab.  

We can begin exploring our dataset right away, pulling out columns by specifying
them using the `$` operator (RStudio will auto-complete, and offer suggested column names as you type.  You can accept the suggestion by pressing "tab", and select from the list of possible selections using the up and down arrow keys):


~~~
cats$weight
~~~
{: .r}



~~~
[1] 2.1 5.0 3.2
~~~
{: .output}



~~~
cats$coat
~~~
{: .r}



~~~
[1] "calico" "black"  "tabby" 
~~~
{: .output}

We can do other operations on the columns:


~~~
## Say we discovered that the scale weighs two Kg light:
cats$weight + 2
~~~
{: .r}



~~~
[1] 4.1 7.0 5.2
~~~
{: .output}



~~~
paste("My cat is", cats$coat)
~~~
{: .r}



~~~
[1] "My cat is calico" "My cat is black"  "My cat is tabby" 
~~~
{: .output}

But what about


~~~
cats$weight + cats$coat
~~~
{: .r}



~~~
Error in cats$weight + cats$coat: non-numeric argument to binary operator
~~~
{: .error}

Understanding what happened here is key to successfully analyzing data in R.

## Data Types

If you guessed that the last command will return an error because `2.1` plus
`"black"` is nonsense, you're right - and you already have some intuition for an
important concept in programming called *data types*. We can ask what type of
data something is:


~~~
typeof(cats$weight)
~~~
{: .r}



~~~
[1] "double"
~~~
{: .output}

There are 5 main types: `double`, `integer`, `complex`, `logical` and `character`.


~~~
typeof(3.14)
~~~
{: .r}



~~~
[1] "double"
~~~
{: .output}



~~~
typeof(1L) # The L suffix forces the number to be an integer, since by default R uses float numbers
~~~
{: .r}



~~~
[1] "integer"
~~~
{: .output}



~~~
typeof(1 + 1i)
~~~
{: .r}



~~~
[1] "complex"
~~~
{: .output}



~~~
typeof(TRUE)
~~~
{: .r}



~~~
[1] "logical"
~~~
{: .output}



~~~
typeof('banana')
~~~
{: .r}



~~~
[1] "character"
~~~
{: .output}

No matter how
complicated our analyses become, all data in R is interpreted as one of these
basic data types. This strictness has some really important consequences.

A user has added details of another cat. This information is in the file
`data/feline-data_v2.csv`.



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

Load the new cats data like before, and check what type of data we find in the
`weight` column:


~~~
cats <- read_csv(file = "data/feline-data_v2.csv")
~~~
{: .r}



~~~
Parsed with column specification:
cols(
  coat = col_character(),
  weight = col_character(),
  likes_string = col_integer()
)
~~~
{: .output}

If we compare this column specification to the column specification before, we see that the weight column has now been read in as `col_character()` instead of `col_double()`.  
If we try to do the same math
we did on them before, we run into trouble:


~~~
cats$weight + 2
~~~
{: .r}



~~~
Error in cats$weight + 2: non-numeric argument to binary operator
~~~
{: .error}

What happened? When R reads a csv file into one of these tables, it insists that
everything in a column be the same basic type; if it can't understand
*everything* in the column as a double, then *nothing* in the column gets to be a
double. The table that R loaded our cats data into is something called a
*tibble*, and it is our first example of something called a *data
structure* - that is, a structure which is built out of the basic
data types.

> # On tibbles
> 
> We used the `read_csv()` function, which is part of the `readr` package
> to load the data.  This is similar to R's inbuilt `read.csv()`.  
> R's standard data structure for tabular data is the `data.frame`.  In
> contrast, `read_csv()` creates a `tibble` (also referred to, for historic
> reasons, as a `tbl_df`).  This extends the functionality of  a `data.frame`,
> and can, for the most part, be treated like a `data.frame`
> 
> You may find that some older functions don't work on tibbles.   A tibble
> can be converted to a dataframe using `as.data.frame(mytibble)`.  To convert
> a data frame to a tibble, use `as.tibble(mydataframe)`
>
{: .callout}

In order to successfully use our data in R, we need to understand what the basic
data structures are, and how they behave. For now, let's remove that extra line
from our cats data and reload it, while we investigate this behavior further:



~~~
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

## Vectors and Type Coercion

To better understand this behavior, let's meet another of the data structures:
the *vector*.


~~~
my_vector <- vector(length = 3)
my_vector
~~~
{: .r}



~~~
[1] FALSE FALSE FALSE
~~~
{: .output}

A vector in R is essentially an ordered list of things, with the special
condition that *everything in the vector must be the same basic data type*. If
you don't choose the datatype, it'll default to `logical`; or, you can declare
an empty vector of whatever type you like.


~~~
another_vector <- vector(mode = 'character', length = 3)
another_vector
~~~
{: .r}



~~~
[1] "" "" ""
~~~
{: .output}

You can check if something is a vector:


~~~
str(another_vector)
~~~
{: .r}



~~~
 chr [1:3] "" "" ""
~~~
{: .output}

The somewhat cryptic output from this command indicates the basic data type
found in this vector - in this case `chr`, character; an indication of the
number of things in the vector - actually, the indexes of the vector, in this
case `[1:3]`; and a few examples of what's actually in the vector - in this case
empty character strings. If we similarly do


~~~
str(cats$weight)
~~~
{: .r}



~~~
 num [1:3] 2.1 5 3.2
~~~
{: .output}

we see that `cats$weight` is a vector, too - *the columns of data we load into a tibble or a 
data.frame are all vectors*, and that's the root of why R forces everything in
a column to be the same basic data type.

> ## Discussion 1
>
> Why is R so opinionated about what we put in our columns of data?
> How does this help us?
>
> > ## Discussion 1
> >
> > By keeping everything in a column the same, we allow ourselves to make simple
> > assumptions about our data; if you can interpret one entry in the column as a
> > number, then you can interpret *all* of them as numbers, so we don't have to
> > check every time. This consistency is what people mean when they talk about 
> > *clean data*; in the long run, strict consistency goes a long way to making 
> > our lives easier in R.
> {: .solution}
{: .discussion}

You can also make vectors with explicit contents with the combine function:


~~~
combine_vector <- c(2,6,3)
combine_vector
~~~
{: .r}



~~~
[1] 2 6 3
~~~
{: .output}

Given what we've learned so far, what do you think the following will produce?


~~~
quiz_vector <- c(2,6,'3')
~~~
{: .r}

This is something called *type coercion*, and it is the source of many surprises
and the reason why we need to be aware of the basic data types and how R will
interpret them. When R encounters a mix of types (here numeric and character) to
be combined into a single vector, it will force them all to be the same
type. Consider:


~~~
coercion_vector <- c('a', TRUE)
coercion_vector
~~~
{: .r}



~~~
[1] "a"    "TRUE"
~~~
{: .output}



~~~
another_coercion_vector <- c(0, TRUE)
another_coercion_vector
~~~
{: .r}



~~~
[1] 0 1
~~~
{: .output}

The coercion rules go: `logical` -> `integer` -> `numeric` -> `complex` ->
`character`, where -> can be read as *are transformed into*. You can try to
force coercion against this flow using the `as.` functions:


~~~
character_vector_example <- c('0','2','4')
character_vector_example
~~~
{: .r}



~~~
[1] "0" "2" "4"
~~~
{: .output}



~~~
character_coerced_to_numeric <- as.numeric(character_vector_example)
character_coerced_to_numeric
~~~
{: .r}



~~~
[1] 0 2 4
~~~
{: .output}



~~~
numeric_coerced_to_logical <- as.logical(character_coerced_to_numeric)
numeric_coerced_to_logical
~~~
{: .r}



~~~
[1] FALSE  TRUE  TRUE
~~~
{: .output}

As you can see, some surprising things can happen when R forces one basic data
type into another! Nitty-gritty of type coercion aside, the point is: if your
data doesn't look like what you thought it was going to look like, type coercion
may well be to blame; make sure everything is the same type in your vectors and
your columns of data.frames, or you will get nasty surprises!

But coercion can also be very useful! For example, in our `cats` data
`likes_string` is numeric, but we know that the 1s and 0s actually represent
`TRUE` and `FALSE` (a common way of representing them). We should use the
`logical` datatype here, which has two states: `TRUE` or `FALSE`, which is
exactly what our data represents. We can 'coerce' this column to be `logical` by
using the `as.logical` function:


~~~
cats$likes_string
~~~
{: .r}



~~~
[1] 1 0 1
~~~
{: .output}



~~~
cats$likes_string <- as.logical(cats$likes_string)
cats$likes_string
~~~
{: .r}



~~~
[1]  TRUE FALSE  TRUE
~~~
{: .output}

The combine function, `c()`, will also append things to an existing vector:


~~~
ab_vector <- c('a', 'b')
ab_vector
~~~
{: .r}



~~~
[1] "a" "b"
~~~
{: .output}



~~~
combine_example <- c(ab_vector, 'SWC')
combine_example
~~~
{: .r}



~~~
[1] "a"   "b"   "SWC"
~~~
{: .output}

You can also make series of numbers:


~~~
mySeries <- 1:10
mySeries
~~~
{: .r}



~~~
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}



~~~
seq(10)
~~~
{: .r}



~~~
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}



~~~
seq(1,10, by = 0.1)
~~~
{: .r}



~~~
 [1]  1.0  1.1  1.2  1.3  1.4  1.5  1.6  1.7  1.8  1.9  2.0  2.1  2.2  2.3
[15]  2.4  2.5  2.6  2.7  2.8  2.9  3.0  3.1  3.2  3.3  3.4  3.5  3.6  3.7
[29]  3.8  3.9  4.0  4.1  4.2  4.3  4.4  4.5  4.6  4.7  4.8  4.9  5.0  5.1
[43]  5.2  5.3  5.4  5.5  5.6  5.7  5.8  5.9  6.0  6.1  6.2  6.3  6.4  6.5
[57]  6.6  6.7  6.8  6.9  7.0  7.1  7.2  7.3  7.4  7.5  7.6  7.7  7.8  7.9
[71]  8.0  8.1  8.2  8.3  8.4  8.5  8.6  8.7  8.8  8.9  9.0  9.1  9.2  9.3
[85]  9.4  9.5  9.6  9.7  9.8  9.9 10.0
~~~
{: .output}

We can ask a few questions about vectors:


~~~
sequence_example <- seq(10)
head(sequence_example, n = 2)
~~~
{: .r}



~~~
[1] 1 2
~~~
{: .output}



~~~
tail(sequence_example, n = 4)
~~~
{: .r}



~~~
[1]  7  8  9 10
~~~
{: .output}



~~~
length(sequence_example)
~~~
{: .r}



~~~
[1] 10
~~~
{: .output}



~~~
class(sequence_example)
~~~
{: .r}



~~~
[1] "integer"
~~~
{: .output}



~~~
typeof(sequence_example)
~~~
{: .r}



~~~
[1] "integer"
~~~
{: .output}

Finally, you can give names to elements in your vector:


~~~
my_example <- 5:8
names(my_example) <- c("a", "b", "c", "d")
my_example
~~~
{: .r}



~~~
a b c d 
5 6 7 8 
~~~
{: .output}



~~~
names(my_example)
~~~
{: .r}



~~~
[1] "a" "b" "c" "d"
~~~
{: .output}

> ## Challenge 1
>
> Start by making a vector with the numbers 1 through 26.
> Multiply the vector by 2, and give the resulting vector
> names A through Z (hint: there is a built in vector called `LETTERS`)
>
> > ## Solution to Challenge 1
> >
> > 
> > ~~~
> > x <- 1:26
> > x <- x * 2
> > names(x) <- LETTERS
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}

## Subsetting vectors

We often need to extract a subset of the elements in a vector.  R provides a number of ways
to do this, which we will explain in this section. As we'll see, these ideas extend naturally
to more complex data structures such as lists and tibbles.


## Accessing elements using their indices

To extract elements of a vector we can give their corresponding index, starting
from one:


~~~
my_example[1]
~~~
{: .r}



~~~
a 
5 
~~~
{: .output}


~~~
my_example[4]
~~~
{: .r}



~~~
d 
8 
~~~
{: .output}

It may look different, but the square brackets operator is a function. For atomic vectors
(and matrices), it means "get me the nth element".

We can ask for multiple elements at once:


~~~
my_example[c(1, 3)]
~~~
{: .r}



~~~
a c 
5 7 
~~~
{: .output}

Or slices of the vector:


~~~
my_example[1:4]
~~~
{: .r}



~~~
a b c d 
5 6 7 8 
~~~
{: .output}

the `:` operator creates a sequence of numbers from the left element to the right.

~~~
1:4
~~~
{: .r}



~~~
[1] 1 2 3 4
~~~
{: .output}



~~~
c(1, 2, 3, 4)
~~~
{: .r}



~~~
[1] 1 2 3 4
~~~
{: .output}


We can ask for the same element multiple times:


~~~
my_example[c(1,1,3)]
~~~
{: .r}



~~~
a a c 
5 5 7 
~~~
{: .output}

If we ask for a number outside of the vector, R will return missing values:


~~~
x[6]
~~~
{: .r}



~~~
 F 
12 
~~~
{: .output}

This is a vector of length one containing an `NA`, whose name is also `NA`.

If we ask for the 0th element, we get an empty vector:


~~~
x[0]
~~~
{: .r}



~~~
named numeric(0)
~~~
{: .output}

> ## Vector numbering in R starts at 1
>
> In many programming languages (C and python, for example), the first
> element of a vector has an index of 0. In R, the first element is 1.
{: .callout}

## Skipping and removing elements

If we use a negative number as the index of a vector, R will return
every element *except* for the one specified:


~~~
my_example[-2]
~~~
{: .r}



~~~
a c d 
5 7 8 
~~~
{: .output}


We can skip multiple elements:


~~~
my_example[c(-1, -5)]  # or x[-c(1,5)]
~~~
{: .r}



~~~
b c d 
6 7 8 
~~~
{: .output}

> ## Tip: Order of operations
>
> A common trip up for novices occurs when trying to skip
> slices of a vector. Most people first try to negate a
> sequence like so:
>
> 
> ~~~
> my_example[-1:3]
> ~~~
> {: .r}
>
> This gives a somewhat cryptic error:
>
> 
> ~~~
> Error in my_example[-1:3]: only 0's may be mixed with negative subscripts
> ~~~
> {: .error}
>
> But remember the order of operations. `:` is really a function, so
> what happens is it takes its first argument as -1, and second as 3,
> so generates the sequence of numbers: `c(-1, 0, 1, 2, 3)`.
>
> The correct solution is to wrap that function call in brackets, so
> that the `-` operator applies to the results:
>
> 
> ~~~
> my_example[-(1:3)]
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> d 
> 8 
> ~~~
> {: .output}
{: .callout}



> ## Challenge 1
>
> Given the following code:
>
> 
> ~~~
> x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
> names(x) <- c('a', 'b', 'c', 'd', 'e')
> print(x)
> ~~~
> {: .r}
> 
> 
> 
> ~~~
>   a   b   c   d   e 
> 5.4 6.2 7.1 4.8 7.5 
> ~~~
> {: .output}
>
> Come up with at least 3 different commands that will produce the following output:
>
> 
> ~~~
>   b   c   d 
> 6.2 7.1 4.8 
> ~~~
> {: .output}
>
> After you find 3 different commands, compare notes with your neighbour. Did you have different strategies?
>
> > ## Solution to challenge 1
> >
> > 
> > ~~~
> > x[2:4]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> >   b   c   d 
> > 6.2 7.1 4.8 
> > ~~~
> > {: .output}
> > 
> > ~~~
> > x[-c(1,5)]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> >   b   c   d 
> > 6.2 7.1 4.8 
> > ~~~
> > {: .output}
> > 
> > ~~~
> > x[c("b", "c", "d")]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> >   b   c   d 
> > 6.2 7.1 4.8 
> > ~~~
> > {: .output}
> > 
> > ~~~
> > x[c(2,3,4)]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> >   b   c   d 
> > 6.2 7.1 4.8 
> > ~~~
> > {: .output}
> >
> {: .solution}
{: .challenge}

## Subsetting by name

We can extract elements by using their name, instead of index:


~~~
my_example[c("a", "c")]
~~~
{: .r}



~~~
a c 
5 7 
~~~
{: .output}

This is usually a much more reliable way to subset objects: the
position of various elements can often change when chaining together
subsetting operations, but the names will always remain the same.

Unfortunately we can't skip or remove elements so easily.

To skip (or remove) a single named element:


~~~
my_example[!(names(my_example) == "a")]
~~~
{: .r}



~~~
b c d 
6 7 8 
~~~
{: .output}


Let's break this down so that its clearer what's happening.

First this happens:


~~~
names(my_example) == "a"
~~~
{: .r}



~~~
[1]  TRUE FALSE FALSE FALSE
~~~
{: .output}

The condition operator is applied to every name of the vector `my_example`. Only the
first name is "a" so that element is TRUE, and all the other elements are `FALSE`.

`!` is the logical NOT operator, and so converts `TRUE` to `FALSE` and vice versa; all of the
elements except the first are now `TRUE`:


~~~
!(names(my_example) == "a")
~~~
{: .r}



~~~
[1] FALSE  TRUE  TRUE  TRUE
~~~
{: .output}

Only elements of the vector that are true will be kept


> ## Tip: Non-unique names
>
> You should be aware that it is possible for multiple elements in a
> vector to have the same name.  Consider these examples:
>
>
>~~~
> x <- 1:3
> x
>~~~
>{: .r}
>
>
>
>~~~
>[1] 1 2 3
>~~~
>{: .output}
>
>
>
>~~~
> names(x) <- c('a', 'a', 'a')
> x
>~~~
>{: .r}
>
>
>
>~~~
>a a a 
>1 2 3 
>~~~
>{: .output}
>
>
>
>~~~
> x['a']  # only returns first value
>~~~
>{: .r}
>
>
>
>~~~
>a 
>1 
>~~~
>{: .output}
>
>
>
>~~~
> x[names(x) == 'a']  # returns all three values
>~~~
>{: .r}
>
>
>
>~~~
>a a a 
>1 2 3 
>~~~
>{: .output}
{: .callout}

Skipping multiple named indices is similar, but uses a different comparison
operator:


~~~
my_example[!(names(my_example) %in% c("a", "c"))]
~~~
{: .r}



~~~
b d 
6 8 
~~~
{: .output}

The `%in%` goes through each element of its left argument, in this case the
names of `my_example`, and asks, "Does this element occur in the second argument?".

> ## Tip: Getting help for operators
>
> Remember you can search for help on operators by wrapping them in quotes:
> `help("%in%")` or `?"%in%"`.
>
{: .callout}


So why can't we use `==` like before? That's an excellent question.

Let's take a look at the comparison component of this code:


~~~
names(my_example) == c('a', 'c')
~~~
{: .r}



~~~
[1]  TRUE FALSE FALSE FALSE
~~~
{: .output}

"c" is in the names of `my_example`, so why didn't this work? `==`
works slightly differently than `%in%`. It will compare each element
of its left argument to the corresponding element of its right
argument. What happens when you compare vectors of different lengths?

![Equality testing](../fig/rmd-06-equality.1.png)

When one vector is shorter than the other, it gets *recycled*:

![Equality testing](../fig/rmd-06-equality.2.png)

In this case R simply repeats `c("a", "c")` twice. Since the recycled "a"
matches x again we got the output: TRUE FALSE TRUE

If the longer vector length isn't a multiple of the shorter vector 
length, then R will also print out a warning message.


~~~
names(my_example) == c('a', 'c', 'e')
~~~
{: .r}



~~~
Warning in names(my_example) == c("a", "c", "e"): longer object length is
not a multiple of shorter object length
~~~
{: .error}



~~~
[1]  TRUE FALSE FALSE FALSE
~~~
{: .output}

This difference between `==` and `%in%` is important to remember,
because it can introduce hard to find and subtle bugs!

## Subsetting through other logical operations

When we removed a single named element one of the intermediate steps was a logical vector: 


~~~
my_example[c(TRUE, TRUE, FALSE, FALSE)]
~~~
{: .r}



~~~
a b 
5 6 
~~~
{: .output}

Note that in this case, the logical vector is also recycled to the
length of the vector we're subsetting!


~~~
my_example[c(TRUE, FALSE)]
~~~
{: .r}



~~~
a c 
5 7 
~~~
{: .output}

Since comparison operators evaluate to logical vectors, we can also
use them to succinctly subset vectors:


~~~
my_example[my_example >= 7]
~~~
{: .r}



~~~
c d 
7 8 
~~~
{: .output}

> ## Tip: Combining logical conditions
>
> There are many situations in which you will wish to combine multiple logical
> criteria. For example, we might want to find all the countries that are
> located in Asia **or** Europe **and** have life expectancies within a certain
> range. Several operations for combining logical vectors exist in R:
>
>  * `&`, the "logical AND" operator: returns `TRUE` if both the left and right
>    are `TRUE`.
>  * `|`, the "logical OR" operator: returns `TRUE`, if either the left or right
>    (or both) are `TRUE`.
>
> The recycling rule applies with both of these, so `TRUE & c(TRUE, FALSE, TRUE)`
> will compare the first `TRUE` on the left of the `&` sign with each of the
> three conditions on the right.
>
> You may sometimes see `&&` and `||` instead of `&` and `|`. These operators
> do not use the recycling rule: they only look at the first element of each
> vector and ignore the remaining elements. The longer operators are mainly used
> in programming, rather than data analysis.
>
>  * `!`, the "logical NOT" operator: converts `TRUE` to `FALSE` and `FALSE` to
>    `TRUE`. It can negate a single logical condition (e.g. `!TRUE` becomes
>    `FALSE`), or a whole vector of conditions(e.g. `!c(TRUE, FALSE)` becomes
>    `c(FALSE, TRUE)`).
>
> Additionally, you can compare the elements within a single vector using the
> `all` function (which returns `TRUE` if every element of the vector is `TRUE`)
> and the `any` function (which returns `TRUE` if one or more elements of the
> vector are `TRUE`).
{: .callout}

> ## Challenge 2
>
> Given the following code:
>
> 
> ~~~
> x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
> names(x) <- c('a', 'b', 'c', 'd', 'e')
> print(x)
> ~~~
> {: .r}
> 
> 
> 
> ~~~
>   a   b   c   d   e 
> 5.4 6.2 7.1 4.8 7.5 
> ~~~
> {: .output}
>
> Write a subsetting command to return the values in x that are greater than 4 and less than 7.
>
> > ## Solution to challenge 2
> >
> > 
> > ~~~
> > x_subset <- x[x<7 & x>4]
> > print(x_subset)
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> >   a   b   d 
> > 5.4 6.2 4.8 
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

## Handling special values

At some point you will encounter functions in R which cannot handle missing, infinite,
or undefined data.

There are a number of special functions you can use to filter out this data:

 * `is.na` will return all positions in a vector, matrix, or data.frame
   containing `NA`.
 * likewise, `is.nan`, and `is.infinite` will do the same for `NaN` and `Inf`.
 * `is.finite` will return all positions in a vector, matrix, or data.frame
   that do not contain `NA`, `NaN` or `Inf`.
 * `na.omit` will filter out all missing values from a vector


## Factors

Another important data structure is called a *factor*. Factors usually look like
character data, but are typically used to represent categorical information. For
example, let's make a vector of strings labelling cat colorations for all the
cats in our study:


~~~
coats <- c('tabby', 'tortoiseshell', 'tortoiseshell', 'black', 'tabby')
coats
~~~
{: .r}



~~~
[1] "tabby"         "tortoiseshell" "tortoiseshell" "black"        
[5] "tabby"        
~~~
{: .output}



~~~
str(coats)
~~~
{: .r}



~~~
 chr [1:5] "tabby" "tortoiseshell" "tortoiseshell" "black" "tabby"
~~~
{: .output}

We can turn a vector into a factor like so:


~~~
CATegories <- parse_factor(coats, levels = NULL)
class(CATegories)
~~~
{: .r}



~~~
[1] "factor"
~~~
{: .output}



~~~
str(CATegories)
~~~
{: .r}



~~~
 Factor w/ 3 levels "tabby","tortoiseshell",..: 1 2 2 3 1
~~~
{: .output}

We specify `levels = NULL` to tell R to work out the levels to assign the factor.  The `parse_factor()`
function does this by setting the levels in the order it first encounters each level. 

The ordering of the levels matters in many statistical procedures.  For example, if we
were studying the effect of an experimental intervention we would normally wish to set
the control group to be the baseline level (i.e. the first level in the factor).  You can
change the levels by specifying the labels:


~~~
mydata <- c("case", "control", "control", "case")
factor_default_example <- parse_factor(mydata, levels = NULL)
str(factor_default_example)
~~~
{: .r}



~~~
 Factor w/ 2 levels "case","control": 1 2 2 1
~~~
{: .output}



~~~
factor_ordering_example <- parse_factor(mydata, levels = c("control", "case"))
str(factor_ordering_example)
~~~
{: .r}



~~~
 Factor w/ 2 levels "control","case": 2 1 1 2
~~~
{: .output}

In this case, we've explicitly told R that "control" should represented by 1, and
"case" by 2. 

> ## Challenge 2
>
> Try repeating the mydata example, but deliberately mis-spell one of the values
> e.g. "controll".  What happens when you try to make a factor of the data?  Does it
> make a difference whether you set the factor levels yourself, or let R set them?
>
> > ## Solution
> > 
> > If we use `levels = NULL` the factor will be created without a warning (with 
> > "controll" being assigned its own level).  If we explicitly specify the factor 
> > levels we get a warning indicating that the "controll" value has been set to NA.
> > **For this reason it is good practice to explicitly tell R what the factor levels
> > are; it is better to know that someting has gone wrong when it happens, rather than
> > finding out about it in your results.**
> {: .solution}
{: .challenge}
    
When we read data into a tibble, readr will never automatically create a factor for a string variable.  We can either convert the variable to a factor after we've read the data in:


~~~
cats$coat <- parse_factor(cats$coat, levels = c("black", "calico", "tabby"))
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

Or tell read_csv that we want the column to be read as a factor when we load the data in:


~~~
cats <- read_csv("data/feline-data.csv", 
                 col_types = cols(
                   coat = col_factor(levels = c("black", "calico", "tabby")
                                     )
                   )
                 )
~~~
{: .r}

> ## Doing more with factors
> 
> If you wish to perform more complex operations on factors, such as recoding 
> level names, changing level order, and collapsing multiple levels into one,
> the [forcats](http://forcats.tidyverse.org/) package, which is part of the tidyverse
> makes this easy.  Note that `forcats` isn't loaded by default, so you will
> need to use `library("forcats")` before using it.
{: .callout}

> ## Differences with base R
> 
> In this lesson we've taught you how to read files and make factors using the functionality in the
> `readr` package.  This section highlights some of the differences between the `readr` functions and
> their base R equivalents, in case you are reviewing code that uses them.
>
> `read_csv()` will always read variables containing text as character variables.  In contrast,
> the base R function `read.csv()` will, by default, convert any character variable to a factor.
> This is often not what you want.  This can be overridden by passing the option `stringsAsFactors = FALSE` 
> to `read.csv()`.  
>
> Base R can also make factors using the `factor()` function.
> the main differences between the two approaches are:
>
> * `factor()` does not require us to pass `levels = NULL` if we want R to work out the levels automatically
> * The automatic levels generated by `factor()` will be alphabetical (rather than according to the order
> that each level is encountered in `parse_factor()`)
> * `factor()` does not warn us if we have data that doesn't match any of the levels we have specified
> 
> It is chiefly for the final reason that we recommend using `parse_factor()` instead of `factor()`.  You
> should be aware that the default ordering of factor levels differs between `factor()` and `parse_factor()`
> though, as we mentioned, it's better practice to explicitly set factor levels anyway.
{: .callout}


## Lists

Another data structure you'll want in your bag of tricks is the `list`. A list
is simpler in some ways than the other types, because you can put anything you
want in it:


~~~
list_example <- list(1, "a", TRUE, 1 + 4i)
list_example
~~~
{: .r}



~~~
[[1]]
[1] 1

[[2]]
[1] "a"

[[3]]
[1] TRUE

[[4]]
[1] 1+4i
~~~
{: .output}



~~~
another_list <- list(title = "Numbers", numbers = 1:10, data = TRUE )
another_list
~~~
{: .r}



~~~
$title
[1] "Numbers"

$numbers
 [1]  1  2  3  4  5  6  7  8  9 10

$data
[1] TRUE
~~~
{: .output}

We can retrieve elements of the list either by referring to them by name:


~~~
another_list$numbers
~~~
{: .r}



~~~
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}

or by position:


~~~
another_list[[2]]
~~~
{: .r}



~~~
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}

We can return a list of several elements of a list using the  `[]` operator, either by name or
by position (but not a mixture of both):


~~~
another_list[c(1,2)]
~~~
{: .r}



~~~
$title
[1] "Numbers"

$numbers
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}



~~~
another_list[c("title", "numbers")]
~~~
{: .r}



~~~
$title
[1] "Numbers"

$numbers
 [1]  1  2  3  4  5  6  7  8  9 10
~~~
{: .output}



We can now understand something a bit surprising in our tibble; what happens if we run:


~~~
typeof(cats)
~~~
{: .r}



~~~
[1] "list"
~~~
{: .output}

We see that tibbles look like lists 'under the hood' - this is because a
tibble is really a list of vectors and factors (and some additional metadata; i.e. data about the data),
as they have to be - in
order to hold those columns that are a mix of vectors and factors, the
tibble needs something a bit more flexible than a vector to put all the
columns together into a familiar table.  In other words, a tibble is a
special list in which all the vectors must have the same length.



~~~
cats$coat
~~~
{: .r}



~~~
[1] calico black  tabby 
Levels: black calico tabby
~~~
{: .output}



~~~
cats[[1]]
~~~
{: .r}



~~~
[1] calico black  tabby 
Levels: black calico tabby
~~~
{: .output}



~~~
typeof(cats[[1]])
~~~
{: .r}



~~~
[1] "integer"
~~~
{: .output}



~~~
str(cats[[1]])
~~~
{: .r}



~~~
 Factor w/ 3 levels "black","calico",..: 2 1 3
~~~
{: .output}

Each row is an *observation* of different variables, itself a tibble, and
thus can be composed of elements of different types.


~~~
cats[1,]
~~~
{: .r}



~~~
# A tibble: 1 x 3
    coat weight likes_string
  <fctr>  <dbl>        <int>
1 calico    2.1            1
~~~
{: .output}



~~~
typeof(cats[1,])
~~~
{: .r}



~~~
[1] "list"
~~~
{: .output}



~~~
str(cats[1,])
~~~
{: .r}



~~~
Classes 'tbl_df', 'tbl' and 'data.frame':	1 obs. of  3 variables:
 $ coat        : Factor w/ 3 levels "black","calico",..: 2
 $ weight      : num 2.1
 $ likes_string: int 1
~~~
{: .output}

> ## Challenge 3
> There are several subtly different ways to call variables, observations and
> elements from tibbles:
>
> - `cats[1]`
> - `cats[[1]]`
> - `cats$coat`
> - `cats["coat"]`
> - `cats[1, 1]`
> - `cats[, 1]`
> - `cats[1, ]`
>
> Try out these examples and explain what is returned by each one.
>
> *Hint:* Use the functions `typeof()` and `str()` to examine what is returned in each case.
>
> > ## Solution to Challenge 3
> > 
> > ~~~
> > cats[1]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 3 x 1
> >     coat
> >   <fctr>
> > 1 calico
> > 2  black
> > 3  tabby
> > ~~~
> > {: .output}
> > The single `[]` returns a tibble containing the selected column(s)
> > 
> >
> > 
> > ~~~
> > cats[[1]]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > [1] calico black  tabby 
> > Levels: black calico tabby
> > ~~~
> > {: .output}
> > The double brace `[[1]]` returns the _contents_ of the tibble. In this case
> >  it is the contents of the first column, a _vector_ of type _factor_.
> > 
> > ~~~
> > cats$coat
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > [1] calico black  tabby 
> > Levels: black calico tabby
> > ~~~
> > {: .output}
> > This example uses the `$` character to address items by name. _coat_ is the
> > first column of the data frame, again a _vector_ of type _factor_.
> > 
> > 
> > ~~~
> > cats["coat"]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 3 x 1
> >     coat
> >   <fctr>
> > 1 calico
> > 2  black
> > 3  tabby
> > ~~~
> > {: .output}
> > Here we are using a single brace `["coat"]` replacing the index number with
> > the column name. Like example 1, the returned object is another tibble.
> > 
> > 
> > ~~~
> > cats[1, 1]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 1 x 1
> >     coat
> >   <fctr>
> > 1 calico
> > ~~~
> > {: .output}
> > This example uses a single brace, but this time we provide row and column
> coordinates. The returned object is a tibble containing the value in row 1, column 1. 
> >
> > 
> > ~~~
> > cats[, 1]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 3 x 1
> >     coat
> >   <fctr>
> > 1 calico
> > 2  black
> > 3  tabby
> > ~~~
> > {: .output}
> > Like the previous example we use single braces and provide row and column
> coordinates. The row coordinate is not specified, R interprets this missing
> value as all the elements in the specified _column_ _vector_.  The command returns
> a tibble.
> > 
> > 
> > ~~~
> > cats[1, ]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 1 x 3
> >     coat weight likes_string
> >   <fctr>  <dbl>        <int>
> > 1 calico    2.1            1
> > ~~~
> > {: .output}
> > Again we use the single brace with row and column coordinates. The column
> coordinate is not specified. The return value is a tibble containing all the
> values in the first row.
> >
> > If we extract a subset of a tibble the results are returned as another tibble.
> > This is one of the advantages of tibbles over base R's inbuilt data.frame type, 
> > which can return either a data frame or a vector depending on whether we select one
> > or multiple columns of data. 
> {: .solution}
{: .challenge}


> ## Challenge 4
>  Create a list of length two containing a character vector for each of the sections in this part of the workshop:
>
>  - Data types
>  - Data structures
>
>  Populate each character vector with the names of the data types and data
>  structures we've seen so far.
>
> > ## Solution to Challenge 4
> > 
> > ~~~
> > dataTypes <- c('double', 'complex', 'integer', 'character', 'logical')
> > dataStructures <- c('tibble', 'vector', 'factor', 'list')
> > answer <- list(dataTypes, dataStructures)
> > ~~~
> > {: .r}
> > Note: it's nice to make a list in big writing on the board or taped to the wall
> > listing all of these types and structures - leave it up for the rest of the workshop
> > to remind people of the importance of these basics.
> >
> {: .solution}
{: .challenge}


## Matrices

We can also define matrices in R.  We don't cover this in this course in any detail, since we are focussing
on data-analysis, rather than maths and algorithms.   For details of the matrix class, you can refer to the [original Software Carpentry version of these notes](http://swcarpentry.github.io/r-novice-gapminder/04-data-structures-part1/#matrices).

