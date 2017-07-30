module Translations exposing (TranslationKey(..), translate, translateHelpFor)


type TranslationKey
    = TK_App_Name
    | TK_App_Description
    | TK_App_ShowHelp
    | TK_Edit_Title
    | TK_Edit_Interval
    | TK_Edit_Pages
    | TK_Edit_CopyUrl
    | TK_Edit_Preview
    | TK_Edit_GoToShow


translate : TranslationKey -> String
translate key =
    case key of
        TK_App_Name ->
            "Carouselm"

        TK_App_Description ->
            "[TODO] Page description"

        TK_App_ShowHelp ->
            "show help"

        TK_Edit_Title ->
            "Carousel's title:"

        TK_Edit_Interval ->
            "Changes' interval:"

        TK_Edit_Pages ->
            "Pages (single URL per line):"

        TK_Edit_CopyUrl ->
            "Copy"

        TK_Edit_Preview ->
            "Preview configuration"

        TK_Edit_GoToShow ->
            "Go to Show"


translateHelpFor : TranslationKey -> Maybe String
translateHelpFor key =
    case key of
        TK_App_Description ->
            Just "TODO - TK_App_Description"

        TK_Edit_Title ->
            Just "TODO - TK_Edit_Title"

        TK_Edit_Interval ->
            Just "TODO - TK_Edit_Interval"

        TK_Edit_Pages ->
            Just "TODO - TK_Edit_Pages"

        TK_Edit_CopyUrl ->
            Just "TODO - TK_Edit_CopyUrl"

        TK_Edit_Preview ->
            Just "TODO - TK_Edit_Preview"

        TK_Edit_GoToShow ->
            Just "TODO - TK_Edit_GoToShow"

        _ ->
            Nothing
