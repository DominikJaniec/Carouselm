module Transformer exposing (encode, decode, decodeOrInitial)

import Base64
import Debug
import Http
import List
import Json.Encode
import Json.Decode
import StateData exposing (..)


encode : StateData -> String
encode state =
    let
        titleEncoder =
            state.title
                |> Json.Encode.string

        intervalEncoder =
            state.interval
                |> asMillisecond
                |> Json.Encode.int

        pagesEncoder =
            List.map Json.Encode.string state.pages
                |> Json.Encode.list

        stateEncoder =
            Json.Encode.object
                [ ( keys.title, titleEncoder )
                , ( keys.interval, intervalEncoder )
                , ( keys.pages, pagesEncoder )
                ]
    in
        Json.Encode.encode const.indent stateEncoder
            |> Base64.encode
            |> Http.encodeUri


decode : String -> Result String StateData
decode input =
    let
        stateDecoder =
            let
                intervalDecoder =
                    Json.Decode.map IntervalMs Json.Decode.int

                titleField =
                    (Json.Decode.field keys.title Json.Decode.string)

                intervalField =
                    (Json.Decode.field keys.interval intervalDecoder)

                pagesField =
                    (Json.Decode.field keys.pages (Json.Decode.list Json.Decode.string))
            in
                Json.Decode.map3 StateData titleField intervalField pagesField
    in
        input
            |> Http.decodeUri
            |> Result.fromMaybe ("Could not decode, got Nothing from the Http.decodeUri for: '" ++ input ++ "'.")
            |> Result.andThen Base64.decode
            |> Result.andThen (Json.Decode.decodeString stateDecoder)


decodeOrInitial : String -> StateData
decodeOrInitial input =
    case (decode input) of
        Ok state ->
            state

        Err error ->
            initialState
                |> Debug.log error


const =
    { indent = 0 }


keys =
    { title = "title"
    , interval = "interval"
    , pages = "pages"
    }
