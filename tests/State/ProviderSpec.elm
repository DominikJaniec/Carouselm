module State.ProviderSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import State
import State.Provider as Provider


suite : Test
suite =
    describe "The State.Provider module"
        [ describe "method `loadFromString`"
            [ test "returns initial empty state for an empty input" <|
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
            ]
        ]
