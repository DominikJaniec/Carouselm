module State.Parser exposing (..)

import State exposing (Interval, Data)


type alias Range =
    { start : Float
    , limit : Float
    }


type ValidationError
    = Required
    | ToLong Int
    | InvalidFormat String
    | OutOfRange Range


type Field
    = Title
    | Interval
    | Pages


type alias StateErrors =
    ( Field, ValidationError )


type alias InputState =
    { title : String
    , interval : String
    , pages : String
    }


parse : InputState -> Result (List StateErrors) State.Data
parse inputState =
    parseState
        inputState.title
        inputState.interval
        inputState.pages


parseState : String -> String -> String -> Result (List StateErrors) State.Data
parseState title interval pages =
    let
        setFromHandler parser field setter =
            \input ( errors, state ) ->
                case parser input of
                    Ok parsed ->
                        ( errors, (setter state parsed) )

                    Err error ->
                        ( ( field, error ) :: errors, state )

        titleHandler =
            (\st val -> { st | title = val })
                |> setFromHandler parseTitle Title

        intervalHandler =
            (\st val -> { st | interval = val })
                |> setFromHandler parseInterval Interval

        pagesHandler =
            (\st val -> { st | pages = val })
                |> setFromHandler parsePages Pages

        folder ( handler, input ) result =
            handler input result
    in
        case
            List.foldl folder ( [], State.initialData ) <|
                [ ( titleHandler, title )
                , ( intervalHandler, interval )
                , ( pagesHandler, pages )
                ]
        of
            ( [], parsed ) ->
                Ok parsed

            ( errors, _ ) ->
                Err errors


parseTitle : String -> Result ValidationError String
parseTitle input =
    case String.trim input of
        "" ->
            Err Required

        title ->
            case
                String.length title > titleMaxLength
            of
                True ->
                    Err (ToLong titleMaxLength)

                False ->
                    Ok title


parseInterval : String -> Result ValidationError State.Interval
parseInterval input =
    case String.trim input of
        "" ->
            Err Required

        value ->
            let
                tryDropUnit unit str =
                    case
                        String.toLower str
                            |> String.endsWith unit
                    of
                        True ->
                            String.dropRight (String.length unit) str
                                |> String.trim
                                |> Just

                        False ->
                            Nothing

                parseFromSeconds =
                    case tryDropUnit "sec" value of
                        Just sec ->
                            ( True, sec )

                        Nothing ->
                            case tryDropUnit "s" value of
                                Just s ->
                                    ( True, s )

                                Nothing ->
                                    ( False, value )
            in
                case parseFromSeconds of
                    ( True, sec ) ->
                        String.toFloat sec
                            |> Result.mapError InvalidFormat
                            |> Result.andThen (validateRange intervalRange)
                            |> Result.map State.IntervalSec

                    ( False, ms ) ->
                        String.toInt ms
                            |> Result.mapError InvalidFormat
                            |> Result.andThen (validateRangeInt intervalRangeMs)
                            |> Result.map State.IntervalMs


parsePages : String -> Result ValidationError (List String)
parsePages input =
    let
        notEmptyLine line =
            not <| String.isEmpty line

        trimmedLines =
            String.split "\n" input
                |> List.map String.trim
                |> List.filter notEmptyLine
    in
        case trimmedLines of
            [] ->
                Err Required

            lines ->
                Ok lines


titleMaxLength : Int
titleMaxLength =
    50


intervalRangeMs : Range
intervalRangeMs =
    { start = 20
    , limit = 365 * 24 * 60 * 60 * 1000
    }


intervalRange : Range
intervalRange =
    { start = intervalRangeMs.start / 1000
    , limit = intervalRangeMs.limit / 1000
    }


validateRange : Range -> Float -> Result ValidationError Float
validateRange range value =
    case
        (range.start <= value)
            && (value < range.limit)
    of
        True ->
            Ok value

        False ->
            Err <| OutOfRange range


validateRangeInt : Range -> Int -> Result ValidationError Int
validateRangeInt range value =
    toFloat value
        |> validateRange range
        |> Result.map (\_ -> value)
