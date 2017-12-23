module Sampler exposing (..)

import Navigation


fakedLocation : Navigation.Location
fakedLocation =
    let
        unset =
            "__FAKED__"
    in
        { href = unset
        , host = unset
        , hostname = unset
        , protocol = unset
        , origin = unset
        , port_ = unset
        , pathname = unset
        , search = unset
        , hash = unset
        , username = unset
        , password = unset
        }


makeLocationWithHash : String -> String -> Navigation.Location
makeLocationWithHash baseUrl hashFragment =
    { fakedLocation
        | href = baseUrl ++ "/" ++ hashFragment
        , hash = hashFragment
    }
