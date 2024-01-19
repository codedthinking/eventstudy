{smcl}


{marker eventstudy-correct-event-study-after-xthdidregress}{...}
{title:{cmd:eventstudy} Correct event study after {cmd:xthdidregress}}


{marker syntax}{...}
{title:Syntax}

{text}{phang2}{cmd:eventstudy}, [{bf:pre}(#) {bf:post}(#) {bf:baseline}({it:string}) {bf:generate}({it:name})]{p_end}


{pstd}{cmd:eventstudy} transforms the coefficients estimated by {cmd:xthdidregress} into a correct event study relative to a baseline. The reported coefficients are the average treatment effects on the treated (ATT) for each period relative to the baseline. The baseline can be either a period before the treatment or the average of the pre-treatment periods.{p_end}

{pstd}The package can be installed with{p_end}

{phang2}{cmd}. net install eventstudy, from(https://raw.githubusercontent.com/codedthinking/eventstudy/main/)


{marker options}{...}
{title:Options}


{marker options-1}{...}
{dlgtab:Options}

{synoptset tabbed}{...}
{synopthdr:Option}
{synoptline}
{synopt:{bf:pre}}Number of periods before treatment to include in the estimation (default 1){p_end}
{synopt:{bf:post}}Number of periods after treatment to include in the estimation (default 3){p_end}
{synopt:{bf:baseline}}Either a negative number between {cmd:-pre} and {cmd:-1} or {cmd:average}, or {cmd:atet}. If {cmd:-k}, the baseline is the kth period before the treatment. If {cmd:average}, the baseline is the average of the pre-treatment periods. If {cmd:atet}, the regression table reports the average of the post-treatment periods minus the average of the pre-treatment periods. Default is {cmd:-1}.{p_end}
{synopt:{bf:generate} (optional)}Name of the frame to store the coefficients and their confidence interval.{p_end}
{synoptline}


{marker background}{...}
{title:Background}

{pstd}{cmd:xthdidregress} returns ATET between {cmd:t} and {cmd:t-1} whenever {cmd:t} is before the treatment. That is, pretrends are reported as first differences, whereas actual treatment effects are reported as difference relative to the period before treatment. This can lead to misleading event study plots. The {cmd:eventstudy} command transforms the coefficients into a correct event study relative to a baseline.{p_end}


{marker remarks}{...}
{title:Remarks}

{pstd}The command can only be run after {cmd:xthdidregress}.{p_end}

{pstd}The command also returns, as part of {cmd:e()}, the coefficients and standard errors. See {cmd:ereturn list} after running the command. Typical post-estimation commands can be used, such as {cmd:outreg2} or {cmd:estout}.{p_end}

{pstd}If the {cmd:generate} option is used, the returned frame contains the following variables:{p_end}

{text}{phang2}{cmd:time}: the time period relative to the baseline{p_end}
{phang2}{cmd:coef}: the estimated coefficient{p_end}
{phang2}{cmd:lower}: the lower bound of the 95% confidence interval{p_end}
{phang2}{cmd:upper}: the upper bound of the 95% confidence interval{p_end}


{pstd}The frame is {cmd:tsset} by {cmd:time}, so {cmd:tsline} can be used to plot the event study.{p_end}


{marker examples}{...}
{title:Examples}

{phang2}{cmd}. . use testdata

. xthdidregress ra (y) (treatment), group(group)

. eventstudy, pre(3) post(3) baseline(-3) generate(eventstudy)

Event study relative to -3              Number of obs    = 800
                                        Number of panels = 100

                                (Std. err. adjusted for 100 clusters in group)
------------------------------------------------------------------------------
             |               Robust
             |       ATET   std. err.      z    P>|z|     [95% conf. interval]
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



{phang2}{cmd}. . eventstudy, pre(3) post(3) baseline(atet)

Event study relative to atet            Number of obs    = 800
                                        Number of panels = 100

                                (Std. err. adjusted for 100 clusters in group)
------------------------------------------------------------------------------
             |               Robust
             |       ATET   std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
        ATET |   .5701579   .0094833    60.12   0.000      .551571    .5887447
------------------------------------------------------------------------------


{marker authors}{...}
{title:Authors}

{text}{phang2}Miklós Koren (Central European University), {it:maintainer}{p_end}



{marker license-and-citation}{...}
{title:License and Citation}

{pstd}You are free to use this package under the terms of its {browse "LICENSE":license}. If you use it, please cite {it:both} the original article and the software package in your work:{p_end}

{text}{phang2}Koren, Miklós. 2024. "EVENTSTUDY: Correct Event Study After XTHDIDREGRESS. [software]" Available at {browse "https://github.com/codedthinking/eventstudy":https://github.com/codedthinking/eventstudy}.{p_end}
