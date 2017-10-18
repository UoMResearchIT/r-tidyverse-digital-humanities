R for Reproducible Scientific Analysis
======================================

An introduction to R for non-programmers using the [Gapminder][gapminder] data and the tidyverse.

This course is based on the [Software Carpentry](https://software-carpentry.org/) course, and has been abridged and modified. The most substantive changes are:

* The Tidyverse is taught (the differences between, e.g. `data.frames` and `tibbles` is included in the notes - though this is mainly for reference).
* Lists are not taught
* The episode on `tidyr` has been removed, in the interests of time.
* Git isn't covered (although version control is mentioned, and the learners are signposted to the Research IT's git course)

A rendered version of the course notes can be found at <https://mawds.github.io/r-novice-gapminder/>.

A rendered version of the original Software Carpentry lesson can be found at: <https://swcarpentry.github.io/r-novice-gapminder>,
[the lesson template documentation][lesson-example]
for instructions on formatting, building, and submitting material,
or run `make` in this directory for a list of helpful commands.

The remainder of this README is from the original Software Carpentry version of the lesson:

The goal of this lesson is to teach novice programmers to write modular code
and best practices for using R for data analysis. R is commonly used in many
scientific disciplines for statistical analysis and its array of third-party
packages. We find that many scientists who come to Software Carpentry workshops
use R and want to learn more. The emphasis of these materials is to give
attendees a strong foundation in the fundamentals of R, and to teach best
practices for scientific computing: breaking down analyses into modular units,
task automation, and encapsulation.

Note that this workshop focuses on the fundamentals of the programming
language R, and not on statistical analysis.

A variety of third party packages are used throughout this workshop. These
are not necessarily the best, nor are they comprehensive, but they are 
packages we find useful, and have been chosen primarily for their 
usability.

Maintainers:

* [Tom Wright][wright_tom]
* [Naupaka Zimmerman][zimmerman_naupaka]

[gapminder]: http://www.gapminder.org/
[lesson-example]: https://swcarpentry.github.io/lesson-example
[wright_tom]: http://software-carpentry.org/team/#wright_thomas
[zimmerman_naupaka]: http://software-carpentry.org/team/#zimmerman_naupaka
