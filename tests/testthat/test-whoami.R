test_that("token and whoami works", {
    token = yq_token()
  if (identical(token, "")) {
    expect_message(yq_whoami())
  }
})
