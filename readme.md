# Build

Uses [elm](https://elm-lang.org/)

`make`

(or `elm make src/Main.elm --output=dist/sorter.js`)

# Run devserver

Uses [`elm-live`](https://github.com/wking-io/elm-live)

`make live`

(or `elm-live src/Main.elm --open --dir=dist/ --start-page=gundam-sorter.html -- --output=dist/sorter.js`)

# Publish

Uses [neocities cli](https://neocities.org/cli). (First run will prompt for login info.)

`make publish`

(or `neocities upload -d gundam_ranking/ dist/gundam-sorter.html dist/sorter.js dist/sorter.css && neocities upload -d gundam_ranking/covers/ dist/covers/*`)

Live version at https://iamevn.net/gundam_ranking/gundam-sorter

