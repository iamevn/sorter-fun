module Value exposing (Value, ValueCmp, getValues, gundam, toCmp, toString, view)

import Dict exposing (Dict)
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)
import Set exposing (Set)


type alias Value =
    { id : String
    , title : String
    , imagePath : String
    , anilistId : Maybe Int
    }


type alias ValueCmp =
    String


toCmp : Value -> ValueCmp
toCmp value =
    value.id


getValues : Set ValueCmp -> List Value
getValues =
    Set.toList >> List.filterMap getValue


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


gundam : List Value
gundam =
    [ { id = "", title = "Mobile Suit Gundam 0079", imagePath = "covers/80.jpg", anilistId = Just 80 }
    , { id = "", title = "Zeta Gundam", imagePath = "covers/85.jpg", anilistId = Just 85 }
    , { id = "", title = "ZZ", imagePath = "covers/86.png", anilistId = Just 86 }
    , { id = "", title = "Char's Counterattack", imagePath = "covers/87.png", anilistId = Just 87 }
    , { id = "", title = "early SD gundam shorts (Mk-I–Mk-V/Counterattack/Gaiden)", imagePath = "covers/2302.jpg", anilistId = Just 2302 }
    , { id = "", title = "0080 War in the Pocket", imagePath = "covers/82.png", anilistId = Just 82 }
    , { id = "", title = "F91", imagePath = "covers/88.png", anilistId = Just 88 }
    , { id = "", title = "0083 Stardust Memory", imagePath = "covers/84.jpg", anilistId = Just 84 }
    , { id = "", title = "Victory Gundam", imagePath = "covers/89.jpg", anilistId = Just 89 }
    , { id = "", title = "G Gundam", imagePath = "covers/96.png", anilistId = Just 96 }
    , { id = "", title = "Gundam Wing", imagePath = "covers/90.png", anilistId = Just 90 }
    , { id = "", title = "08th MS Team", imagePath = "covers/81.jpg", anilistId = Just 81 }
    , { id = "", title = "After War Gundam X", imagePath = "covers/92.png", anilistId = Just 92 }
    , { id = "", title = "Wing Endless Waltz", imagePath = "covers/91.png", anilistId = Just 91 }
    , { id = "", title = "Turn A Gundam", imagePath = "covers/95.jpg", anilistId = Just 95 }
    , { id = "", title = "G-Saviour", imagePath = "covers/GSaviour.jpg", anilistId = Nothing }
    , { id = "", title = "SEED", imagePath = "covers/93.jpg", anilistId = Just 93 }
    , { id = "", title = "SD Gundam Force", imagePath = "covers/2391.jpg", anilistId = Just 2391 }
    , { id = "", title = "SEED Destiny", imagePath = "covers/94.jpg", anilistId = Just 94 }
    , { id = "", title = "Seed Supernova", imagePath = "covers/2743.jpg", anilistId = Just 2743 }
    , { id = "", title = "MS IGLOO", imagePath = "covers/igloo.jpg", anilistId = Just 1917 }
    , { id = "", title = "MS IGLOO 2", imagePath = "covers/igloo2.jpg", anilistId = Just 4232 }
    , { id = "", title = "Witch from Mercury", imagePath = "covers/139274.png", anilistId = Just 139274 }
    , { id = "", title = "GQuuuuuuX", imagePath = "covers/185213.jpg", anilistId = Just 185213 }
    , { id = "", title = "Gundam Neo Experience 0087: Green Divers", imagePath = "covers/8839.jpg", anilistId = Just 8839 }
    , { id = "", title = "Mobile Suit Zeta Gundam: A New Translation", imagePath = "covers/1967.png", anilistId = Just 1967 }
    , { id = "", title = "Mobile Suit Gundam Seed MSV Astray", imagePath = "covers/864.png", anilistId = Just 864 }
    , { id = "", title = "Mobile Suit Gundam Seed C.E.73: Stargazer", imagePath = "covers/1215.jpg", anilistId = Just 1215 }
    , { id = "", title = "Gundam: Mission To The Rise", imagePath = "covers/4540.png", anilistId = Just 4540 }
    , { id = "", title = "Ring of Gundam", imagePath = "covers/7060.jpg", anilistId = Just 7060 }
    , { id = "", title = "Gundam EVOLVE", imagePath = "covers/3288.jpg", anilistId = Just 3288 }
    ]


gundamMap : Dict ValueCmp Value
gundamMap =
    List.map (\v -> ( v.id, v )) gundam
        |> Dict.fromList


getValue : String -> Maybe Value
getValue id =
    Dict.get id gundamMap
