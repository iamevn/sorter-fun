DIST := dist
PAGE := gundam-sorter.html
CSS := sorter.css
TARGET := $(DIST)/sorter.js
MAIN := src/Main.elm
SRC_FILES := $(wildcard src/*.elm) $(wildcard src/**/*.elm)

$(TARGET) : $(SRC_FILES)
	elm make $(MAIN) --output=$(TARGET)

.PHONY : live
live : 
	elm-live $(MAIN) --open --dir=$(DIST) --start-page=$(PAGE) -- --output=$(TARGET)

.PHONY : publish
publish : $(DIST)/$(PAGE) $(DIST)/$(CSS) $(TARGET)
	neocities upload -d gundam_ranking/ $^

.PHONY : publish_covers
publish_covers : $(DIST)/covers/*
	neocities upload -d gundam_ranking/covers/ $^

.PHONY : publish_all
publish_all : publish publish_covers

.PHONY : clean
clean : $(TARGET)
	rm $^

