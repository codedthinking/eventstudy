eventstudy.sthlp: README.md smcl.lua
	pandoc -f gfm -t smcl.lua $< > $@
smcl.lua:
	curl -sLo $@ "https://raw.githubusercontent.com/korenmiklos/pandoc-smcl/master/smcl.lua"