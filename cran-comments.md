## Test environments

* Windows Server x64 (build 17763) (on github actions), R version 4.1.2 (2021-11-01)
* macOS Big Sur 10.16 (on github actions), R version 4.1.2 (2021-11-01)
* Ubuntu 18.04.6 LTS (on github actions), R version 3.6.3 (2020-02-29)
* Ubuntu 18.04.6 LTS (on github actions), R version 4.0.5 (2021-03-31)
* Ubuntu 20.04.3 LTS (on github actions), R version 4.1.2 (2021-11-01)
* Ubuntu 20.04.3 LTS (on github actions), R Under development (unstable) (2022-01-26 r81569)
* CRAN win-builder (x86_64-w64-mingw32), R version 4.1.2 (2021-11-01) and R Under development (unstable) (2022-01-27 r81578 ucrt)
* i386-pc-solaris2.10 (32-bit) (on R-hub builder), R version 4.1.2 (2021-11-01)
* aarch64-apple-darwin20 (64-bit), macOS 11.6 Big Sur (on R-hub builder), R version 4.1.2 (2021-11-01)

## R CMD check results
There were no ERRORs, WARNINGs or NOTEs.

## Comments
As agreed to by CRAN maintainers this submission is to replace a previously cancelled submission.

In this version calls to the github api from package functions terminates with an informative message rather than an error should the api request limit be exceeded. 
