module NavigatorSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Miscellaneous exposing (..)
import Sampler exposing (..)
import Navigator
import State


suite : Test
suite =
    describe "The Navigator module"
        [ describe "Method `extractState`"
            [ test "Returns `Err` when `Context` does not match to given `Location`" <|
                \_ ->
                    { fakedLocation | href = "sample.unknown.url" }
                        |> Navigator.extractState (Navigator.Context "known.url")
                        |> Expect.equal (Err Navigator.UnknownLocation)
            , test "Propagates `Err` from `Provider` when #fragment is invalid" <|
                \_ ->
                    makeLocationWithHash "http://example.com" "#edit/some-garbage"
                        |> Navigator.extractState (Navigator.Context "http://example.com")
                        |> Expect.equal (Err (Navigator.ProviderError "Invalid base64"))
            , test "Returns `State.initialApp` for empty #fragment" <|
                \_ ->
                    makeLocationWithHash "sample.url" "#"
                        |> Navigator.extractState (Navigator.Context "sample.url")
                        |> Expect.equal (Ok State.initialApp)
            , test "Returns `State.initialApp` for `Location` with no #fragment" <|
                \_ ->
                    makeLocationWithHash "https://github.com" ""
                        |> Navigator.extractState (Navigator.Context "https://github.com")
                        |> Expect.equal (Ok State.initialApp)
            , test "Returns correct `State.App` for given #fragment" <|
                \_ ->
                    let
                        baseUrl =
                            "https://DominikJaniec.github.io/Carouselm"

                        expectedApp =
                            ( State.ModeEdit
                            , Just
                                { title = "Sample `Carouselem's` working presentation"
                                , interval = State.IntervalMs 45369
                                , pages =
                                    [ "http://learnyouahaskell.com/"
                                    , "https://code.visualstudio.com/"
                                    , "https://docs.haskellstack.org/"
                                    ]
                                }
                            )
                    in
                        makeLocationWithHash baseUrl "#edit/eyJ0aXRsZSI6IlNhbXBsZSBgQ2Fyb3VzZWxlbSdzYCB3b3JraW5nIHByZXNlbnRhdGlvbiIsImludGVydmFsIjo0NTM2OSwicGFnZXMiOlsiaHR0cDovL2xlYXJueW91YWhhc2tlbGwuY29tLyIsImh0dHBzOi8vY29kZS52aXN1YWxzdHVkaW8uY29tLyIsImh0dHBzOi8vZG9jcy5oYXNrZWxsc3RhY2sub3JnLyJdfQ%3D%3D"
                            |> Navigator.extractState (Navigator.Context baseUrl)
                            |> Expect.equal (Ok expectedApp)
            ]
        , describe "Method `getContext`" <|
            [ testCases "Stores whole Location's `href` without #fragment"
                [ ( { fakedLocation
                        | href = "sample"
                    }
                  , Navigator.Context "sample"
                  )
                , ( { fakedLocation
                        | href = "http://localhost/carouselm"
                    }
                  , Navigator.Context "http://localhost/carouselm"
                  )
                , ( { fakedLocation
                        | href = "http://localhost#carouselm?or=stuff"
                        , hash = "#carouselm?or=stuff"
                    }
                  , Navigator.Context "http://localhost"
                  )
                , ( { fakedLocation
                        | href = "https://www.youtube.com/watch?v=0rHUDWjR5gg&list=PL8dPuuaLjXtPAJr1ysd5yGIyiSFuh0mIL"
                    }
                  , Navigator.Context "https://www.youtube.com/watch?v=0rHUDWjR5gg&list=PL8dPuuaLjXtPAJr1ysd5yGIyiSFuh0mIL"
                  )
                , ( { fakedLocation
                        | href = "https://developer.mozilla.org:8080/en-US/search?q=URL#search-results-close-container"
                        , hash = "#search-results-close-container"
                    }
                  , Navigator.Context "https://developer.mozilla.org:8080/en-US/search?q=URL"
                  )
                ]
              <|
                \location context ->
                    Navigator.getContext location
                        |> Expect.equal context
            , test "Drops all trailing slashes" <|
                \_ ->
                    makeLocationWithHash "https://drop///last//////" "#ifnored-here"
                        |> Navigator.getContext
                        |> Expect.equal (Navigator.Context "https://drop///last")
            ]
        , describe "Method `makeShareableUrl`"
            [ test "Provides full URL from `State.Data` as Show" <|
                \_ ->
                    State.Data "Example title" (State.IntervalSec 13.7) [ "page/a", "other.page.com" ]
                        |> Navigator.makeShareableUrl (Navigator.Context "http://base.url/test.x?example.com")
                        |> Expect.equal "http://base.url/test.x?example.com/#show/eyJ0aXRsZSI6IkV4YW1wbGUgdGl0bGUiLCJpbnRlcnZhbCI6MTM3MDAsInBhZ2VzIjpbInBhZ2UvYSIsIm90aGVyLnBhZ2UuY29tIl19"
            ]
        ]
