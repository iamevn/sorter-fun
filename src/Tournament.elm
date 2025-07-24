module Tournament exposing (..)

import BinaryTreeDiagram exposing (BinaryTree)
import Choice exposing (Choice)
import Comparison exposing (Comparison)
import Html exposing (Html)
import Value exposing (Value)


type Tournament
    = Leaf (Maybe Value)
    | Node
        { left : Tournament
        , right : Tournament
        , value : Maybe Value
        }


getValue : Tournament -> Maybe Value
getValue tournament =
    case tournament of
        Leaf value ->
            value

        Node node ->
            node.value


hasValue : Tournament -> Bool
hasValue tournament =
    case getValue tournament of
        Nothing ->
            False

        Just _ ->
            True


makeTournament : List Value -> Tournament
makeTournament values =
    case values of
        [] ->
            Leaf Nothing

        [ v ] ->
            Leaf (Just v)

        [ a, b ] ->
            Node
                { left = Leaf (Just a)
                , right = Leaf (Just b)
                , value = Nothing
                }

        a :: b :: rest ->
            Node
                { left = makeTournament [ a, b ]
                , right = makeTournament rest
                , value = Nothing
                }


prune : List Value -> Tournament -> ( List Value, Tournament )
prune results tournament =
    -- clean up tournament tree (pulling out any results)
    let
        -- if root has result pull it out and add it to input results
        newResult : Maybe Value
        newResult =
            getValue tournament

        mergedResults =
            case newResult of
                Just value ->
                    value :: results

                Nothing ->
                    results

        -- if pulled root, walk back down tree removing pulled value from nodes it is on
        rootedTournament =
            case newResult of
                Nothing ->
                    tournament

                Just remove ->
                    let
                        loop tree =
                            case tree of
                                Leaf Nothing ->
                                    Leaf Nothing

                                Leaf (Just val) ->
                                    if val == remove then
                                        Leaf Nothing

                                    else
                                        tree

                                Node node ->
                                    if node.value == Just remove then
                                        Node { value = Nothing, left = loop node.left, right = loop node.right }

                                    else
                                        tree
                    in
                    loop tournament

        -- remove empty leaves
        -- childless nodes: make leaf if has value, remove if not
        -- single-child nodes: replace with child
        trimmedTournament =
            let
                loop tree =
                    case tree of
                        Leaf _ ->
                            tree

                        Node node ->
                            case ( node.left, node.right ) of
                                ( Leaf Nothing, _ ) ->
                                    node.right

                                ( _, Leaf Nothing ) ->
                                    node.left

                                ( _, _ ) ->
                                    Node { node | left = loop node.left, right = loop node.right }
            in
            loop rootedTournament

        ( loopedResults, loopedTournament ) =
            if hasValue trimmedTournament then
                prune mergedResults trimmedTournament

            else
                ( mergedResults, trimmedTournament )
    in
    ( loopedResults, loopedTournament )


findMatches : Tournament -> List Comparison
findMatches tournament =
    -- walk tree until find empty node with non-empty children to compare (leafs or nodes with values)
    case tournament of
        Leaf _ ->
            []

        Node node ->
            case node.value of
                Just _ ->
                    []

                Nothing ->
                    case ( node.left, node.right ) of
                        ( Leaf (Just l), Leaf (Just r) ) ->
                            [ { left = l, right = r } ]

                        ( Leaf _, Leaf _ ) ->
                            []

                        ( Node leftNode, Node rightNode ) ->
                            case ( leftNode.value, rightNode.value ) of
                                ( Just l, Just r ) ->
                                    [ { left = l, right = r } ]

                                ( Nothing, Nothing ) ->
                                    List.concat [ findMatches node.left, findMatches node.right ]

                                ( Just l, Nothing ) ->
                                    findMatches node.right

                                ( Nothing, Just r ) ->
                                    findMatches node.left

                        ( Node _, Leaf Nothing ) ->
                            findMatches node.left

                        ( Leaf Nothing, Node _ ) ->
                            findMatches node.right

                        ( Node leftNode, Leaf (Just r) ) ->
                            case leftNode.value of
                                Just l ->
                                    [ { left = l, right = r } ]

                                Nothing ->
                                    findMatches node.left

                        ( Leaf (Just l), Node rightNode ) ->
                            case rightNode.value of
                                Just r ->
                                    [ { left = l, right = r } ]

                                Nothing ->
                                    findMatches node.right


promote : Comparison -> Choice -> Tournament -> Tournament
promote cmp choice tournament =
    let
        walk : Tournament -> Tournament
        walk tree =
            case tree of
                Leaf _ ->
                    tree

                Node node ->
                    case ( node.left, node.right ) of
                        ( Leaf (Just l), Leaf (Just r) ) ->
                            if l == cmp.left && r == cmp.right then
                                case choice of
                                    Choice.Left ->
                                        Node { node | value = Just l }

                                    Choice.Right ->
                                        Node { node | value = Just r }

                            else
                                tree

                        ( Leaf _, Leaf _ ) ->
                            tree

                        ( Node leftNode, Node rightNode ) ->
                            if leftNode.value == Just cmp.left && rightNode.value == Just cmp.right then
                                case choice of
                                    Choice.Left ->
                                        Node { node | value = Just cmp.left }

                                    Choice.Right ->
                                        Node { node | value = Just cmp.right }

                            else
                                Node { node | left = walk node.left, right = walk node.right }

                        ( Node _, Leaf Nothing ) ->
                            Node { node | left = walk node.left }

                        ( Leaf Nothing, Node _ ) ->
                            Node { node | right = walk node.right }

                        ( Node leftNode, Leaf (Just r) ) ->
                            if leftNode.value == Just cmp.left && r == cmp.right then
                                case choice of
                                    Choice.Left ->
                                        Node { node | value = Just cmp.left }

                                    Choice.Right ->
                                        Node { node | value = Just cmp.right }

                            else
                                Node { node | left = walk node.left }

                        ( Leaf (Just l), Node rightNode ) ->
                            if l == cmp.left && rightNode.value == Just cmp.right then
                                case choice of
                                    Choice.Left ->
                                        Node { node | value = Just cmp.left }

                                    Choice.Right ->
                                        Node { node | value = Just cmp.right }

                            else
                                Node { node | right = walk node.right }
    in
    walk tournament


toBinaryTree : Tournament -> BinaryTree (Maybe Value)
toBinaryTree tournament =
    case tournament of
        Leaf l ->
            BinaryTreeDiagram.Node
                l
                BinaryTreeDiagram.Empty
                BinaryTreeDiagram.Empty

        Node n ->
            BinaryTreeDiagram.Node
                n.value
                (toBinaryTree n.left)
                (toBinaryTree n.right)


view : Tournament -> Html msg
view tournament =
    let
        tree =
            toBinaryTree tournament

        getColor : Maybe Value -> String
        getColor val =
            case val of
                Nothing ->
                    "black"

                Just _ ->
                    "grey"

        getText : Maybe Value -> String
        getText =
            Maybe.map Value.toString
                >> Maybe.withDefault ""
    in
    BinaryTreeDiagram.diagramView getColor getText tree
