module Main exposing (..)

import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Controls exposing (..)
import State
import State.Parser as Parser
import State.Provider as Provider
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
    { inputs : Parser.InputState
    , stateData : State.Data
    , showHelp : Bool
    , shareUrl : String
    }


type alias InputsSetter =
    Parser.InputState -> Parser.InputState


model : Model
model =
    let
        stateData =
            State.initialData

        emptyInputs =
            Parser.InputState "" "" ""
    in
        Model emptyInputs stateData False ""
            |> withState stateData


withState : State.Data -> Model -> Model
withState data model =
    Model
        (Parser.unparse data)
        data
        model.showHelp
        (generateUrl data)


generateUrl : State.Data -> String
generateUrl data =
    case
        State.showAppFor data
            |> Provider.storeInString
    of
        Err error ->
            error

        Ok url ->
            -- TODO : Find current host name - Base URL.
            "https://example.com/" ++ url



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
            (\inputs -> { inputs | title = txt })
                |> updateInputs model

        Interval txt ->
            (\inputs -> { inputs | interval = txt })
                |> updateInputs model

        Pages txt ->
            (\inputs -> { inputs | pages = txt })
                |> updateInputs model

        ShowHelp ->
            { model | showHelp = True }

        Preview ->
            model

        CopyUrl ->
            Debug.crash "Not yet implemented."

        GoToShow ->
            model

        GoToEdit ->
            model

        GoToAbout ->
            model


updateInputs : Model -> InputsSetter -> Model
updateInputs model setter =
    let
        newInputs =
            setter model.inputs

        newUrl =
            -- TODO : Make better validation:
            makeShareUrl newInputs
    in
        { model
            | inputs = newInputs
            , shareUrl = newUrl
        }


makeShareUrl : Parser.InputState -> String
makeShareUrl inputs =
    case Parser.parse inputs of
        Err errors ->
            toString errors

        Ok data ->
            generateUrl data



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
        [ inputFor TK_Edit_Title "vid_title" Title model.inputs.title
        , inputFor TK_Edit_Interval "vid_interval" Interval model.inputs.interval
        , inputAreaFor TK_Edit_Pages "vid_pages" Pages model.inputs.pages
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
        [ input [ readonly True, defaultValue model.shareUrl ] []
        , buttonFor TK_Flow_CopyUrl CopyUrl
        ]
