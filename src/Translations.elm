module Translations exposing (TraKey(..), translate, translateHelp)


type TraKey
    = TK_App_Name
    | TK_App_Description
    | TK_App_Help_Show
    | TK_App_Help_Content
    | TK_Edit_Title
    | TK_Edit_Interval
    | TK_Edit_Pages
    | TK_Flow_Preview
    | TK_Flow_GoToShow
    | TK_Edit_CopyUrl


translate : TraKey -> String
translate key =
    case key of
        TK_App_Name ->
            "Carouselm"

        TK_App_Description ->
            "[TODO] Page description"

        TK_App_Help_Show ->
            "show help"

        TK_App_Help_Content ->
            "[TODO] Help content"

        TK_Edit_Title ->
            "Carousel's title:"

        TK_Edit_Interval ->
            "Changes' interval [ms]:"

        TK_Edit_Pages ->
            "Pages (single URL per line):"

        TK_Flow_Preview ->
            "Preview configuration"

        TK_Flow_GoToShow ->
            "Go to Show"

        TK_Edit_CopyUrl ->
            "Copy"


translateHelp : TraKey -> Maybe String
translateHelp key =
    case key of
        TK_Edit_Title ->
            Just "TODO - TK_Edit_Title"

        TK_Edit_Interval ->
            Just "TODO - TK_Edit_Interval"

        TK_Edit_Pages ->
            Just "TODO - TK_Edit_Pages"

        TK_Flow_Preview ->
            Just "TODO - TK_Flow_Preview"

        TK_Flow_GoToShow ->
            Just "TODO - TK_Edit_GoToShow"

        TK_Edit_CopyUrl ->
            Just "TODO - TK_Edit_CopyUrl"

        _ ->
            Nothing
