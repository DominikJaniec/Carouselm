module Miscellaneous exposing (..)

import Expect exposing (Expectation)
import Test exposing (Test)


testCases : String -> List ( i, e ) -> (i -> e -> Expectation) -> Test
testCases name params tester =
    let
        title input expected =
            "# [ Given case: "
                ++ toString input
                ++ " | Expected: "
                ++ toString expected
                ++ " ]"

        makeTest ( input, expected ) =
            Test.test (title input expected) <|
                \_ -> tester input expected
    in
        List.map makeTest params
            |> Test.describe name


testSamples : String -> List i -> (i -> Expectation) -> Test
testSamples name inputs tester =
    let
        title input =
            "$ [ Given sample: "
                ++ toString input
                ++ " ]"

        makeTest input =
            Test.test (title input) <|
                \_ -> tester input
    in
        List.map makeTest inputs
            |> Test.describe name


expectResultError : Result subject x -> (subject -> Expectation) -> Expectation
expectResultError result test =
    case result of
        Ok _ ->
            Expect.fail "Expected `Err`, but got `Ok`"

        Err x ->
            test x
