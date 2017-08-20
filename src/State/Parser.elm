module State.Parser exposing (..)

import State exposing (Interval)


type alias Range =
    { start : Float
    , limit : Float
    }


type ValidationError
    = Required
    | ToLong Int
    | InvalidFormat String
    | OutOfRange Range


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
