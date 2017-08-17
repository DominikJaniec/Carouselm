module Main exposing (..)

import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Controls exposing (..)
import State exposing (..)
import Translations exposing (..)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { title : String
    , interval : Int
    , pages : String
    , showHelp : Bool
    , generatedUrl : String
    }


model : Model
model =
    let
        initial =
            State.initialData

        initialInterval =
            initial.interval
                |> State.asMillisecond

        initialPages =
            (initial.pages ++ [ "" ])
                |> String.join "\n"
    in
        Model initial.title initialInterval initialPages False ""
            |> withGeneratedUrl



-- UPDATE


type Msg
    = Title String
    | Interval String
    | Pages String
    | ShowHelp
    | CopyUrl
    | Preview
    | GoToShow
    | GoToEdit
    | GoToAbout


update : Msg -> Model -> Model
update msg model =
    case msg of
        Title txt ->
            { model | title = txt }

        Interval val ->
            withParsedInterval model val

        Pages txt ->
            { model | pages = txt }

        ShowHelp ->
            { model | showHelp = True }

        Preview ->
            withGeneratedUrl model

        CopyUrl ->
            Debug.crash "Not yet implemented."

        GoToShow ->
            model

        GoToEdit ->
            model

        GoToAbout ->
            model


withParsedInterval : Model -> String -> Model
withParsedInterval model text =
    let
        parsed =
            String.toInt text
                |> Result.withDefault -42
    in
        { model | interval = parsed }


withGeneratedUrl : Model -> Model
withGeneratedUrl model =
    { model | generatedUrl = generateUrl model }


generateUrl : Model -> String
generateUrl model =
    [ model.title, (toString model.interval), model.pages ]
        |> String.join "||"
        |> String.length
        |> toString



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "view-app" ]
        [ showView model, editView model ]


showView : Model -> Html Msg
showView model =
    section [ class "view-show" ]
        [ sectionNavigator model
        , sectionDisplay model
        ]


sectionNavigator : Model -> Html Msg
sectionNavigator model =
    let
        flowButtons =
            [ iconButtonFor TK_Show_Edit "icon-edit" GoToEdit
            , iconButtonFor TK_Show_About "icon-about" GoToAbout
            ]
    in
        section [ class "section-navigator" ]
            [ (pageIndicators model ++ flowButtons)
                |> List.map (\e -> li [] [ e ])
                |> ul [ class "navi-menu" ]
            ]


pageIndicators : Model -> List (Html Msg)
pageIndicators model =
    List.repeat 4 "(o)"
        |> List.map (\e -> button [] [ text e ])


sectionDisplay : Model -> Html Msg
sectionDisplay model =
    section [] [ text "Show: View - TODO..." ]


editView : Model -> Html Msg
editView model =
    section [ class "view-edit" ]
        [ sectionTop model
        , sectionConfig model
        , sectionFlow model
        , sectionUrl model
        ]


sectionTop : Model -> Html Msg
sectionTop model =
    section [ class "section-top" ]
        [ h1 [] [ textFor TK_App_Name ]
        , h3 []
            [ textFor TK_App_Description
            , button [ class "help-show", hidden model.showHelp, onClick ShowHelp ]
                [ textFor TK_App_Help_Show ]
            ]
        , article [ class "help-content", hidden (not model.showHelp) ]
            [ textFor TK_App_Help_Content ]
        ]


sectionConfig : Model -> Html Msg
sectionConfig model =
    section [ class "section-config" ]
        [ inputFor TK_Edit_Title "vid_title" Title model.title
        , inputFor TK_Edit_Interval "vid_interval" Interval (toString model.interval)
        , inputAreaFor TK_Edit_Pages "vid_pages" Pages model.pages
        ]


sectionFlow : Model -> Html Msg
sectionFlow model =
    section [ class "section-flow" ]
        [ buttonFor TK_Flow_Preview Preview
        , buttonFor TK_Flow_GoToShow GoToShow
        ]


sectionUrl : Model -> Html Msg
sectionUrl model =
    section [ class "section-url" ]
        [ input [ disabled True, defaultValue model.generatedUrl ] []
        , buttonFor TK_Flow_CopyUrl CopyUrl
        ]
