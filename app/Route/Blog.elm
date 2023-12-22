module Route.Blog exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import BackendTask.Custom
import Element exposing (Element, fill, height, px, width)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html
import Json.Decode as Decode
import Json.Encode as Encode
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Post exposing (Post)
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import UrlPath
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    { posts : List Post
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    BackendTask.succeed Data
        |> BackendTask.andMap
            (BackendTask.Custom.run "posts"
                Encode.null
                (Decode.list Post.decoder)
                |> BackendTask.allowFatal
            )


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = [ "images", "icon-png.png" ] |> UrlPath.join |> Pages.Url.fromPath
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Welcome to elm-pages!"
        , locale = Nothing
        , title = "elm-pages is running"
        }
        |> Seo.website


postView : Post -> Element msg
postView post =
    Element.row []
        [ Route.Blog__Slug_ { slug = post.slug }
            |> Route.link []
                [ Html.text post.title
                ]
            |> Element.html
        ]


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app shared =
    { title = "Renters Union Nashville | Blog"
    , body =
        [ Element.paragraph [] [ Element.text "Posts" ]
        , app.data.posts
            |> List.map postView
            |> Element.column [ width fill, height (px 100) ]
        ]
    }
