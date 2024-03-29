#' YuQue API Client
#'
#' Tool to access YuQue.
#'
#' @docType package
#' @name yq
#' @source <https://www.yuque.com/>
NULL

#' Query the YuQue API
#'
#' This is an extremely minimal client. You need to know the API
#' to be able to use this client. All this function does is:
#' \itemize{
#'   \item Try to substitute each listed parameter into
#'     \code{endpoint}, using the \code{:parameter} notation.
#'   \item If a GET request (the default), then add
#'     all other listed parameters as query parameters.
#'   \item If not a GET request, then send the other parameters
#'     in the request body, as JSON.
#'   \item Convert the response to an R list using
#'     \code{jsonlite::fromJSON}.
#' }
#'
#' @param endpoint YuQue API endpoint. Must be one of the following forms:
#'
#'    \itemize{
#'      \item "METHOD path", e.g. "GET /users/shixiangwang"
#'      \item "path", e.g. "/users/shixiangwang".
#'      \item "METHOD url", e.g. "GET https://www.yuque.com/api/v2/users/shixiangwang"
#'      \item "url", e.g. "https://www.yuque.com/api/v2/users/shixiangwang".
#'    }
#'
#'    If the method is not supplied, will use \code{.method}, which defaults
#'    to \code{GET}.
#' @param ... Name-value pairs giving API parameters. Will be matched
#'   into \code{url} placeholders, sent as query parameters in \code{GET}
#'   requests, and in the JSON body of \code{POST} requests.
#' @param .destfile path to write response to disk.  If NULL (default), response will
#'   be processed and returned as an object.  If path is given, response will
#'   be written to disk in the form sent.
#' @param .overwrite if \code{destfile} is provided, whether to overwrite an
#'   existing file.  Defaults to FALSE.
#' @param .token Authentication token. Default to YUQUE_TOKEN
#'   environment variables, in this order if any is set.
#' @param .api_url YuQue API url (default: \url{https://www.yuque.com/api/v2}). Used
#'   if \code{endpoint} just contains a path. Default to YuQue_API_URL
#'   environment variable if set.
#' @param .method HTTP method to use if not explicitly supplied in the
#'    \code{endpoint}.
#' @param .send_headers Named character vector of header field values
#'   (excepting \code{Authorization}, which is handled via
#'   \code{.token}). This can be used to override or augment the
#'   defaults, which are as follows: the \code{Accept} field defaults
#'   to \code{"application/json"} and the
#'   \code{User-Agent} field defaults to
#'   \code{"https://github.com/ShixiangWang/yq"}. This can be used
#'   to, e.g., provide a custom media type, in order to access a
#'   preview feature of the API.
#'
#' @return A \code{response} object from [httr] package, which is also a \code{list}.
#'
#' @importFrom httr content add_headers headers
#'   status_code http_type GET POST PATCH PUT DELETE
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom utils URLencode capture.output
#' @export
#' @seealso \code{\link{yq_whoami}()} for details on YuQue API token
#'   management.
#' @examples
#' # For more details, please read API of 'YuQue'
#' # <https://www.yuque.com/yuque/developer>
#'
#' # User -----------------------------------------
#' ## Information for a user
#' yq("/users/shixiangwang")
#' yq("/users/shixiangwang") %>% headers()     # Obtain headers
#' yq("/users/shixiangwang") %>% status_code() # Obtain status
#' yq("/users/shixiangwang") %>% content()     # Obtain response
#' ## Information for the current authenticated user
#' yq("/user")
#'
#' # Group -----------------------------------------
#' ## List groups of a user
#' yq("/users/shixiangwang/groups")
#' ## Information for a group
#' ## Just treat it like a user
#' yq("/groups/elegant-r")
#'
#' # Repo -------------------------------------------
#' ## List repo of a user or group
#' yq("/users/shixiangwang/repos")
#' yq("/users/elegant-r/repos")
#' ## Information for a repo
#' yq("/repos/shixiangwang/tools")
#'
#' # Doc --------------------------------------------
#' ## List documents of a repo
#' yq("/repos/shixiangwang/tools/docs")
#' ## Information of a document
#' \dontrun{
#' yq("/repos/elegant-r/zfc8ub/docs/krle92")
#' }
#'
yq <- function(endpoint, ..., .token = NULL, .destfile = NULL,
               .overwrite = FALSE, .api_url = NULL, .method = "GET",
               .send_headers = NULL) {
  params <- list(...)

  req <- yq_build_request(
    endpoint = endpoint, params = params,
    token = .token, destfile = .destfile,
    overwrite = .overwrite,
    send_headers = .send_headers,
    api_url = .api_url, method = .method
  )

  yq_make_request(req)
}
