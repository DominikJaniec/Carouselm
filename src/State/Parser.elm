module State.Parser exposing (..)

import State exposing (Interval)


type ValidationError
    = Required
    | ToLong Int
    | InvalidFormat String


parseTitle : String -> Result ValidationError String
parseTitle input =
    case String.trim input of
        "" ->
            Err Required

        title ->
            let
                maxLenght =
                    50
            in
                if String.length title > maxLenght then
                    Err (ToLong maxLenght)
                else
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
                            |> Result.map State.IntervalSec
                            |> Result.mapError InvalidFormat

                    ( False, ms ) ->
                        String.toInt ms
                            |> Result.map State.IntervalMs
                            |> Result.mapError InvalidFormat


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
