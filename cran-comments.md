# Comment to Cran  

## Submission to fix errors - 9 Sept 2022 - version 2.1.0
This is to fix the errors currently present in the CRAN checks. The errors stems from a test on the catalogue function: the API providers must have changed some of the details in the data that the package queries. Test has been updated to match the current data. 


## First submmission 

This is the first submission of a new maintainer for the package - see Claudia Vitolo's email on August 5th. 

R CMD --as-cran only gives a NOTE on the change on maintainer 

Tested via rhub on 
Windows Server 2022, R-devel, 64 bit 
Ubuntu Linux 20.04.1 LTS, R-devel, GCC
Ubuntu Linux 20.04.1 LTS, R-release, GCC
Fedora Linux, R-devel, clang, gfortran
macOS 10.13.6 High Sierra, R-release, brew
macOS 10.13.6 High Sierra, R-release, CRAN setup

