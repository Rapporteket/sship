## Test environments
* Microsoft Windows Server 2019 (on github actions), R version 4.1.1 (2021-08-10)
* macOS Catalina 10.15.7 (on github actions), R version 4.1.1 (2021-08-10)
* Ubuntu 18.04 (on github actions), R version 4.0.5 (2021-03-31)
* Ubuntu 20.04 (on github actions), R version 4.1.1 (2021-08-10)
* Ubuntu 20.04 (on github actions), R Under development (unstable) (2021-09-06 r80861)
* CRAN win-builder, R version 4.1.1 (2021-08-10) and R Under development (unstable) (2021-09-06 r80861)
* i386-pc-solaris2.10 (32-bit) (on R-hub builder), R version 4.1.1 (2021-08-10) 

## R CMD check results
There were no ERRORs and WARNINGs.

There was one NOTE:

* Days since last update: 1

## Package update shortly after the previous submission
The previous submission was made only a couple of days ago. As discovered by the CRAN Team notifying the maintainer today (Sep 8, 2021), examples and tests did not pass R checks on Solaris. Hence, this submission is a bugfix version of the package that should remedy the failing checks on Solaris. 
