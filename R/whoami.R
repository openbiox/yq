#' Info on current YuQue user and token
#'
#' Reports basic profile for the current authenticated user.
#'
#' Get a personal access token for the YuQue API from
#' \url{https://www.yuque.com/settings} and select the scopes necessary for
#' your planned tasks. The \code{repo} scope, for example, is one many are
#' likely to need. The token itself is a string of 40 letters and digits. You
#' can store it any way you like and provide explicitly via the \code{.token}
#' argument to \code{\link{yq}()}.
#'
#' However, many prefer to define an environment variable \code{YUQUE_TOKEN}
#' with this value in their \code{.Renviron} file. Add a
#' line that looks like this, substituting your PAT:
#'
#' \preformatted{
#' YUQUE_TOKEN=8c70fd8419398999c9ac5bacf3192882193cadf2
#' }
#'
#' Put a line break at the end! If you're using an editor that shows line
#' numbers, there should be (at least) two lines, where the second one is empty.
#' Restart R for this to take effect. Call \code{yq_whoami()} to confirm
#' success.
#'
#' To get complete information on the authenticated user, call
#' \code{yq("/users/your_login_name")}.
#'
#' @inheritParams yq
#'
#' @return a `data.frame`
#' @export
#'
#' @examples
#' \dontrun{
#' yq_whoami()
#'
#' }
yq_whoami <- function(.token = NULL, .api_url = NULL, .send_headers = NULL) {
  .token <- .token %||% yq_token()
  if (isTRUE(.token == "")) {
    message(
      "No personal access token (PAT) available.\n",
      "Obtain a PAT from here after you login in:\n",
      "https://www.yuque.com/settings/\n",
      "For more on what to do with the PAT, see ?yq_whoami."
    )
    return(invisible(NULL))
  }
  res <- yq(
    endpoint = "/user", .token = .token,
    .api_url = .api_url, .send_headers = .send_headers
  )

  if (res$status_code != 200) {
    stop("Status code: ", res$status_code, ", please check token or internet.", call. = FALSE)
  } else {
    content = res %>% content()
    res = list(
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
      limits = res$headers$`x-ratelimit-remaining`
    )
  }

  nch = 20
  lapply(names(res), function(x) {
    x2 = paste0(x, paste(rep(" ", nch - nchar(x)), collapse = ""))
    message(x2, ": ", res[[x]])
    invisible(0)
  })
  invisible(res)
}

obfuscate <- function(x, first = 2, last = 0) {
  paste0(
    substr(x, start = 1, stop = first),
    "...",
    substr(x, start = nchar(x) - last + 1, stop = nchar(x))
  )
}
