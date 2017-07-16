module State exposing (..)

import Debug
import Maybe


type Interval
    = IntervalMs Int
    | IntervalSec Int


type Side
    = ModeInit
    | ModeEdit
    | ModeShow


type alias Data =
    { title : String
    , interval : Interval
    , pages : List String
    }


type alias App =
    ( Side, Maybe Data )


initialData : Data
initialData =
    let
        defaultTitle =
            "Sample show's title..."

        defaultInterval =
            IntervalMs 7654

        defaultPages =
            [ "http://elm-lang.org/"
            , "https://guide.elm-lang.org/"
            , "https://github.com/DominikJaniec/Carouselm"
            ]
    in
        Data defaultTitle defaultInterval defaultPages


initialApp : App
initialApp =
    ( ModeInit, Nothing )


initialEditApp : App
initialEditApp =
    ( ModeEdit, Just initialData )


asMillisecond : Interval -> Int
asMillisecond interval =
    case interval of
        IntervalMs val ->
            val

        IntervalSec val ->
            1000 * val


fix : App -> App
fix app =
    case app of
        ( mode, Nothing ) ->
            initialEditApp
                |> Debug.log ("Fixed `" ++ toString mode ++ "` without data to the .")

        ( ModeInit, data ) ->
            initialApp
                |> Debug.log ("Moving `" ++ toString ModeInit ++ "` with data: " ++ toString data)
                |> fix

        appState ->
            appState
