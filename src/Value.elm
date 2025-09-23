module Value exposing (ChosenValues, VID, Value(..), allShows, getAnilistId, getId, getImagePath, getTitle, getValues, groups, groupsByShow, gundam, toString, view)

import Dict exposing (Dict)
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)
import Set exposing (Set)


type alias VID =
    String


type alias ChosenValues =
    Set VID


type alias ShowMeta =
    { id : VID
    , title : String
    , imagePath : String
    , anilistId : Maybe Int
    }


type alias GroupMeta =
    { id : VID
    , title : String
    , imagePath : String
    , anilistId : Maybe Int
    , contains : List Value
    }


type Value
    = Show ShowMeta
    | Group GroupMeta


type alias Value_ =
    { id : VID
    , title : String
    , imagePath : String
    , anilistId : Maybe Int
    }


getId : Value -> VID
getId value =
    case value of
        Show { id } ->
            id

        Group { id } ->
            id


getTitle : Value -> String
getTitle value =
    case value of
        Show { title } ->
            title

        Group { title } ->
            title


getImagePath value =
    case value of
        Show { imagePath } ->
            imagePath

        Group { imagePath } ->
            imagePath


getAnilistId value =
    case value of
        Show { anilistId } ->
            anilistId

        Group { anilistId } ->
            anilistId


getValues : Set VID -> List Value
getValues =
    Set.toList >> List.filterMap getValue


toString : Value -> String
toString =
    getTitle


view : Value -> Html any
view value =
    div [ class "show" ]
        [ img [ src <| getImagePath value, class "poster" ] []
        , div
            [ class "title" ]
            [ text <| getTitle value ]
        ]


