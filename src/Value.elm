module Value exposing (Value, demoValues, toString, view)

import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)


type alias Value =
    { title : String
    , imagePath : String
    , anilistId : Maybe Int
    }


toString : Value -> String
toString { title } =
    title


view : Value -> Html any
view value =
    div [ class "show" ]
        [ img [ src value.imagePath, class "poster" ] []
        , div
            [ class "title" ]
            [ text value.title ]
        ]


demoValues : List Value
demoValues =
    [ { title = "Mobile Suit Gundam 0079", imagePath = "covers/bx80.jpg", anilistId = Just 80 }
    , { title = "Zeta Gundam", imagePath = "covers/bx85.jpg", anilistId = Just 85 }
    , { title = "ZZ", imagePath = "covers/b86.png", anilistId = Just 86 }
    , { title = "Char's Counterattack", imagePath = "covers/bx87.png", anilistId = Just 87 }
    , { title = "early SD gundam shorts (Mk-I–Mk-V/Counterattack/Gaiden)", imagePath = "covers/2302.jpg", anilistId = Just 2302 }
    , { title = "0080 War in the Pocket", imagePath = "covers/bx82.png", anilistId = Just 82 }
    , { title = "F91", imagePath = "covers/bx88.png", anilistId = Just 88 }
    , { title = "0083 Stardust Memory", imagePath = "covers/bx84.jpg", anilistId = Just 84 }
    , { title = "Victory Gundam", imagePath = "covers/bx89.jpg", anilistId = Just 89 }
    , { title = "G Gundam", imagePath = "covers/bx96.png", anilistId = Just 96 }
    , { title = "Gundam Wing", imagePath = "covers/b90.png", anilistId = Just 90 }
    , { title = "08th MS Team", imagePath = "covers/bx81.jpg", anilistId = Just 81 }
    , { title = "After War Gundam X", imagePath = "covers/bx92.png", anilistId = Just 92 }
    , { title = "Wing Endless Waltz", imagePath = "covers/bx91.png", anilistId = Just 91 }
    , { title = "Turn A Gundam", imagePath = "covers/nx95.jpg", anilistId = Just 95 }
    , { title = "G-Saviour", imagePath = "covers/GSaviour.jpg", anilistId = Nothing }
    , { title = "SEED", imagePath = "covers/bx93.jpg", anilistId = Just 93 }
    , { title = "SD Gundam Force", imagePath = "covers/2391.jpg", anilistId = Just 2391 }
    , { title = "SEED Destiny", imagePath = "covers/bx94.jpg", anilistId = Just 94 }
    , { title = "Seed Supernova", imagePath = "covers/2743.jpg", anilistId = Just 2743 }
    , { title = "Witch from Mercury", imagePath = "covers/bx139274.png", anilistId = Just 139274 }
    , { title = "GQuuuuuuX", imagePath = "covers/bx185213.jpg", anilistId = Just 185213 }
    ]
