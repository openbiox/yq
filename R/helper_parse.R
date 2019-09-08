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

    if (is.list(ct[[1]])) {
        suppressWarnings(ct <- ct %>% data.table::rbindlist(fill = TRUE))
    } else {
        ct <- dplyr::bind_cols(ct)
    }

    ct = ct %>%
        dplyr::as_tibble() %>%
        dplyr::rename(
            books = .data$books_count,
            public_books = .data$public_books_count,
            topics = .data$topics_count,
            public_topics = .data$public_topics_count,
            members = .data$members_count
        )

    verbose = match.arg(verbose)
    if (verbose == "less") {
        message(paste(ct$name, collapse = " "))
    } else {
        #// What's the meaning of public here?
        cols2show = c("login", "name", "books", "topics", "members", "description")
        show_table(ct[, cols2show], justify = "left", wrap_width = 20,
                   caption = "Info of Group")
    }
    ct
}

parse_group_detail = function(response) {
    stopifnot(inherits(response, "response"))

    if (response$status_code != 200) {
        stop("Status code: ", response$status_code, ", please check token or internet.", call. = FALSE)
    }

    ability = content(response)$abilities
    ability = dplyr::tibble(
        level = c("overall", "group_user", "repo"),
        read =  c(ability$read, NA, NA),
        create = c(NA, ability$group_user$create, ability$repo$create),
        update = c(ability$update, ability$group_user$update, ability$repo$update),
        destroy = c(ability$destroy, ability$group_user$destroy, ability$repo$destroy)

    )
    res = list()
    res$data = parse_group_info(response, verbose = "all")
    res$ability = ability
    show_table(ability, caption = "Ability to Group")

    res
}

parse_group_member = function(response) {
    stopifnot(inherits(response, "response"))

    if (response$status_code != 200) {
        stop("Status code: ", response$status_code,
             ", please check token or internet or authority.", call. = FALSE)
    } else {
        ct = response %>% content()
        ct = ct$data

    }

    short_info = purrr::map_df(ct, function(x) {
        dplyr::tibble(
            id = x$user$id,
            login = x$user$login,
            name = x$user$name,
            description = ifelse(is.null(x$user$description), NA, x$user$description)
        )
    })

    show_table(short_info, justify = "left", wrap_width = 30,
               caption = "Info of Group Member")

    ct
}

