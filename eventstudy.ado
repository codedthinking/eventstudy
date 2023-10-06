*! version 0.2.0 06oct2023
program eventstudy, rclass
    syntax [, pre(integer 1) post(integer 3) baseline(string)]
    display as text "Event study analysis"
	if ("`level'" == "") {
		local level 95
	}    
    if ("`baseline'" == "") {
        local baseline "-1"
    }
    local T1 = `pre'-1
    local K = `pre'+`post'+1

    quietly estat aggregation, dynamic(-`T1'/`post') 
    matrix bad_coef = r(b)
    matrix bad_Var = r(V)

    matrix Wcum = I(`K')
    forvalues i = 1/`pre' {
        forvalues j = 1/`i' {
            matrix Wcum[`j', `i'] = -1.0
        }
    }
    matrix Wcum = Wcum[1..., 1..`pre'-1], Wcum[1..., `pre'+1..`pre'+`post'+1]

    if ("`baseline'" == "average") {
        matrix W0 = I(`K') - (J(`K', `pre', 1/`pre'), J(`K', `post'+1, 0))
    }
    else {
        matrix W0 = I(`K')
        local bl = `pre' + `baseline' + 1
        forvalues i = 1/`K' {
            matrix W0[`i', `bl'] = W0[`i', `bl'] - 1.0
        }
    }
    matrix b = bad_coef * Wcum' * W0'
    matrix V = W0 * Wcum * bad_Var * Wcum' * W0'

    * label coefficients
    forvalues t = -`pre'/`post' {
        local colnames `colnames' `t'
    }
    matrix colname b = `colnames'
    matrix colname V = `colnames'
    matrix rowname V = `colnames'

    _coef_table_header, title(Event study relative to `baseline') width(62)
	display
	_coef_table, bmat(b) vmat(V) level(`level') 	///
		depname("Event time") coeftitle(ATET)

    return matrix b = b
    return matrix V = V
end