module StateSpec exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (..)
import Test exposing (..)
import State


suite : Test
suite =
    describe "The State module"
        [ describe "method `asMillisecond`"
            [ fuzz int "`IntervalMs` - let given millisecods through" <|
                \value ->
                    value
                        |> State.IntervalMs
                        |> State.asMillisecond
                        |> Expect.equal value
            , fuzz int "`IntervalSec` - outputs thousands more" <|
                \value ->
                    value
                        |> State.IntervalSec
                        |> State.asMillisecond
                        |> Expect.equal (1000 * value)
            ]
        , describe "method `fix`"
            [ test "transforms `ModeInit` with data to `ModeShow`" <|
                \_ ->
                    let
                        sampleData =
                            State.Data "Some title" (State.IntervalSec 3) []
                    in
                        ( State.ModeInit, Just sampleData )
                            |> State.fix
                            |> Expect.equal ( State.ModeShow, Just sampleData )
            , test "does not change app's state for `ModeShow` and `ModeEdit`" <|
                \_ ->
                    let
                        sampleData =
                            State.Data "Very c0mpl1(^7ed title" (State.IntervalMs 4) [ "URL", "s" ]

                        customAppStates =
                            [ ( State.ModeEdit, Just sampleData )
                            , ( State.ModeShow, Just sampleData )
                            ]
                    in
                        List.map State.fix customAppStates
                            |> Expect.equalLists customAppStates
            , describe "transforms all modes without data into `initialApp`" <|
                let
                    appStatesWithoutData =
                        [ ( State.ModeInit, Nothing )
                        , ( State.ModeEdit, Nothing )
                        , ( State.ModeShow, Nothing )
                        ]

                    header app =
                        "case of: `" ++ (toString (Tuple.first app)) ++ "`"

                    tester app =
                        test (header app) <|
                            \_ ->
                                State.fix app
                                    |> Expect.equal State.initialApp
                in
                    List.map tester appStatesWithoutData
            ]
        ]
