module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import State exposing (..)
import Translations exposing (..)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


type alias Model =
    { title : String
    , interval : Int
    , pages : String
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
        Model
            initial.title
            initialInterval
            initialPages


type Msg
    = Title String
    | Interval String
    | Pages String
    | CopyUrl
    | Preview
    | GoToShow


update : Msg -> Model -> Model
update msg model =
    case msg of
        Title txt ->
            { model | title = txt }

        Interval val ->
            let
                parsed =
                    String.toInt val
                        |> Result.withDefault -42
            in
                { model | interval = parsed }

        Pages txt ->
            { model | pages = txt }

        CopyUrl ->
            model

        Preview ->
            model

        GoToShow ->
            model


view : Model -> Html Msg
view model =
    div [] [ showPreview model, editView model ]


text : TranslationKey -> Html Msg
text key =
    translate key
        |> Html.text


labelFor : TranslationKey -> String -> Html Msg
labelFor key inputId =
    let
        helpIcon txt =
            span [ title txt ] [ Html.text "(?)" ]

        labelContent =
            case translateHelpFor key of
                Just helpTxt ->
                    [ text key, helpIcon helpTxt ]

                Nothing ->
                    [ text key ]
    in
        label [ for inputId ] labelContent


buttonFor : TranslationKey -> Msg -> Html Msg
buttonFor key msg =
    let
        buttonAttr =
            case translateHelpFor key of
                Just helpTxt ->
                    [ title helpTxt ]

                Nothing ->
                    []

        buttonContent =
            [ text key ]
    in
        button buttonAttr buttonContent


editView : Model -> Html Msg
editView model =
    div []
        [ h1 [] [ text TK_App_Name ]
        , h3 [] [ text TK_App_Description ]
        , text TK_App_ShowHelp
        , hr [] []
        , div []
            [ labelFor TK_Edit_Title "title"
            , input [ id "title", type_ "text", required True, onInput Title, defaultValue model.title ] []
            ]
        , div []
            [ labelFor TK_Edit_Interval "interval"
            , input [ id "interval", type_ "text", required True, onInput Interval, defaultValue (toString model.interval) ] []
            ]
        , div []
            [ labelFor TK_Edit_Pages "pages"
            , textarea [ id "pages", required True, onInput Pages, defaultValue model.pages ] []
            ]
        , hr [] []
        , div []
            [ input [ disabled True, defaultValue "TODO. Generated URL..." ] []
            , buttonFor TK_Edit_CopyUrl CopyUrl
            ]
        , div []
            [ buttonFor TK_Edit_Preview Preview
            , buttonFor TK_Edit_GoToShow GoToShow
            ]
        ]


showPreview : Model -> Html Msg
showPreview model =
    div [] [ Html.text "TODO..." ]
