MAIN := src/Main.elm
TARGET := dist/sorter.js
PAGE := gundam-sorter.html
CSS := sorter.css
COVERS := $(wildcard dist/covers/*)
PUBLISHED_TIMESTAMP := .make_last_published
PUBLISHED_COVERS_TIMESTAMP := .make_last_published_covers

$(TARGET) : $(wildcard src/*.elm) $(wildcard src/**/*.elm)
	elm make $(MAIN) --output=$@

.PHONY : live
live : 
	elm-live $(MAIN) --open --dir=dist/ --start-page=$(PAGE) -- --output=$(TARGET)

# neocities' cli tool checks if files changed before republishing but we can save a little time
# by only trying to publish files that have changed since our last publish.
# Can track when we last published with a hidden file (whose contents don't matter).
.PHONY : publish
publish : $(PUBLISHED_TIMESTAMP) $(PUBLISHED_COVERS_TIMESTAMP)

$(PUBLISHED_TIMESTAMP) : dist/$(PAGE) dist/$(CSS) $(TARGET)
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

