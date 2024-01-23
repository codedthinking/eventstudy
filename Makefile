FILES := $(shell cat files.txt)
TARGET := package.zip

$(TARGET): $(FILES)
	zip $(TARGET) $(FILES)
eventbaseline.sthlp: README.md smcl.lua
	pandoc -f gfm -t smcl.lua $< > $@
smcl.lua:
	curl -sLo $@ "https://raw.githubusercontent.com/korenmiklos/pandoc-smcl/master/smcl.lua"
%.pkg: %.ado README.md packager.py
	poetry run python packager.py README.md $* 