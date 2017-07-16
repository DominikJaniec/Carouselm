module TransformerSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import StateData exposing (..)
import Transformer exposing (..)


suite : Test
suite =
    describe "The Transformer module"
        [ describe "Piped 'encode' and 'decode' returns given input"
            [ test "has no effect on the 'initialState'" <|
                \_ ->
                    initialState
                        |> pipedTransformer
                        |> Expect.equal initialState
            , test "handles custom data" <|
                \_ ->
                    let
                        sampleTitle =
                            "Sample title with specials: !@#$%^&*()_+-=`~[]\\{}|;':\",./<>?"

                        sampleState =
                            StateData sampleTitle (IntervalMs 135711) [ "a", "b", "c", "d" ]
                    in
                        sampleState
                            |> pipedTransformer
                            |> Expect.equal sampleState
            ]
        ]


pipedTransformer : StateData -> StateData
pipedTransformer input =
    Transformer.encode input
        |> Transformer.decodeOrInitial
