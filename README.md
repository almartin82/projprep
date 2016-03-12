# projprep
**projprep** is a R package that helps read, clean up, and convert baseball projection data into auction prices.

## installation
projprep is written in R.
If you're new to R, start by installing:

* [R](https://cran.r-project.org/)
* [RStudio](https://www.rstudio.com/products/RStudio/#Desktop)

`projprep` is _not_ yet available on [cran](https://cran.r-project.org/), the home of R packages.  That means you'll need to install it with `devtools`:

```
install.packages('devtools')
library(devtools)

devtools::install_github('almartin82/projprep')
library(projprep)
```

Here's how to read in, clean, and convert the fantasypros projections:

```
raw_fp <- get_fantasy_pros(2016)
fp_pp <- proj_prep(raw_fp)
head(fp_pp) %>% as.data.frame()
```

## projections supported

* [cbs](http://www.cbssports.com/fantasy/baseball/stats/sortable/cbs/OF/season/standard/projections?&print_rows=9999)
* [fantasy pros](http://www.fantasypros.com/mlb/projections/hitters.php) (composite)
* [baseball guru](http://baseballguru.com/bbinside4.html)
* [pod projections](http://www.projectingx.com/baseball-player-projections/)
* [razzball steamer](http://razzball.com/steamer-hitter-projections/)

## not yet supported

* [steamer](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=steamer&team=0&lg=all&players=0)
* [steamer600](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=steamer600&team=0&lg=all&players=0)
* [fangraphs fans](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=fan&team=0&lg=all&players=0)
* [fangraphs depth charts](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=fan&team=0&lg=all&players=0)
* [zips](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=fan&team=0&lg=all&players=0)
* [tg](http://www.tgfantasybaseball.com/baseball/projections.cfm)
* [morps](http://morps.mlblogs.com/category/morps/)
* [cheatsheet](http://mrcheatsheet.com/2016/03/08/2016-fantasy-baseball-cheatsheets-2/)
* [davenport](http://claydavenport.com/projections/PROJHOME.shtml)
* [espn](http://games.espn.go.com/flb/tools/projections?display=alt)
* [marcel] (_can't find link to 2016 projections_)
* [cairo] (_can't find link to 2016 projections_)
* [pecota] (http://www.baseballprospectus.com/fantasy/extras/splash_page.php)
