module State.Provider exposing (loadFromString)

import State
import State.Transformer as Transformer


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

        [ modePart, dataPart ] ->
            let
                buildApp mode data =
                    ( mode, Just data )
            in
                Result.map2 buildApp (extractMode modePart) (extractData dataPart)

        otherParts ->
            Err ("Unknown parts' schema. Too many '/'.")


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


extractData : String -> Result String State.Data
extractData =
    Transformer.decode
