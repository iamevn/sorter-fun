module Comparison exposing (Comparison, toString)

import Value exposing (Value)


type alias Comparison =
    { left : Value
    , right : Value
    }


toString : Comparison -> String
toString cmp =
    "(" ++ Value.toString cmp.left ++ ", " ++ Value.toString cmp.right ++ ")"
