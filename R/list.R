# yq_list_* funs
yq_list_groups = function() {
    auth = get_auth()
    r = yq("/users/:login/groups", login = auth$login, .token = auth$token)
    r = parse_group_info(r)
    invisible(r)
}

yq_list_public_groups = function() {
    r = yq("/groups")
    r = parse_group_info(r)
    invisible(r)
}

yq_list_group_info = function(login) {
    auth = get_auth()
    r = yq("/groups/:login", login = login, .token = auth$token)
    # r = parse_group_info(r)
    # invisible(r)
}
