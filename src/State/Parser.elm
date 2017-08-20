module State.Parser exposing (..)


type ValidationError
    = Required
    | ToLong Int


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
