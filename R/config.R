# config
.yuque_config_path = "~/.yuque.json"

#' Configure YuQue
#'
#' Ask some questions to user and save configuration to local file.
#'
#' More details see [yq_whoami], [yq_token].
#'
#' @return Nothing.
#' @export
#'
#' @examples
#' \dontrun{
#' if (interactive())
#'   yq_config()
#' }
yq_config = function() {
    config = list()
    config$login = ""
    config$token = ""

    while(config$login == "") {
        config$login = readline("Please type your login name of YuQue: \n(type e to exit) ")
        if (identical(config$login, "")) stop("No name input!", call. = FALSE)
        if (config$login == "e") return(1)
    }

    if (identical(readline("Do you want to input token? \n(type ENTER to proceed) "), "")) {
        config$token = readline("Please type your token: ")
        while(nchar(config$toke) != 40) {
            config$token = readline("Bad token, please re-type: \n(The token shoule be a string of 40)")
        }
    }

    message("Checking if the login name exist...")
    r = yq(paste0("GET /users/", config$login))
    if (status_code(r) != 200) stop("Bad login or internet, please check!", call. = FALSE)

    if (config$token != "") {
        message("Found token, checking it...")
        r =   yq(
            endpoint = "/user", .token = config$token
        )
        if (status_code(r) != 200) stop("Bad token or internet, please check!", call. = FALSE)
        login = content(r)$data$login
        if (login != config$login){
            message("Found the login with your token is ", login, " while you inputed ", config$login)
            if (identical(readline("Do you want to change it? \n(type ENTER to proceed)"), "")) {
                message("Got it.")
                config$login = login
            } else {
                message("OK, I will not change it.")
            }
        }

    }

    message("Saving info to ", .yuque_config_path)
    update_config(config, path = .yuque_config_path)

    message("Done. Enjoy this tool.\n- Shixiang")
}

update_config = function(x, path) {
    if (!file.exists(path)) {
        jsonlite::write_json(x, path = path)
    } else {
        up_config = jsonlite::read_json(path, simplifyVector = TRUE)
        up_names = names(up_config)
        for (i in names(x)) {
            ifelse(i %in% up_names,
                   message("Updating ", i),
                   message("Adding ", i))
            up_config[[i]] = x[[i]]
        }
        jsonlite::write_json(up_config, path = path)
    }

}

#jsonlite::read_json("test.json", simplifyVector = TRUE)
