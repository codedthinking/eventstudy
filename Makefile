FILES := $(shell cat files.txt)
TARGET := eventbaseline.zip

.PHONY: tag

$(TARGET): $(FILES) tag
	zip $(TARGET) $(FILES)
tag:
	$(eval VERSION=$(shell grep 'version:' README.md | cut -d ' ' -f 2 | sed 's/^/v/'))
	git add $(FILES)
	git commit -m "Version $(VERSION)"
	git tag $(VERSION)
eventbaseline.sthlp: README.md smcl.lua
	pandoc -f gfm -t smcl.lua $< > $@
smcl.lua:
	curl -sLo $@ "https://raw.githubusercontent.com/korenmiklos/pandoc-smcl/master/smcl.lua"
%.pkg: %.ado README.md packager.py
	poetry run python packager.py README.md $* 