module Colors exposing (default, grayFont, redFont, white)

import Element exposing (rgb255)


default =
    { largeHeaderFont = rgb255 255 87 87
    , largeHeaderBackground = grayFont
    , mediumHeaderFont = rgb255 255 255 255
    , mediumHeaderBackground = rgb255 255 87 87
    , smallHeaderFont = redFont
    , smallHeaderBackground = rgb255 255 255 255
    , paragraph = grayFont
    }


white =
    rgb255 255 255 255


redFont =
    rgb255 220 47 54


grayFont =
    rgb255 75 75 75
