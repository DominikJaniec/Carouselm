module MainSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Sampler exposing (..)
import Main
import State
import State.Provider
import Navigator


suite : Test
suite =
    describe "The Main module"
        [ describe "Method `initializeModel`" <|
            [ test "Sets State-related fields to expected values" <|
                \_ ->
                    let
                        expectedStateData =
                            { title = "F# Advent Calendar 2017"
                            , interval = State.IntervalMs 7000
                            , pages =
                                [ "https://sergeytihon.com/2017/10/22/f-advent-calendar-in-english-2017/"
                                , "https://twitter.com/hashtag/FsAdvent"
                                ]
                            }

                        expectedInputs =
                            { title = "F# Advent Calendar 2017"
                            , interval = "7000"
                            , pages = "https://sergeytihon.com/2017/10/22/f-advent-calendar-in-english-2017/\nhttps://twitter.com/hashtag/FsAdvent\n"
                            }

                        expectedStateShareUrl =
                            "https://DominikJaniec.github.io/Carouselm/#show/eyJ0aXRsZSI6IkYjIEFkdmVudCBDYWxlbmRhciAyMDE3IiwiaW50ZXJ2YWwiOjcwMDAsInBhZ2VzIjpbImh0dHBzOi8vc2VyZ2V5dGlob24uY29tLzIwMTcvMTAvMjIvZi1hZHZlbnQtY2FsZW5kYXItaW4tZW5nbGlzaC0yMDE3LyIsImh0dHBzOi8vdHdpdHRlci5jb20vaGFzaHRhZy9Gc0FkdmVudCJdfQ%3D%3D"
                    in
                        initializeMainModel
                            "https://DominikJaniec.github.io/Carouselm/"
                            "#show/eyJ0aXRsZSI6IkYjIEFkdmVudCBDYWxlbmRhciAyMDE3IiwiaW50ZXJ2YWwiOjcwMDAsInBhZ2VzIjpbImh0dHBzOi8vc2VyZ2V5dGlob24uY29tLzIwMTcvMTAvMjIvZi1hZHZlbnQtY2FsZW5kYXItaW4tZW5nbGlzaC0yMDE3LyIsImh0dHBzOi8vdHdpdHRlci5jb20vaGFzaHRhZy9Gc0FkdmVudCJdfQ%3D%3D"
                            |> Expect.all
                                [ \m -> Expect.equal expectedStateData m.previewStateData
                                , \m -> Expect.equal expectedStateData m.stateData
                                , \m -> Expect.equal expectedInputs m.inputs
                                , \m -> Expect.equal expectedStateShareUrl m.stateShareUrl
                                ]
            ]
        , describe "Method `update`" <|
            [ test "Msg `Preview` sets previewStateData as current stateData" <|
                \_ ->
                    let
                        sampleModel =
                            initializeMainModel "" ""

                        givenInputs =
                            { title = "Some testing sample"
                            , interval = "97531"
                            , pages = "http://a.com\nhttp://b.z.com\n"
                            }

                        expectedStateData =
                            { title = "Some testing sample"
                            , interval = State.IntervalMs 97531
                            , pages =
                                [ "http://a.com"
                                , "http://b.z.com"
                                ]
                            }
                    in
                        Main.updateInputs sampleModel (\_ -> givenInputs)
                            |> Main.update Main.Preview
                            |> (\( model, _ ) -> model.previewStateData)
                            |> Expect.equal expectedStateData
            ]
        , describe "Method `updateInputs`" <|
            [ test "Does not change `previewStateData`" <|
                \_ ->
                    let
                        sampleModel =
                            initializeMainModel
                                "https://DominikJaniec.github.io/Carouselm/"
                                "#show/eyJ0aXRsZSI6IkludGVyZXN0aW5nIFlvdVR1YmUgY2hhbm5lbHMiLCJpbnRlcnZhbCI6MzAwMDAsInBhZ2VzIjpbImh0dHBzOi8vd3d3LnlvdXR1YmUuY29tL3VzZXIvQ29tcHV0ZXJwaGlsZSIsImh0dHBzOi8vd3d3LnlvdXR1YmUuY29tL2NoYW5uZWwvVUN0RVN2MWU3bnRKYUxKWUtJTzFGb1l3IiwiaHR0cHM6Ly93d3cueW91dHViZS5jb20vY2hhbm5lbC9VQ3ZCcXp6dlVCTENzOFk3QXhiLWpaZXciLCJodHRwczovL3d3dy55b3V0dWJlLmNvbS9jaGFubmVsL1VDby0zVGhOUW1QbVFTUUxfTDZMeDFfdyIsImh0dHBzOi8vd3d3LnlvdXR1YmUuY29tL2NoYW5uZWwvVUNveGNqcS04eElEVFlwM3V6NjQ3VjVBIl19"

                        givenInputs =
                            { title = "Troll-Roll"
                            , interval = "3 sec"
                            , pages = "https://youtu.be/dQw4w9WgXcQ\nhttps://youtu.be/gkTb9GP9lVI\n"
                            }

                        expectedStateData =
                            { title = "Interesting YouTube channels"
                            , interval = State.IntervalMs 30000
                            , pages =
                                [ "https://www.youtube.com/user/Computerphile"
                                , "https://www.youtube.com/channel/UCtESv1e7ntJaLJYKIO1FoYw"
                                , "https://www.youtube.com/channel/UCvBqzzvUBLCs8Y7Axb-jZew"
                                , "https://www.youtube.com/channel/UCo-3ThNQmPmQSQL_L6Lx1_w"
                                , "https://www.youtube.com/channel/UCoxcjq-8xIDTYp3uz647V5A"
                                ]
                            }
                    in
                        Main.updateInputs sampleModel (\_ -> givenInputs)
                            |> (\model -> model.previewStateData)
                            |> Expect.equal expectedStateData
            , test "Updates `stateData` according to valid inputs" <|
                \_ ->
                    let
                        sampleModel =
                            initializeMainModel "" ""

                        givenInputs =
                            { title = "Better title than sample"
                            , interval = "13691"
                            , pages = "https://www.smbc-comics.com\nhttp://explosm.net\n"
                            }

                        expectedStateData =
                            { title = "Better title than sample"
                            , interval = State.IntervalMs 13691
                            , pages =
                                [ "https://www.smbc-comics.com"
                                , "http://explosm.net"
                                ]
                            }
                    in
                        Main.updateInputs sampleModel (\_ -> givenInputs)
                            |> (\model -> model.stateData)
                            |> Expect.equal expectedStateData
            , test "Generates errors messages as URL when inputs are invalid" <|
                \_ ->
                    let
                        sampleModel =
                            initializeMainModel "" ""

                        givenInputs =
                            { title = "this one title is valid"
                            , interval = "2warp"
                            , pages = ""
                            }

                        expectedMessage =
                            "[(Pages,Required),(Interval,InvalidFormat \"could not convert string '2warp' to an Int\")]"
                    in
                        Main.updateInputs sampleModel (\_ -> givenInputs)
                            |> (\model -> model.stateShareUrl)
                            |> Expect.equal expectedMessage
            , test "Generates string with full URL when inputs are valid" <|
                \_ ->
                    let
                        sampleModel =
                            initializeMainModel "https://example.com/" ""

                        givenInputs =
                            { title = "Short title"
                            , interval = "963"
                            , pages = "dose not look like URL\nIt is OK however\n"
                            }

                        expectedUrl =
                            "https://example.com/#show/eyJ0aXRsZSI6IlNob3J0IHRpdGxlIiwiaW50ZXJ2YWwiOjk2MywicGFnZXMiOlsiZG9zZSBub3QgbG9vayBsaWtlIFVSTCIsIkl0IGlzIE9LIGhvd2V2ZXIiXX0%3D"
                    in
                        Main.updateInputs sampleModel (\_ -> givenInputs)
                            |> (\model -> model.stateShareUrl)
                            |> Expect.equal expectedUrl
            ]
        ]


initializeMainModel : String -> String -> Main.Model
initializeMainModel baseUrl hashFragment =
    let
        ( initializedModel, _ ) =
            makeLocationWithHash baseUrl hashFragment
                |> Main.initializeModel
    in
        initializedModel
