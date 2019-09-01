yq_make_request <- function(x) {

    method_fun <- list("GET" = GET, "POST" = POST, "PATCH" = PATCH,
                       "PUT" = PUT, "DELETE" = DELETE)[[x$method]]
    if (is.null(method_fun)) stop("Unknown HTTP verb", call. = FALSE)

    raw <- do.call(method_fun,
                   compact(list(url = x$url, query = x$query, body = x$body,
                                add_headers(x$headers), x$dest)))
    raw
}
