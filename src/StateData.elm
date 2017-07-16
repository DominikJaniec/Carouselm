module StateData exposing (..)


type Interval
    = IntervalSec Int


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
            IntervalSec 7

        defaultPages =
            [ "http://elm-lang.org/"
            , "https://guide.elm-lang.org/"
            , "https://github.com/DominikJaniec/Carouselm"
            ]
    in
        StateData defaultTitle defaultInterval defaultPages
