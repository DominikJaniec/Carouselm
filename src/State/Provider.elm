module State.Provider exposing (loadFromString, storeInString)

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
                Transformer.decode dataPart
                    |> Result.map2 buildApp (extractMode modePart)

        otherParts ->
            Err ("Unknown parts' schema. Too many '/'.")


storeInString : State.App -> Result String String
storeInString app =
    let
        mode =
            Tuple.first app

        data =
            Tuple.second app
    in
        case ( mode, data ) of
            ( State.ModeInit, Nothing ) ->
                Ok ""

            ( State.ModeInit, Just _ ) ->
                Err "The `ModeInit` could not be with any data."

            _ ->
                let
                    encodedData =
                        data
                            |> Maybe.map Transformer.encode
                            |> Maybe.withDefault ""

                    makeResult mode =
                        Ok <| mode ++ "/" ++ encodedData
                in
                    translateMode mode
                        |> Result.andThen makeResult


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


translateMode : State.Mode -> Result String String
translateMode mode =
    case mode of
        State.ModeShow ->
            Ok "show"

        State.ModeEdit ->
            Ok "edit"

        _ ->
            Err ""
