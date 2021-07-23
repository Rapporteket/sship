test_that("github_api is class githubApi", {
  expect_equal(
    class(github_api("repos/Rapporteket/sship/branches", proxy_url = "")),
    "github_api"
  )
})

test_that("github_api fun provides an error for none existing endpoint", {
  expect_error(github_api("none/existent/endpoint"), regexp = "404")
})
