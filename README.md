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
1 561 106 102 15 324 0.398 2.921749   2.113615  0.4649843  2.786986   2.882437
2 520 100  94  7 299 0.419 2.423724   1.625623 -0.3575923  2.095884   3.763959
3 562  91 105 12 285 0.358 1.676686   2.296612  0.1565180  1.708866   1.203347
4 559  91  92 14 279 0.392 1.676686   1.503625  0.3621622  1.543002   2.630574
5 544  97 100 15 295 0.410 2.174711   1.991617  0.4649843  1.985307   3.386164
6 502  87  98  7 279 0.364 1.344669   1.869619 -0.3575923  1.543002   1.455211
  unadjusted_zsum replacement_pos adjustment_zscore final_zsum value hit_pitch
1       11.169772              OF        -0.1798619  10.989910  72.8         h
2        9.551597              OF        -0.1798619   9.371735  62.3         h
3        7.042029              3B        -0.1085769   6.933452  46.3         h
4        7.716048              OF        -0.1798619   7.536186  50.3         h
5       10.002783              1B        -1.0255269   8.977256  59.7         h
6        5.854908              OF        -0.1798619   5.675046  38.1         h
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
