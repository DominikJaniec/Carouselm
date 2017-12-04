module MainSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Main
import Navigation


suite : Test
suite =
    describe "The Main module"
        [ describe "Method `updateInputs`" <|
            [ test "Generates errors messages as URL when inputs are invalid" <|
                \_ ->
                    let
                        ( sampleModel, _ ) =
                            Navigation.Location "" "" "" "" "" "" "" "" "" "" ""
                                |> Main.initializeModel

                        givenInputs =
                            { title = "this one title is valid"
                            , interval = "2warp"
                            , pages = ""
                            }

                        expectedMessage =
                            "[(Pages,Required),(Interval,InvalidFormat \"could not convert string '2warp' to an Int\")]"
                    in
                        Main.updateInputs sampleModel (\_ -> givenInputs)
                            |> extractStateShareUrl
                            |> Expect.equal expectedMessage
            , test "Generates string with full URL when inputs are valid" <|
                \_ ->
                    let
                        ( sampleModel, _ ) =
                            Navigation.Location "https://example.com/" "" "" "" "" "" "" "" "" "" ""
                                |> Main.initializeModel

                        givenInputs =
                            { title = "Short title"
                            , interval = "963"
                            , pages = "dose not look like URL\nIt is OK however\n"
                            }

                        expectedUrl =
                            "https://example.com/#show/eyJ0aXRsZSI6IlNob3J0IHRpdGxlIiwiaW50ZXJ2YWwiOjk2MywicGFnZXMiOlsiZG9zZSBub3QgbG9vayBsaWtlIFVSTCIsIkl0IGlzIE9LIGhvd2V2ZXIiXX0%3D"
                    in
                        Main.updateInputs sampleModel (\_ -> givenInputs)
                            |> extractStateShareUrl
                            |> Expect.equal expectedUrl
            ]
        ]


extractStateShareUrl : Main.Model -> String
extractStateShareUrl model =
    model.stateShareUrl
