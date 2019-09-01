## Main API URL
default_api_url <- "https://www.yuque.com/api/v2"

## Headers to send with each API request
default_send_headers <- c(
  "Accept" = "application/json",
  "User-Agent" = "https://github.com/ShixiangWang/yunque"
)

## yq_set_*(x)
## x = a list in which we build up an httr request
## x goes in, x comes out, possibly modified

yq_set_verb <- function(x) {
  if (!nzchar(x$endpoint)) {
    return(x)
  }

  # No method defined, so use default
  if (grepl("^/", x$endpoint) || grepl("^http", x$endpoint)) {
    return(x)
  }

  x$method <- gsub("^([^/ ]+)\\s+.*$", "\\1", x$endpoint)
  stopifnot(x$method %in% c("GET", "POST", "PATCH", "PUT", "DELETE"))
  x$endpoint <- gsub("^[A-Z]+ ", "", x$endpoint)
  x
}

yq_set_endpoint <- function(x) {
  params <- x$params
  if (!grepl(":", x$endpoint) || length(params) == 0L || has_no_names(params)) {
    return(x)
  }

  named_params <- which(has_name(params))
  done <- rep_len(FALSE, length(params))
  endpoint <- endpoint2 <- x$endpoint

  for (i in named_params) {
    n <- names(params)[i]
    p <- params[[i]][1]
    endpoint2 <- gsub(paste0(":", n, "\\b"), p, endpoint)
    if (endpoint2 != endpoint) {
      endpoint <- endpoint2
      done[i] <- TRUE
    }
  }

  x$endpoint <- endpoint
  x$params <- x$params[!done]
  x$params <- cleanse_names(x$params)
  x
}

yq_set_query <- function(x) {
  params <- x$params
  if (x$method != "GET" || length(params) == 0L) {
    return(x)
  }
  stopifnot(all(has_name(params)))
  x$query <- params
  x$params <- NULL
  x
}

yq_set_body <- function(x) {
  if (length(x$params) == 0L) {
    return(x)
  }
  if (x$method == "GET") {
    warning("This is a 'GET' request and unnamed parameters are being ignored.")
    return(x)
  }
  x$body <- toJSON(x$params, auto_unbox = TRUE)
  x
}

yq_set_headers <- function(x) {
  auth <- yq_auth(x$token %||% yq_token())
  send_headers <- yq_send_headers(x$send_headers)
  x$headers <- c(send_headers, auth)
  x
}

yq_set_url <- function(x) {
  if (grepl("^https?://", x$endpoint)) {
    x$url <- URLencode(x$endpoint)
  } else {
    api_url <- x$api_url %||% Sys.getenv("YuQue_API_URL", unset = default_api_url)
    x$url <- URLencode(paste0(api_url, x$endpoint))
  }

  x
}

#' @importFrom httr write_disk write_memory
yq_set_dest <- function(x) {
  if (is.null(x$dest)) {
    x$dest <- write_memory()
  } else {
    x$dest <- write_disk(x$dest, overwrite = x$overwrite)
  }
  x
}


yq_send_headers <- function(headers = NULL) {
  modify_vector(default_send_headers, headers)
}
