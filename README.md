---
author: Koren, Miklós (https://koren.mk)
date: 2024-01-22
version: 0.5.3
title: EVENTSTUDY - Correct Event Study After XTHDIDREGRESS
description: |
    `eventstudy` transforms the coefficients estimated by `xthdidregress` into a correct
    event study relative to a baseline. The reported coefficients are the average 
    treatment effects on the treated (ATT) for each period relative to the baseline. 
    The baseline can be either a period before the treatment or the average of the 
    pre-treatment periods.
url: https://github.com/codedthinking/eventstudy
requires: Stata version 18
files: 
    - eventstudy.ado
    - eventstudy.sthlp
    - LICENSE
    - testdata.dta 
---
# `eventstudy` Correct event study after `xthdidregress`

# Syntax

- `eventstudy`, [**pre**(#) **post**(#) **baseline**(*string*) **generate**(*name*)]

`eventstudy` transforms the coefficients estimated by `xthdidregress` into a correct event study relative to a baseline. The reported coefficients are the average treatment effects on the treated (ATT) for each period relative to the baseline. The baseline can be either a period before the treatment or the average of the pre-treatment periods.


The package can be installed with
```
net install eventstudy, from(https://raw.githubusercontent.com/codedthinking/eventstudy/main/)
```

# Options
## Options
Option | Description
-------|------------
**pre** | Number of periods before treatment to include in the estimation (default 1)
**post** | Number of periods after treatment to include in the estimation (default 3)
**baseline** | Either a negative number between `-pre` and `-1` or `average`, or `atet`. If `-k`, the baseline is the kth period before the treatment. If `average`, the baseline is the average of the pre-treatment periods. If `atet`, the regression table reports the average of the post-treatment periods minus the average of the pre-treatment periods. Default is `-1`.
**generate** (optional) | Name of the frame to store the coefficients and their confidence interval.

# Background
`xthdidregress` returns ATET between `t` and `t-1` whenever `t` is before the treatment. That is, pretrends are reported as first differences, whereas actual treatment effects are reported as difference relative to the period before treatment. This can lead to misleading event study plots. The `eventstudy` command transforms the coefficients into a correct event study relative to a baseline.

# Remarks
The command can only be run after `xthdidregress`. 

The command also returns, as part of `e()`, the coefficients and standard errors. See `ereturn list` after running the command. Typical post-estimation commands can be used, such as `outreg2` or `estout`.

If the `generate` option is used, the returned frame contains the following variables:
- `time`: the time period relative to the baseline
- `coef`: the estimated coefficient
- `lower`: the lower bound of the 95% confidence interval
- `upper`: the upper bound of the 95% confidence interval

The frame is `tsset` by `time`, so `tsline` can be used to plot the event study.

# Examples
```
. use testdata

. xthdidregress ra (y) (treatment), group(group)

. eventstudy, pre(3) post(3) baseline(-3) generate(eventstudy)

Time variable: time, -3 to 3
        Delta: 1 unit

Event study relative to -3                 Number of obs = 662

------------------------------------------------------------------------------
           y |       ATET   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
          -3 |          0  (omitted)
          -2 |   .0927541   .0149854     6.19   0.000     .0633833    .1221249
          -1 |   .2026121   .0123289    16.43   0.000     .1784478    .2267764
           0 |   .5125657   .0143483    35.72   0.000     .4844435    .5406879
           1 |   .6146663   .0158062    38.89   0.000     .5836867     .645646
           2 |   .7274315   .0196456    37.03   0.000     .6889267    .7659362
           3 |   .8197896   .0194226    42.21   0.000     .7817219    .8578572
------------------------------------------------------------------------------

. frame eventstudy: list

     +------------------------------+
     | time    coef   lower   upper |
     |------------------------------|
  1. |   -3   0.000   0.000   0.000 |
  2. |   -2   0.093   0.063   0.122 |
  3. |   -1   0.203   0.178   0.227 |
  4. |    0   0.513   0.484   0.541 |
  5. |    1   0.615   0.584   0.646 |
     |------------------------------|
  6. |    2   0.727   0.689   0.766 |
  7. |    3   0.820   0.782   0.858 |
     +------------------------------+

. frame eventstudy: tsline upper coef lower
```

![](tsline.png)

```
. xthdidregress ra (y) (treatment), group(group)

. eventstudy, pre(3) post(3) baseline(atet)

Event study relative to atet               Number of obs = 662

------------------------------------------------------------------------------
           y |       ATET   Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
        ATET |   .5701579   .0094833    60.12   0.000      .551571    .5887447
------------------------------------------------------------------------------
```



# Authors
- Miklós Koren (Central European University), *maintainer*

# License and Citation
You are free to use this package under the terms of its [license](LICENSE). If you use it, please cite *both* the original article and the software package in your work:

- Koren, Miklós. 2024. "EVENTSTUDY: Correct Event Study After XTHDIDREGRESS. [software]" Available at https://github.com/codedthinking/eventstudy.
