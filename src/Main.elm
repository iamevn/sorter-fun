-- TODO: make into a Browser.application
-- TODO: arrow-key input
-- TODO: seed randomness either from url param or something else
-- TODO: saving sorting state to url fragment
-- TODO: pick random comparsion when there are multiple candidates
-- TODO: pick which shows to sort


module Main exposing (main)

import Browser
import Choice exposing (Choice)
import Comparison exposing (Comparison)
import Html exposing (Html, br, button, details, div, h1, li, node, ol, span, summary, text)
import Html.Attributes exposing (class, href, id, rel)
import Html.Events exposing (onClick)
import Random exposing (generate)
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


type alias SortingState =
    { results : List Value
    , toCompare : List Comparison
    , tournament : Tournament
    , currentStep : Int
    , estimatedSteps : Int
    , originalValues : List Value
    }


type Model
    = Init
    | Sorting SortingState
    | Sorted { ranked : List Value, tournament : Tournament, stepCount : Int }


type Msg
    = NewList (List Value)
    | Pick Choice
    | Reset


init : () -> ( Model, Cmd Msg )
init _ =
    ( Init
    , generate NewList <| shuffle Value.demoValues
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( model
            , generate NewList <| shuffle Value.demoValues
            )

        NewList values ->
            ( step <|
                Sorting
                    { results = []
                    , toCompare = []
                    , tournament = Tournament.makeTournament values
                    , currentStep = 0
                    , estimatedSteps = maxComparisonSteps <| List.length values
                    , originalValues = values
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


stylesheet : String -> Html Msg
stylesheet path =
    node "link"
        [ href path
        , rel "stylesheet"
        ]
        []


view : Model -> Html Msg
view model =
    let
        styleLink =
            stylesheet "sorter.css"
    in
    case model of
        Init ->
            div []
                [ styleLink
                , text "building list..."
                ]

        Sorting state ->
            div []
                [ styleLink
                , case state.toCompare of
                    [] ->
                        div [] []

                    cmp :: _ ->
                        div [ id "sort-root" ]
                            [ div [ id "sort-container" ]
                                [ button
                                    [ onClick (Pick Choice.Left)
                                    , id "sort-left"
                                    , class "sort-option"
                                    ]
                                    [ Value.view cmp.left ]
                                , div [ id "sort-status" ]
                                    [ span []
                                        (List.map text
                                            [ "Comparison "
                                            , String.fromInt state.currentStep
                                            , " / "
                                            , String.fromInt state.estimatedSteps
                                            ]
                                        )
                                    ]
                                , button
                                    [ onClick (Pick Choice.Right)
                                    , id "sort-right"
                                    , class "sort-option"
                                    ]
                                    [ Value.view cmp.right ]
                                ]
                            ]
                , br [] []
                , resetButton
                , details
                    []
                    [ summary [] [ text "debug" ]
                    , div [ id "sorted-root" ]
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
            let
                comparisonsText =
                    case results.stepCount of
                        0 ->
                            "no comparisons"

                        1 ->
                            "1 comparison"

                        n ->
                            String.fromInt n ++ " comparisons"
            in
            div [ id "sorted-root" ]
                [ styleLink
                , h1 [] [ text <| "Results after " ++ comparisonsText ]
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
                    Sorted { ranked = List.reverse results, tournament = tournament, stepCount = sortingState.currentStep }

                _ ->
                    Sorting <|
                        updateStepEstimate
                            { sortingState
                                | results = results
                                , toCompare = toCompare
                                , tournament = tournament
                                , currentStep = sortingState.currentStep + 1
                            }

        _ ->
            model


updateStepEstimate : SortingState -> SortingState
updateStepEstimate sortingState =
    let
        totalCount =
            List.length sortingState.originalValues

        resultCount =
            List.length sortingState.results

        prevEstimate =
            sortingState.estimatedSteps

        maxTotalSteps =
            maxComparisonSteps totalCount

        remainingCount =
            totalCount - resultCount

        maxRemainingSteps =
            maxComparisonSteps remainingCount

        newEstimate =
            min maxTotalSteps (sortingState.currentStep + maxRemainingSteps)
    in
    { sortingState
        | estimatedSteps = min newEstimate prevEstimate
    }


maxComparisonSteps : Int -> Int
maxComparisonSteps itemCount =
    if itemCount <= 1 then
        0

    else
        let
            halfCount =
                toFloat itemCount / 2

            halfLower =
                floor halfCount

            halfUpper =
                ceiling halfCount
        in
        List.sum
            [ maxComparisonSteps halfLower
            , maxComparisonSteps halfUpper
            , itemCount - 1
            ]
