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

Here's how to read in, clean, and convert the steamer projections, available on fangraphs:

```
raw_steamer <- get_steamer(2017)
steamer_pp <- proj_prep(raw_steamer)
head(steamer_pp$h_final) %>% as.data.frame()
```

produces
```
dropped 1394 hitters and 173 pitchers from the steamer projections
data because ids could not be matched.  these are usually players
with limited AB/IP.  see `fangraphs_unmatched` for names.

building a projection_prep object!
using the following hitting categories: r, rbi, sb, tb, obp
using the following pitching categories: w, sv, k, era, whip
TODO: to change any of these settings, run `set_defaults()`.

filtering players with invalid positions for your league settings.
filtered 0 hitters and 0 pitchers.
finding h replacement-level players, assuming 12 teams.
finding p replacement-level players, assuming 12 teams.
re-calculating value over h replacement, by position.
re-calculating value over p replacement, by position.
calculating prices for h players
there are 133 h players with total value greater than replacement level
calculating prices for p players
there are 109 p players with total value greater than replacement level

   mlbid        fullname firstname   lastname position priority_pos
1 454560      A.J. Ellis      A.J.      Ellis        C            C
2 543362    A.J. Jimenez      A.J.    Jimenez        C            C
3 150229 A.J. Pierzynski      A.J. Pierzynski        C            C
4 572041    A.J. Pollock      A.J.    Pollock       OF           OF
5 607223       A.J. Reed      A.J.       Reed       1B           1B
6 623510     A.J. Simcox      A.J.     Simcox       SS           SS
  projection_name  ab  r rbi sb  tb   obp   r_zscore rbi_zscore
1         steamer  90 10  10  1  32 0.340 -4.6265175 -3.8746920
2         steamer   1  0   0  0   0 0.274 -5.4241929 -4.5539330
3         steamer   1  0   0  0   0 0.299 -5.4241929 -4.5539330
4         steamer 519 74  59 23 229 0.341  0.4786053 -0.5464116
5         steamer 127 16  17  0  52 0.318 -4.1479122 -3.3992234
6         steamer   1  0   0  0   0 0.253 -5.4241929 -4.5539330
  sb_zscore  tb_zscore obp_zscore unadjusted_zsum replacement_pos
1 -0.955319 -5.4911269 -5.9997661      -20.947422               C
2 -1.062125 -6.4291408 -7.3302088      -24.799600               C
3 -1.062125 -6.4291408 -7.3291121      -24.798504               C
4  1.394410  0.2835212  0.4220793        2.032204              OF
5 -1.062125 -4.9048682 -5.5704410      -19.084570              1B
6 -1.062125 -6.4291408 -7.3311301      -24.800522              SS
  adjustment_zscore final_zsum  value hit_pitch
1         9.4375119 -11.509910  -56.7         h
2         9.4375119 -15.362089  -76.1         h
3         9.4375119 -15.360992  -76.1         h
4         0.7031254   2.735329   14.7         h
5        -0.4498531 -19.534423  -97.0         h
6         0.9561033 -23.844418 -118.6         h
```

## 2017 projections supported
* [steamer](http://www.fangraphs.com/projections.aspx?pos=all&stats=bat&type=steamer&team=0&lg=all&players=0)

_probably others, but I'm short on time this year and haven't tested anything else_

## 2016 projections supported

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
