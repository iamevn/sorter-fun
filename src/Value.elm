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
    [ { title = "Mobile Suit Gundam 0079", imagePath = "covers/80.jpg", anilistId = Just 80 }
    , { title = "Zeta Gundam", imagePath = "covers/85.jpg", anilistId = Just 85 }
    , { title = "ZZ", imagePath = "covers/86.png", anilistId = Just 86 }
    , { title = "Char's Counterattack", imagePath = "covers/87.png", anilistId = Just 87 }
    , { title = "early SD gundam shorts (Mk-I–Mk-V/Counterattack/Gaiden)", imagePath = "covers/2302.jpg", anilistId = Just 2302 }
    , { title = "0080 War in the Pocket", imagePath = "covers/82.png", anilistId = Just 82 }
    , { title = "F91", imagePath = "covers/88.png", anilistId = Just 88 }
    , { title = "0083 Stardust Memory", imagePath = "covers/84.jpg", anilistId = Just 84 }
    , { title = "Victory Gundam", imagePath = "covers/89.jpg", anilistId = Just 89 }
    , { title = "G Gundam", imagePath = "covers/96.png", anilistId = Just 96 }
    , { title = "Gundam Wing", imagePath = "covers/90.png", anilistId = Just 90 }
    , { title = "08th MS Team", imagePath = "covers/81.jpg", anilistId = Just 81 }
    , { title = "After War Gundam X", imagePath = "covers/92.png", anilistId = Just 92 }
    , { title = "Wing Endless Waltz", imagePath = "covers/91.png", anilistId = Just 91 }
    , { title = "Turn A Gundam", imagePath = "covers/95.jpg", anilistId = Just 95 }
    , { title = "G-Saviour", imagePath = "covers/GSaviour.jpg", anilistId = Nothing }
    , { title = "SEED", imagePath = "covers/93.jpg", anilistId = Just 93 }
    , { title = "SD Gundam Force", imagePath = "covers/2391.jpg", anilistId = Just 2391 }
    , { title = "SEED Destiny", imagePath = "covers/94.jpg", anilistId = Just 94 }
    , { title = "Seed Supernova", imagePath = "covers/2743.jpg", anilistId = Just 2743 }
    , { title = "MS IGLOO", imagePath = "covers/igloo.jpg", anilistId = Just 1917 }
    , { title = "MS IGLOO 2", imagePath = "covers/igloo2.jpg", anilistId = Just 4232 }
    , { title = "Witch from Mercury", imagePath = "covers/139274.png", anilistId = Just 139274 }
    , { title = "GQuuuuuuX", imagePath = "covers/185213.jpg", anilistId = Just 185213 }
    , { title = "Gundam Neo Experience 0087: Green Divers", imagePath = "covers/8839.jpg", anilistId = Just 8839 }
    , { title = "Mobile Suit Zeta Gundam: A New Translation", imagePath = "covers/1967.png", anilistId = Just 1967 }
    , { title = "Mobile Suit Gundam Seed MSV Astray", imagePath = "covers/864.png", anilistId = Just 864 }
    , { title = "Mobile Suit Gundam Seed C.E.73: Stargazer", imagePath = "covers/1215.jpg", anilistId = Just 1215 }
    , { title = "Gundam: Mission To The Rise", imagePath = "covers/4540.png", anilistId = Just 4540 }
    , { title = "Ring of Gundam", imagePath = "covers/7060.jpg", anilistId = Just 7060 }
    , { title = "Gundam EVOLVE", imagePath = "covers/3288.jpg", anilistId = Just 3288 }
    ]