gundam : List Value
gundam =
    [ Show { id = "0079", title = "Mobile Suit Gundam 0079", imagePath = "covers/80.jpg", anilistId = Just 80 }
    , Group
        { id = "0079Movies"
        , title = "Mobile Suit Gundam movie trilogy"
        , imagePath = "covers/1090.jpg"
        , anilistId = Just 1090
        , contains =
            [ Show { id = "MSG1", title = "Mobile Suit Gundam I", imagePath = "covers/1090.jpg", anilistId = Just 1090 }
            , Show { id = "MSG2", title = "Mobile Suit Gundam II: Soldiers of Sorrow", imagePath = "covers/1091.jpg", anilistId = Just 1091 }
            , Show { id = "MSG3", title = "Mobile Suit Gundam III: Encounters in Space", imagePath = "covers/1092.jpg", anilistId = Just 1092 }
            ]
        }
    , Show { id = "Z", title = "Zeta Gundam", imagePath = "covers/85.jpg", anilistId = Just 85 }
    , Show { id = "ZZ", title = "ZZ", imagePath = "covers/86.jpg", anilistId = Just 86 }
    , Show { id = "CCA", title = "Char's Counterattack", imagePath = "covers/87.jpg", anilistId = Just 87 }
    , Group
        { id = "earlySD"
        , title = "early SD Gundam shorts"
        , imagePath = "covers/2302.jpg"
        , anilistId = Just 2302
        , contains =
            [ Show { id = "SDMK1", title = "SD Gundam Mk. I", imagePath = "covers/2302.jpg", anilistId = Just 2302 }
            , Show { id = "SDMK2", title = "SD Gundam Mk. II", imagePath = "covers/2303.jpg", anilistId = Just 2303 }
            , Show { id = "SDMK3", title = "SD Gundam Mk. III", imagePath = "covers/2305.jpg", anilistId = Just 2305 }
            , Show { id = "SDMK4", title = "SD Gundam Mk. IV", imagePath = "covers/2304.jpg", anilistId = Just 2304 }
            , Show { id = "SDMK5", title = "SD Gundam Mk. V", imagePath = "covers/6792.jpg", anilistId = Just 6792 }
            , Show { id = "SDCounterattack", title = "SD Gundam's Counterattack", imagePath = "covers/2306.jpg", anilistId = Just 2306 }
            , Show { id = "SDGaiden", title = "SD Gundam Gaiden", imagePath = "covers/1939.jpg", anilistId = Just 1939 }
            , Show { id = "SDMatsuri", title = "SD Gundam Matsuri", imagePath = "covers/9098.jpg", anilistId = Just 9098 }
            , Show { id = "SDScramble", title = "SD Gundam Musha Knight Command Emergency Sortie", imagePath = "covers/9087.jpg", anilistId = Just 9087 }
            , Show { id = "SDHyakka", title = "SD Gundam Hyakka (Many Things SD Gundam)", imagePath = "covers/hyakka.jpg", anilistId = Nothing }
            ]
        }
    , Show { id = "0080", title = "0080 War in the Pocket", imagePath = "covers/82.jpg", anilistId = Just 82 }
    , Show { id = "F91", title = "F91", imagePath = "covers/88.jpg", anilistId = Just 88 }
    , Show { id = "0083", title = "0083 Stardust Memory", imagePath = "covers/84.jpg", anilistId = Just 84 }
    , Show { id = "V", title = "Victory Gundam", imagePath = "covers/89.jpg", anilistId = Just 89 }
    , Show { id = "G", title = "G Gundam", imagePath = "covers/96.jpg", anilistId = Just 96 }
    , Show { id = "Wing", title = "Gundam Wing", imagePath = "covers/90.jpg", anilistId = Just 90 }
    , Show { id = "08th", title = "08th MS Team", imagePath = "covers/81.jpg", anilistId = Just 81 }
    , Show { id = "X", title = "After War Gundam X", imagePath = "covers/92.jpg", anilistId = Just 92 }
    , Show { id = "EW", title = "Wing Endless Waltz", imagePath = "covers/91.jpg", anilistId = Just 91 }
    , Show { id = "TurnA", title = "Turn A Gundam", imagePath = "covers/95.jpg", anilistId = Just 95 }
    , Show { id = "GSaviour", title = "G-Saviour", imagePath = "covers/GSaviour.jpg", anilistId = Nothing }
    , Show { id = "SEED", title = "SEED", imagePath = "covers/93.jpg", anilistId = Just 93 }
    , Show { id = "SDGF", title = "SD Gundam Force", imagePath = "covers/2391.jpg", anilistId = Just 2391 }
    , Show { id = "SEED:Destiny", title = "SEED Destiny", imagePath = "covers/94.jpg", anilistId = Just 94 }
    , Show { id = "SEED:Supernova", title = "Seed Supernova", imagePath = "covers/2743.jpg", anilistId = Just 2743 }
    , Show { id = "IGLOO", title = "MS IGLOO", imagePath = "covers/1917.jpg", anilistId = Just 1917 }
    , Show { id = "IGLOO2", title = "MS IGLOO 2", imagePath = "covers/4232.jpg", anilistId = Just 4232 }
    , Show { id = "Neo0087", title = "Gundam Neo Experience 0087: Green Divers", imagePath = "covers/8839.jpg", anilistId = Just 8839 }
    , Group
        { id = "Z:ANT"
        , title = "Mobile Suit Zeta Gundam: A New Translation"
        , imagePath = "covers/1967.jpg"
        , anilistId = Just 1967
        , contains =
            [ Show { id = "Z:ANT1", title = "Mobile Suit Zeta Gundam: A New Translation I - Heir to the Stars", imagePath = "covers/1967.jpg", anilistId = Just 1967 }
            , Show { id = "Z:ANT2", title = "Mobile Suit Zeta Gundam: A New Translation II - Lovers", imagePath = "covers/1968.jpg", anilistId = Just 1968 }
            , Show { id = "Z:ANT3", title = "Mobile Suit Zeta Gundam: A New Translation III - Love Is the Pulse of the Stars", imagePath = "covers/1969.jpg", anilistId = Just 1969 }
            ]
        }
    , Show { id = "M2R", title = "Gundam: Mission To The Rise", imagePath = "covers/4540.jpg", anilistId = Just 4540 }
    , Show { id = "EVOLVE", title = "Gundam EVOLVE", imagePath = "covers/3288.jpg", anilistId = Just 3288 }
    , Show { id = "Ring", title = "Ring of Gundam", imagePath = "covers/7060.jpg", anilistId = Just 7060 }
    , Show { id = "SEED:Astray", title = "Mobile Suit Gundam Seed MSV Astray", imagePath = "covers/864.jpg", anilistId = Just 864 }
    , Show { id = "SEED:Stargazer", title = "Mobile Suit Gundam Seed C.E.73: Stargazer", imagePath = "covers/1215.jpg", anilistId = Just 1215 }
    , Show { id = "00", title = "Mobile Suit Gundam 00", imagePath = "covers/2581.jpg", anilistId = Just 2581 }
    , Show { id = "00:WT", title = "Mobile Suit Gundam 00 The Movie: A Wakening of the Trailblazer", imagePath = "covers/6288.jpg", anilistId = Just 6288 }
    , Show { id = "UC", title = "Mobile Suit Gundam Unicorn", imagePath = "covers/6336.jpg", anilistId = Just 6336 }
    , Show { id = "GBBG", title = "Mobile Suit Gunpla Builders Beginning G", imagePath = "covers/9040.jpg", anilistId = Just 9040 }
    , Show { id = "SDBBW", title = "SD Gundam Sangokuden Brave Battle Warriors", imagePath = "covers/8287.jpg", anilistId = Just 8287 }
    , Show { id = "AGE", title = "Mobile Suit Gundam AGE", imagePath = "covers/10808.jpg", anilistId = Just 10808 }
    , Show { id = "AGE:ME", title = "Mobile Suit Gundam AGE: Memory of Eden", imagePath = "covers/17655.jpg", anilistId = Just 17655 }
    , Show { id = "BF", title = "Gundam Build Fighters", imagePath = "covers/19319.jpg", anilistId = Just 19319 }
    , Show { id = "Gundamsan", title = "Mobile Suit Gundam-san", imagePath = "covers/20756.jpg", anilistId = Just 20756 }
    , Show { id = "GReco", title = "Gundam Reconguista in G", imagePath = "covers/20658.jpg", anilistId = Just 20658 }
    , Show { id = "BFTry", title = "Gundam Build Fighters Try", imagePath = "covers/20739.jpg", anilistId = Just 20739 }
    , Show { id = "Origin", title = "Mobile Suit Gundam: The Origin", imagePath = "covers/10937.jpg", anilistId = Just 10937 }
    , Show { id = "IBO", title = "Mobile Suit Gundam: Iron-Blooded Orphans", imagePath = "covers/21268.jpg", anilistId = Just 21268 }
    , Show { id = "Thunderbolt", title = "Mobile Suit Gundam: Thunderbolt", imagePath = "covers/21458.jpg", anilistId = Just 21458 }
    , Show { id = "BFTryIW", title = "Gundam Build Fighters Try Island Wars", imagePath = "covers/21814.jpg", anilistId = Just 21814 }
    , Show { id = "TwilightAXIS", title = "Mobile Suit Gundam: Twilight AXIS", imagePath = "covers/98504.jpg", anilistId = Just 98504 }
    , Show { id = "BF:Battlogue", title = "Gundam Build Fighters Battlogue", imagePath = "covers/99731.jpg", anilistId = Just 99731 }
    , Show { id = "BF:GMCounterattack", title = "Gundam Build Fighters GM'S Counterattack", imagePath = "covers/99732.jpg", anilistId = Just 99732 }
    , Show { id = "BD", title = "Gundam Build Divers", imagePath = "covers/101036.jpg", anilistId = Just 101036 }
    , Show { id = "Narrative", title = "Mobile Suit Gundam Narrative", imagePath = "covers/101554.jpg", anilistId = Just 101554 }
    , Show { id = "SDWSangoku", title = "SD Gundam World Sangoku Soketsuden", imagePath = "covers/108041.jpg", anilistId = Just 108041 }
    , Show { id = "LightLife", title = "Mobile Suit Gundam Light of Life Chronicle U.C.", imagePath = "covers/113138.jpg", anilistId = Just 113138 }
    , Show { id = "BDRR", title = "Gundam Build Divers Re:Rise", imagePath = "covers/110786.jpg", anilistId = Just 110786 }
    , Group
        { id = "GRecoMovies"
        , title = "Gundam Reconguista in G Movies"
        , imagePath = "covers/105596.jpg"
        , anilistId = Just 105596
        , contains =
            [ Show { id = "GReco1", title = "Reconguista in G the Movie I Go! Core Fighter", imagePath = "covers/105596.jpg", anilistId = Just 105596 }
            , Show { id = "GReco2", title = "Reconguista in G the Movie II Bellri’s Fierce Charge", imagePath = "covers/114334.jpg", anilistId = Just 114334 }
            , Show { id = "GReco3", title = "Reconguista in G the Movie III Legacy from Space", imagePath = "covers/132324.jpg", anilistId = Just 132324 }
            , Show { id = "GReco4", title = "Reconguista in G the Movie IV Shouting Love Into a Fierce Fight", imagePath = "covers/146631.jpg", anilistId = Just 146631 }
            , Show { id = "GReco5", title = "Reconguista in G the Movie V Crossing the Line Between Life and Death ", imagePath = "covers/146632.jpg", anilistId = Just 146632 }
            ]
        }
    , Show { id = "BuildReal", title = "Gundam Build Real", imagePath = "covers/buildreal.jpg", anilistId = Nothing }
    , Show { id = "SDWHeroes", title = "SD Gundam World Heroes", imagePath = "covers/126664.jpg", anilistId = Just 126664 }
    , Show { id = "Hathaway", title = "Mobile Suit Gundam Hathaway", imagePath = "covers/105595.jpg", anilistId = Just 105595 }
    , Show { id = "BreakerBattlogue", title = "Gundam Breaker Battlogue", imagePath = "covers/135645.jpg", anilistId = Just 135645 }
    , Show { id = "Doan", title = "Mobile Suit Gundam Cucuruz Doan's Island", imagePath = "covers/139273.jpg", anilistId = Just 139273 }
    , Show { id = "WfM", title = "Witch from Mercury", imagePath = "covers/139274.jpg", anilistId = Just 139274 }
    , Show { id = "Meta", title = "Gundam Build Metaverse", imagePath = "covers/163204.jpg", anilistId = Just 163204 }
    , Show { id = "SFreedom", title = "Mobile Suit Gundam SEED Freedom", imagePath = "covers/134761.jpg", anilistId = Just 134761 }
    , Show { id = "SilverPhantom", title = "Mobile Suit Gundam: Silver Phantom", imagePath = "covers/silverphantom.jpg", anilistId = Nothing }
    , Show { id = "RfV", title = "Mobile Suit Gundam: Requiem for Vengeance", imagePath = "covers/166703.jpg", anilistId = Just 166703 }
    , Show { id = "GQX", title = "GQuuuuuuX", imagePath = "covers/185213.jpg", anilistId = Just 185213 }

    -- , Show { id = "IBO:UH", title = "Mobile Suit Gundam: Iron-Blooded Orphans Urdr Hunt -Path of the Little Challenger-", imagePath = "covers/114842.jpg", anilistId = Just 114842 }
    ]


