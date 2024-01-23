clear all
use "df.dta"

* time index has to be non-negative for xtset
replace t = t + 100
xtset i t

* illustrate event study plot with kink
xthdidregress ra (y) (d), group(i)
estat aggregation, dynamic(-4/5) graph
graph export "eventstudy_kink.png", replace

* event study plot with correct baseline
xthdidregress ra (y) (d), group(i)
eventbaseline, pre(5) post(5) baseline(-1) generate(eventstudy_correct)
frame eventstudy_correct: tsline upper coef lower
graph export "eventstudy_correct.png", replace

* ATET as difference of average of after and before
xthdidregress ra (y) (d), group(i)
eventbaseline, pre(5) post(5) baseline(atet)
