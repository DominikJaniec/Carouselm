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
        , describe "Method `parsePages`"
            [ testCases "Should return `Ok [ page ]` for a single line input"
                [ ( "something", Ok [ "something" ] )
                , ( "   trimmed\t", Ok [ "trimmed" ] )
                , ( "http://like.page", Ok [ "http://like.page" ] )
                , ( "https://example.com/      ", Ok [ "https://example.com/" ] )
                , ( "http://www.some   stuff\twith.s p a c e s.com", Ok [ "http://www.some   stuff\twith.s p a c e s.com" ] )
                ]
              <|
                \input expected ->
                    Parser.parsePages input
                        |> Expect.equal expected
            , testCases "Should return `Ok [ pages ]` for a multiple lines input"
                [ ( "a\nb\nc", Ok [ "a", "b", "c" ] )
                , ( "\n\nhttps://some.url\n\n\n\n\nhttps://other.com\n", Ok [ "https://some.url", "https://other.com" ] )
                , ( "http://zxc.net\nhttps://www.stuff.com\nhttps://localhost", Ok [ "http://zxc.net", "https://www.stuff.com", "https://localhost" ] )
                , ( "    starts.with.spaces/\n\tmiddle\t\nhttp://ends-with.space\t", Ok [ "starts.with.spaces/", "middle", "http://ends-with.space" ] )
                ]
              <|
                \input expected ->
                    Parser.parsePages input
                        |> Expect.equal expected
            , testSamples "Should return `Err Required` for an empty input"
                [ "", "  ", "\t", " \t ", " \t   \t  " ]
              <|
                \input ->
                    Parser.parsePages input
                        |> Expect.equal (Err Parser.Required)
            ]
        ]


maxLenghtTitle : String
maxLenghtTitle =
    String.repeat 50 "o"
