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
   ab   r rbi sb  tb   obp r_zscore rbi_zscore sb_zscore tb_zscore obp_zscore
1 561 106 102 15 324 0.398     2.96       2.12     0.469      2.84      2.315
2 520 100  94  7 299 0.419     2.45       1.63    -0.354      2.13      2.078
3 562  91 105 12 285 0.358     1.69       2.30     0.161      1.73      1.345
4 559  91  92 14 279 0.392     1.69       1.50     0.366      1.56      2.133
5 544  97 100 15 295 0.410     2.20       2.00     0.469      2.02      2.304
6 502  87  98  7 279 0.364     1.36       1.87    -0.354      1.56      0.534
  unadjusted_zsum replacement_pos adjustment_zscore final_zsum value hit_pitch
1           10.70              OF            -0.389      10.32  65.1         h
2            7.94              OF            -0.389       7.55  47.9         h
3            7.24              3B            -0.723       6.51  41.5         h
4            7.26              OF            -0.389       6.87  43.7         h
5            8.99              1B            -1.219       7.77  49.3         h
6            4.97              OF            -0.389       4.58  29.5         h
```

## projections supported

* [cbs](http://www.cbssports.com/fantasy/baseball/stats/sortable/cbs/OF/season/standard/projections?&print_rows=9999)
* [fantasy pros](http://www.fantasypros.com/mlb/projections/hitters.php) (composite)
* [baseball guru](http://baseballguru.com/bbinside4.html)
* [pod projections](http://www.projectingx.com/baseball-player-projections/)
* [razzball steamer](http://razzball.com/steamer-hitter-projections/)
* [steamer](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=steamer&team=0&lg=all&players=0)
* [steamer600](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=steamer600&team=0&lg=all&players=0)
* [fangraphs depth charts (_fangraphsdc_)](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=fan&team=0&lg=all&players=0)
* [zips](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=fan&team=0&lg=all&players=0)
* [pecota](http://www.baseballprospectus.com/fantasy/extras/splash_page.php)

## not yet supported

* [davenport](http://claydavenport.com/projections/PROJHOME.shtml)
* [espn](http://games.espn.go.com/flb/tools/projections?display=alt)
* [morps](http://morps.mlblogs.com/category/morps/)
* [tg](http://www.tgfantasybaseball.com/baseball/projections.cfm)
* [marcel] (_can't find link to 2016 projections_)
* [cairo] (_can't find link to 2016 projections_)

## code of conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
