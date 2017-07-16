module StateData exposing (..)


type Interval
    = IntervalMs Int
    | IntervalSec Int


type alias StateData =
    { title : String
    , interval : Interval
    , pages : List String
    }


initialState : StateData
initialState =
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
        StateData defaultTitle defaultInterval defaultPages


asMillisecond : Interval -> Int
asMillisecond interval =
    case interval of
        IntervalMs val ->
            val

        IntervalSec val ->
            1000 * val
