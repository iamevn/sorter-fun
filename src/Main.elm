module Main exposing (main)

import Browser
import Choice exposing (Choice)
import Comparison exposing (Comparison)
import Html exposing (Html, br, button, details, div, h1, li, ol, summary, text)
import Html.Events exposing (onClick)
import Random
import Random.List
import Tournament exposing (Tournament)
import Value exposing (Value)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Model
    = Init
    | Sorting
        { results : List Value
        , toCompare : List Comparison
        , tournament : Tournament
        }
    | Sorted { ranked : List Value, tournament : Tournament }


type Msg
    = NewList (List Value)
    | Pick Choice
    | Reset


init : () -> ( Model, Cmd Msg )
init _ =
    ( Init
    , Random.generate NewList
        (Random.List.shuffle Value.demoValues)
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( Init
            , Random.generate NewList
                (Random.List.shuffle Value.demoValues)
            )

        NewList values ->
            ( stepTournament <|
                Sorting
                    { results = []
                    , toCompare = []
                    , tournament = Tournament.makeTournament values
                    }
            , Cmd.none
            )

        Pick choice ->
            case model of
                Sorting state ->
                    case state.toCompare of
                        [] ->
                            --TODO: maybe error here?
                            ( model, Cmd.none )

                        cmp :: cmps ->
                            ( stepTournament <|
                                Sorting
                                    { state
                                        | tournament = Tournament.promote cmp choice state.tournament
                                        , toCompare = cmps
                                    }
                            , Cmd.none
                            )

                _ ->
                    ( model, Cmd.none )


resetButton : Html Msg
resetButton =
    button [ onClick Reset ] [ text "Start Over" ]


view : Model -> Html Msg
view model =
    case model of
        Init ->
            div []
                [ text "building list..."
                ]

        Sorting state ->
            div []
                [ h1 [] [ text "sorting" ]
                , case state.toCompare of
                    [] ->
                        div [] []

                    cmp :: _ ->
                        div []
                            [ button [ onClick (Pick Choice.Left) ]
                                [ Value.view cmp.left ]
                            , button [ onClick (Pick Choice.Right) ]
                                [ Value.view cmp.right ]
                            ]
                , br [] []
                , resetButton
                , details
                    []
                    [ summary [] [ text "debug" ]
                    , div []
                        [ text "Results: "
                        , ol []
                            (List.map
                                (\value -> li [] [ Value.view value ])
                                (List.reverse state.results)
                            )
                        ]
                    , div []
                        [ text "To compare:"
                        , br [] []
                        , List.map Comparison.toString state.toCompare |> String.join ", " |> text
                        ]
                    , Tournament.view state.tournament
                    ]
                ]

        Sorted results ->
            div []
                [ h1 [] [ text "sorted" ]
                , ol []
                    (List.map
                        (\value -> li [] [ Value.view value ])
                        results.ranked
                    )
                , if results.tournament /= Tournament.Leaf Nothing then
                    details []
                        [ summary [] [ text "debug" ]
                        , Tournament.view results.tournament
                        ]

                  else
                    div [] []
                , resetButton
                ]


stepTournament : Model -> Model
stepTournament model =
    case model of
        Sorting sortingState ->
            let
                ( newResults, newTournament ) =
                    Tournament.prune sortingState.results sortingState.tournament
            in
            case Tournament.findMatches newTournament of
                [] ->
                    Sorted { ranked = List.reverse newResults, tournament = newTournament }

                toCompare ->
                    Sorting
                        { results = newResults
                        , toCompare = toCompare
                        , tournament = newTournament
                        }

        _ ->
            model
