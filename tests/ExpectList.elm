module ExpectList exposing (..)

import Expect exposing (Expectation)


contains : a -> List a -> Expectation
contains expectedItem list =
    let
        message =
            "Expected the list contains: `"
                ++ toString expectedItem
                ++ "`, but it is: "
                ++ toString list
    in
        List.any ((==) expectedItem) list
            |> Expect.true message


length : Int -> List a -> Expectation
length expectedLength list =
    let
        actual =
            List.length list

        message =
            "Expected the list's length to be "
                ++ toString expectedLength
                ++ ", but got: "
                ++ toString actual
    in
        (actual == expectedLength)
            |> Expect.true message


equivalent : List a -> List a -> Expectation
equivalent expectedList list =
    let
        expectSameLength =
            length (List.length expectedList)

        expectSameItems =
            expectedList |> List.map (\x -> contains x)

        expectations =
            expectSameLength :: expectSameItems
    in
        list |> Expect.all expectations
