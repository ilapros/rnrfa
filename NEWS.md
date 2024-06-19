2.1.0.6
--------------------------------------
date: 2024/06/19

small changes: 
- changes in test functions: realized I needed them after the API broke for some days 

2.1.0.5 intermediate github version 
--------------------------------------
date: 2023/11/08

Medium changes: 

- plot_trend updated to reflect changes in the ggmap package due to the stamen maps no longer being directly available

Minor changes: 

- catalogue() now allows for not all information to be retrieved (bug fix)
- changes in the vignette text, mostly allowing the output to appear and updated the dependencies

v2.1.0 and submitted to CRAN
--------------------------------------
Minor changes: 

- Changes in test. some changes must have occurred in the NRFA dataset 
- Bumped version - should have done this the previous time


v2.0.6 and submitted to CRAN
--------------------------------------
Major changes: 

- Change of maintainer for CRAN package 
- The hard dependency on the rgdal package is dropped (this is in light of the announced retirement of rgdal in 2023). In the process the hard dependence to sp has been dropped in favour of sf, to avoid possible issues down the line when sp goes through the changes necessary to accommodate the rgdal retirement. The package still depends on sp via ggmap -> RgoogleMaps. 

Minor changes:

1. To further ensure that the package fails gracefully when the NRFA api is interrogated about stations which do not exist an informative message is printed and the function(s) return a NULL object.  
2. Thanks to Andrew Duncan (@aj2duncan) osg_parse now outputs a missing value if a missing coordinate is given 
3. small fixes in documentation. 

v2.0.4 and submitted to CRAN.
--------------------------------------
Minor change:

- Ensure that the package fails gracefully with an informative message if the resource is not available or has changed (and not give a check warning nor error). This is a CRAN policy. 


v2.0.2 and submitted to CRAN.
--------------------------------------

Major changes:

1. Fixed issue #19 whereby rejected/missing data in peak flows are flagged as such in output. Added full_info to input parameters to retrieve data quality flags.
2. timeseries are now classed as zoo object, not xts.
3. startseason and endseason in seasonal_averages() are now deprecated, seasons are labelled by the calendar quarter in which the season ends.

Minor changes:

- Added more tests


v2.0.1 and submitted to CRAN.
--------------------------------------

Major changes:

1. Removed obsolete tests that were checking against proj4-based pre-calculated values. This is to overcome issue with use of proj6.


Updated to v2.0 and submitted to CRAN.
--------------------------------------

Major changes:

1. Developed new function to interface new API 
2. Updated existing functions to work with the new API

Minor changes:
1. Fixed broken URL in README file


Updated to v1.5 and submitted to CRAN.
--------------------------------------

Major changes:

1. osg_parse now does not fail when gridRefs is a mixture of upper and lower cases, thanks to Christoph Kratz (@bogsnork on GitHub, see https://github.com/cvitolo/rnrfa/issues/12)!
2. fixed tests for get_ts
3. automatic deployment of website for documentation on github


Updated to v1.4 and submitted to CRAN.
--------------------------------------

Major changes:

1. osg_parse now is vectorised, thanks to Tobias Gauster! 


Updated to v1.3 and submitted to CRAN.
--------------------------------------

Major changes:

1. Removed dependency from cowplot package


Updated to v1.2 and submitted paper to the R Journal
----------------------------------------------------

Major changes:

1. Added some utility functions (e.g. plot_trend) to generate plots in the paper


Updated to v1.1 and submitted to CRAN.
----------------------------------------

Major changes:

1. testthat framework for unit tests
2. travis for continuous integration on linux
3. appveyors for continuous integration on windows
4. added code of conduct
5. renamed functions to follow best practice
6. moved package to root directory to follow best practice


Updated to v0.5.4 and submitted to CRAN.
----------------------------------------

Major changes:

1. Michael Spencer (contributor) updated the function OSGparse to work with grid references of different lengths.

2. Added testthat framework for unit tests
