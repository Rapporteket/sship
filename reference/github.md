# Make calls to the github API

Provides a structured list of the specified resource from the the github
API.

## Usage

``` r
gh(path, proxy_url = NULL, token = NULL)

github_api(path, proxy_url = NULL, token = NULL)

rate_limit(proxy_url = NULL, token = NULL)
```

## Arguments

- path:

  Character string with path to the API resource.

- proxy_url:

  Character string defining a network proxy in the form host:port.
  Default is NULL in which case the API call will not use a proxy.

- token:

  Character string holding a github personal access token (PAT) to be
  used for requests that requires authorization. Default value is NULL
  in which case the request will be unauthorized unless PAT can be
  obtained from the environmental variable GITHUB_PAT.

## Value

A list of class github_api containing the parsed content, API resource
path and the response object. For `rate_limit()` the path is always
"/rate_limit" and can hence be used to detect if the limit is exceeded
(without being counted as a request itself). If the allowed API rate is
exceeded `gh()` will return a message stating the fact and simple
suggestions on how to remedy the problem.

## Details

For most use cases only `gh()` will be relevant. The helper function
`github_api()` do the actual lifting while `rate_limit()` handles API
rate limits.

## Examples

``` r
## Get all branches of a repository. If the api rate limit is exceeded this
## function will return NULL and an informative message
gh("repos/Rapporteket/sship/branches")
#> $content
#>       name                               commit.sha
#> 1 gh-pages f7c7ae3960a49fd2080418216d8d20d33e1af4a4
#> 2     main d8a6299d4b522f7d3fa4871f7c9fcdbba4c2c6e6
#>                                                                                        commit.url
#> 1 https://api.github.com/repos/Rapporteket/sship/commits/f7c7ae3960a49fd2080418216d8d20d33e1af4a4
#> 2 https://api.github.com/repos/Rapporteket/sship/commits/d8a6299d4b522f7d3fa4871f7c9fcdbba4c2c6e6
#>   protected
#> 1     FALSE
#> 2      TRUE
#> 
#> $path
#> [1] "repos/Rapporteket/sship/branches"
#> 
#> $response
#> Response [https://api.github.com/repos/Rapporteket/sship/branches]
#>   Date: 2026-08-28 13:00
#>   Status: 200
#>   Content-Type: application/json; charset=utf-8
#>   Size: 400 B
#> 
#> 
#> attr(,"class")
#> [1] "github_api"

## helper functions that will normally not be used
github_api("/rate_limit")
#> $content
#> $content$resources
#> $content$resources$core
#> $content$resources$core$limit
#> [1] 15000
#> 
#> $content$resources$core$used
#> [1] 0
#> 
#> $content$resources$core$remaining
#> [1] 15000
#> 
#> $content$resources$core$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$search
#> $content$resources$search$limit
#> [1] 30
#> 
#> $content$resources$search$used
#> [1] 0
#> 
#> $content$resources$search$remaining
#> [1] 30
#> 
#> $content$resources$search$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$graphql
#> $content$resources$graphql$limit
#> [1] 10000
#> 
#> $content$resources$graphql$used
#> [1] 0
#> 
#> $content$resources$graphql$remaining
#> [1] 10000
#> 
#> $content$resources$graphql$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$integration_manifest
#> $content$resources$integration_manifest$limit
#> [1] 5000
#> 
#> $content$resources$integration_manifest$used
#> [1] 0
#> 
#> $content$resources$integration_manifest$remaining
#> [1] 5000
#> 
#> $content$resources$integration_manifest$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$source_import
#> $content$resources$source_import$limit
#> [1] 100
#> 
#> $content$resources$source_import$used
#> [1] 0
#> 
#> $content$resources$source_import$remaining
#> [1] 100
#> 
#> $content$resources$source_import$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$code_scanning_autofix
#> $content$resources$code_scanning_autofix$limit
#> [1] 10
#> 
#> $content$resources$code_scanning_autofix$used
#> [1] 0
#> 
#> $content$resources$code_scanning_autofix$remaining
#> [1] 10
#> 
#> $content$resources$code_scanning_autofix$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$actions_runner_registration
#> $content$resources$actions_runner_registration$limit
#> [1] 10000
#> 
#> $content$resources$actions_runner_registration$used
#> [1] 0
#> 
#> $content$resources$actions_runner_registration$remaining
#> [1] 10000
#> 
#> $content$resources$actions_runner_registration$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$scim
#> $content$resources$scim$limit
#> [1] 15000
#> 
#> $content$resources$scim$used
#> [1] 0
#> 
#> $content$resources$scim$remaining
#> [1] 15000
#> 
#> $content$resources$scim$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$dependency_snapshots
#> $content$resources$dependency_snapshots$limit
#> [1] 100
#> 
#> $content$resources$dependency_snapshots$used
#> [1] 0
#> 
#> $content$resources$dependency_snapshots$remaining
#> [1] 100
#> 
#> $content$resources$dependency_snapshots$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$dependency_sbom
#> $content$resources$dependency_sbom$limit
#> [1] 200
#> 
#> $content$resources$dependency_sbom$used
#> [1] 0
#> 
#> $content$resources$dependency_sbom$remaining
#> [1] 200
#> 
#> $content$resources$dependency_sbom$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$audit_log
#> $content$resources$audit_log$limit
#> [1] 1750
#> 
#> $content$resources$audit_log$used
#> [1] 0
#> 
#> $content$resources$audit_log$remaining
#> [1] 1750
#> 
#> $content$resources$audit_log$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$audit_log_streaming
#> $content$resources$audit_log_streaming$limit
#> [1] 15
#> 
#> $content$resources$audit_log_streaming$used
#> [1] 0
#> 
#> $content$resources$audit_log_streaming$remaining
#> [1] 15
#> 
#> $content$resources$audit_log_streaming$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$code_search
#> $content$resources$code_search$limit
#> [1] 10
#> 
#> $content$resources$code_search$used
#> [1] 0
#> 
#> $content$resources$code_search$remaining
#> [1] 10
#> 
#> $content$resources$code_search$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$copilot_usage_records
#> $content$resources$copilot_usage_records$limit
#> [1] 1750
#> 
#> $content$resources$copilot_usage_records$used
#> [1] 0
#> 
#> $content$resources$copilot_usage_records$remaining
#> [1] 1750
#> 
#> $content$resources$copilot_usage_records$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$enterprise_token_inventory
#> $content$resources$enterprise_token_inventory$limit
#> [1] 1750
#> 
#> $content$resources$enterprise_token_inventory$used
#> [1] 0
#> 
#> $content$resources$enterprise_token_inventory$remaining
#> [1] 1750
#> 
#> $content$resources$enterprise_token_inventory$reset
#> [1] 1787925657
#> 
#> 
#> 
#> $content$rate
#> $content$rate$limit
#> [1] 15000
#> 
#> $content$rate$used
#> [1] 0
#> 
#> $content$rate$remaining
#> [1] 15000
#> 
#> $content$rate$reset
#> [1] 1787925657
#> 
#> 
#> 
#> $path
#> [1] "/rate_limit"
#> 
#> $response
#> Response [https://api.github.com/rate_limit]
#>   Date: 2026-08-28 13:00
#>   Status: 200
#>   Content-Type: application/json; charset=utf-8
#>   Size: 1.24 kB
#> 
#> 
#> attr(,"class")
#> [1] "github_api"
rate_limit()
#> $content
#> $content$resources
#> $content$resources$core
#> $content$resources$core$limit
#> [1] 15000
#> 
#> $content$resources$core$used
#> [1] 0
#> 
#> $content$resources$core$remaining
#> [1] 15000
#> 
#> $content$resources$core$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$search
#> $content$resources$search$limit
#> [1] 30
#> 
#> $content$resources$search$used
#> [1] 0
#> 
#> $content$resources$search$remaining
#> [1] 30
#> 
#> $content$resources$search$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$graphql
#> $content$resources$graphql$limit
#> [1] 10000
#> 
#> $content$resources$graphql$used
#> [1] 0
#> 
#> $content$resources$graphql$remaining
#> [1] 10000
#> 
#> $content$resources$graphql$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$integration_manifest
#> $content$resources$integration_manifest$limit
#> [1] 5000
#> 
#> $content$resources$integration_manifest$used
#> [1] 0
#> 
#> $content$resources$integration_manifest$remaining
#> [1] 5000
#> 
#> $content$resources$integration_manifest$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$source_import
#> $content$resources$source_import$limit
#> [1] 100
#> 
#> $content$resources$source_import$used
#> [1] 0
#> 
#> $content$resources$source_import$remaining
#> [1] 100
#> 
#> $content$resources$source_import$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$code_scanning_autofix
#> $content$resources$code_scanning_autofix$limit
#> [1] 10
#> 
#> $content$resources$code_scanning_autofix$used
#> [1] 0
#> 
#> $content$resources$code_scanning_autofix$remaining
#> [1] 10
#> 
#> $content$resources$code_scanning_autofix$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$actions_runner_registration
#> $content$resources$actions_runner_registration$limit
#> [1] 10000
#> 
#> $content$resources$actions_runner_registration$used
#> [1] 0
#> 
#> $content$resources$actions_runner_registration$remaining
#> [1] 10000
#> 
#> $content$resources$actions_runner_registration$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$scim
#> $content$resources$scim$limit
#> [1] 15000
#> 
#> $content$resources$scim$used
#> [1] 0
#> 
#> $content$resources$scim$remaining
#> [1] 15000
#> 
#> $content$resources$scim$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$dependency_snapshots
#> $content$resources$dependency_snapshots$limit
#> [1] 100
#> 
#> $content$resources$dependency_snapshots$used
#> [1] 0
#> 
#> $content$resources$dependency_snapshots$remaining
#> [1] 100
#> 
#> $content$resources$dependency_snapshots$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$dependency_sbom
#> $content$resources$dependency_sbom$limit
#> [1] 200
#> 
#> $content$resources$dependency_sbom$used
#> [1] 0
#> 
#> $content$resources$dependency_sbom$remaining
#> [1] 200
#> 
#> $content$resources$dependency_sbom$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$audit_log
#> $content$resources$audit_log$limit
#> [1] 1750
#> 
#> $content$resources$audit_log$used
#> [1] 0
#> 
#> $content$resources$audit_log$remaining
#> [1] 1750
#> 
#> $content$resources$audit_log$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$audit_log_streaming
#> $content$resources$audit_log_streaming$limit
#> [1] 15
#> 
#> $content$resources$audit_log_streaming$used
#> [1] 0
#> 
#> $content$resources$audit_log_streaming$remaining
#> [1] 15
#> 
#> $content$resources$audit_log_streaming$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$code_search
#> $content$resources$code_search$limit
#> [1] 10
#> 
#> $content$resources$code_search$used
#> [1] 0
#> 
#> $content$resources$code_search$remaining
#> [1] 10
#> 
#> $content$resources$code_search$reset
#> [1] 1787922117
#> 
#> 
#> $content$resources$copilot_usage_records
#> $content$resources$copilot_usage_records$limit
#> [1] 1750
#> 
#> $content$resources$copilot_usage_records$used
#> [1] 0
#> 
#> $content$resources$copilot_usage_records$remaining
#> [1] 1750
#> 
#> $content$resources$copilot_usage_records$reset
#> [1] 1787925657
#> 
#> 
#> $content$resources$enterprise_token_inventory
#> $content$resources$enterprise_token_inventory$limit
#> [1] 1750
#> 
#> $content$resources$enterprise_token_inventory$used
#> [1] 0
#> 
#> $content$resources$enterprise_token_inventory$remaining
#> [1] 1750
#> 
#> $content$resources$enterprise_token_inventory$reset
#> [1] 1787925657
#> 
#> 
#> 
#> $content$rate
#> $content$rate$limit
#> [1] 15000
#> 
#> $content$rate$used
#> [1] 0
#> 
#> $content$rate$remaining
#> [1] 15000
#> 
#> $content$rate$reset
#> [1] 1787925657
#> 
#> 
#> 
#> $path
#> [1] "/rate_limit"
#> 
#> $response
#> Response [https://api.github.com/rate_limit]
#>   Date: 2026-08-28 13:00
#>   Status: 200
#>   Content-Type: application/json; charset=utf-8
#>   Size: 1.24 kB
#> 
#> 
#> attr(,"class")
#> [1] "github_api"
```
