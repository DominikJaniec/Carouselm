module Transformer exposing (encode, decode, decodeOrInitial)

import List exposing (..)
import Json.Encode as JsonEncode exposing (..)
import Json.Decode as JsonDecode exposing (..)
import StateData exposing (..)


encode : StateData -> String
encode state =
    let
        titleEncoder =
            state.title
                |> JsonEncode.string

        intervalEncoder =
            state.interval
                |> asMillisecond
                |> JsonEncode.int

        pagesEncoder =
            List.map JsonEncode.string state.pages
                |> JsonEncode.list

        stateEncoder =
            JsonEncode.object
                [ ( keys.title, titleEncoder )
                , ( keys.interval, intervalEncoder )
                , ( keys.pages, pagesEncoder )
                ]
    in
        JsonEncode.encode const.indent stateEncoder


decode : String -> Result String StateData
decode input =
    let
        stateDecoder =
            let
                intervalDecoder =
                    JsonDecode.map IntervalMs JsonDecode.int

                titleField =
                    (JsonDecode.field keys.title JsonDecode.string)

                intervalField =
                    (JsonDecode.field keys.interval intervalDecoder)

                pagesField =
                    (JsonDecode.field keys.pages (JsonDecode.list JsonDecode.string))
            in
                JsonDecode.map3 StateData titleField intervalField pagesField
    in
        JsonDecode.decodeString stateDecoder input


decodeOrInitial : String -> StateData
decodeOrInitial input =
    case (decode input) of
        Ok state ->
            state

        Err _ ->
            initialState


const =
    { indent = 0 }


keys =
    { title = "title"
    , interval = "interval"
    , pages = "pages"
    }
