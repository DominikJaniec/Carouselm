module Navigator
    exposing
        ( Context
        , ExtractError(..)
        , extractState
        , getContext
        , makeShareableUrl
        )

import Navigation
import State
import State.Provider as Provider


type alias Context =
    { baseUrl : String
    }


type ExtractError
    = UnknownLocation
    | ProviderError String


extractState : Context -> Navigation.Location -> Result ExtractError State.App
extractState ctx location =
    let
        extract maybeFragment =
            case maybeFragment of
                Nothing ->
                    Ok State.initialApp

                Just fragment ->
                    Provider.loadFromString fragment
                        |> Result.mapError ProviderError
    in
        extractHashFragment ctx location
            |> Result.andThen extract
            |> Result.map State.fix


getContext : Navigation.Location -> Context
getContext location =
    dropHashFragment location
        |> dropTrailingSlashes
        |> Context


makeShareableUrl : Context -> State.Data -> String
makeShareableUrl ctx data =
    case
        State.showAppFor data
            |> Provider.storeInString
    of
        Ok urlFragment ->
            ctx.baseUrl ++ "/#" ++ urlFragment

        Err error ->
            -- TODO: Make it not possible.
            "Should never happen, but: Err "
                ++ error
                |> Debug.crash


dropHashFragment : Navigation.Location -> String
dropHashFragment location =
    case String.uncons location.hash of
        Just ( '#', _ ) ->
            let
                fragmentLength =
                    String.length location.hash
            in
                location.href
                    |> String.dropRight fragmentLength

        _ ->
            location.href


dropTrailingSlashes : String -> String
dropTrailingSlashes str =
    case String.endsWith "/" str of
        False ->
            str

        True ->
            String.dropRight 1 str
                |> dropTrailingSlashes


extractHashFragment : Context -> Navigation.Location -> Result ExtractError (Maybe String)
extractHashFragment ctx location =
    case
        location.href
            |> String.startsWith ctx.baseUrl
    of
        False ->
            Err UnknownLocation

        True ->
            Ok <|
                case String.uncons location.hash of
                    Just ( '#', content ) ->
                        Just content

                    _ ->
                        Nothing
