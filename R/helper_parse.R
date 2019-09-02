parse_user_info = function(response) {
    stopifnot(inherits(response, "response"))

    if (response$status_code != 200) {
        stop("Status code: ", response$status_code, ", please check token or internet.", call. = FALSE)
    } else {
        content = response %>% content()
        response = list(
            type = content$data$type,
            id = content$data$id,
            login = content$data$login,
            name = content$data$name,
            description = content$data$description,
            books_count = content$data$books_count,
            public_books_count = content$data$public_books_count,
            followers_count = content$data$followers_count,
            following_count = content$data$following_count,
            created_at = content$data$created_at,
            updated_at = content$data$updated_at,
            limits = response$headers$`x-ratelimit-remaining`
        )
    }

    nch = 20
    lapply(names(response), function(x) {
        x2 = paste0(x, paste(rep(" ", nch - nchar(x)), collapse = ""))
        message(x2, ": ", response[[x]])
        invisible(0)
    })
}
