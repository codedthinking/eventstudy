# `eventstudy` Correct event study after `xthdidregress`

# Syntax

- `eventstudy`, [**pre**(#) **post**(#) **baseline**(*string*)]

`eventstudy` transforms the coefficients estimated by `xthdidregress` into a correct event study relative to a baseline. The reported coefficients are the average treatment effects on the treated (ATT) for each period relative to the baseline. The baseline can be either the period before the treatment or the average of the pre-treatment periods.


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
**baseline** | Either a negative number between `-pre` and `-1` or `average`. If `-k`, the baseline is the kth period before the treatment. If `average`, the baseline is the average of the pre-treatment periods. Default is `-1`.

## Background
`xthdidregress` returns ATET between `t` and `t-1` whenever `t` is before the treatment. That is, pretrends are reported as first differences, whereas actual treatment effects are reported as difference relative to the period before treatment. 

## Remarks
The command can only be run after `xthdidregress`. 

The command also returns, as part of `r()`, the coefficients and standard errors. See `return list` after running the command.


# Examples
```
use https://friosavila.github.io/playingwithstata/drdid/lalonde.dta, clear
```
```
xtset id year
```
```
xthdidregress ra (re) (experimental), group(id)
eventstudy, pre(2) post(3) baseline(average)
```


# Authors
- Miklós Koren (Central European University), *maintainer*

# License and Citation
You are free to use this package under the terms of its [license](LICENSE). If you use it, please cite *both* the original article and the software package in your work:

- Koren, Miklós. 2023. "EVENTSTUDY: Correct Event Study After XTHDIDREGRESS. [software]" Available at https://github.com/codedthinking/eventstudy.
