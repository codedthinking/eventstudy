*! version 0.7.0 23jan2024
program eventbaseline, eclass
    syntax [, pre(integer 1) post(integer 3) baseline(string) generate(string) level(real 95)] [graph]
	if ("`level'" == "") {
		local level 95
	}    
    if ("`baseline'" == "") {
        local baseline "-1"
    }   
    if (e(cmd) != "xthdidregress") {
        display in red "eventstudy can only be used after xthdidregress"
        error 198
    }
    local T1 = `pre'-1
    local K = `pre'+`post'+1

    local depvar = e(depvar)
    local cohortvar = e(cohortvar)
    local timevar = e(timevar)
    tempname bad_coef bad_Var Wcum W0 b V Nobs coefplot tlabels

    tempvar exclude esample
    * exclude observations outside of the event window
    quietly generate `exclude' = cond(`cohortvar' == 0, 0, !inrange(`timevar' - `cohortvar', -`pre', `post'))
    quietly generate `esample' = e(sample) & (`exclude' == 0)
    quietly count if `esample'
    local Nobs = r(N)

    quietly estat aggregation, dynamic(-`T1'/`post') 
    matrix `bad_coef' = r(b)
    matrix `bad_Var' = r(V)

    matrix `Wcum' = I(`K')
    forvalues i = 1/`pre' {
        forvalues j = 1/`i' {
            matrix `Wcum'[`j', `i'] = -1.0
        }
    }
    matrix `Wcum' = `Wcum'[1..., 1..`pre'-1], `Wcum'[1..., `pre'+1..`pre'+`post'+1]

    if ("`baseline'" == "average") {
        matrix `W0' = I(`K') - (J(`K', `pre', 1/`pre'), J(`K', `post'+1, 0))
    }
    else if ("`baseline'" == "atet") {
        matrix `W0' = (J(1, `pre', -1/`pre'), J(1, `post'+1, 1/(`post'+1)))
    }
    else {
        if (!inrange(`baseline', -`pre', -1)) {
            display in red "Baseline must be between -`pre' and -1"
            error 198
        }
        matrix `W0' = I(`K')
        local bl = `pre' + `baseline' + 1
        forvalues i = 1/`K' {
            matrix `W0'[`i', `bl'] = `W0'[`i', `bl'] - 1.0
        }
    }
    matrix `b' = `bad_coef' * `Wcum'' * `W0''
    matrix `V' = `W0' * `Wcum' * `bad_Var' * `Wcum'' * `W0''

    if ("`baseline'" == "atet") {
        local colnames "ATET"
    }
    else {
        * label coefficients
        forvalues t = -`pre'/`post' {
            local colnames `colnames' `t'
        }
    }
    matrix colname `b' = `colnames'
    matrix colname `V' = `colnames'
    matrix rowname `V' = `colnames'

    matrix `coefplot' = J(`K', 4, .)
    matrix colname `coefplot' = xvar b ll ul
    local tlabels ""
    forvalues t = -`pre'/`post' {
        local tlabels `tlabels' `t'
        local i = `t' + `pre' + 1
        matrix `coefplot'[`i', 1] = `t''
        matrix `coefplot'[`i', 2] = `b'[1, `i']
        matrix `coefplot'[`i', 3] = `b'[1, `i'] + invnormal((100-`level')/200) * sqrt(`V'[`i', `i'])
        matrix `coefplot'[`i', 4] = `b'[1, `i'] - invnormal((100-`level')/200) * sqrt(`V'[`i', `i'])
    }

    tempname coef lower upper
    if ("`generate'" != "") {
        capture frame drop `generate'
        frame create `generate' time coef lower upper
        forvalues t = -`pre'/`post' {
            local i = `t' + `pre' + 1
            scalar `coef' = `b'[1, `i']
            scalar `lower' = `b'[1, `i'] + invnormal((100-`level')/200) * sqrt(`V'[`i', `i'])
            scalar `upper' = `b'[1, `i'] - invnormal((100-`level')/200) * sqrt(`V'[`i', `i'])
            frame post `generate' (`t') (`coef') (`lower') (`upper')
        }
        frame `generate': tsset time
        frame `generate': format coef lower upper %9.3f
    }

	ereturn post `b' `V', obs(`Nobs') esample(`esample')
    ereturn local depvar `depvar'
	ereturn local cmd eventstudy
	ereturn local cmdline eventstudy `0'

    _coef_table_header, title(Event study relative to `baseline') width(62)
	display
	_coef_table, bmat(e(b)) vmat(e(V)) level(`level') 	///
		depname(`depvar') coeftitle(ATET)

    if ("`graph'" == "graph") {
        hetdid_coefplot, mat(`coefplot') title(Event study relative to `baseline') ///
            ylb(`depvar') xlb("Length of exposure to the treatment") ///
            yline(0) legend(off) level(`level') yline(0,  extend) ytick(0, add) ylabel(0, add) xlabel(`tlabels')
    }
end

