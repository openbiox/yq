#' Return the local user's YuQue Personal Access Token (PAT)
#'
#' You can read more about PATs here:
#' <https://www.yuque.com/yuque/developer/api#785a3731>
#' and you can access your PATs here (if logged in to YuQue):
#' <https://www.yuque.com/settings>.
#'
#' Currently it consults the `YUQUE_TOKEN`
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
    c("X-Auth-Token" = token)
  } else {
    character()
  }
}