gundamDict : Dict VID Value
gundamDict =
    let
        d =
            List.map (\v -> ( getId v, v )) gundam
                |> Dict.fromList
    in
    if List.length gundam /= Dict.size d then
        Debug.todo "need unique IDs"

    else
        d


groups : Dict VID GroupMeta
groups =
    let
        justGroups : Value -> Maybe GroupMeta
        justGroups value =
            case value of
                Show _ ->
                    Nothing

                Group g ->
                    Just g
    in
    gundam
        |> List.filterMap justGroups
        |> List.map (\g -> ( g.id, g ))
        |> Dict.fromList


groupsByShow : Dict VID VID
groupsByShow =
    let
        f : GroupMeta -> List ( VID, VID )
        f g =
            List.map (\v -> ( getId v, g.id )) g.contains
    in
    Dict.values groups
        |> List.concatMap f
        |> Dict.fromList


getValueFromGroup : VID -> GroupMeta -> Maybe Value
getValueFromGroup id { contains } =
    List.filter (\value -> getId value == id) contains
        |> List.head


getValue : String -> Maybe Value
getValue id =
    case Dict.get id gundamDict of
        Nothing ->
            case Dict.get id groupsByShow |> Maybe.andThen getValue of
                Just (Group g) ->
                    getValueFromGroup id g

                _ ->
                    Nothing

        Just v ->
            Just v


