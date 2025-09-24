DIST := dist
PAGE := gundam-sorter.html
CSS := sorter.css
COVERS := $(wildcard $(DIST)/covers/*)
TARGET := $(DIST)/sorter.js
MAIN := src/Main.elm
SRC_FILES := $(wildcard src/*.elm) $(wildcard src/**/*.elm)
PUBLISHED_TIMESTAMP := .make_last_published
PUBLISHED_COVERS_TIMESTAMP := $(PUBLISHED_TIMESTAMP)_covers

$(TARGET) : $(SRC_FILES)
	elm make $(MAIN) --output=$@

.PHONY : live
live : 
	elm-live $(MAIN) --open --dir=$(DIST) --start-page=$(PAGE) -- --output=$(TARGET)

# neocities' cli tool checks if files changed before republishing
# but we can save a little time by only trying to publish
# files that have changed since our last publish.
# Can track when we last published with a hidden file.
# This file's contents don't matter.
.PHONY : publish
publish : $(PUBLISHED_TIMESTAMP) $(PUBLISHED_COVERS_TIMESTAMP)

$(PUBLISHED_TIMESTAMP) : $(DIST)/$(PAGE) $(DIST)/$(CSS) $(TARGET)
	neocities upload -d gundam_ranking/ $?
	@date > $@
	@printf "%s\\n" $? >> $@

$(PUBLISHED_COVERS_TIMESTAMP) : $(COVERS)
	neocities upload -d gundam_ranking/covers/ $?
	@date > $@
	@printf "%s\\n" $? >> $@

.PHONY : clean
clean :
	rm -f $(TARGET) $(PUBLISHED_TIMESTAMP) $(PUBLISHED_COVERS_TIMESTAMP)

