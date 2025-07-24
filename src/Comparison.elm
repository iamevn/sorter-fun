module Comparison exposing (..)

import Value exposing (Value)


type alias Comparison =
    { left : Value, right : Value }


makeComparison : Value -> Value -> Comparison
makeComparison left right =
    { left = left, right = right }


toString : Comparison -> String
toString cmp =
    "(" ++ Value.toString cmp.left ++ ", " ++ Value.toString cmp.right ++ ")"
