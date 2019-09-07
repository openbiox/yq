show_table = function(data, justify = "left", caption = NULL, wrap_width = 15, ...) {
    data = data %>%
        dplyr::mutate_if(is.character, ~stringr::str_wrap(., width = wrap_width))
    pander::pandoc.table(data, justify = justify,
                         plain.ascii = TRUE,
                         caption = caption,
                         row.names = FALSE, ...)
}
