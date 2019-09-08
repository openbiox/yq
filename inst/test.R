auth  = get_auth()
r = yq("/groups/:login/users", login = "biotrainee", .token = auth$token)
r %>% content()

yq_list_group_members(login = "biotrainee")
