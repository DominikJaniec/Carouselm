module Navigator exposing (Context, extractContext, makeShareableUrl)

import Navigation
import State
import State.Provider as Provider


type alias Context =
    { baseUrl : String
    }


extractContext : Navigation.Location -> Context
extractContext location =
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
