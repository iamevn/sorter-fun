module Value exposing (Value, demoValues, toString, view)

import Html exposing (Html)


type alias Value =
    String


toString : Value -> String
toString value =
    case String.words value of
        first :: _ ->
            first

        _ ->
            value


view : Value -> Html any
view value =
    Html.text value


demoValues : List Value
demoValues =
    [ "🍎 apple"
    , "🍐 pear"
    , "🍊 orange "
    , "🍋 lemon"
    , "🍌 banana"
    , "🍉 watermelon"
    , "🍇 grape"
    , "🍓 strawberry"
    , "🫐 blueberry"
    , "🍒 cherry"
    , "🍑 peach"
    , "🍍 pineapple"
    , "🥝 kiwi"
    ]
