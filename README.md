# projprep
**projprep** is a R package that helps read, clean up, and convert baseball projection data into auction prices.

## installation
projprep is written in R.
If you're new to R, start by installing:

* [R](https://cran.r-project.org/)
* [RStudio](https://www.rstudio.com/products/RStudio/#Desktop)

`projprep` is *_not_* available on [CRAN](https://cran.r-project.org/), the home of R packages.  That means you'll need to install it with `devtools`:

```
install.packages('devtools')
library(devtools)

devtools::install_github('almartin82/projprep')
library(projprep)
```

## quickstart

Here's how to read in, clean, and convert the fantasypros projections:

```
raw_fp <- get_fantasy_pros(2016)
fp_pp <- proj_prep(raw_fp)
head(fp_pp$h_final) %>% as.data.frame()
```

produces
```
  mlbid          fullname firstname    lastname position priority_pos projection_name
1     1        Mike Trout      Mike       Trout       OF           OF    fantasy_pros
2     2      Bryce Harper     Bryce      Harper    OF,OF           OF    fantasy_pros
3     3       Kris Bryant      Kris      Bryant    3B,OF           3B    fantasy_pros
4     4  Andrew McCutchen    Andrew   McCutchen       OF           OF    fantasy_pros
5     5  Paul Goldschmidt      Paul Goldschmidt       1B           1B    fantasy_pros
6     6 Giancarlo Stanton Giancarlo     Stanton       OF           OF    fantasy_pros
   ab   r rbi sb  tb   obp r_zscore rbi_zscore  sb_zscore tb_zscore obp_zscore
1 561 106 102 15 324 0.398 2.960769   2.118955  0.4692127  2.840235  2.3149390
2 520 100  94  7 299 0.419 2.454174   1.627208 -0.3537670  2.129584  2.0779222
3 562  91 105 12 285 0.358 1.694281   2.303361  0.1605953  1.731620  1.3453569
4 559  91  92 14 279 0.392 1.694281   1.504271  0.3663403  1.561063  2.1327197
5 544  97 100 15 295 0.410 2.200876   1.996018  0.4692127  2.015880  2.3044888
6 502  87  98  7 279 0.364 1.356550   1.873081 -0.3537670  1.561063  0.5344593
  unadjusted_zsum replacement_pos adjustment_zscore final_zsum value hit_pitch
1       10.704112              OF        -0.3885831  10.315529  65.1         h
2        7.935121              OF        -0.3885831   7.546538  47.9         h
3        7.235213              3B        -0.7225773   6.512636  41.5         h
4        7.258674              OF        -0.3885831   6.870091  43.7         h
5        8.986476              1B        -1.2187528   7.767723  49.3         h
6        4.971387              OF        -0.3885831   4.582804  29.5         h
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
