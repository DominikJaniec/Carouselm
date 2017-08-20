module State.ParserSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Miscellaneous exposing (..)
import State.Parser as Parser


suite : Test
suite =
    describe "The State.Parser module"
        [ describe "Method `parseTitle`"
            [ testCases "Should return trimmed `Ok str` for a correct input"
                [ ( "Sample title", Ok "Sample title" )
                , ( "   hole on left", Ok "hole on left" )
                , ( "\tOther kind of left", Ok "Other kind of left" )
                , ( "Spaces at the end     ", Ok "Spaces at the end" )
                , ( "sentence with tab-end\t", Ok "sentence with tab-end" )
                , ( " <- nothing on both sides -> ", Ok "<- nothing on both sides ->" )
                , ( "          " ++ maxLenghtTitle ++ "\n", Ok maxLenghtTitle )
                ]
              <|
                \input expected ->
                    Parser.parseTitle input
                        |> Expect.equal expected
            , testSamples "Should return `Err (TooLong 50)` for a longer input"
                [ "x" ++ maxLenghtTitle
                , maxLenghtTitle ++ "x"
                , "a" ++ maxLenghtTitle ++ "b"
                , "qwer" ++ maxLenghtTitle ++ "zxcv"
                , maxLenghtTitle ++ " \t " ++ maxLenghtTitle
                ]
              <|
                \input ->
                    Parser.parseTitle input
                        |> Expect.equal (Err (Parser.ToLong 50))
            , testSamples "Should return `Err Required` for an empty input"
                [ "", "  ", "\t", " \t ", " \t   \t  " ]
              <|
                \input ->
                    Parser.parseTitle input
                        |> Expect.equal (Err Parser.Required)
            ]
        ]


maxLenghtTitle : String
maxLenghtTitle =
    String.repeat 50 "o"
