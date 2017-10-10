---
title: "Introduction to R and RStudio"
teaching: 45
exercises: 10
questions:
- "How to find your way around RStudio?"
- "How to interact with R?"
objectives:
- "Describe the purpose and use of each pane in the RStudio IDE"
- "Locate buttons and options in the RStudio IDE"
- "Define a variable"
- "Assign data to a variable"
- "Manage a workspace in an interactive R session"
- "Use mathematical and comparison operators"
- "Call functions"
- "Understand the concept of a vector"
- "Understand how to extract elements from a vector"
keypoints:
- "Use RStudio to write and run R programs."
- "R has the usual arithmetic operators and mathematical functions."
- "Use `<-` to assign values to variables."
- "Use the `[]` operator to extract elements from a vector"
source: Rmd
---




## Motivation

Science is a multi-step process: once you've designed an experiment and collected
data, the real fun begins! This lesson will teach you how to start this process using
R and RStudio. We will begin with raw data, perform exploratory analyses, and learn
how to plot results graphically. This example starts with a dataset from
[gapminder.org](https://www.gapminder.org) containing population information for many
countries through time. Can you read the data into R? Can you plot the population for
Senegal? Can you calculate the average income for countries on continent of Asia?
By the end of these lessons you will be able to do things like plot the populations
for all of these countries in under a minute!

## Before Starting The Workshop

If you are using your own computer, please ensure you have the latest version of R and RStudio installed on your machine. This is important, as some packages used in the workshop may not install correctly (or at all) if R is not up to date.

[Download and install the latest version of R here](https://www.r-project.org/)

[Download and install RStudio here](https://www.rstudio.com/)

**The University machines already have suitable versions of R and RStudio installed.**  

> ## RStudio
>
> The University machines have RStudio version 1 installed on them.  Version
> 1.1 of RStudio was released on 9 October 2017.  If you install RStudio on your
> own machine it will be version 1.1; by default this uses a different colour theme,
> however the layout of windows and buttons is similar.
> 
> Details of new features in version 1.1 can be found on the [page announcing its
> release](https://blog.rstudio.com/2017/10/09/rstudio-v1.1-released/)
>
{: .callout}

## Introduction to RStudio

Throughout this lesson, we're going to teach you some of the fundamentals of
the R language as well as some best practices for organizing code for
scientific projects that will make your life easier.

We'll be using RStudio: a free, open source R integrated development
environment. It provides a built in editor, works on all platforms (including
on servers) and provides many advantages such as integration with version
control and project management.

**Basic layout**

When you first open RStudio, you will be greeted by three panels:

  * The interactive R console (entire left)
  * Environment/History (tabbed in upper right)
  * Files/Plots/Packages/Help/Viewer (tabbed in lower right)

![RStudio layout](../fig/01-rstudio.png)

Once you open files, such as R scripts, an editor panel will also open
in the top left.

![RStudio layout with .R file open](../fig/01-rstudio-script.png)

We can make a new script by choosing `File`, `New File`, `R Script` from the menu, or by pressing `ctrl+shift+N`.  Scripts let us store R code.  You should make sure that all the code you use for an analysis is stored in a script; this makes the process you followed clear, and will let you, or others, recreate your analyses.   

## Work flow within RStudio
There are two main ways one can work within RStudio.

1. Test and play within the interactive R console then copy code into
a `.R` file to run later.
   *  This works well when doing small tests and initially starting off.
   *  It quickly becomes laborious
2. Start writing in an `.R` file and use RStudio's command / short cut
to push current line, selected lines or modified lines to the
interactive R console.
   * This is a great way to start; all your code is saved for later
   * You will be able to run the file you create from within RStudio
   or using R's `source()`  function.

> ## Tip: Running segments of your code
>
> RStudio offers you great flexibility in running code from within the editor
> window. There are buttons, menu choices, and keyboard shortcuts. To run the
> current line, you can
> 1. click on the `Run` button above the editor panel, or 
> 2. select "Run Lines" from the "Code" menu, or 
> 3. hit Ctrl-Enter in Windows
> or Linux or Command-Enter on OS X. (This shortcut can also be seen by hovering
> the mouse over the button).
>
> To run a block of code, select it and then `Run`.
> If you have modified a line of code within a block of code you have just run,
> there is no need to reselect the section and `Run`, you can use the next button
> along, `Re-run the previous region`. This will run the previous code block
> including the modifications you have made.
{: .callout}

> ## The history tab
>
> RStudio keeps a log of the command you've entered.  This makes it 
easier to go back and edit a command if you've made a mistake in it.
There are several ways of accessing the command history:
>
> 1. In the console window, the up and down arrows will take you 
through the command history. (The command can then be edited using the
left and right arrow keys)
> 2. The history tab in the top right of RStudio contains the command history.  One
or more lines from this can be selected.  These can then be copied to the console, or to
your R script by pressing the appropriate button.
{: .callout}

## Introduction to R

Much of your time in R will be spent in the R interactive
console. This is where you will run all of your code, and can be a
useful environment to try out ideas before adding them to an R script
file. This console in RStudio is the same as the one you would get if
you typed in `R` in your command-line environment.

The first thing you will see in the R interactive session is a bunch
of information, followed by a `>` and a blinking cursor. It operates
on the idea of a "Read, evaluate, print loop": you type in commands,
R tries to execute them, and then returns a result.

## Using R as a calculator

The simplest thing you could do with R is do arithmetic:


~~~
1 + 100
~~~
{: .r}



~~~
[1] 101
~~~
{: .output}

And R will print out the answer, with a preceding `[1]`. Don't worry about this
for now, we'll explain that later. For now think of it as indicating output.

Like bash, if you type in an incomplete command, R will wait for you to
complete it:

~~~
> 1 +
~~~
{: .r}

~~~
+
~~~
{: .output}

Any time you hit return and the R session shows a `+` instead of a `>`, it
means it's waiting for you to complete the command. If you want to cancel
a command you can simply hit `Esc` and RStudio will give you back the `>`
prompt.

> ## Tip: Cancelling commands
>
> If you're using R from the command line instead of from within RStudio,
> you need to use `Ctrl+C` instead of `Esc` to cancel the command. This
> applies to Mac users as well!
>
> Cancelling a command isn't only useful for killing incomplete commands:
> you can also use it to tell R to stop running code (for example if it's
> taking much longer than you expect), or to get rid of the code you're
> currently writing.
>
{: .callout}

When using R as a calculator, the order of operations is the same as you
would have learned back in school.

From highest to lowest precedence:

 * Parentheses: `(`, `)`
 * Exponents: `^` or `**`
 * Divide: `/`
 * Multiply: `*`
 * Add: `+`
 * Subtract: `-`


~~~
3 + 5 * 2
~~~
{: .r}



~~~
[1] 13
~~~
{: .output}

Use parentheses to group operations in order to force the order of
evaluation if it differs from the default, or to make clear what you
intend.


~~~
(3 + 5) * 2
~~~
{: .r}



~~~
[1] 16
~~~
{: .output}

This can get unwieldy when not needed, but  clarifies your intentions.
Remember that others may later read your code.


~~~
(3 + (5 * (2 ^ 2))) # hard to read
3 + 5 * 2 ^ 2       # clear, if you remember the rules
3 + 5 * (2 ^ 2)     # if you forget some rules, this might help
~~~
{: .r}


The text after each line of code is called a
"comment". Anything that follows after the hash symbol
`#` is ignored by R when it executes code.

Really small or large numbers get a scientific notation:


~~~
2/10000
~~~
{: .r}



~~~
[1] 2e-04
~~~
{: .output}

Which is shorthand for "multiplied by `10^XX`". So `2e-4`
is shorthand for `2 * 10^(-4)`.

You can write numbers in scientific notation too:


~~~
5e3  # Note the lack of minus here
~~~
{: .r}



~~~
[1] 5000
~~~
{: .output}

## Mathematical functions

R has many built in mathematical functions. To call a function,
we simply type its name, followed by  open and closing parentheses.
Anything we type inside the parentheses are called the function's
arguments:


~~~
sin(1)  # trigonometry functions
~~~
{: .r}



~~~
[1] 0.841471
~~~
{: .output}


~~~
log(1)  # natural logarithm
~~~
{: .r}



~~~
[1] 0
~~~
{: .output}


~~~
log10(10) # base-10 logarithm
~~~
{: .r}



~~~
[1] 1
~~~
{: .output}


~~~
exp(0.5) # e^(1/2)
~~~
{: .r}



~~~
[1] 1.648721
~~~
{: .output}

## Remembering function names and arguments

Don't worry about trying to remember every function in R. You
can simply look them up on Google, or if you can remember the
start of the function's name, type the start of it, then press the `tab` key.
This will show a list of
functions whose name matches what you've typed so far; this is known
as `tab completion`, and can save a lot of typing (and reduce the risk
of typing errors).  Tab completion works in R (i.e. running it out
of RStudio), and in RStudio. In RStudio this feature is even more useful; a
extract of the function's help file will be shown alongside the function name.

This is one advantage that RStudio has over R on its own: it
has auto-completion abilities that allow you to more easily
look up functions, their arguments, and the values that they
take.

Typing a `?` before the name of a command will open the help page
for that command. As well as providing a detailed description of
the command and how it works, scrolling to the bottom of the
help page will usually show a collection of code examples which
illustrate command usage. We'll go through an example later.



## Comparing things

We can also do comparison in R:


~~~
1 == 1  # equality (note two equals signs, read as "is equal to")
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 != 2  # inequality (read as "is not equal to")
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 < 2  # less than
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 <= 1  # less than or equal to
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 > 0  # greater than
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}


~~~
1 >= -9 # greater than or equal to
~~~
{: .r}



~~~
[1] TRUE
~~~
{: .output}

> ## Tip: Comparing Numbers
>
> A word of warning about comparing numbers: you should
> never use `==` to compare two numbers unless they are
> integers (a data type which can specifically represent
> only whole numbers).
>
> Computers may only represent decimal numbers with a
> certain degree of precision, so two numbers which look
> the same when printed out by R, may actually have
> different underlying representations and therefore be
> different by a small margin of error (called Machine
> numeric tolerance).
>
> Instead you should use the `all.equal` function.
>
> Further reading: [http://floating-point-gui.de/](http://floating-point-gui.de/)
>
{: .callout}

## Variables and assignment

We can store values in variables using the assignment operator `<-`, like this:


~~~
x <- 1/40
~~~
{: .r}

Notice that assignment does not print a value. Instead, we stored it for later
in something called a **variable**. `x` now contains the **value** `0.025`:


~~~
x
~~~
{: .r}



~~~
[1] 0.025
~~~
{: .output}

More precisely, the stored value is a *decimal approximation* of
this fraction called a [floating point number](http://en.wikipedia.org/wiki/Floating_point).

Look for the `Environment` tab in one of the panes of RStudio, and you will see that `x` and its value
have appeared. Our variable `x` can be used in place of a number in any calculation that expects a number:


~~~
log(x)
~~~
{: .r}



~~~
[1] -3.688879
~~~
{: .output}

Notice also that variables can be reassigned:


~~~
x <- 100
~~~
{: .r}

`x` used to contain the value 0.025 and and now it has the value 100.

Assignment values can contain the variable being assigned to:


~~~
x <- x + 1 #notice how RStudio updates its description of x on the top right tab
~~~
{: .r}

The right hand side of the assignment can be any valid R expression.
The right hand side is *fully evaluated* before the assignment occurs.

> ## Legal variable names
> Variable names can contain letters, numbers, underscores and periods.
> They cannot start with a number nor contain spaces at all.
> Different people use different conventions for long variable names, these include:
>
>  * periods.between.words
> * underscores\_between_words
>  * camelCaseToSeparateWords
>
> What you use is up to you, but **be consistent**.
{: .callout}

It is also possible to use the `=` operator for assignment:


~~~
x = 1/40
~~~
{: .r}

But this is much less common among R users.  The most important thing is to
**be consistent** with the operator you use. There are occasionally places
where it is less confusing to use `<-` than `=`, and it is the most common
symbol used in the community. So the recommendation is to use `<-`.

We aren't limited to storing numbers in variables:


~~~
sentence <- "the cat sat on the mat"
~~~
{: .r}

Note that we need to put strings of characters inside quotes.  

But the type of data that is stored in a variable affects what we can do with it:


~~~
x + 1
~~~
{: .r}



~~~
[1] 1.025
~~~
{: .output}



~~~
sentence + 1
~~~
{: .r}



~~~
Error in sentence + 1: non-numeric argument to binary operator
~~~
{: .error}

We will discuss the important concept of _data types_ in the next episode.  


> ## Challenge 1
>
> Which of the following are valid R variable names?
> 
> ~~~
> min_height
> max.height
> _age
> .mass
> MaxLength
> min-length
> 2widths
> celsius2kelvin
> ~~~
> {: .r}
>
> > ## Solution to challenge 1
> >
> > The following can be used as R variables:
> > 
> > ~~~
> > min_height
> > max.height
> > MaxLength
> > celsius2kelvin
> > ~~~
> > {: .r}
> >
> > The following creates a hidden variable:
> > 
> > ~~~
> > .mass
> > ~~~
> > {: .r}
> >
> > The following will not be able to be used to create a variable
> > 
> > ~~~
> > _age
> > min-length
> > 2widths
> > ~~~
> > {: .r}
> {: .solution}
{: .challenge}

> ## Challenge 2
>
> What will be the value of each  variable  after each
> statement in the following program?
>
> 
> ~~~
> mass <- 47.5
> age <- 122
> mass <- mass * 2.3
> age <- age - 20
> ~~~
> {: .r}
>
> > ## Solution to challenge 2
> >
> > 
> > ~~~
> > mass <- 47.5
> > ~~~
> > {: .r}
> > This will give a value of 47.5 for the variable mass
> >
> > 
> > ~~~
> > age <- 122
> > ~~~
> > {: .r}
> > This will give a value of 122 for the variable age
> >
> > 
> > ~~~
> > mass <- mass * 2.3
> > ~~~
> > {: .r}
> > This will multiply the existing value of 47.5 by 2.3 to give a new value of
> > 109.25 to the variable mass.
> >
> > 
> > ~~~
> > age <- age - 20
> > ~~~
> > {: .r}
> > This will subtract 20 from the existing value of 122 to give a new value
> > of 102 to the variable age.
> {: .solution}
{: .challenge}


> ## Challenge 3
>
> Run the code from the previous challenge, and write a command to
> compare mass to age. Is mass larger than age?
>
> > ## Solution to challenge 3
> >
> > One way of answering this question in R is to use the `>` to set up the following:
> > 
> > ~~~
> > mass > age
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > [1] TRUE
> > ~~~
> > {: .output}
> > This will yield a boolean value of TRUE since 109.25 is greater than 102.
> {: .solution}
{: .challenge}

## Vectorization

As well as dealing with single values, we can work with vectors of values.  
There are various ways of creating vectors; the `:` operator will generate sequences of
consecutive values:


~~~
1:5
~~~
{: .r}



~~~
[1] 1 2 3 4 5
~~~
{: .output}



~~~
-3:3
~~~
{: .r}



~~~
[1] -3 -2 -1  0  1  2  3
~~~
{: .output}



~~~
5:1
~~~
{: .r}



~~~
[1] 5 4 3 2 1
~~~
{: .output}

The result of the `:` operator is a _vector_; this is a 1 dimensional array of values.
We can apply functions to all the elements of a vector:


~~~
(1:5) * 2
~~~
{: .r}



~~~
[1]  2  4  6  8 10
~~~
{: .output}



~~~
2^(1:5)
~~~
{: .r}



~~~
[1]  2  4  8 16 32
~~~
{: .output}

We can assign a vector to a variable:


~~~
x <- 5:10
~~~
{: .r}

We can also create vectors "by hand" using the `c()` function; this tersely named function is used to _combine_ values into a vector; these values can, themselves, be vectors:


~~~
c(2, 4, -1)
~~~
{: .r}



~~~
[1]  2  4 -1
~~~
{: .output}



~~~
c(x, 2, 2, 3)
~~~
{: .r}



~~~
[1]  5  6  7  8  9 10  2  2  3
~~~
{: .output}

Vectors aren't limited to storing numbers:


~~~
c("a", "b", "c", "def")
~~~
{: .r}



~~~
[1] "a"   "b"   "c"   "def"
~~~
{: .output}

R comes with a few built in vectors containing useful sequences:

~~~
LETTERS
~~~
{: .r}



~~~
 [1] "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q"
[18] "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
~~~
{: .output}



~~~
letters
~~~
{: .r}



~~~
 [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q"
[18] "r" "s" "t" "u" "v" "w" "x" "y" "z"
~~~
{: .output}



~~~
month.abb
~~~
{: .r}



~~~
 [1] "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov"
[12] "Dec"
~~~
{: .output}



~~~
month.name
~~~
{: .r}



~~~
 [1] "January"   "February"  "March"     "April"     "May"      
 [6] "June"      "July"      "August"    "September" "October"  
[11] "November"  "December" 
~~~
{: .output}



~~~
pi
~~~
{: .r}



~~~
[1] 3.141593
~~~
{: .output}


## Vector lengths

We can calculate how many elements a vector contains using the `length()` function:


~~~
length(x)
~~~
{: .r}



~~~
[1] 6
~~~
{: .output}



~~~
length(letters)
~~~
{: .r}



~~~
[1] 26
~~~
{: .output}


## Subsetting vectors

Having defined a vector, it's often useful to _extract_ parts of a vector.   We do this with the
`[]` operator.  Using the built in `month.name` vector:


~~~
month.name[2]
~~~
{: .r}



~~~
[1] "February"
~~~
{: .output}



~~~
month.name[2:4]
~~~
{: .r}



~~~
[1] "February" "March"    "April"   
~~~
{: .output}

Let's unpick the second example; `2:4` generates the sequence 2,3,4.   This gets passed to the 
extract operator `[]`.   We can also generate this sequence using the `c()` function:


~~~
month.name[c(2,3,4)]
~~~
{: .r}



~~~
[1] "February" "March"    "April"   
~~~
{: .output}

> ## Vector numbering in R starts at 1
>
> In many programming languages (C and python, for example), the first
> element of a vector has an index of 0. In R, the first element is 1.
{: .callout}

We can pass the extract operator a vector of indices that we wish to extract:

~~~
month.name[c(1,2,3)]
~~~
{: .r}



~~~
[1] "January"  "February" "March"   
~~~
{: .output}



~~~
month.name[c(11,12)]
~~~
{: .r}



~~~
[1] "November" "December"
~~~
{: .output}

Values are returned in the order that we specify the indices.  We can extract the same element more 
than once:


~~~
month.name[4:2]
~~~
{: .r}



~~~
[1] "April"    "March"    "February"
~~~
{: .output}



~~~
month.name[c(1,1,2,3,4)]
~~~
{: .r}



~~~
[1] "January"  "January"  "February" "March"    "April"   
~~~
{: .output}

> ## Challenge 4
> 
> Return a vector containing the letters of the alphabet in reverse order
>
> > ## Solution to challenge 4
> > We can extract the elements in reverse order by generating the sequence
> > 26, 25, ... 1 using the `:` operator:
> >
> > 
> > ~~~
> > letters[length(letters):1]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> >  [1] "z" "y" "x" "w" "v" "u" "t" "s" "r" "q" "p" "o" "n" "m" "l" "k" "j"
> > [18] "i" "h" "g" "f" "e" "d" "c" "b" "a"
> > ~~~
> > {: .output}
> > 
> > Why didn't we just use `letters[26:1]`?  By hard-coding the length of the
> > variable into our code, we're making an assumption that `letters` will always
> > be length 26.  Although this is probably a safe assumption in English, other
> > languages may have more (or fewer) letters in their alphabet.   It is good
> > practice to avoid hard-coding information about your data into your scripts.
> > We will talk about testing assumptions at the very end of the course.
> {: .solution}
{: .challenge}


If we try and extract an element that doesn't exist in the vector, the missing values are `NA`:


~~~
month.name[10:13]
~~~
{: .r}



~~~
[1] "October"  "November" "December" NA        
~~~
{: .output}

## Missing data

`NA` is a special value, that is used to represent "not available", or "missing".  If we perform computations which include `NA`, the result is usually `NA`:


~~~
1 + NA
~~~
{: .r}



~~~
[1] NA
~~~
{: .output}

This raises an interesting point; how do we test if a value is `NA`?  This doesn't work:


~~~
x <- NA
x == NA
~~~
{: .r}



~~~
[1] NA
~~~
{: .output}

## Handling special values

There are a number of special functions you can use to handle missing data, and other special values:

 * `is.na` will return all positions in a vector, matrix, or data.frame
   containing `NA`.
 * likewise, `is.nan`, and `is.infinite` will do the same for `NaN` and `Inf`.
 * `is.finite` will return all positions in a vector, matrix, or data.frame
   that do not contain `NA`, `NaN` or `Inf`.
 * `na.omit` will filter out all missing values from a vector

## Skipping and removing elements

If we use a negative number as the index of a vector, R will return
every element *except* for the one specified:


~~~
month.name[-2]
~~~
{: .r}



~~~
 [1] "January"   "March"     "April"     "May"       "June"     
 [6] "July"      "August"    "September" "October"   "November" 
[11] "December" 
~~~
{: .output}

We can skip multiple elements:


~~~
month.name[c(-1, -5)]  # or month.name[-c(1,5)]
~~~
{: .r}



~~~
 [1] "February"  "March"     "April"     "June"      "July"     
 [6] "August"    "September" "October"   "November"  "December" 
~~~
{: .output}

> ## R's results prompt
> 
> We saw that R returns results prefixed with a `[1]`.  This is the index of the first 
> element of the results vector on that line of results.  This is useful if we're returning 
> vectors that are too long to fit on a single row.
>
{: .callout}

> ## Tip: Order of operations
>
> A common error occurs when trying to skip
> slices of a vector. Most people first try to negate a
> sequence like so:
>
> 
> ~~~
> month.name[-1:3]
> ~~~
> {: .r}
>
> This gives a somewhat cryptic error:
>
> 
> ~~~
> Error in month.name[-1:3]: only 0's may be mixed with negative subscripts
> ~~~
> {: .error}
>
> But remember the order of operations. `:` is really a function, so
> what happens is it takes its first argument as -1, and second as 3,
> so generates the sequence of numbers: `-1, 0, 1, 2, 3`.
>
> The correct solution is to wrap that function call in brackets, so
> that the `-` operator is applied to the sequence:
>
> 
> ~~~
> -(1:3)
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> [1] -1 -2 -3
> ~~~
> {: .output}
> 
> 
> 
> ~~~
> month.name[-(1:3)]
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> [1] "April"     "May"       "June"      "July"      "August"    "September"
> [7] "October"   "November"  "December" 
> ~~~
> {: .output}
{: .callout}

## Subsettting with logical vectors 

As well as providing a list of indices we want to keep (or delete, if we prefix them with `-`), we 
can pass a _logical vector_ to R indicating the indices we wish to select:


~~~
month.name[c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE)]
~~~
{: .r}



~~~
[1] "January" "March"   "April"  
~~~
{: .output}

What happens if we supply a logical vector that is shorter than the vector we're extracting the elements from?


~~~
month.name[c(TRUE,FALSE)]
~~~
{: .r}



~~~
[1] "January"   "March"     "May"       "July"      "September" "November" 
~~~
{: .output}

This illustrates the idea of _vector recycling_; the `[]` extract operator recycles the subsetting vector:


~~~
month.name[c(TRUE,FALSE,TRUE,FALSE,TRUE,FALSE,TRUE,FALSE,TRUE,FALSE,TRUE,FALSE)]
~~~
{: .r}



~~~
[1] "January"   "March"     "May"       "July"      "September" "November" 
~~~
{: .output}

The idea of selecting elements of a vector using a logical subsetting vector may seem a bit esoteric, and a lot more
typing than just selecting the elements you want by index.  It becomes really useful when we write code to generate
the logical vector:


~~~
my_vector <- c(0.01, 0.69, 0.51, 0.39, 0.81, 0.93, 0.49, 0.34, 0.84, 0.16)
my_vector > 0.5
~~~
{: .r}



~~~
 [1] FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE FALSE
~~~
{: .output}



~~~
my_vector[my_vector > 0.5]
~~~
{: .r}



~~~
[1] 0.69 0.51 0.81 0.93 0.84
~~~
{: .output}

> ## Tip: Combining logical conditions
>
> There are many situations in which you will wish to combine multiple logical
> criteria. For example, we might want to find all the elements that are 
> between two values. Several operations for combining logical vectors exist in R:
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


> ## Challenge 5
>
> Given the following code:
>
> 
> ~~~
> x <- c(5.4, 6.2, 7.1, 4.8, 7.5)
> print(x)
> ~~~
> {: .r}
> 
> 
> 
> ~~~
> [1] 5.4 6.2 7.1 4.8 7.5
> ~~~
> {: .output}
>
> Come up with at least 3 different commands that will produce the following output:
>
> 
> ~~~
> [1] 6.2 7.1 4.8
> ~~~
> {: .output}
>
> After you find 3 different commands, compare notes with your neighbour. Did you have different strategies?
>
> > ## Solution to challenge 5
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
> > [1] 6.2 7.1 4.8
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
> > [1] 6.2 7.1 4.8
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
> > [1] 6.2 7.1 4.8
> > ~~~
> > {: .output}
> > 
> > ~~~
> > x[c(FALSE, TRUE, TRUE, TRUE, FALSE)]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > [1] 6.2 7.1 4.8
> > ~~~
> > {: .output}
> >
> > (We can use vector recycling to make the last example slightly shorter:
> > 
> > ~~~
> > x[c(FALSE, TRUE, TRUE, TRUE)]
> > ~~~
> > {: .r}
> > 
> > 
> > 
> > ~~~
> > [1] 6.2 7.1 4.8
> > ~~~
> > {: .output}
> > The first element of the logical vector will be recycled)
> {: .solution}
{: .challenge}


## Data types

One thing you may have noticed is that all the data in a vector has been the same type; all the elements have had the same type (i.e. they have all been numbers, all been character, or all been logical (`TRUE`/`FALSE`)).  This is an important property of vectors; the type of data the vector holds is a property of the vector, not of each element.  Let's look at what happens if we try to create a vector of numeric and character data:


~~~
c(1, 2, "three", "four", 5)
~~~
{: .r}



~~~
[1] "1"     "2"     "three" "four"  "5"    
~~~
{: .output}

We see that R has coerced the elements containing digits to strings, so that all the elements have the same type.  

