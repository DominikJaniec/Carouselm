module Transformer exposing (..)

import StateData exposing (..)


encode : StateData -> String
encode _ =
    ""


decode : String -> StateData
decode _ =
    StateData.initialState
