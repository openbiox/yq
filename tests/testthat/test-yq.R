test_that("yq works", {
    expect_s3_class(yq("/users/shixiangwang"), "response")
    expect_s3_class(yq("GET /users/shixiangwang"), "response")
    expect_s3_class(yq("https://www.yuque.com/api/v2/users/shixiangwang"), "response")
    expect_s3_class(yq("GET https://www.yuque.com/api/v2/users/shixiangwang"), "response")
    expect_s3_class(yq("/groups/elegant-r"), "response")
    expect_s3_class(yq("/repos/shixiangwang/tools"), "response")
    expect_s3_class(yq("/repos/shixiangwang/tools/docs"), "response")
})
