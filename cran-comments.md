# Resubmission
This is a resubmission. Thanks for the comments and accordingly I have:

* Altered the use of setwd() in functions enc() and dec() to ensure that the user working directory stay unaltered on function exit.
* Removed the use of setwd() in tests (i.e. tests/testthat/test-enc.R) altogether.

# Test environments
* Microsoft Windows Server 2019 (on github actions), R version 4.1.1 (2021-08-10)
* macOS Catalina 10.15.7 (on github actions), R version 4.1.1 (2021-08-10)
* Ubuntu 18.04 (on github actions), R version 3.6.3 (2020-02-29)
* Ubuntu 18.04 (on github actions), R version 4.0.5 (2021-03-31)
* Ubuntu 20.04 (on github actions), R version 4.1.1 (2021-08-10)
* Ubuntu 20.04 (on github actions), R Under development (unstable) (2021-08-25 r80817)
* CRAN win-builder, R version 4.1.1 (2021-08-10) and  R Under development (unstable) (2021-08-25 r80817)

# R CMD check results
There were no ERRORs and WARNINGs.

There were one NOTE:

* New submission
