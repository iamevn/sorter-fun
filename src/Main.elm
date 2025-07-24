module Main exposing (..)

import Browser
import Choice exposing (Choice)
import Comparison exposing (Comparison)
import Html exposing (Html, br, button, div, h1, text)
import Html.Events exposing (onClick)
import Random
import Random.List
import Tournament exposing (Tournament)
import Value exposing (Value)


main =
    Browser.sandbox { init = init, update = update, view = view }


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
                    Sorted (List.reverse newResults) newTournament

                toCompare ->
                    Sorting
                        { results = newResults
                        , toCompare = toCompare
                        , tournament = newTournament
                        }

        _ ->
            model


type alias SortingState =
    { results : List Value
    , toCompare : List Comparison
    , tournament : Tournament
    }


type Model
    = Sorting SortingState
    | Sorted (List Value) Tournament


init : Model
init =
    let
        -- TODO: shuffle
        values =
            [ "apple", "banana", "orange", "grape", "pear", "peach", "pineapple", "strawberry" ]

        tournament =
            Tournament.makeTournament values

        initialSorting =
            Sorting { results = [], toCompare = [], tournament = tournament }
    in
    stepTournament initialSorting


type
    Msg
    -- | NewList (List Value)
    = Pick Choice


update : Msg -> Model -> Model
update msg model =
    case msg of
        Pick choice ->
            case model of
                Sorting state ->
                    case state.toCompare of
                        [] ->
                            --TODO: maybe error here?
                            model

                        cmp :: cmps ->
                            Sorting
                                { state
                                    | tournament = Tournament.promote cmp choice state.tournament
                                    , toCompare = cmps
                                }
                                |> stepTournament

                _ ->
                    model


view : Model -> Html Msg
view model =
    case model of
        Sorting state ->
            div []
                [ h1 [] [ text "sorting" ]
                , case state.toCompare of
                    [] ->
                        div [] []

                    cmp :: _ ->
                        div []
                            [ button [ onClick (Pick Choice.Left) ]
                                [ text <| Value.toString cmp.left ]
                            , button [ onClick (Pick Choice.Right) ]
                                [ text <| Value.toString cmp.right ]
                            ]
                , div []
                    [ text "Results: "
                    , List.map Value.toString state.results |> String.join ", " |> text
                    ]
                , div []
                    [ text "To compare:"
                    , br [] []
                    , List.map Comparison.toString state.toCompare |> String.join ", " |> text
                    ]
                , Tournament.view state.tournament
                ]

        Sorted results tournament ->
            div []
                [ h1 [] [ text "sorted" ]
                , List.map Value.toString results |> String.join ", " |> text
                , if tournament /= Tournament.Leaf Nothing then
                    Tournament.view tournament

                  else
                    div [] []
                ]
