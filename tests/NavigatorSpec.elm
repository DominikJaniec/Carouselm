module NavigatorSpec exposing (..)

import Expect exposing (Expectation)
import Test exposing (..)
import Miscellaneous exposing (..)
import Navigation
import Navigator
import State


suite : Test
suite =
    describe "The Navigator module"
        [ describe "Method `extractContext`" <|
            [ testCases "Stores whole Location's `href` without #fragment"
                [ ( { fakedLocation | href = "sample" }
                  , Navigator.Context "sample"
                  )
                , ( { fakedLocation | href = "http://localhost/carouselm" }
                  , Navigator.Context "http://localhost/carouselm"
                  )
                , ( { fakedLocation
                        | href = "http://localhost#carouselm?or=stuff"
                        , hash = "#carouselm?or=stuff"
                    }
                  , Navigator.Context "http://localhost"
                  )
                , ( { fakedLocation | href = "https://www.youtube.com/watch?v=0rHUDWjR5gg&list=PL8dPuuaLjXtPAJr1ysd5yGIyiSFuh0mIL" }
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
                    Navigator.extractContext location
                        |> Expect.equal context
            , test "Drops all trailing slashes" <|
                \_ ->
                    Navigator.extractContext
                        { fakedLocation
                            | href = "https://drop///last////#ignored"
                            , hash = "#ignored"
                        }
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


fakedLocation : Navigation.Location
fakedLocation =
    let
        unset =
            "__FAKED__"
    in
        { href = unset
        , host = unset
        , hostname = unset
        , protocol = unset
        , origin = unset
        , port_ = unset
        , pathname = unset
        , search = unset
        , hash = unset
        , username = unset
        , password = unset
        }
