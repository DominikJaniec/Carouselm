module State.TransformerSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import State
import State.Transformer as Transformer


suite : Test
suite =
    describe "The State.Transformer module"
        [ describe "Piped `encode` and `decode` returns given input"
            [ test "has no effect on the `initialData`" <|
                \_ ->
                    State.initialData
                        |> pipedTestedTransformer
                        |> Expect.equal State.initialData
            , test "handles custom data" <|
                \_ ->
                    let
                        sampleData =
                            State.Data "Sample title with specials: !@#$%^&*()_+-=`~[]\\{}|;':\",./<>?"
                                (State.IntervalMs 135711)
                                [ "a", "b", "c", "d" ]
                    in
                        sampleData
                            |> pipedTestedTransformer
                            |> Expect.equal sampleData
            ]
        , describe "Method `encode` produces correct Base64 string"
            [ test "for standard `initialData` input" <|
                \_ ->
                    State.initialData
                        |> Transformer.encode
                        |> Expect.equal "eyJ0aXRsZSI6IlNhbXBsZSBzaG93J3MgdGl0bGUuLi4iLCJpbnRlcnZhbCI6NzY1NCwicGFnZXMiOlsiaHR0cDovL2VsbS1sYW5nLm9yZy8iLCJodHRwczovL2d1aWRlLmVsbS1sYW5nLm9yZy8iLCJodHRwczovL2dpdGh1Yi5jb20vRG9taW5pa0phbmllYy9DYXJvdXNlbG0iXX0%3D"
            , test "for custom sample of a state" <|
                \_ ->
                    let
                        sampleState =
                            State.Data "This is sample with UTF8: ĄĆĘŁŃÓŚŹŻ 🌍 🌎 🌏 ąćęłńóśźż characters"
                                (State.IntervalMs 99166)
                                [ "https://arxiv.org/pdf/1606.06565.pdf"
                                , "https://ocw.mit.edu/high-school/humanities-and-social-sciences/godel-escher-bach/"
                                , "http://fsharpforfunandprofit.com/"
                                , "https://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems"
                                , "http://vindinium.org/"
                                ]
                    in
                        sampleState
                            |> Transformer.encode
                            |> Expect.equal "eyJ0aXRsZSI6IlRoaXMgaXMgc2FtcGxlIHdpdGggVVRGODogxITEhsSYxYHFg8OTxZrFucW7IPCfjI0g8J%2BMjiDwn4yPIMSFxIfEmcWCxYTDs8WbxbrFvCBjaGFyYWN0ZXJzIiwiaW50ZXJ2YWwiOjk5MTY2LCJwYWdlcyI6WyJodHRwczovL2FyeGl2Lm9yZy9wZGYvMTYwNi4wNjU2NS5wZGYiLCJodHRwczovL29jdy5taXQuZWR1L2hpZ2gtc2Nob29sL2h1bWFuaXRpZXMtYW5kLXNvY2lhbC1zY2llbmNlcy9nb2RlbC1lc2NoZXItYmFjaC8iLCJodHRwOi8vZnNoYXJwZm9yZnVuYW5kcHJvZml0LmNvbS8iLCJodHRwczovL3dpa2kuaGFza2VsbC5vcmcvSC05OTpfTmluZXR5LU5pbmVfSGFza2VsbF9Qcm9ibGVtcyIsImh0dHA6Ly92aW5kaW5pdW0ub3JnLyJdfQ%3D%3D"
            ]
        ]


pipedTestedTransformer : State.Data -> State.Data
pipedTestedTransformer input =
    Transformer.encode input
        |> Transformer.decodeOrInitial
