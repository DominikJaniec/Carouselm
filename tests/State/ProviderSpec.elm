module State.ProviderSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import State
import State.Provider as Provider


suite : Test
suite =
    describe "The State.Provider module"
        [ describe "method `loadFromString`"
            [ test "extracts initial empty state for an empty input" <|
                \_ ->
                    Provider.loadFromString ""
                        |> Expect.equal (Ok ( State.ModeInit, Nothing ))
            , test "returns `Err` for an invalid input" <|
                \_ ->
                    Provider.loadFromString "invalid"
                        |> Expect.err
            , describe "returns matched empty state for" <|
                let
                    emptyShowStat =
                        ( State.ModeShow, Nothing )

                    emptyEditStat =
                        ( State.ModeEdit, Maybe.Nothing )

                    samples =
                        [ ( "show", emptyShowStat )
                        , ( "Show", emptyShowStat )
                        , ( "SHOW", emptyShowStat )
                        , ( "show/", emptyShowStat )
                        , ( "sHow/", emptyShowStat )
                        , ( "SHOW/", emptyShowStat )
                        , ( "edit", emptyEditStat )
                        , ( "Edit", emptyEditStat )
                        , ( "EDIT", emptyEditStat )
                        , ( "edit/", emptyEditStat )
                        , ( "edIt/", emptyEditStat )
                        , ( "EDIT/", emptyEditStat )
                        ]

                    header sample =
                        "an input: `" ++ (Tuple.first sample) ++ "`"

                    tester sample =
                        test (header sample) <|
                            \_ ->
                                Provider.loadFromString (Tuple.first sample)
                                    |> Expect.equal (Ok (Tuple.second sample))
                in
                    List.map tester samples
            , describe "returns `Err` for an input with invalid data" <|
                let
                    samples =
                        [ "show/edit"
                        , "show/should-be-invalid"
                        , "show/bWFnaWMgc3R1ZmYgaGVyZQ=="
                        , "show/edit/too/many/slashes"
                        , "edit/show"
                        , "edit/this-is-bad-data"
                        , "edit/eyJhbG1vc3QiOmZhbHNlLCJhcHAtc3RhdGUiOiJkYXRhIiwibXlMaXN0IjpbMSwyLDMsNSw3LDQyLCJ4Il19"
                        , "edit/show/to-complicated/input"
                        ]

                    header sample =
                        "an input: `" ++ sample ++ "`"

                    tester sample =
                        test (header sample) <|
                            \_ ->
                                Provider.loadFromString sample
                                    |> Expect.err
                in
                    List.map tester samples
            , test "extracts valid `ModeEdit` state with its data" <|
                \_ ->
                    let
                        data =
                            State.Data
                                "Just magic title"
                                (State.IntervalMs 456)
                                [ "http://example.com" ]

                        result =
                            ( State.ModeEdit, Just data )
                    in
                        Provider.loadFromString "/edit/eyJ0aXRsZSI6Ikp1c3QgbWFnaWMgdGl0bGUiLCJpbnRlcnZhbCI6NDU2LCJwYWdlcyI6WyJodHRwOi8vZXhhbXBsZS5jb20iXX0%3D/"
                            |> Expect.equal (Ok result)
            , test "extracts valid `ModeShow` state with its data" <|
                \_ ->
                    let
                        data =
                            State.Data
                                "Dość błazeństw, żrą mój pęk luźnych fig"
                                (State.IntervalMs 9999)
                                [ "https://en.wikipedia.org/wiki/Pangram"
                                , "https://pl.wikipedia.org/wiki/Pangram#j.C4.99zyk_polski"
                                ]

                        result =
                            ( State.ModeShow, Just data )
                    in
                        Provider.loadFromString "show///eyAidGl0bGUiOiAiRG%2FFm8SHIGLFgmF6ZcWEc3R3LCDFvHLEhSBtw7NqIHDEmWsgbHXFum55Y2ggZmlnIg0KLCAiaW50ZXJ2YWwiIDogOTk5OQ0KLCAicGFnZXMiOg0KICAgIFsgImh0dHBzOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL1BhbmdyYW0iDQogICAgLCAiaHR0cHM6Ly9wbC53aWtpcGVkaWEub3JnL3dpa2kvUGFuZ3JhbSNqLkM0Ljk5enlrX3BvbHNraSINCiAgICBdDQp9"
                            |> Expect.equal (Ok result)
            ]
        ]
