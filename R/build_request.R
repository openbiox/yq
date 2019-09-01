## Main API URL
default_api_url <- "https://www.yuque.com/api/v2"

## Headers to send with each API request
default_send_headers <- c("Accept" = "application/json",
                          "User-Agent" = "https://github.com/ShixiangWang/yunque")

yq_build_request <- function(endpoint = "/user", params = list(),
                             token = NULL, destfile = NULL, overwrite = NULL,
                             send_headers = NULL,
                             api_url = NULL, method = "GET") {

    working <- list(method = method, url = character(), headers = NULL,
                    query = NULL, body = NULL,
                    endpoint = endpoint, params = params,
                    token = token, send_headers = send_headers, api_url = api_url,
                    dest = destfile, overwrite = overwrite)

    working <- yq_set_verb(working)
    working <- yq_set_endpoint(working)
    working <- yq_set_query(working)
    working <- yq_set_body(working)
    working <- yq_set_headers(working)
    working <- yq_set_url(working)
    working <- yq_set_dest(working)
    working[c("method", "url", "headers", "query", "body", "dest")]

}
