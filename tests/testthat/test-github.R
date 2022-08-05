# To recreate the stored responses delete the 'gh_api_response' directory
# recursively and re-run these tests

with_mock_dir("gh_api_response", {

  test_that("github_api is class github_api", {
    expect_equal(
      class(github_api("repos/Rapporteket/sship/branches", proxy_url = "")),
      "github_api"
    )
  })

  test_that("github_api provides an error when response is not json", {
    expect_error(github_api("/zen"))
  })

  test_that("github_api fun provides an error for none existing endpoint", {
    expect_error(github_api("none/existent/endpoint"), regexp = "404")
  })

  test_that("rates can be reported", {
    expect_equal(rate_limit()$path, "/rate_limit")
  })

  test_that("a useful value from the api can be returned", {
    expect_true("main" %in% gh("repos/Rapporteket/sship/branches")$content$name)
  })

})


# To recreate the stored responses delete the 'gh_api_response_overrated'
# directory recursively and re-run these tests. They will fail initially, so
# manually edit gh_api_response_overrated/api.github.com/rate_limit.json and set
# 'remaining' to 0

with_mock_dir("gh_api_response_overrated", {
  test_that("gh function ends gracefully when api allowance is exceeded", {
    expect_message(gh("repos/Rapporteket/sship/branches"))
    expect_null(gh("repos/Rapporteket/sship/branches"))
  })
})

test_that("helper function handles GITHUB_PAT env var", {
  with_envvar(
    new = c("GITHUB_PAT" = ""), {
      expect_null(env_pat(NULL))
      expect_equal(env_pat("PAT"), "PAT")
    }
  )
  with_envvar(
    new = c("GITHUB_PAT" = "123"), {
      expect_equal(env_pat(NULL), "123")
      expect_equal(env_pat("PAT"), "PAT")
    }
  )
})
