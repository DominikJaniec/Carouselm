module State exposing (..)


type Interval
    = IntervalMs Int
    | IntervalSec Float


type Mode
    = ModeInit
    | ModeEdit
    | ModeShow


type alias Data =
    { title : String
    , interval : Interval
    , pages : List String
    }


type alias App =
    ( Mode, Maybe Data )


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
    ( ModeEdit, Just initialData )


asMillisecond : Interval -> Int
asMillisecond interval =
    case interval of
        IntervalMs val ->
            val

        IntervalSec val ->
            1000.0 * val |> floor


fix : App -> App
fix app =
    case app of
        ( mode, Nothing ) ->
            initialApp
                |> Debug.log ("Changed `" ++ toString mode ++ "` without any data to the initial app state")

        ( ModeInit, data ) ->
            ( ModeShow, data )

        appState ->
            appState


showApp : Data -> App
showApp data =
    ( ModeShow, Just data )
