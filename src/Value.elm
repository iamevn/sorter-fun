module Value exposing (GID, Value, getValues, gundam, toString, view)

import Dict exposing (Dict)
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)
import Set exposing (Set)


type alias GID =
    String


type alias Value =
    { id : GID
    , title : String
    , imagePath : String
    , anilistId : Maybe Int
    }


getValues : Set GID -> List Value
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
    [ { id = "0079", title = "Mobile Suit Gundam 0079", imagePath = "covers/80.jpg", anilistId = Just 80 }
    , { id = "MSG1", title = "Mobile Suit Gundam I", imagePath = "covers/1090", anilistId = Just 1090 }
    , { id = "MSG2", title = "Mobile Suit Gundam II: Soldiers of Sorrow", imagePath = "covers/1091", anilistId = Just 1091 }
    , { id = "MSG3", title = "Mobile Suit Gundam III: Encounters in Space", imagePath = "covers/1092", anilistId = Just 1092 }
    , { id = "Z", title = "Zeta Gundam", imagePath = "covers/85.jpg", anilistId = Just 85 }
    , { id = "ZZ", title = "ZZ", imagePath = "covers/86.jpg", anilistId = Just 86 }
    , { id = "CCA", title = "Char's Counterattack", imagePath = "covers/87.jpg", anilistId = Just 87 }
    , { id = "SDMK1", title = "SD Gundam Mk. I", imagePath = "covers/2302.jpg", anilistId = Just 2302 }
    , { id = "SDMK2", title = "SD Gundam Mk. II", imagePath = "covers/2303.jpg", anilistId = Just 2303 }
    , { id = "SDMK3", title = "SD Gundam Mk. III", imagePath = "covers/2305.jpg", anilistId = Just 2305 }
    , { id = "SDMK4", title = "SD Gundam Mk. IV", imagePath = "covers/2304.jpg", anilistId = Just 2304 }
    , { id = "SDMK5", title = "SD Gundam Mk. V", imagePath = "covers/6792.jpg", anilistId = Just 6792 }
    , { id = "SDCounterattack", title = "SD Gundam's Counterattack", imagePath = "covers/2306.jpg", anilistId = Just 2306 }
    , { id = "SDGaiden", title = "SD Gundam Gaiden", imagePath = "covers/1939.jpg", anilistId = Just 1939 }
    , { id = "0080", title = "0080 War in the Pocket", imagePath = "covers/82.jpg", anilistId = Just 82 }
    , { id = "F91", title = "F91", imagePath = "covers/88.jpg", anilistId = Just 88 }
    , { id = "0083", title = "0083 Stardust Memory", imagePath = "covers/84.jpg", anilistId = Just 84 }
    , { id = "V", title = "Victory Gundam", imagePath = "covers/89.jpg", anilistId = Just 89 }
    , { id = "G", title = "G Gundam", imagePath = "covers/96.jpg", anilistId = Just 96 }
    , { id = "Wing", title = "Gundam Wing", imagePath = "covers/90.jpg", anilistId = Just 90 }
    , { id = "08th", title = "08th MS Team", imagePath = "covers/81.jpg", anilistId = Just 81 }
    , { id = "X", title = "After War Gundam X", imagePath = "covers/92.jpg", anilistId = Just 92 }
    , { id = "EW", title = "Wing Endless Waltz", imagePath = "covers/91.jpg", anilistId = Just 91 }
    , { id = "TurnA", title = "Turn A Gundam", imagePath = "covers/95.jpg", anilistId = Just 95 }
    , { id = "GSaviour", title = "G-Saviour", imagePath = "covers/GSaviour.jpg", anilistId = Nothing }
    , { id = "SEED", title = "SEED", imagePath = "covers/93.jpg", anilistId = Just 93 }
    , { id = "SDGF", title = "SD Gundam Force", imagePath = "covers/2391.jpg", anilistId = Just 2391 }
    , { id = "SEED:Destiny", title = "SEED Destiny", imagePath = "covers/94.jpg", anilistId = Just 94 }
    , { id = "SEED:Supernova", title = "Seed Supernova", imagePath = "covers/2743.jpg", anilistId = Just 2743 }
    , { id = "IGLOO", title = "MS IGLOO", imagePath = "covers/1917.jpg", anilistId = Just 1917 }
    , { id = "IGLOO2", title = "MS IGLOO 2", imagePath = "covers/4232.jpg", anilistId = Just 4232 }
    , { id = "Neo0087", title = "Gundam Neo Experience 0087: Green Divers", imagePath = "covers/8839.jpg", anilistId = Just 8839 }
    , { id = "Z:ANT", title = "Mobile Suit Zeta Gundam: A New Translation", imagePath = "covers/1967.jpg", anilistId = Just 1967 }
    , { id = "SEED:Astray", title = "Mobile Suit Gundam Seed MSV Astray", imagePath = "covers/864.jpg", anilistId = Just 864 }
    , { id = "SEED:Stargazer", title = "Mobile Suit Gundam Seed C.E.73: Stargazer", imagePath = "covers/1215.jpg", anilistId = Just 1215 }
    , { id = "M2R", title = "Gundam: Mission To The Rise", imagePath = "covers/4540.jpg", anilistId = Just 4540 }
    , { id = "Ring", title = "Ring of Gundam", imagePath = "covers/7060.jpg", anilistId = Just 7060 }
    , { id = "EVOLVE", title = "Gundam EVOLVE", imagePath = "covers/3288.jpg", anilistId = Just 3288 }
    , { id = "WfM", title = "Witch from Mercury", imagePath = "covers/139274.jpg", anilistId = Just 139274 }
    , { id = "GQX", title = "GQuuuuuuX", imagePath = "covers/185213.jpg", anilistId = Just 185213 }
    ]


gundamDict : Dict GID Value
gundamDict =
    let
        d =
            List.map (\v -> ( v.id, v )) gundam
                |> Dict.fromList
    in
    if List.length gundam /= Dict.size d then
        Debug.todo "need unique IDs"

    else
        d


getValue : String -> Maybe Value
getValue id =
    Dict.get id gundamDict


eWatched =
    Set.fromList
        [ "0079"
        , "Z"
        , "ZZ"
        , "CCA"
        , "earlySD"
        , "0080"
        , "F91"
        , "0083"
        , "V"
        , "G"
        , "Wing"
        , "08th"
        , "X"
        , "EW"
        , "TurnA"
        , "GSaviour"
        , "SEED"
        , "SDGF"
        , "SEED:Destiny"
        , "SEED:Supernova"
        , "IGLOO"
        , "IGLOO2"
        , "Neo0087"
        , "Z:ANT"
        , "SEED:Astray"
        , "SEED:Stargazer"
        , "M2R"
        , "Ring"
        , "EVOLVE"
        , "WfM"
        , "GQX"
        ]


ggpWatched =
    Set.fromList
        [ "0079"
        , "Z"
        , "ZZ"
        , "CCA"
        , "earlySD"
        , "0080"
        , "F91"
        , "0083"
        , "V"
        , "G"
        , "Wing"
        , "08th"
        , "X"
        , "EW"
        , "TurnA"
        , "GSaviour"
        , "SEED"
        , "SDGF"
        , "SEED:Destiny"
        , "SEED:Supernova"
        , "IGLOO"
        , "IGLOO2"
        , "Neo0087"
        , "Z:ANT"
        , "SEED:Astray"
        , "SEED:Stargazer"
        , "M2R"
        , "Ring"
        , "EVOLVE"
        ]
