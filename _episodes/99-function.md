---
title: Functions Explained (self study)
teaching: 0 
exercises: 0
questions:
- "How can I write a new function in R?"
- "How do we write functions that work with dplyr?"
objectives:
- "Explain why we should divide programs into small, single-purpose functions."
- "Define a function that takes arguments."
- "Return a value from a function."
- "Understand the benefits and drawbacks of non standard evaluation"
keypoints:
- "Use `function` to define a new function in R."
- "Use parameters to pass values into functions."
- "Load functions into programs using `source`."
source: Rmd
---



_This episode will form part of the forthcoming "Programming in R" course.  It is included in this course for self study. If you are interested in taking part in a pilot of the course, (provisionally scheduled for March/April 2018, please contact david.mawdsley@manchester.ac.uk)_

If we only had one data set to analyse, it would probably be faster to load the
file into a spreadsheet and use that to plot simple statistics. However, the
gapminder data is updated periodically, and we may want to pull in that new
information later and re-run our analysis again. We may also obtain similar data
from a different source in the future.

In this episode, we'll learn how to write a function so that we can repeat
several operations with a single command.

> ## What is a function?
>
> Functions gather a sequence of operations into a whole, preserving it for ongoing use. Functions provide:
>
> * a name we can remember and invoke it by
> * relief from the need to remember the individual operations
> * a defined set of inputs and expected outputs
> * rich connections to the larger programming environment
>
> As the basic building block of most programming languages, user-defined
> functions constitute "programming" as much as any single abstraction can. If
> you have written a function, you are a computer programmer.
{: .callout}

## Defining a function

Let's create a new R script file in the `src/` directory and call it functions-lesson.R:


~~~
my_sum <- function(a, b) {
  the_sum <- a + b
  return(the_sum)
}
~~~
{: .language-r}

We can use the function in the same way as any other functions we've used so far in this course:


~~~
my_sum(2,3)
~~~
{: .language-r}



~~~
[1] 5
~~~
{: .output}



~~~
my_sum(10,10)
~~~
{: .language-r}



~~~
[1] 20
~~~
{: .output}


Now let’s define a function `fahr_to_kelvin` that converts temperatures from Fahrenheit to Kelvin:


~~~
fahr_to_kelvin <- function(temp) {
  kelvin <- ((temp - 32) * (5 / 9)) + 273.15
  return(kelvin)
}
~~~
{: .language-r}

