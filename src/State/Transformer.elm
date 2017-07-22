module State.Transformer exposing (encode, decode, decodeOrInitial)

import Base64
import Http
import Json.Encode
import Json.Decode
import State exposing (..)


encode : Data -> String
encode data =
    let
        titleEncoder =
            data.title
                |> Json.Encode.string

        intervalEncoder =
            data.interval
                |> asMillisecond
                |> Json.Encode.int

        pagesEncoder =
            List.map Json.Encode.string data.pages
                |> Json.Encode.list

        dataEncoder =
            Json.Encode.object
                [ ( keys.title, titleEncoder )
                , ( keys.interval, intervalEncoder )
                , ( keys.pages, pagesEncoder )
                ]
    in
        Json.Encode.encode const.indent dataEncoder
            |> Base64.encode
            |> Http.encodeUri


decode : String -> Result String Data
decode input =
    let
        dataDecoder =
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
                Json.Decode.map3 Data titleField intervalField pagesField
    in
        input
            |> Http.decodeUri
            |> Result.fromMaybe ("Could not decode, got Nothing from the Http.decodeUri for: '" ++ input ++ "'.")
            |> Result.andThen Base64.decode
            |> Result.andThen (Json.Decode.decodeString dataDecoder)


decodeOrInitial : String -> Data
decodeOrInitial input =
    case (decode input) of
        Ok data ->
            data

        Err error ->
            initialData
                |> Debug.log error


const =
    { indent = 0 }


keys =
    { title = "title"
    , interval = "interval"
    , pages = "pages"
    }
