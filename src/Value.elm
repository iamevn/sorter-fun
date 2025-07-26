module Value exposing (..)

import Html exposing (Html)


type alias Value =
    String


toString : Value -> String
toString value =
    value


view : Value -> Html any
view value =
    Html.text <| toString value


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
