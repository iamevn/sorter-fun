-- TODO: arrow-key input
-- TODO: seed randomness either from url param or something else
-- TODO: saving sorting state to url fragment
-- TODO: pick random comparsion when there are multiple candidates
-- TODO: pick which shows to sort


module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation exposing (Key)
import Choice exposing (Choice)
import Comparison exposing (Comparison)
import Html exposing (Html, br, button, details, div, h1, li, node, ol, span, summary, text)
import Html.Attributes exposing (class, href, id, rel)
import Html.Events exposing (onClick)
import Random exposing (generate)
import Random.List exposing (shuffle)
import Tournament exposing (Tournament)
import Url exposing (Url)
import Value exposing (Value)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }


type alias SortingState =
    { results : List Value
    , toCompare : List Comparison
    , tournament : Tournament
    , currentStep : Int
    , estimatedSteps : Int
    , originalValues : List Value
    }


type alias SortedResults =
    { ranked : List Value, tournament : Tournament, stepCount : Int }


type Model
    = Init
    | Sorting SortingState
    | Sorted SortedResults


type Msg
    = NewList (List Value)
    | Pick Choice
    | Noop
    | Reset


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ _ _ =
    -- TODO: store key and init based on url
    ( Init
    , generate NewList <| shuffle Value.demoValues
    )


onUrlRequest : UrlRequest -> Msg
onUrlRequest _ =
    Noop


onUrlChange : Url -> Msg
onUrlChange _ =
    Noop


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

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


viewInit : List (Html Msg)
viewInit =
    [ text "building list..."
    ]


viewSorting : SortingState -> List (Html Msg)
viewSorting state =
    [ case state.toCompare of
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


viewSorted : SortedResults -> List (Html Msg)
viewSorted results =
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
    [ div [ id "sorted-root" ]
        [ h1 [] [ text <| "Results after " ++ comparisonsText ]
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
    ]


view : Model -> Document Msg
view model =
    { title =
        "Gundam Sorter"
    , body =
        stylesheet "sorter.css"
            :: (case model of
                    Init ->
                        viewInit

                    Sorting state ->
                        viewSorting state

                    Sorted results ->
                        viewSorted results
               )
    }


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
