module StateDataSpec exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (..)
import Test exposing (..)
import StateData exposing (..)


suite : Test
suite =
    describe "The StateData module"
        [ describe "asMillisecond"
            [ fuzz int "IntervalMs: let given millisecods through" <|
                \value ->
                    IntervalMs value
                        |> asMillisecond
                        |> Expect.equal value
            , fuzz int "IntervalSec: outputs thousands more" <|
                \value ->
                    IntervalSec value
                        |> asMillisecond
                        |> Expect.equal (1000 * value)
            ]
        ]
