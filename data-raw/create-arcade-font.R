
suppressPackageStartupMessages({
  library(dplyr)
  library(purrr)
})

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Each pair of digits describes a point i.e. "00" is the point (0, 0)
# Points are separated by a space for readability
# Strokes within a glyph are separaed by ":"
# Font is defined on an 9x9 grid with x and y coords in the range [0,9]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arcode_font_point_sets <- list(
  A   = "00 06 48 86 80 :  03 83",
  B   = "00 08 58 76 54 04 :  64 82 60 00",
  C   = "88 08 00 80",
  D   = "00 08 58 85 83 50 00",
  E   = "88 08 00 80 :  04 64",
  F   = "88 08 00 :  04 64",
  G   = '88 08 00 80 83 43',
  H   = '00 08 :  80 88 :  04 84',
  I   = '00 80 :  08 88 :  40 48',
  J   = '88 80 40 03',
  K   = '00 08 :  88 04 80',
  L   = '08 00 80',
  M   = '00 08 45 88 80',
  N   = '00 08 80 88',
  O   = '00 80 88 08 00',
  P   = '00 08 88 84 04',
  Q   = '00 08 88 83 40 00 :  43 80',
  R   = '00 08 88 84 04 80',
  S   = '00 80 84 04 08 88',
  T   = '08 88 :  40 48',
  U   = '08 00 80 88',
  V   = '08 40 88',
  W   = '08 00 43 80 88',
  X   = '00 88 :  08 80',
  Y   = '08 45 88 :  45 40',
  Z   = '08 88 00 80',
  `0` = '00 80 88 08 00',
  `1` = '00 80 :  40 48 26',
  `2` = '08 88 84 04 00 80',
  `3` = '08 88 80 00 :  04 84',
  `4` = '08 04 84 :  88 80',
  `5` = '00 80 84 04 08 88',
  `6` = '08 00 80 84 04',
  `7` = '08 88 80',
  `8` = '00 08 88 80 00 :  04 84',
  `9` = '80 88 08 04 84',
  `.` = '00 01 11 10 00',
  `,` = '01 02 12 11 01 :  11 00',
  `-` = '14 74',
  ` ` = '00',
  `=` = '13 73 :  15 75',
  `!` = '00 01 11 10 00 :  03 08 18 13 03',
  `?` = '06 08 88 84 44 40',
  `:` = '02 03 13 12 02 :  05 06 16 15 05',
  `;` = '02 03 13 12 02 :  05 06 16 15 05 :  1 2 0 0',
  `#` = '03 83 :  05 85 :  30 38 :  50 58',
  `'` = '07 08 18 17 07 :  17 05',
  `"` = '07 08 18 17 07 :  17 05 :  27 28 38 37 27 :  37 25',
  `[` = '28 08 00 20',
  `]` = '08 28 20 00',
  `(` = '28 04 20',
  `)` = '08 24 00',
  `{` = '28 04 20',
  `}` = '08 24 00',
  `$` = '01 81 84 04 07 87 :  40 48',
  `+` = '41 47 :  14 74',
  `/` = '00 88',
  `*` = '41 47 :  14 74 :  22 66 :  26 62',
  `%` = '00 88 :  18 28 27 17 18 :  70 71 61 60 70',
  `^` = '26 48 66',
  `|` = '40 48',
  `_` = '00 80',
  `<` = '87 04 81',
  `>` = '07 84 01',
  `&` = '80 47 58 67 21 30 60 82',
  `@` = '71 60 20 02 06 28 68 86 84 62 22 24 36 66 62'
)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @param points_string e.g. "00 34 12 56"
# @return data.frame of x,y coordinates
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
points_to_df <- function(points_string) {
  points <- gsub("\\s+", '', points_string)
  points <- strsplit(points, '')[[1]]
  points <- as.integer(points)
  res <- as.data.frame(t(matrix(points, nrow = 2)))
  names(res) <- c('x', 'y')
  res$idx <- seq(nrow(res))
  res
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @param point_set colon-separated string containing 1 or more point strings
#        e.g. "12 34 : 45 56"
# @return data.frame with x, y and stroke number
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
point_set_to_df <- function(point_set) {
  points_strings <- strsplit(point_set, ":")[[1]]

  dfs <- lapply(points_strings, points_to_df)
  dplyr::bind_rows(dfs, .id = 'stroke')
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# @param point_sets named list of points sets. One point set for each glyph
# @return data.frame with x, y, stroke and letter
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
point_sets_to_df <- function(point_sets) {
  dfs <- lapply(point_sets, point_set_to_df)
  dplyr::bind_rows(dfs, .id = 'letter')
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create point set for the arcade font and save in package as external data
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arcade_df <- point_sets_to_df(arcode_font_point_sets)
arcade_df <- as_tibble(arcade_df)

usethis::use_data(arcade_df, internal = FALSE, overwrite = TRUE)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Test Plot of all chars
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
})


ggplot(arcade_df, aes(x, y)) +
  # geom_point() +
  geom_path(aes(group=stroke)) +
  coord_fixed() +
  theme_void() +
  facet_wrap(~letter)









