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
        , describe "method `storeInString`" <|
            [ test "returns empty string for `ModeInit` without data" <|
                \_ ->
                    ( State.ModeInit, Nothing )
                        |> Provider.storeInString
                        |> Expect.equal (Ok "")
            , test "returns `Err` for `ModeInit` with some data" <|
                \_ ->
                    let
                        data =
                            State.Data
                                "ModeInit with any data is rather invalid"
                                (State.IntervalSec 13)
                                [ "https://some.net", "http//other.com" ]
                    in
                        ( State.ModeInit, Just data )
                            |> Provider.storeInString
                            |> Expect.err
            , test "returns valid string from `initialApp`" <|
                \_ ->
                    State.initialApp
                        |> Provider.storeInString
                        |> Expect.equal (Ok "edit/eyJ0aXRsZSI6IlNhbXBsZSBzaG93J3MgdGl0bGUuLi4iLCJpbnRlcnZhbCI6NzY1NCwicGFnZXMiOlsiaHR0cDovL2VsbS1sYW5nLm9yZy8iLCJodHRwczovL2d1aWRlLmVsbS1sYW5nLm9yZy8iLCJodHRwczovL2dpdGh1Yi5jb20vRG9taW5pa0phbmllYy9DYXJvdXNlbG0iXX0%3D")
            , test "returns valid string for Edit app's state without data" <|
                \_ ->
                    ( State.ModeEdit, Nothing )
                        |> Provider.storeInString
                        |> Expect.equal (Ok "edit/")
            , test "produces valid string from custom Edit app's state" <|
                \_ ->
                    let
                        data =
                            State.Data
                                ""
                                (State.IntervalSec 777)
                                [ "http://p1.net", "http://pn.org" ]
                    in
                        ( State.ModeEdit, Just data )
                            |> Provider.storeInString
                            |> Expect.equal (Ok "edit/eyJ0aXRsZSI6IiIsImludGVydmFsIjo3NzcwMDAsInBhZ2VzIjpbImh0dHA6Ly9wMS5uZXQiLCJodHRwOi8vcG4ub3JnIl19")
            , test "returns valid string for Show app's state without data" <|
                \_ ->
                    ( State.ModeShow, Nothing )
                        |> Provider.storeInString
                        |> Expect.equal (Ok "show/")
            , test "produces valid string from custom Show app's state" <|
                \_ ->
                    let
                        data =
                            State.Data
                                "Like empty title"
                                (State.IntervalMs 98765)
                                [ "https://en.wikipedia.org/wiki/Rosetta_Stone" ]
                    in
                        ( State.ModeShow, Just data )
                            |> Provider.storeInString
                            |> Expect.equal (Ok "show/eyJ0aXRsZSI6Ikxpa2UgZW1wdHkgdGl0bGUiLCJpbnRlcnZhbCI6OTg3NjUsInBhZ2VzIjpbImh0dHBzOi8vZW4ud2lraXBlZGlhLm9yZy93aWtpL1Jvc2V0dGFfU3RvbmUiXX0%3D")
            ]
        ]
