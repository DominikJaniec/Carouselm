module State.Provider exposing (loadFromString)

import State


loadFromString : String -> Result String State.App
loadFromString input =
    case splitParts input of
        [] ->
            basicState

        [ modePart ] ->
            let
                buildApp mode =
                    ( mode, Nothing )
            in
                Result.map buildApp (extractMode modePart)

        otherParts ->
            Err ("Unknown parts' schema. Too many '/'." ++ toString otherParts)


basicState : Result String State.App
basicState =
    Ok ( State.ModeInit, Nothing )


splitParts : String -> List String
splitParts input =
    String.split "/" input
        |> List.map String.trim
        |> List.filter (\x -> String.isEmpty x |> not)


extractMode : String -> Result String State.Mode
extractMode from =
    case String.toLower from of
        "show" ->
            Ok State.ModeShow

        "edit" ->
            Ok State.ModeEdit

        _ ->
            Err ("Unknown mode: `" ++ from ++ "`.")