We define `fahr_to_kelvin` by assigning it to the output of `function`.  The
list of argument names are contained within parentheses.  Next, the
[body]({{ page.root }}/reference/#function-body) of the function---the statements that are
executed when it runs---is contained within curly braces (`{}`).  The statements
in the body are indented by two spaces.  This makes the code easier to read but
does not affect how the code operates.

When we call the function, the values we pass to it as arguments are assigned to those
variables so that we can use them inside the function.  Inside the function, we
use a [return statement]({{ page.root }}/reference/#return-statement) to send a result back
to whoever asked for it.

> ## Tip
>
> One feature unique to R is that the return statement is not required.
> R automatically returns whichever variable is on the last line of the body
> of the function. But for clarity, we will explicitly define the
> return statement.
{: .callout}


Let's try running our function.
Calling our own function is no different from calling any other function:


~~~
# freezing point of water
fahr_to_kelvin(32)
~~~
{: .language-r}



~~~
[1] 273.15
~~~
{: .output}


~~~
# boiling point of water
fahr_to_kelvin(212)
~~~
{: .language-r}



~~~
[1] 373.15
~~~
{: .output}

> ## Challenge 1
>
> Write a function called `kelvin_to_celsius` that takes a temperature in Kelvin
> and returns that temperature in Celsius
>
> Hint: To convert from Kelvin to Celsius you subtract 273.15
>
> > ## Solution to challenge 1
> >
> > Write a function called `kelvin_to_celsius` that takes a temperature in Kelvin
> > and returns that temperature in Celsius
> >
> > 
> > ~~~
> > kelvin_to_celsius <- function(temp) {
> >  celsius <- temp - 273.15
> >  return(celsius)
> > }
> > ~~~
> > {: .language-r}
> {: .solution}
{: .challenge}

## Combining functions

The real power of functions comes from mixing, matching and combining them
into ever-larger chunks to get the effect we want.

> ## Challenge 2
>
> Define the function to convert directly from Fahrenheit to Celsius,
> by using the `fahr_to_kelvin` function defined earlier, and the 
> `kelvin_to_celsius` function you wrote in challenge 1. 
>
> > ## Solution to challenge 2
> >
> > Define the function to convert directly from Fahrenheit to Celsius,
> > by reusing these two functions above
> >
> >
> > 
> > ~~~
> > fahr_to_celsius <- function(temp) {
> >   temp_k <- fahr_to_kelvin(temp)
> >   result <- kelvin_to_celsius(temp_k)
> >   return(result)
> > }
> > ~~~
> > {: .language-r}
> {: .solution}
{: .challenge}


> ## Tip: Function scope
>
> Another important concept is scoping: any variables (or functions!) you
> create or modify inside the body of a function only exist for the lifetime
> of the function's execution. When we call `calcGDP`, the variables `dat`,
> `gdp` and `new` only exist inside the body of the function. Even if we
> have variables of the same name in our interactive R session, they are
> not modified in any way when executing a function.
{: .callout}


## Using functions

If you've been writing these functions down into a separate R script , you can load in the functions into our R session by using the
`source` function:


~~~
source("src/functions-lesson.R")
~~~
{: .language-r}

It is a good idea to separate your analyis code and the functions it calls into separate files.  You 
can then `source()` your functions file at the start of your analyis script.



## Programming with dplyr

A lot of the "cleverness" of the tidyverse comes from how it handles the values we pass to its functions.
This lets us write code in a very expressive way (for example, the idea of treating the dplyr
pipelines as a sentence consisting of a series of verbs, with the `%>%` operator being read as "and then".)

Unfortunately this comes at a price when we come to use `dplyr` in our own functions.  The `dplyr` functions use what is known as Non Standard Evaluation; this means that they don't evaluate their parameters in the standard way that the examples in this episode have used so far.  This is probably the most complicted concept we will cover today, so pleae don't worry if you don't "get" it at first attempt. 

We'll illustrate this by way of an example.

Let's write a function that will filter our gapminder data by year *and* calculate the GDP of all the countries 
that are returned.   First, let's think about how we'd do this *without* using a function.  We'll then put our 
code in a function; this will let us easily repeat the calculation for other years, without re-writing the code.

This saves us effort, but more importantly it means that the code for calculating the GDP only exists in a single place.  If we find we've used the wrong formula to calculate GDP we would only need to change it in a single place, rather than hunting down all the places we've calculated it.  This important idea is known as "Don't Repeat Yourself".

We can filter and calculate the GDP as follows:


~~~
gdpgapfiltered <- gapminder %>%
    filter(year == 2007) %>% 
    mutate(gdp = gdpPercap * pop)
~~~
{: .language-r}

Note that we filter by year first, and _then_ calculate the GDP.  Although we could reverse the order of the `filter()` and `mutate()` functions, it is more efficient to filter the data and then calculate the GDP on the remaining data.

Let's put this code in a function; note that we change the input data to be the parameter we pass when we call
the function, and our hard-coded year to be the year parameter (it's _really_ easy to forget to make these changes
when you start making functions from existing code):


~~~
calc_GDP_and_filter <- function(dat, year){
  
  gdpgapfiltered <- dat %>%
      filter(year == year) %>% 
      mutate(gdp = gdpPercap * pop)
  
  return(gdpgapfiltered)
  
}

calc_GDP_and_filter(gapminder, 1997)
~~~
{: .language-r}



~~~
# A tibble: 1,704 x 7
       country  year      pop continent lifeExp gdpPercap         gdp
         <chr> <int>    <dbl>     <chr>   <dbl>     <dbl>       <dbl>
 1 Afghanistan  1952  8425333      Asia  28.801  779.4453  6567086330
 2 Afghanistan  1957  9240934      Asia  30.332  820.8530  7585448670
 3 Afghanistan  1962 10267083      Asia  31.997  853.1007  8758855797
 4 Afghanistan  1967 11537966      Asia  34.020  836.1971  9648014150
 5 Afghanistan  1972 13079460      Asia  36.088  739.9811  9678553274
 6 Afghanistan  1977 14880372      Asia  38.438  786.1134 11697659231
 7 Afghanistan  1982 12881816      Asia  39.854  978.0114 12598563401
 8 Afghanistan  1987 13867957      Asia  40.822  852.3959 11820990309
 9 Afghanistan  1992 16317921      Asia  41.674  649.3414 10595901589
10 Afghanistan  1997 22227415      Asia  41.763  635.3414 14121995875
# ... with 1,694 more rows
~~~
{: .output}

The function hasn't done what we'd expect; we've successfully passed in the gapminder data, via the `dat` parameter,
but it looks like the `year` parameter has been ignored.

Look at the line: 


~~~
    filter(year == year) %>% 
~~~
{: .language-r}

We passed a value of `year` into the function when we called it.  R has no way of knowing we're referring to the function parameter's `year` rather than the tibble's `year` variable.     We run into this problem because of dplyr's "Non Standard Evaluation" (NSE); this means that the functions don't follow R's usual rules about how parameters are evaluated.  

NSE is usually really useful; when we've written things like `gapminder %>% select(year, country)` we've made use of non standard evaluation.  This is much more intuitive than the base R equivalent, where we'd have to write something like `gapminder[, names(gapminder) %in% c("year", "country")]`. Non standard evaluation lets the `select()` function work out that we're referring to variable names in the tibble.  Unfortunately this simplicity comes at a price when we come to write functions.  It means we need a way of telling R whether we're referring to a variable in the tibble, or a parameter we've passed via the function.

If we're  using standard evaluation, then we see the value of the year parameter.  For example, let's put
a `print()` statement in our function:



~~~
calc_GDP_and_filter <- function(dat, year){
  # For debugging
  print(year)
  
  gdpgapfiltered <- dat %>%
      filter(year == year) %>% 
      mutate(gdp = gdpPercap * pop)
  
  return(gdpgapfiltered)
  
}

calc_GDP_and_filter(gapminder, 1997)
~~~
{: .language-r}



~~~
[1] 1997
~~~
{: .output}



~~~
# A tibble: 1,704 x 7
       country  year      pop continent lifeExp gdpPercap         gdp
         <chr> <int>    <dbl>     <chr>   <dbl>     <dbl>       <dbl>
 1 Afghanistan  1952  8425333      Asia  28.801  779.4453  6567086330
 2 Afghanistan  1957  9240934      Asia  30.332  820.8530  7585448670
 3 Afghanistan  1962 10267083      Asia  31.997  853.1007  8758855797
 4 Afghanistan  1967 11537966      Asia  34.020  836.1971  9648014150
 5 Afghanistan  1972 13079460      Asia  36.088  739.9811  9678553274
 6 Afghanistan  1977 14880372      Asia  38.438  786.1134 11697659231
 7 Afghanistan  1982 12881816      Asia  39.854  978.0114 12598563401
 8 Afghanistan  1987 13867957      Asia  40.822  852.3959 11820990309
 9 Afghanistan  1992 16317921      Asia  41.674  649.3414 10595901589
10 Afghanistan  1997 22227415      Asia  41.763  635.3414 14121995875
# ... with 1,694 more rows
~~~
{: .output}


We can use the `calc_GDP_and_filter`'s `year` parameter like a normal variable in our function _except_ when we're using it as part of a parameter to a `dplyr` verb (e.g. `filter`), or another function that uses non standard evaluation.   We need to _unquote_ the `year` parameter so that the `dplyr` function can see its contents (i.e. 1997 in this example).  We do this using the `UQ()` ("unquote") function:


~~~
    filter(year == UQ(year) ) %>% 
~~~
{: .language-r}

When the filter function is evaluated it will see:



~~~
    filter(year == 1997) %>% 
~~~
{: .language-r}

Modifying our function, we have:


~~~
calc_GDP_and_filter <- function(dat, year){
  
gdpgapfiltered <- dat %>%
    filter(year == UQ(year) ) %>% 
    mutate(gdp = gdpPercap * pop)

return(gdpgapfiltered)
  
}

calc_GDP_and_filter(gapminder, 1997)
~~~
{: .language-r}



~~~
# A tibble: 142 x 7
       country  year       pop continent lifeExp  gdpPercap          gdp
         <chr> <int>     <dbl>     <chr>   <dbl>      <dbl>        <dbl>
 1 Afghanistan  1997  22227415      Asia  41.763   635.3414  14121995875
 2     Albania  1997   3428038    Europe  72.950  3193.0546  10945912519
 3     Algeria  1997  29072015    Africa  69.152  4797.2951 139467033682
 4      Angola  1997   9875024    Africa  40.963  2277.1409  22486820881
 5   Argentina  1997  36203463  Americas  73.275 10967.2820 397053586287
 6   Australia  1997  18565243   Oceania  78.830 26997.9366 501223252921
 7     Austria  1997   8069876    Europe  77.510 29095.9207 234800471832
 8     Bahrain  1997    598561      Asia  73.925 20292.0168  12146009862
 9  Bangladesh  1997 123315288      Asia  59.412   972.7700 119957417048
10     Belgium  1997  10199787    Europe  77.530 27561.1966 281118335091
# ... with 132 more rows
~~~
{: .output}

Our function now works as expected.

> ## Another way of thinking about quoting
> 
> (This section is based on [programming with dplyr](http://dplyr.tidyverse.org/articles/programming.html))
>
> Consider the following code:
>
> 
> ~~~
> greet <- function(person){
>   print("Hello person")
> }
> 
> greet("David")
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> [1] "Hello person"
> ~~~
> {: .output}
> 
> The `print` function has no way of knowing that `person` refers to the variable `person`, and isn't 
> part of the string `person`.  To make the contents of the `person` variable visible to the function we
> need to construct the string, using the `paste` function:
>
> 
> ~~~
> greet <- function(person){
>   print(paste("Hello", person))
> }
> 
> greet("David")
> ~~~
> {: .language-r}
> 
> 
> 
> ~~~
> [1] "Hello David"
> ~~~
> {: .output}
> This means that the `person` variable is evaluated in an _unquoted_ environment, so its contents can be evaluated.
{: .callout}

There is one small issue that remains; how does filter _know_ that the first `year` in ``` filter(year == UQ(year) ) %>%  ``` refers to the `year` variable in the tibble?  What happens if we delete the 
year variable? Surely this should give an error?


~~~
gap_noyear <- gapminder %>% select(-year)
calc_GDP_and_filter(gap_noyear, 1997)
~~~
{: .language-r}



~~~
# A tibble: 1,704 x 6
       country      pop continent lifeExp gdpPercap         gdp
         <chr>    <dbl>     <chr>   <dbl>     <dbl>       <dbl>
 1 Afghanistan  8425333      Asia  28.801  779.4453  6567086330
 2 Afghanistan  9240934      Asia  30.332  820.8530  7585448670
 3 Afghanistan 10267083      Asia  31.997  853.1007  8758855797
 4 Afghanistan 11537966      Asia  34.020  836.1971  9648014150
 5 Afghanistan 13079460      Asia  36.088  739.9811  9678553274
 6 Afghanistan 14880372      Asia  38.438  786.1134 11697659231
 7 Afghanistan 12881816      Asia  39.854  978.0114 12598563401
 8 Afghanistan 13867957      Asia  40.822  852.3959 11820990309
 9 Afghanistan 16317921      Asia  41.674  649.3414 10595901589
10 Afghanistan 22227415      Asia  41.763  635.3414 14121995875
# ... with 1,694 more rows
~~~
{: .output}

As you can see, it doesn't; instead the `filter()` function will "fall through" to look for the `year` variable in `filter()`'s _calling environment_,  This is the `calc_GDP_and_filter()` environment, which does have a `year` variable.  Since this is a standard R variable, it will be implicitly unquoted, so `filter()` will see:


~~~
    filter(1997 == 1997) %>% 
~~~
{: .language-r}

which is always `TRUE`, so the filter won't do anything!

We need a way of telling the function that the first `year` "belongs" to the data.  We can do this with the `.data` pronoun:


~~~
calc_GDP_and_filter <- function(dat, year){
  
gdpgapfiltered <- dat %>%
    filter(.data$year == UQ(year) ) %>% 
    mutate(gdp = .data$gdpPercap * .data$pop)

return(gdpgapfiltered)
  
}

calc_GDP_and_filter(gapminder, 1997)
~~~
{: .language-r}



~~~
# A tibble: 142 x 7
       country  year       pop continent lifeExp  gdpPercap          gdp
         <chr> <int>     <dbl>     <chr>   <dbl>      <dbl>        <dbl>
 1 Afghanistan  1997  22227415      Asia  41.763   635.3414  14121995875
 2     Albania  1997   3428038    Europe  72.950  3193.0546  10945912519
 3     Algeria  1997  29072015    Africa  69.152  4797.2951 139467033682
 4      Angola  1997   9875024    Africa  40.963  2277.1409  22486820881
 5   Argentina  1997  36203463  Americas  73.275 10967.2820 397053586287
 6   Australia  1997  18565243   Oceania  78.830 26997.9366 501223252921
 7     Austria  1997   8069876    Europe  77.510 29095.9207 234800471832
 8     Bahrain  1997    598561      Asia  73.925 20292.0168  12146009862
 9  Bangladesh  1997 123315288      Asia  59.412   972.7700 119957417048
10     Belgium  1997  10199787    Europe  77.530 27561.1966 281118335091
# ... with 132 more rows
~~~
{: .output}



~~~
calc_GDP_and_filter(gap_noyear, 1997)
~~~
{: .language-r}



~~~
Error in filter_impl(.data, quo): Evaluation error: Column `year`: not found in data.
~~~
{: .error}


As you can see, we've also used the `.data` pronoun when calculating the GDP; if our tibble was missing either the `gdpPercap` or `pop` variables, R would search in the calling environment (i.e. the `calc_GDP_and_filter()` function).  As the variables aren't found there it would look in the `calc_GDP_and_filter()`'s calling environment, and so on.  If it finds variables matching these names, they would be used instead, giving an incorrect result; if they cannot be found we will get an error.  Using the `.data` pronoun makes our source of the data clear, and prevents this risk.

> ## Challenge:  Filtering by country name and year
>
> Create a new function that will filter by country name *and* by year, and then calculate the GDP.
>
> > ## Solution
> >
> > 
> > ~~~
> >  calcGDPCountryYearFilter <- function(dat, year, country){
> >  dat <- dat %>% filter(.data$year == UQ(year) ) %>% 
> >        filter(.data$country == UQ(country) ) %>% 
> >         mutate(gdp = .data$pop * .data$gdpPercap)
> >         
> >  return(dat)
> > }
> > calcGDPCountryYearFilter(gapminder, year=2007, country="United Kingdom")
> > ~~~
> > {: .language-r}
> > 
> > 
> > 
> > ~~~
> > # A tibble: 1 x 7
> >          country  year      pop continent lifeExp gdpPercap          gdp
> >            <chr> <int>    <dbl>     <chr>   <dbl>     <dbl>        <dbl>
> > 1 United Kingdom  2007 60776238    Europe  79.425  33203.26 2.017969e+12
> > ~~~
> > {: .output}
> > 
> {: .solution}
{: .challenge}


> ## Tip
>
> The "programming with dplyr" vignette is highly recommended if you are
> writing functions for dplyr.  This can be accessed by typing `vignette("programming", package="dplyr")`
>  
{: .callout}

[man]: http://cran.r-project.org/doc/manuals/r-release/R-lang.html#Environment-objects
[chapter]: http://adv-r.had.co.nz/Environments.html
[adv-r]: http://adv-r.had.co.nz/


> ## Tip: Testing and documenting
>
> It's important to both test functions and document them:
> Documentation helps you, and others, understand what the
> purpose of your function is, and how to use it, and its
> important to make sure that your function actually does
> what you think.
>
> When you first start out, your workflow will probably look a lot
> like this:
>
>  1. Write a function
>  2. Comment parts of the function to document its behaviour
>  3. Load in the source file
>  4. Experiment with it in the console to make sure it behaves
>     as you expect
>  5. Make any necessary bug fixes
>  6. Rinse and repeat.
>
> Formal documentation for functions, written in separate `.Rd`
> files, gets turned into the documentation you see in help
> files. The [roxygen2][] package allows R coders to write documentation alongside
> the function code and then process it into the appropriate `.Rd` files.
> You will want to switch to this more formal method of writing documentation
> when you start writing more complicated R projects.
>
> Formal automated tests can be written using the [testthat][] package.
{: .callout}


In this episode we've introduced the idea of writing your own functions, and talked about the
complications caused by non standard evaluation.   The forthcoming Research IT course "Programming in R" will cover writing, testing and documenting functions in much more detail.  We will notify participants of this course when it is available to book.

[roxygen2]: http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html
[testthat]: http://r-pkgs.had.co.nz/tests.html
