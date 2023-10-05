*! version 0.1.0 05oct2023
program eventstudy, rclass
    syntax [, pre(integer 1) post(integer 3)]
    display as text "Event study analysis"
	if ("`level'" == "") {
		local level 95
	}    
    local T1 = `pre'-1

    estat aggregation, dynamic(-`T1'/`post') 
    matrix bad_coef = r(b)
    matrix bad_Var = r(V)

    matrix Wcum = I(`pre'+`post'+1)
    forvalues i = 1/`pre' {
        forvalues j = 1/`i' {
            matrix Wcum[`j', `i'] = -1.0
        }
    }
    matrix Wcum = Wcum[1..., 1..`pre'-1], Wcum[1..., `pre'+1..`pre'+`post'+1]

    matrix W0 = I(`pre'+`post'+1) - (J(`pre'+`post'+1, `pre', 1/`pre'), J(`pre'+`post'+1, `post'+1, 0))

    matrix b = W0 * Wcum * bad_coef'
    matrix V = W0 * Wcum * bad_Var * Wcum' * W0'

	/*
    _coef_table_header, title(Event study relative to -1) width(62)
	display

	_coef_table, bmat(b) vmat(V) level(`level') 	///
		depname("") 
    */

    return matrix b = b
    return matrix V = V
end