## functions to retrieve request elements
## possibly consult an env var or combine with a built-in default

#' Return the local user's GitHub Personal Access Token (PAT)
#'
#' You can read more about PATs here:
#' <https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/>
#' and you can access your PATs here (if logged in to GitHub):
#' <https://github.com/settings/tokens>.
#'
#' Currently it consults the `GITHUB_PAT` and `GITHUB_TOKEN`
#' environment variables, in this order.
#'
#' @return A string, with the token, or a zero length string scalar,
#' if no token is available.
#'
#' @export

yq_token <- function() {
    Sys.getenv("YUQUE_TOKEN", unset = "")
}

yq_auth <- function(token) {
    if (isTRUE(token != "")) {
        c("Authorization" = paste("token", token))
    } else {
        character()
    }
}

yq_send_headers <- function(headers = NULL) {
    modify_vector(default_send_headers, headers)
}
