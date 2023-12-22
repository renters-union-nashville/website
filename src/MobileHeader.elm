module MobileHeader exposing (view)

import Colors
import Element exposing (Element, column, fill, link, padding, spacing, width)
import Element.Background as Background
import Element.Font as Font
import Html.Attributes as Attrs
import Route exposing (Route(..))
import UrlPath exposing (UrlPath)


headerLink attrs isActive =
    link
        ([ Element.htmlAttribute <| Attrs.attribute "elm-pages:prefetch" "true"
         , Font.size 20
         , Element.htmlAttribute (Attrs.class "responsive-mobile")
         ]
            ++ (if isActive then
                    [ Font.color Colors.grayFont ]

                else
                    []
               )
            ++ attrs
        )


noPreloadLink attrs =
    link
        ([ Font.size 20
         ]
            ++ attrs
        )


view : { path : UrlPath, route : Maybe Route } -> Element msg
view page =
    column
        [ width fill
        , Font.size 28
        , spacing 10
        , padding 10
        , Background.color (Element.rgb255 255 87 87)
        , Element.htmlAttribute (Attrs.class "responsive-mobile")

        -- , Border.widthEach { top = 0, bottom = 1, left = 0, right = 0 }
        ]
        [ headerLink []
            (page.route == Just Index)
            { url = "/"
            , label = Element.text "WHO WE ARE"
            }

        -- , headerLink []
        --     (page.route == Just Calendar)
        --     { url = "/calendar"
        --     , label = Element.text "CALENDAR"
        --     }
        -- , headerLink []
        --     (page.route == Just Handbook)
        --     { url = "/handbook"
        --     , label = Element.text "HANDBOOK"
        --     }
        -- , headerLink []
        --     (page.route == Just Blog)
        --     { url = "/blog"
        --     , label = Element.text "BLOG"
        --     }
        ]
