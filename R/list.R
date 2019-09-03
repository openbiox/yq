# yq_list_* funs
yq_list_groups = function() {
    auth = get_auth()
    yq("/users/:login/groups", login = auth$login, .token = auth$token)
}
