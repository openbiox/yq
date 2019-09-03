parse_user_info = function(response, show = TRUE) {
    stopifnot(inherits(response, "response"))

    if (response$status_code != 200) {
        stop("Status code: ", response$status_code, ", please check token or internet.", call. = FALSE)
    } else {
        ct = response %>% content()
        ct = ct$data
        response = list(
            type = ct$type,
            id = ct$id,
            login = ct$login,
            name = ct$name,
            description = ct$description,
            books_count = ct$books_count,
            public_books_count = ct$public_books_count,
            followers_count = ct$followers_count,
            following_count = ct$following_count,
            created_at = ct$created_at,
            updated_at = ct$updated_at,
            limits = response$headers$`x-ratelimit-remaining`
        )
    }


    if (show) {
        nch = 20
        lapply(names(response), function(x) {
            x2 = paste0(x, paste(rep(" ", nch - nchar(x)), collapse = ""))
            message(x2, ": ", response[[x]])
        })
    }

    response
}


parse_group_info = function(response, verbose = c("less", "all")) {
    #// TODO: how to reduce query time?
    #// I mean user can use features like ls and ll but only query once
    stopifnot(inherits(response, "response"))

    if (response$status_code != 200) {
        stop("Status code: ", response$status_code, ", please check token or internet.", call. = FALSE)
    } else {
        ct = response %>% content()
        ct = ct$data

    }

    suppressWarnings(ct <- ct %>% data.table::rbindlist(fill = TRUE))
    ct = ct %>%
        dplyr::as_tibble()

    verbose = match.arg(verbose)
    if (verbose == "less") {
        message(paste(ct$name, collapse = " "))
    } else {

    }

    ct
}