getShowIds : Value -> List VID
getShowIds value =
    case value of
        Show { id } ->
            [ id ]

        Group { contains } ->
            List.concatMap getShowIds contains


allShows =
    Set.fromList <|
        List.concatMap getShowIds gundam


evanWatched =
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
        , "M2R"
        , "EVOLVE"
        , "Ring"
        , "SEED:Astray"
        , "SEED:Stargazer"
        , "WfM"
        , "GQX"
        ]


ggpWatched =
    Set.fromList
        [ "0079"
        , "0079Movies" -- , "MSG1" , "MSG2" , "MSG3"
        , "Z"
        , "ZZ"
        , "CCA"
        , "earlySD" -- , "SDMK1" , "SDMK2" , "SDMK3" , "SDMK4" , "SDMK5" , "SDCounterattack" , "SDGaiden" , "SDMatsuri" , "SDScramble" , "SDHyakka"
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
        , "Z:ANT" -- , "Z:ANT1" , "Z:ANT2" , "Z:ANT3"
        , "M2R"
        , "EVOLVE"
        , "Ring"
        , "SEED:Astray"
        , "SEED:Stargazer"
        , "00"
        , "00:WT"
        , "UC"
        , "GBBG"
        , "SDBBW"
        , "AGE"
        , "AGE:ME"
        , "BF"
        ]
