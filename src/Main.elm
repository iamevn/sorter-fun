-- TODO: progress counter
-- TODO: make into a Browser.application
-- TODO: arrow-key input
-- TODO: seed randomness either from url param or something else
-- TODO: saving sorting state to url fragment


module Main exposing (main)

import Browser
import Choice exposing (Choice)
import Comparison exposing (Comparison)
import Html exposing (Html, br, button, details, div, h1, li, node, ol, summary, text)
import Html.Attributes exposing (class, href, id, rel)
import Html.Events exposing (onClick)
import Random
import Random.List exposing (shuffle)
import Tournament exposing (Tournament)
import Value exposing (Value)


main : Program () Model Msg
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
    , Random.generate NewList <| shuffle Value.demoValues
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( model
            , Random.generate NewList
                (Random.List.shuffle Value.demoValues)
            )

        NewList values ->
            ( step <|
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
                            --maybe should error here?
                            ( model, Cmd.none )

                        cmp :: cmps ->
                            ( step <|
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
    let
        styleLink =
            node "link"
                [ href "sorter.css"
                , rel "stylesheet"
                ]
                []
    in
    case model of
        Init ->
            div []
                [ styleLink
                , text "building list..."
                ]

        Sorting state ->
            div [ id "sort-root" ]
                [ styleLink
                , case state.toCompare of
                    [] ->
                        div [ id "sort-container-empty" ] []

                    cmp :: _ ->
                        div [ id "sort-container" ]
                            [ button
                                [ onClick (Pick Choice.Left)
                                , id "sort-left"
                                , class "sort-option"
                                ]
                                [ Value.view cmp.left ]
                            , button
                                [ onClick (Pick Choice.Right)
                                , id "sort-right"
                                , class "sort-option"
                                ]
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
            div [ id "sorted-root" ]
                [ styleLink
                , h1 [] [ text "Results" ]
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


step : Model -> Model
step model =
    case model of
        Sorting sortingState ->
            let
                ( results, toCompare, tournament ) =
                    Tournament.step sortingState.results sortingState.tournament
            in
            case toCompare of
                [] ->
                    Sorted { ranked = List.reverse results, tournament = tournament }

                _ ->
                    Sorting { results = results, toCompare = toCompare, tournament = tournament }

        _ ->
            model
