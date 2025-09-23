Live version at https://iamevn.net/gundam_ranking/gundam-sorter

# Build

`elm make src/Main.elm --output=dist/sorter.js`

# Run devserver

(Using [`elm-live`](https://github.com/wking-io/elm-live))

`elm-live src/Main.elm --open --dir=dist/ --start-page=gundam-sorter.html -- --output=dist/sorter.js`
