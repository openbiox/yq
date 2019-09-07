# yq_list_* funs

#' List Information for Group, Repo etc.
#'
#' @param verbose 'all' or 'less', the former will print more messages.
#' @param login a string for login name of YuQue.
#' @return a `list` or `data.frame`
#'
#'
#'

#' @export
#' @rdname yq_list
yq_list_groups = function(verbose = c("less", "all")) {
    auth = get_auth()
    r = yq("/users/:login/groups", login = auth$login, .token = auth$token)
    r = parse_group_info(r, verbose = match.arg(verbose))
    invisible(r)
}

#' @export
#' @rdname yq_list
yq_list_public_groups = function(verbose = c("less", "all")) {
    r = yq("/groups")
    r = parse_group_info(r, verbose = match.arg(verbose))
    invisible(r)
}

#' @export
#' @rdname yq_list
yq_list_group_info = function(login) {
    auth = get_auth()
    r = yq("/groups/:login", login = login, .token = auth$token)
    r = parse_group_detail(r)
    invisible(r)
}
