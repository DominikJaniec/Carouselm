module State.ParserSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Miscellaneous exposing (..)
import State
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
                emptyInputSamples
              <|
                \input ->
                    Parser.parseTitle input
                        |> Expect.equal (Err Parser.Required)
            ]
        , describe "Method `parseInterval`"
            [ testCases "Should return `Ok IntervalMs` for an input with positive integer Number"
                [ ( "1", Ok (State.IntervalMs 1) )
                , ( "001", Ok (State.IntervalMs 1) )
                , ( " 1\n", Ok (State.IntervalMs 1) )
                , ( "4112", Ok (State.IntervalMs 4112) )
                , ( "18690", Ok (State.IntervalMs 18690) )
                , ( "\t\t111\t\t", Ok (State.IntervalMs 111) )
                , ( "\n \t 1989 \n \t", Ok (State.IntervalMs 1989) )
                ]
              <|
                \input expected ->
                    Parser.parseInterval input
                        |> Expect.equal expected
            , testCases "Should return `Ok IntervalSec` for an input with positive Number ends with `sec` or `s`"
                [ ( "7s", Ok (State.IntervalSec 7) )
                , ( "2sec", Ok (State.IntervalSec 2) )
                , ( "03s", Ok (State.IntervalSec 3) )
                , ( "05sec", Ok (State.IntervalSec 5) )
                , ( "\t 13s", Ok (State.IntervalSec 13) )
                , ( "\t 64sec", Ok (State.IntervalSec 64) )
                , ( "16.25s", Ok (State.IntervalSec 16.25) )
                , ( "32.75sec", Ok (State.IntervalSec 32.75) )
                , ( "111.333s", Ok (State.IntervalSec 111.333) )
                , ( "999.222sec", Ok (State.IntervalSec 999.222) )
                , ( " 4 s ", Ok (State.IntervalSec 4) )
                , ( " 1 sec", Ok (State.IntervalSec 1) )
                , ( "\t6.9    s\t", Ok (State.IntervalSec 6.9) )
                , ( "\t9.3  sec\n", Ok (State.IntervalSec 9.3) )
                , ( "  98765.4321 s ", Ok (State.IntervalSec 98765.4321) )
                , ( "\n12345.6789\nsec\n", Ok (State.IntervalSec 12345.6789) )
                ]
              <|
                \input expected ->
                    Parser.parseInterval input
                        |> Expect.equal expected
            , testSamples "Should return `Err InvalidFormat cause` for an input other than Number"
                [ "one", "other", "1234-5", "1O2", "   seven", "fourty-two", "0x03z", "    \t 123,45 \n", "12,345,678.90", "42h", "7min", "3m" ]
              <|
                \input ->
                    case Parser.parseInterval input of
                        Err (Parser.InvalidFormat _) ->
                            Expect.pass

                        other ->
                            ("Expected `InvalidFormat` but got: " ++ toString other)
                                |> Expect.fail
            , testSamples "Should return `Err Required` for an emput input"
                emptyInputSamples
              <|
                \input ->
                    Parser.parseInterval input
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
                emptyInputSamples
              <|
                \input ->
                    Parser.parsePages input
                        |> Expect.equal (Err Parser.Required)
            ]
        ]


maxLenghtTitle : String
maxLenghtTitle =
    String.repeat 50 "o"


emptyInputSamples : List String
emptyInputSamples =
    [ "", "  ", "\t", " \t ", " \t   \t  " ]
