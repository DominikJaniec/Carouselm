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
