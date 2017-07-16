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
            [ test "transforms `initialApp` into `initialEditApp`" <|
                \_ ->
                    State.initialApp
                        |> State.fix
                        |> Expect.equal State.initialEditApp
            , test "has no effect on the `initialEditApp`" <|
                \_ ->
                    State.initialEditApp
                        |> State.fix
                        |> Expect.equal State.initialEditApp
            , test "fixes state with `ModeInit` with data into `initialEditApp`" <|
                \_ ->
                    ( State.ModeInit, Just (State.Data "XXX" (State.IntervalMs 0) [ "X" ]) )
                        |> State.fix
                        |> Expect.equal State.initialEditApp
            , test "does not change custom state" <|
                \_ ->
                    let
                        sampleData =
                            State.Data "Complicated title" (State.IntervalMs 4) [ "url" ]

                        sampleApp =
                            ( State.ModeShow, Just sampleData )
                    in
                        sampleApp
                            |> State.fix
                            |> Expect.equal sampleApp
            ]
        ]
