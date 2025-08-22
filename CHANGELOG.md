# Changelog

All notable changes to this project will be documented in this file.

## [8.1.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v8.0.1...v8.1.0) (2025-08-22)


### Features

* Respect the package-lock.json for a NodeJS Lambda function ([#681](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/681)) ([5e4391c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/5e4391c55605d11ac98655a2fd2d6a8f2583d3b6))

## [8.0.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v8.0.0...v8.0.1) (2025-06-25)


### Bug Fixes

* Lower minimum Terraform version to 1.5.7 ([#688](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/688)) ([ab60651](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/ab606514be095d7ad55ebd920069cb090fa39cd5))

## [8.0.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.21.1...v8.0.0) (2025-06-25)


### ⚠ BREAKING CHANGES

* Upgrade AWS provider and min required Terraform version to 6.0 and 1.10 respectively (#687)

### Features

* Upgrade AWS provider and min required Terraform version to 6.0 and 1.10 respectively ([#687](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/687)) ([367e9a2](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/367e9a2c5c7e6a4335fcc7c13c14e54f8e347f9c))

## [7.21.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.21.0...v7.21.1) (2025-06-19)


### Bug Fixes

* Add .NET 8 runtime example ([#685](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/685)) ([d5c657c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/d5c657c96234b1ee352af418243690c297f3f3b2))

## [7.21.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.20.3...v7.21.0) (2025-05-16)


### Features

* Add buildx and multi-stage build support to docker-build module ([#679](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/679)) ([29893ab](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/29893ab17086b6ec45955f1f5d2f1be4f7cf2285))

## [7.20.3](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.20.2...v7.20.3) (2025-05-16)


### Bug Fixes

* Do not expose output from build command in Docker ([#677](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/677)) ([75ee97d](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/75ee97d184231a45bdb8d8398ecccb6f2558d0a5))

## [7.20.2](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.20.1...v7.20.2) (2025-04-09)


### Bug Fixes

* Add aws_partition to support usage of this module in aws-cn and gov ([64433c0](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/64433c096e690b767a8b106b67383edfe8263ba7))

## [7.20.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.20.0...v7.20.1) (2025-01-26)


### Bug Fixes

* Make default tag `terraform-aws-modules` optional ([#657](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/657)) ([685af53](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/685af5370e580a89cee68aeae06bb40dc3257892))

## [7.20.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.19.0...v7.20.0) (2025-01-08)


### Features

* Use inline instead of managed policies ([#615](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/615)) ([394d337](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/394d337450d88aa877ec560cd49080bb8b9a45ba))

## [7.19.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.18.0...v7.19.0) (2025-01-08)


### Features

* Add `cache_from` option in the docker-build module ([#641](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/641)) ([55cdaa6](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/55cdaa68a63413f4ae5724c8b3a09a6b10d72f12))

## [7.18.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.17.1...v7.18.0) (2025-01-08)


### Features

* Allow temp dir for poetry docker builds ([#638](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/638)) ([65ffea2](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/65ffea2cfd99a27b6be3fc3e48482cf0fb821f2f))

## [7.17.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.17.0...v7.17.1) (2025-01-07)


### Bug Fixes

* Rename npm_package_json to npm_requirements ([#621](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/621)) ([4bc61eb](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/4bc61eb58005e149dc1ca87ba79f42b0cba944fd))

## [7.17.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.16.0...v7.17.0) (2024-12-08)


### Features

* Support Event Source Mapping `metrics_config`, `provisioned_poller_config`, and Lambda Recursion Loop ([#649](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/649)) ([002d7ec](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/002d7ec3c9bc3e7a44fac536c3443ba640ff9828))

## [7.16.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.15.0...v7.16.0) (2024-11-26)


### Features

* Radically redesign the build plan form ([#646](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/646)) ([32d8d06](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/32d8d060a660b0ec5702403da1b970118f62a314))

## [7.15.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.14.1...v7.15.0) (2024-11-18)


### Features

* Make `source_path` blocks independent ([#640](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/640)) ([0fdac2e](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/0fdac2ec54fdcd5fd34787f348803000c1e21eb6))

## [7.14.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.14.0...v7.14.1) (2024-11-17)


### Bug Fixes

* Skip broken symlinks on hash computing ([#639](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/639)) ([c28b940](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/c28b940c8b8a8ea8b423728e05883942f5eaf661))

## [7.14.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.13.0...v7.14.0) (2024-10-11)


### Features

* Support lambda function `vpc_config.ipv6_allowed_for_dual_stack` and event source mapping `tags` ([#628](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/628)) ([2a602f9](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/2a602f9a4f76d11005d1dba56d9c966a87553f4e))


### Bug Fixes

* Update CI workflow versions to latest ([#631](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/631)) ([d06718f](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/d06718f605294f59a42ae6e3db70bfd7b9fa35f3))

## [7.13.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.12.0...v7.13.0) (2024-10-05)


### Features

* Support `aws_lambda_event_source_mapping.document_db_event_source_config` ([#626](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/626)) ([5d48199](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/5d481996ed6ef5ce784847b7e5bae1bae1ee8bfd))

## [7.12.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.11.0...v7.12.0) (2024-10-05)


### Features

* Add support for kafka event source config ([#617](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/617)) ([2c077cb](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/2c077cb1450af76cf44b56bfeba796ee9d9d9a00))

## [7.11.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.10.0...v7.11.0) (2024-10-01)


### Features

* Add function_url_auth_type option to aws_lambda_permission ([#625](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/625)) ([9f13397](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/9f13397f20467e660eba0ae5fcf98c66c75187ba))

## [7.10.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.9.0...v7.10.0) (2024-09-29)


### Features

* Add `tumbling_window_in_seconds` ([#623](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/623)) ([eedacff](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/eedacffef287cb02f776da4950e8345d9ec0200f))

## [7.9.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.8.1...v7.9.0) (2024-09-10)


### Features

* Added more examples for Rust, Go, Java runtimes ([#612](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/612)) ([a6fe411](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/a6fe4115ac96592ecbda27f72d42536da6518add))

## [7.8.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.8.0...v7.8.1) (2024-08-23)


### Bug Fixes

* Fix package.py commands after :zip not being executed ([#606](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/606)) ([801e69c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/801e69c08b74217e7f1319b128d5efd264162aaf))

## [7.8.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.7.1...v7.8.0) (2024-08-23)


### Features

* Added the skip_destroy argument for functions ([#600](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/600)) ([36c6109](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/36c61093dbb6114f9880d40b225e7f00f83493f9))

## [7.7.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.7.0...v7.7.1) (2024-07-25)


### Bug Fixes

* Always use absolute path to temp folders ([#599](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/599)) ([a058372](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/a058372431c552a0cb740a76beffe77285edeb91))

## [7.7.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.6.0...v7.7.0) (2024-06-18)


### Features

* Added support for alias to have multiple filter criteria same as function ([#585](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/585)) ([6549ca1](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/6549ca1301c74880e41440aa314e732739283e8a))

## [7.6.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.5.0...v7.6.0) (2024-06-12)


### Features

* Support passing extra args to poetry export ([#584](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/584)) ([3aa288f](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/3aa288fee324e64a8db409e5a32abaeebe38e6c2))

## [7.5.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.4.0...v7.5.0) (2024-06-07)


### Features

* Renamed python3.8-11 to python3.12 in examples, added tag to resources ([#583](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/583)) ([02ab668](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/02ab668458c87792861a54f54fd1b00e97afcc68))

## [7.4.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.3.0...v7.4.0) (2024-05-03)


### Features

* Added support for CW log_group_class and skip_destroy ([#565](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/565)) ([7256f7c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/7256f7c226adf294bb6280f1fc4326d015e78d83))

## [7.3.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.2.6...v7.3.0) (2024-05-03)


### Features

* Added create before destroy on aws_lambda_permission ([#561](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/561)) ([e9c4676](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/e9c467688de057a454646d5f947f3d4527f78a19))

## [7.2.6](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.2.5...v7.2.6) (2024-04-12)


### Bug Fixes

* Zip source directory should read from sh_work_dir ([#560](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/560)) ([f786681](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/f7866811bc1429ce224bf6a35448cb44aa5155e7))

## [7.2.5](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.2.4...v7.2.5) (2024-03-29)


### Bug Fixes

* Run pre-commit autoupdate (trigger patch release) ([#555](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/555)) ([8bb79de](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/8bb79de2733503aeb5824423b1a5f573ac25004d))

## [7.2.4](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.2.3...v7.2.4) (2024-03-29)


### Bug Fixes

* Dont raise FileNotFoundError from close() on tmpfile rename ([#550](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/550)) ([58ba987](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/58ba987a07710957abce30b4bba6587873f9b0e1))

## [7.2.3](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.2.2...v7.2.3) (2024-03-22)


### Bug Fixes

* Fixed constant drift with Lambda logging configuration ([#551](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/551)) ([8f97707](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/8f97707f6ea9aa3d382106a4917a0ddd1c3ec3e2))

## [7.2.2](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.2.1...v7.2.2) (2024-03-13)


### Bug Fixes

* Update CI workflow versions to remove deprecated runtime warnings ([#549](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/549)) ([cfe47e6](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/cfe47e63e906658dd4e8a5162ebac290b6a2cdf8))

### [7.2.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.2.0...v7.2.1) (2024-01-31)


### Bug Fixes

* Dynamic logging config for Gov Cloud ([#541](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/541)) ([b9a6ea1](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/b9a6ea18aa5b060d9d1b6e1bddfa50f60954da0d))

## [7.2.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.1.0...v7.2.0) (2024-01-26)


### Features

* Added support to override default tags of provider in S3 object ([#538](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/538)) ([e33a1a1](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/e33a1a1ad214d1c1e5aa0adb0d40c50cfd21d135))

## [7.1.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v7.0.0...v7.1.0) (2024-01-22)


### Features

* Commands should fail the build if their exit code is not zero ([#534](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/534)) ([eebfc36](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/eebfc3618ae290683456dc4e2fc7136857a95c57))

## [7.0.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.8.0...v7.0.0) (2024-01-19)


### ⚠ BREAKING CHANGES

* Added advanced logging configuration. Bump version of AWS provider to 5.32 (#531)

### Features

* Added advanced logging configuration. Bump version of AWS provider to 5.32 ([#531](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/531)) ([259b403](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/259b40300f0719179a0e5c5a0143795597329ae8))

## [6.8.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.7.1...v6.8.0) (2024-01-17)


### Features

* Allow defining direct path to pyproject.toml ([#525](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/525)) ([d33b722](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/d33b722d30e346b3966fe8f6e5d92ee554c2011d))

### [6.7.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.7.0...v6.7.1) (2024-01-15)


### Bug Fixes

* Set timeouts only when values are given ([#522](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/522)) ([b4bfe39](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/b4bfe39fab2a53607dc770bed18599a0fca5a694))

## [6.7.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.6.0...v6.7.0) (2024-01-14)


### Features

* Add control to use timestamp to trigger the package creation or not (useful for CI/CD) ([#521](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/521)) ([57dbfc1](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/57dbfc1909206bd6034b0d36883029a953c199db))

## [6.6.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.5.0...v6.6.0) (2024-01-12)


### Features

* Added support for triggers on docker_registry_image resource ([#518](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/518)) ([4ed7d19](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/4ed7d196dc26ca80daf6d04416e2a9fa91af6c1b))

## [6.5.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.4.0...v6.5.0) (2023-11-22)


### Features

* Added variable to control the create log group permission ([#514](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/514)) ([c173c27](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/c173c27fb57969da85967f2896b858c4654b0bba))

## [6.4.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.3.0...v6.4.0) (2023-11-07)


### Features

* Added support for triggers in docker-build module when hash changes ([#510](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/510)) ([41d8db7](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/41d8db71ad4fc9f56bb55c314133ce007f587e33))

## [6.3.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.2.0...v6.3.0) (2023-11-03)


### Features

* Allow to specify custom KMS key for S3 object ([#505](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/505)) ([eb339d6](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/eb339d658c232d0afa0a7f4f7902becab2a2a2e9))

## [6.2.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.1.0...v6.2.0) (2023-10-27)


### Features

* Make `compatible_runtimes` optional, added sam metadata control ([#493](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/493)) ([180da4c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/180da4cb0a720f7138e6504700ddfe8d9c63abfd))

## [6.1.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.0.1...v6.1.0) (2023-10-27)


### Features

* Allows tags to be provided only to the function ([#508](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/508)) ([610d602](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/610d602bb2038d3c2719c14d938b303cefcccac9))

### [6.0.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v6.0.0...v6.0.1) (2023-10-05)


### Bug Fixes

* Fixed npm install on Windows without having to use wsl ([#502](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/502)) ([ffa56e8](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/ffa56e896d7c5e5c8cbc851f0c453b70e4ec100f))

## [6.0.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v5.3.0...v6.0.0) (2023-08-09)


### ⚠ BREAKING CHANGES

* Disable creation of SAM metadata null-resources by default (#494)

### Features

* Disable creation of SAM metadata null-resources by default ([#494](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/494)) ([9c9603c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/9c9603cbb889a2cda1555deaed908d320e013515))

## [5.3.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v5.2.0...v5.3.0) (2023-07-17)


### Features

* Added timeouts for Lambda Functions ([#485](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/485)) ([2a59ba2](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/2a59ba2948fa22dd7cb7a1c8a721fa826c3832e8))

## [5.2.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v5.1.0...v5.2.0) (2023-07-05)


### Features

* Add module wrappers ([#479](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/479)) ([b5e9346](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/b5e9346de58bff16a63b63f76209bdb59534105e))

## [5.1.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v5.0.0...v5.1.0) (2023-07-04)


### Features

* Support maximum concurrency of Lambda Alias with SQS as an event source ([#457](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/457)) ([24bd26e](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/24bd26e8d598d183a995e2742713e122ecc607a5))

## [5.0.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.18.0...v5.0.0) (2023-06-05)


### ⚠ BREAKING CHANGES

* Bump versions of Terraform to 1.0, kreuzwerker/docker provider to 3.0 (#464)

### Features

* Bump versions of Terraform to 1.0, kreuzwerker/docker provider to 3.0 ([#464](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/464)) ([3f2044f](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/3f2044f0d6a5cad4b37100c26b2558d1acb9b982))

## [4.18.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.17.0...v4.18.0) (2023-05-17)


### Features

* Added control to create logs by Lambda@Edge in all regions ([#462](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/462)) ([712d8ec](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/712d8ecb9a224be8ed36cb34eebf4b7e815d0565))

## [4.17.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.16.0...v4.17.0) (2023-05-04)


### Features

* add qualified invoke ARN output ([#437](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/437)) ([dcd899b](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/dcd899b40bdeb4c7f607a5568e6f24dac81f26a0))

## [4.16.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.15.0...v4.16.0) (2023-04-18)


### Features

* Adding variable principal_org_id to resource aws_lambda_permission ([#448](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/448)) ([31d75e7](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/31d75e7206d2816471fe828e86ef3f2a1ad1218d))

## [4.15.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.14.0...v4.15.0) (2023-04-17)


### Features

* Add invoke_mode input ([#446](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/446)) ([d7b3ac9](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/d7b3ac970b7f18be19c95ec43ce4d1fac9ae2572))

## [4.14.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.13.0...v4.14.0) (2023-04-14)


### Features

* Add max session duration for IAM role ([#391](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/391)) ([3a21ac5](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/3a21ac58bc5c4e1cb369a935a977246c10f31cf5))

## [4.13.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.12.1...v4.13.0) (2023-04-03)


### Features

* Support maximum concurrency of Lambda with SQS as an event source ([#402](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/402)) ([268975c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/268975c9e2224cb05bdad8d7c39f879610dedc53))

### [4.12.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.12.0...v4.12.1) (2023-03-10)


### Bug Fixes

* Set the default value of replacement_security_group_ids to null ([#434](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/434)) ([a2d9ff9](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/a2d9ff97d437670feb2f361cf4874e193eea8a12))

## [4.12.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.11.0...v4.12.0) (2023-03-10)


### Features

* Added configuration options to replace security groups on destroy of Lambda function ([#422](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/422)) ([2d92236](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/2d92236245edf0f614fb949e6b5e84f2c0216dcd))

## [4.11.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.10.1...v4.11.0) (2023-03-10)


### Features

* Add dynamic blocks for consumer group id config ([#399](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/399)) ([7d7bb79](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/7d7bb792ceb0ba97192a8f8fe5b4a232e3239af8))

### [4.10.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.10.0...v4.10.1) (2023-02-13)


### Bug Fixes

* Properly construct poetry commands when not using docker for building package ([#420](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/420)) ([97b00d3](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/97b00d309a5b8e8c16f9790658db1fc411c124f4))

## [4.10.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.9.0...v4.10.0) (2023-02-10)


### Features

* Allow multiple filters in event source mappings ([#379](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/379)) ([66eb330](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/66eb330d4352a2bd95feded7f17f4c5046175aa5))

## [4.9.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.8.0...v4.9.0) (2023-01-30)


### Features

* Add snap_start functionality ([#406](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/406)) ([91c811b](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/91c811bfdf190f3eb1f4f2beaad3e401916d67b3))

## [4.8.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.7.2...v4.8.0) (2023-01-18)


### Features

* Update docker provider pin to 2.x in docker-build submodule ([#401](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/401)) ([fc2a39b](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/fc2a39b3e81d3a86992deab198566500a7066fab))

### [4.7.2](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.7.1...v4.7.2) (2023-01-10)


### Bug Fixes

* Use a version for  to avoid GitHub API rate limiting on CI workflows ([#393](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/393)) ([5481694](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/54816948d469cc753adca5b9bbd28c690c25ee3a))

### [4.7.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.7.0...v4.7.1) (2022-11-11)


### Bug Fixes

* Fixed opposite refresh_alias behavior in modules/alias ([#372](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/372)) ([f7b2a3a](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/f7b2a3a5e4f9764dac26034b5909e755e1c05880))

## [4.7.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.6.1...v4.7.0) (2022-11-11)


### Features

* Added static/defined/computed ARN for the Lambda Function outputs ([#376](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/376)) ([eed4f42](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/eed4f42cb53ec0186fcf26016e29442f635a5159))

### [4.6.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.6.0...v4.6.1) (2022-11-07)


### Bug Fixes

* Update CI configuration files to use latest version ([#374](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/374)) ([4a75d95](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/4a75d95bc92e21227e901192143b29c11695124e))

## [4.6.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.5.0...v4.6.0) (2022-11-03)


### Features

* Add SAM Metadata resources to enable the integration with SAM CLI tool ([#325](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/325)) ([bfcd34c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/bfcd34cfb21e4975990c807b85747f52b8601567))

## [4.5.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.4.1...v4.5.0) (2022-10-31)


### Features

* Support additional arguments for docker and entrypoint override ([#366](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/366)) ([dc4d000](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/dc4d00068dc1bb1cbcac8943541b6406abcecbf2))

### [4.4.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.4.0...v4.4.1) (2022-10-31)


### Bug Fixes

* Fixed policy name when create_role is false ([#371](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/371)) ([da56fc5](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/da56fc56b9b98535f24db013a1d6e34c3fa3a066))

## [4.4.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.3.0...v4.4.0) (2022-10-31)


### Features

* Add a way to define IAM policy name prefix ([#354](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/354)) ([7df6bbf](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/7df6bbffa3d7d87570d6858db770bf8059f20591))

## [4.3.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.2.2...v4.3.0) (2022-10-31)


### Features

* Support installing poetry dependencies with pip ([#311](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/311)) ([398ae5a](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/398ae5a9ace660bb3e7021824c0bffe1ee19f44c))

### [4.2.2](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.2.1...v4.2.2) (2022-10-31)


### Bug Fixes

* Checks for `npm` instead of `runtime` when building nodejs packages ([#364](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/364)) ([682052c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/682052c516b70425cd89ebd4086f2ffcf5c96bae))

### [4.2.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.2.0...v4.2.1) (2022-10-27)


### Bug Fixes

* Qualifiers in event invoke config ([#368](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/368)) ([93e1dc3](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/93e1dc3207105bd0620d3c3a952a0cce4d247972))

## [4.2.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.1.4...v4.2.0) (2022-10-22)


### Features

* Added support for Code Signing Configuration ([#351](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/351)) ([dd40178](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/dd40178f7534fa4fd341a8e9dbf645bbe4c279d0))

### [4.1.4](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.1.3...v4.1.4) (2022-10-21)


### Bug Fixes

* Skips the runtime test when building in docker ([#362](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/362)) ([2055256](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/20552562aa80843fe5cb5e569b5e58daaf569741))

### [4.1.3](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.1.2...v4.1.3) (2022-10-20)


### Bug Fixes

* Performs plan-phase runtime check only if building package ([#359](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/359)) ([dfc8934](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/dfc8934e907e5eb7f1820b838ec6e98f4011128a))

### [4.1.2](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.1.1...v4.1.2) (2022-10-20)


### Bug Fixes

* Generates error in plan phase if runtime is not available ([#358](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/358)) ([f9bf21d](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/f9bf21df9bef0730ed3efc174fc12a79e3a5268c))

### [4.1.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.1.0...v4.1.1) (2022-10-14)


### Bug Fixes

* Forces the local_filename output to wait for the package to be built ([#356](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/356)) ([745dc53](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/745dc5359f45d15fe4201114c0f0ec0069c99fa1))

## [4.1.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.0.2...v4.1.0) (2022-10-14)


### Features

* Add example for S3 bucket access through VPC Endpoint ([#349](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/349)) ([2ceb32f](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/2ceb32fdbef85758305a59b2320bdd40e246290f))

### [4.0.2](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.0.1...v4.0.2) (2022-09-17)


### Bug Fixes

* Override docker entrypoint when it exists ([#316](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/316)) ([3bb7623](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/3bb7623e74f7cc6f45519cf162ea252b7d69c7bc))

### [4.0.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v4.0.0...v4.0.1) (2022-09-01)


### Bug Fixes

* Lambda should depend on policy attachments ([#327](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/327)) ([b4eef74](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/b4eef74b79e73928a11be36e4400cac8b5ad7227))

## [4.0.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v3.3.1...v4.0.0) (2022-08-18)


### ⚠ BREAKING CHANGES

* Updated AWS provider to v4, added ECR repo force_delete argument in docker-build module (#337)

### Features

* Updated AWS provider to v4, added ECR repo force_delete argument in docker-build module ([#337](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/337)) ([953ccee](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/953ccee287135da9850818b2d7411bdb72f23ae5))

### [3.3.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v3.3.0...v3.3.1) (2022-06-17)


### Bug Fixes

* Fixed enabled attribute in Lambda Event Source Mapping by default ([#321](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/321)) ([779b368](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/779b368781f0bf14964c2f6e306c1c9ef4690bbb))

## [3.3.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v3.2.1...v3.3.0) (2022-06-16)


### Features

* Added support for event source mapping in alias submodule ([#320](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/320)) ([af22d00](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/af22d006c0b771809a0bf7a7a2bda49dafabb6a5))

### [3.2.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v3.2.0...v3.2.1) (2022-05-23)


### Bug Fixes

* Removed docker provider block from docker-build submodule ([#314](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/314)) ([151a09a](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/151a09a9b64a10cc8898becef245b7cdf96ee943))

## [3.2.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v3.1.1...v3.2.0) (2022-04-27)


### Features

* Add support for Lambda Function URL resource ([#308](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/308)) ([c239f9d](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/c239f9d722c8c68cb5d43f96f108540c1b99f95b))

### [3.1.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v3.1.0...v3.1.1) (2022-04-13)


### Bug Fixes

* Fixed ephemeral_storage in AWS govcloud region ([#305](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/305)) ([13c4449](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/13c444905e18fa9eceffd07ee884251eb28a8fd5))

## [3.1.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v3.0.1...v3.1.0) (2022-03-28)


### Features

* Added support for self managed kafka in event source mapping ([#278](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/278)) ([ee41186](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/ee41186b6e8bd04edfb1805b49820a7237f941a8))

### [3.0.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v3.0.0...v3.0.1) (2022-03-28)


### Bug Fixes

* Removed hard-coded AWS account id in examples ([#275](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/275)) ([5ab1383](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/5ab1383042c1e73ea1a1f709c9a279815ae0cf1a))

## [3.0.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.36.0...v3.0.0) (2022-03-28)


### ⚠ BREAKING CHANGES

* Updated AWS provider to version 4.8 (#296)

### Features

* Added support for ephemeral storage (requires AWS provider version 4.8.0) ([#291](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/291)) ([f191bae](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/f191baea053e126fc6b83a2ea4d6988c4f47ebde))
* Updated AWS provider to version 4.8 ([#296](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/296)) ([d4b55a8](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/d4b55a8bb142a7124f4cd910d68a631d9658260e)), closes [#291](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/291)

## [2.36.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.35.1...v2.36.0) (2022-03-26)


### Features

* Add support to build automatically npm dependencies ([#293](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/293)) ([ecb3807](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/ecb38076b0408982183ebb8070aff7c7e01c4b82))

### [2.35.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.35.0...v2.35.1) (2022-03-18)


### Bug Fixes

* Added support for keep_remotely in docker-build submodule ([#284](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/284)) ([db34260](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/db34260a1685333fa1f491b77f4564033c29729b))

## [2.35.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.34.1...v2.35.0) (2022-03-12)


### Features

* Made it clear that we stand with Ukraine ([2d32d84](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/2d32d84a3483bb2eb66f37b33cab13fba0d96adc))

### [2.34.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.34.0...v2.34.1) (2022-02-23)


### Bug Fixes

* Fixed event source mapping filter criteria ([#272](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/272)) ([a5c03fe](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/a5c03fef2c5c332dc31b84030cbb63302ef8a23d))

## [2.34.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.33.2...v2.34.0) (2022-01-31)


### Features

* Add event filter criteria capabilities ([#242](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/242)) ([159f57a](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/159f57aede1173a41ab9ef362909f8fb3e67d8d4))

### [2.33.2](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.33.1...v2.33.2) (2022-01-21)


### Bug Fixes

* Fixed incorrect tomap() ([#257](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/257)) ([2478baa](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/2478baa167816af2dee477d7e88703efff8b713b))

### [2.33.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.33.0...v2.33.1) (2022-01-21)


### Bug Fixes

* Updated code style to use `try()` ([#256](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/256)) ([e9aed29](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/e9aed29a45762ea2bc1675fa9e1ed7458703f86b))

## [2.33.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.32.0...v2.33.0) (2022-01-21)


### Features

* Accept new arguments `function_response_types` in `aws_lambda_event_source_mapping` ([#255](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/255)) ([1fda108](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/1fda108d41a8b167007ecc43b78654a4a2fa9aa5))

## [2.32.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.31.0...v2.32.0) (2022-01-17)


### Features

* Added flag to exclude general tags from S3 Object tagging ([#250](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/250)) ([a8a185c](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/a8a185cb85b794cae8c169522c12039077507f52))

## [2.31.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.30.0...v2.31.0) (2022-01-10)


### Features

* Allow the use of third party images to build dependencies ([#245](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/245)) ([0a9793e](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/0a9793ec9f04d96a0ffa6abb3d920659fae654b1))

# [2.30.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.29.0...v2.30.0) (2022-01-06)


### Features

* Added support for skip_destroy in Lambda Layer Version ([#244](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/244)) ([b9671e1](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/b9671e13d57823319e5b25900457dafcc81a4dbe))

# [2.29.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.28.0...v2.29.0) (2022-01-05)


### Features

* Add ECR Lifecycle Policy Option to docker-build module ([#243](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/243)) ([577b077](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/577b07768be37c0c24ea16294e2a9760833762bf))

# [2.28.0](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.27.1...v2.28.0) (2021-12-10)


### Features

* Add `pip_tmp_dir` to allow setting the location of the pip temporary directory ([#230](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/230)) ([f5f86b5](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/f5f86b593f6d72408464ae5124e34dc01f73387c))

## [2.27.1](https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.27.0...v2.27.1) (2021-11-27)


### Bug Fixes

* update CI/CD process to enable auto-release workflow ([#234](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/234)) ([e882a07](https://github.com/terraform-aws-modules/terraform-aws-lambda/commit/e882a072ff587d7271e0fdd647f180f9b61ceefc))

<a name="v2.27.0"></a>
## [v2.27.0] - 2021-11-22

- feat: Added support for random sleep delay in deploy submodule ([#233](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/233))


<a name="v2.26.0"></a>
## [v2.26.0] - 2021-11-12

- fix: Fixed max timeout for Lambda[@Edge](https://github.com/Edge) ([#232](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/232))


<a name="v2.25.0"></a>
## [v2.25.0] - 2021-11-09

- feat: Added required IAM permissions for CodeDeploy hooks ([#228](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/228))


<a name="v2.24.0"></a>
## [v2.24.0] - 2021-11-05

- feat: Added support for Cross-Account ECR for docker-build module ([#227](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/227))
- fix: Raise failure when CodeDeploy deployment fails ([#225](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/225))


<a name="v2.23.0"></a>
## [v2.23.0] - 2021-10-22

- feat: Allow passing build_args for building with docker-build module ([#217](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/217))


<a name="v2.22.0"></a>
## [v2.22.0] - 2021-10-12

- feat: Add policy_path variable for IAM policies ([#202](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/202))
- chore: Added example for pip install in layers ([#214](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/214))


<a name="v2.21.0"></a>
## [v2.21.0] - 2021-10-07

- fix: Use `AWSXRayDaemonWriteAccess` instead of deprecated `AWSXrayWriteOnlyAccess` ([#211](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/211))


<a name="v2.20.0"></a>
## [v2.20.0] - 2021-10-02

- feat: Add support for AWS Graviton2 powered functions ([#206](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/206))


<a name="v2.19.0"></a>
## [v2.19.0] - 2021-10-01

- feat: add support for additional assume_role_policy statements ([#203](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/203))


<a name="v2.18.0"></a>
## [v2.18.0] - 2021-09-25

- feat: Added support for partition in IAM policies to work in GovCloud ([#201](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/201))
- docs: Added a mention of good examples - 1Mill/serverless-tf-examples ([#197](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/197))


<a name="v2.17.0"></a>
## [v2.17.0] - 2021-09-11

- fix: Replace aws_iam_policy_attachment to aws_iam_role_policy_attachment ([#195](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/195))


<a name="v2.16.0"></a>
## [v2.16.0] - 2021-08-30

- feat: Add `recreate_missing_package` parameter ([#181](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/181))


<a name="v2.15.0"></a>
## [v2.15.0] - 2021-08-30

- fix: Strip leading `./` in S3 key ([#191](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/191))
- docs: Added a note for TFC/TFE customers ([#193](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/193))


<a name="v2.14.0"></a>
## [v2.14.0] - 2021-08-30

- fix: Take patterns into account when computing hash ([#169](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/169))
- feat: Add unique_id output of the lambda role ([#173](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/173))


<a name="v2.13.0"></a>
## [v2.13.0] - 2021-08-30

- fix: Sort directories and files to ensure they are always processed in the same order ([#177](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/177))
- feat: Added docker pip cache support for macOS ([#192](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/192))


<a name="v2.12.0"></a>
## [v2.12.0] - 2021-08-30

- feat: Add Amazon MQ event source type support ([#190](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/190))


<a name="v2.11.0"></a>
## [v2.11.0] - 2021-08-20

- fix: No need to set `aws_s3_bucket_object` `etag` as filename is already a hash of the content ([#180](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/180))


<a name="v2.10.0"></a>
## [v2.10.0] - 2021-08-20

- feat: Add support for separate deployments of infra and code ([#175](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/175))


<a name="v2.9.0"></a>
## [v2.9.0] - 2021-08-20

- feat: Add topics parameter support for lambda event source ([#166](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/166))


<a name="v2.8.0"></a>
## [v2.8.0] - 2021-08-14

- feat: Expose ecr tag & scan variables in docker-build module ([#189](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/189))


<a name="v2.7.0"></a>
## [v2.7.0] - 2021-07-08

- fix: Remove `random` provider because it is not used ([#172](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/172))


<a name="v2.6.0"></a>
## [v2.6.0] - 2021-07-07

- fix: Fixed deprecated call to map() in deploy submodule ([#171](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/171))


<a name="v2.5.0"></a>
## [v2.5.0] - 2021-06-28

- feat: Add submodule to handle creation of docker images ([#162](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/162))


<a name="v2.4.0"></a>
## [v2.4.0] - 2021-06-07

- docs: Updated README with S3 bucket id handling ([#157](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/157))


<a name="v2.3.0"></a>
## [v2.3.0] - 2021-05-27

- feat: add tags to `aws_iam_policy` resources ([#153](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/153))


<a name="v2.2.0"></a>
## [v2.2.0] - 2021-05-25

- chore: Remove checked checkboxes to make module docs render properly ([#156](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/156))


<a name="v2.1.0"></a>
## [v2.1.0] - 2021-05-20

- feat: Added destination_config in aws_lambda_event_source_mapping ([#152](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/152))
- chore: update CI/CD to use stable `terraform-docs` release artifact and discoverable Apache2.0 license ([#149](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/149))
- chore: Updated versions&comments in examples
- chore: Updated versions in README


<a name="v2.0.0"></a>
## [v2.0.0] - 2021-04-26

- feat: Shorten outputs (removing this_) ([#148](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/148))


<a name="v1.48.0"></a>
## [v1.48.0] - 2021-04-26

- fix: make lambda function depend on the Cloudwatch log group ([#133](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/133))
- fix: add documentation for the :zip command ([#115](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/115))
- feat: Added example to show creation of Lambdas with for_each ([#146](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/146))


<a name="v1.47.0"></a>
## [v1.47.0] - 2021-04-19

- feat: Extended `trusted_entities` variable to support multiple types ([#143](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/143))


<a name="v1.46.0"></a>
## [v1.46.0] - 2021-04-13

- fix: package.py not found with -chdir option ([#136](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/136))


<a name="v1.45.0"></a>
## [v1.45.0] - 2021-04-06

- fix: permission for lambda-to-lambda async calls ([#141](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/141))
- chore: update documentation and pin `terraform_docs` version to avoid future changes ([#134](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/134))


<a name="v1.44.0"></a>
## [v1.44.0] - 2021-03-09

- chore: Added examples to show CloudWatch Event Rule as triggers ([#126](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/126))


<a name="v1.43.0"></a>
## [v1.43.0] - 2021-03-03

- fix: Defaults the role_name coalesce to * to workaround import error ([#121](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/121))


<a name="v1.42.0"></a>
## [v1.42.0] - 2021-03-02

- feat: Add s3_acl and s3_server_site_encryption variables ([#120](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/120))


<a name="v1.41.0"></a>
## [v1.41.0] - 2021-03-01

- feat: Added interpreter variable to control script runtime in deploy module ([#92](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/92))


<a name="v1.40.0"></a>
## [v1.40.0] - 2021-02-28

- fix: revert module Terraform 0.13.x version upgrade ([#117](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/117))
- chore: fix documentation due to terraform docs 0.11.2 update ([#116](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/116))


<a name="v1.39.0"></a>
## [v1.39.0] - 2021-02-22

- chore: only run validate check on min terraform version ([#114](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/114))
- chore: add ci-cd workflow for pre-commit checks ([#112](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/112))
- docs: Fixed terraform-docs automatically


<a name="v1.38.0"></a>
## [v1.38.0] - 2021-02-18

- feat: Add output for lambda CloudWatch log group name ([#111](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/111))
- chore: update documentation based on latest `terraform-docs` which includes module and resource sections ([#108](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/108))


<a name="v1.37.0"></a>
## [v1.37.0] - 2021-02-14

- feat: Added Lambda event source mapping ([#103](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/103))


<a name="v1.36.0"></a>
## [v1.36.0] - 2021-02-03

- feat: add eventbridge async permissions ([#101](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/101))


<a name="v1.35.0"></a>
## [v1.35.0] - 2021-01-26

- fix: add permission to create log group ([#100](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/100))
- docs: Fix memory size limit ([#99](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/99))


<a name="v1.34.0"></a>
## [v1.34.0] - 2021-01-14

- fix: skip creating deployments if current and target versions match ([#85](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/85))


<a name="v1.33.0"></a>
## [v1.33.0] - 2021-01-14

- docs: update description of hook vars, note naming expectations of default policy ([#95](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/95))


<a name="v1.32.0"></a>
## [v1.32.0] - 2021-01-14

- fix: Fixed apigateway trigger to use source_arn ([#94](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/94))
- docs: Improved package.py error message for missing source_paths ([#88](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/88))
- docs: Explicitly state the IAM role property used for lambda_role ([#90](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/90))


<a name="v1.31.0"></a>
## [v1.31.0] - 2020-12-07

- feat: Add support for creating lambdas that use Container Images ([#80](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/80))


<a name="v1.30.0"></a>
## [v1.30.0] - 2020-11-23

- fix: Fixed CodeDeploy hooks ([#76](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/76))


<a name="v1.29.0"></a>
## [v1.29.0] - 2020-11-19

- feat: Customizable prefixes for IAM policies (as for IAM role) ([#74](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/74))


<a name="v1.28.0"></a>
## [v1.28.0] - 2020-11-17

- feat: Updated range of supported versions of Terraform and providers ([#71](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/71))


<a name="v1.27.0"></a>
## [v1.27.0] - 2020-11-02

- ci: Updated pre-commit hooks, added terraform_validate ([#68](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/68))


<a name="v1.26.0"></a>
## [v1.26.0] - 2020-10-27

- fix: Removed hash_extra_paths to have the same hash for multiple executors ([#66](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/66))


<a name="v1.25.0"></a>
## [v1.25.0] - 2020-10-26

- fix: Fixed concurrent builds ([#65](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/65))
- chore: Upgraded pre-commit-terraform to fix terraform-docs


<a name="v1.24.0"></a>
## [v1.24.0] - 2020-09-23

- feat: Added tflint as pre-commit hook ([#60](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/60))


<a name="v1.23.0"></a>
## [v1.23.0] - 2020-09-14

- feat: Added support for policy_jsons (list of strings) ([#58](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/58))


<a name="v1.22.0"></a>
## [v1.22.0] - 2020-08-26

- feat: Updated submodules to support Terraform 0.13


<a name="v1.21.0"></a>
## [v1.21.0] - 2020-08-25

- fix: os xcode python interpreter ([#50](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/50))
- docs: Updated description for provisioned_concurrent_executions (closes [#38](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/38))
- chore: Set number_of_policies in example


<a name="v1.20.0"></a>
## [v1.20.0] - 2020-08-19

- fix: Fix policy attachments for managed policies ([#45](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/45))
- feat: Add support for EFS File System Config ([#46](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/46))
- feat: Bump version of AWS provider to support v3
- feat: Upgraded Terraform version supported
- docs: Updated FAQ with info about "We currently do not support adding policies for "
- fix: Adds region wildcard to log group arn when lambda[@edge](https://github.com/edge) ([#35](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/35))
- fix: Fixed issue with zip renaming on Windows platform ([#32](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/32))
- feat: docker image building for installing pip requirements independently from OS ([#31](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/31))
- fix: Fixed patterns applying ([#30](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/30))
- fix: Fixed DUMP_ENV logging level ([#28](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/28))
- fix: Fixed IAM policy attachment with multiple functions ([#26](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/26))
- feat: Added support for variety of options for source_path, closes [#12](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/12) ([#25](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/25))
- Updated examples and readme
- Added more samples to examples/simple/main.tf
- package.py - Log directories with ending /
- package.py - Log skipped items + made uniform some messages
- package.py - Added support for comments in patterns
- package.py - Renamed: logger -> log
- feat: Added ZipContentFilter class to apply patterns filtering
- package.py - Fixed and improved logging
- package.py - Added BuildPlanManager initial implementation
- package.py - Fixed building in docker
- package.py - Implemented ZipFileStream.write_file
- feat: In-place zip archiving
- package.py - Removed dir changing on zip archive generation
- package.py - Simplified emit_dir_files func
- package.py - Fixed timestamp appling
- package.py - Added hidden hash command to calculate Lambda's content hash
- package.py - Finished ZipFileStream.write_dirs implementation
- package.py - Moved borrowed ZipInfo.from_file to a ZipWriteStream class
- package.py - Added initial ZipFileStream skel
- package.py - Move out inner functions from *_command functions
- feat: Added pid to the prepare stage log records
- feat: Added AWS CodeDeploy group name to outputs
- fix: Create AWS CodeDeploy resources conditionally
- fix: Do not create AWS Cloudwatch log group for Lambda Layers
- feat: Add Cloudwatch Logs resources (or use existing) ([#24](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/24))


<a name="v1.6.1"></a>
## [v1.6.1] - 2020-08-14

- fix: Added support for AWS provider v3 used by notify-slack module with Terraform 0.12


<a name="v1.19.0"></a>
## [v1.19.0] - 2020-08-14

- feat: Add support for EFS File System Config ([#46](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/46))


<a name="v1.18.0"></a>
## [v1.18.0] - 2020-08-13

- feat: Bump version of AWS provider to support v3


<a name="v1.17.0"></a>
## [v1.17.0] - 2020-07-20

- feat: Upgraded Terraform version supported


<a name="v1.16.0"></a>
## [v1.16.0] - 2020-06-26

- docs: Updated FAQ with info about "We currently do not support adding policies for "


<a name="v1.15.0"></a>
## [v1.15.0] - 2020-06-24

- fix: Adds region wildcard to log group arn when lambda[@edge](https://github.com/edge) ([#35](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/35))


<a name="v1.14.0"></a>
## [v1.14.0] - 2020-06-18

- fix: Fixed issue with zip renaming on Windows platform ([#32](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/32))


<a name="v1.13.0"></a>
## [v1.13.0] - 2020-06-17

- feat: docker image building for installing pip requirements independently from OS ([#31](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/31))


<a name="v1.12.0"></a>
## [v1.12.0] - 2020-06-16

- fix: Fixed patterns applying ([#30](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/30))
- fix: Fixed DUMP_ENV logging level ([#28](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/28))


<a name="v1.11.0"></a>
## [v1.11.0] - 2020-06-16

- fix: Fixed IAM policy attachment with multiple functions ([#26](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/26))


<a name="v1.10.0"></a>
## [v1.10.0] - 2020-06-14

- feat: Added support for variety of options for source_path, closes [#12](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/12) ([#25](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/25))
- Updated examples and readme
- Added more samples to examples/simple/main.tf
- package.py - Log directories with ending /
- package.py - Log skipped items + made uniform some messages
- package.py - Added support for comments in patterns
- package.py - Renamed: logger -> log
- feat: Added ZipContentFilter class to apply patterns filtering
- package.py - Fixed and improved logging
- package.py - Added BuildPlanManager initial implementation
- package.py - Fixed building in docker
- package.py - Implemented ZipFileStream.write_file
- feat: In-place zip archiving
- package.py - Removed dir changing on zip archive generation
- package.py - Simplified emit_dir_files func
- package.py - Fixed timestamp appling
- package.py - Added hidden hash command to calculate Lambda's content hash
- package.py - Finished ZipFileStream.write_dirs implementation
- package.py - Moved borrowed ZipInfo.from_file to a ZipWriteStream class
- package.py - Added initial ZipFileStream skel
- package.py - Move out inner functions from *_command functions
- feat: Added pid to the prepare stage log records


<a name="v1.9.0"></a>
## [v1.9.0] - 2020-06-12

- feat: Added AWS CodeDeploy group name to outputs


<a name="v1.8.0"></a>
## [v1.8.0] - 2020-06-12

- fix: Create AWS CodeDeploy resources conditionally
- fix: Do not create AWS Cloudwatch log group for Lambda Layers


<a name="v1.7.0"></a>
## [v1.7.0] - 2020-06-12

- feat: Add Cloudwatch Logs resources (or use existing) ([#24](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/24))


<a name="v1.6.0"></a>
## [v1.6.0] - 2020-06-11

- feat: Added package debug levels


<a name="v1.5.0"></a>
## [v1.5.0] - 2020-06-10

- fix: Added dependency for aws_s3_bucket_object, fixes [#15](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/15) ([#19](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/19))
- feat: Added support for one-shot artifacts build to skip recreation of missing packages ([#20](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/20))


<a name="v1.4.0"></a>
## [v1.4.0] - 2020-06-10

- feat: Added deploy module to do complex deployments using AWS CodeDeploy ([#17](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/17))
- feat: Stable zip archives - v1 ([#18](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/18))
- feat: Added better support for Lambda Alias resources via separate submodule ([#14](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/14))
- feat: Reliable passing build plan by a separate file + minor changes ([#13](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/13))


<a name="v1.3.0"></a>
## [v1.3.0] - 2020-06-07

- fix: Computed values in number of policies


<a name="v1.2.0"></a>
## [v1.2.0] - 2020-06-07

- feat: Added support for Lambda Permissions for allowed triggers ([#11](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/11))
- docs: Added link to apigateway-v2 module


<a name="v1.1.0"></a>
## [v1.1.0] - 2020-06-05

- feat: Added 4 new ways to customize IAM policies for Lambda Function ([#10](https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/10))
- Fixed README
- Updated README formatting


<a name="v1.0.0"></a>
## [v1.0.0] - 2020-06-04

- Updated README formatting
- Initial terraform-aws-lambda implementation
- Added example of Dockerfile for custom AWS Lambda build env
- Added initial draft implementation of lambda.py and package.tf


<a name="v0.0.1"></a>
## v0.0.1 - 2020-06-02

- first commit


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.27.0...HEAD
[v2.27.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.26.0...v2.27.0
[v2.26.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.25.0...v2.26.0
[v2.25.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.24.0...v2.25.0
[v2.24.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.23.0...v2.24.0
[v2.23.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.22.0...v2.23.0
[v2.22.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.21.0...v2.22.0
[v2.21.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.20.0...v2.21.0
[v2.20.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.19.0...v2.20.0
[v2.19.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.18.0...v2.19.0
[v2.18.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.17.0...v2.18.0
[v2.17.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.16.0...v2.17.0
[v2.16.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.15.0...v2.16.0
[v2.15.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.14.0...v2.15.0
[v2.14.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.13.0...v2.14.0
[v2.13.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.12.0...v2.13.0
[v2.12.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.11.0...v2.12.0
[v2.11.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.10.0...v2.11.0
[v2.10.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.9.0...v2.10.0
[v2.9.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.8.0...v2.9.0
[v2.8.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.7.0...v2.8.0
[v2.7.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.6.0...v2.7.0
[v2.6.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.5.0...v2.6.0
[v2.5.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.4.0...v2.5.0
[v2.4.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.3.0...v2.4.0
[v2.3.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.2.0...v2.3.0
[v2.2.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.1.0...v2.2.0
[v2.1.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v2.0.0...v2.1.0
[v2.0.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.48.0...v2.0.0
[v1.48.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.47.0...v1.48.0
[v1.47.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.46.0...v1.47.0
[v1.46.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.45.0...v1.46.0
[v1.45.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.44.0...v1.45.0
[v1.44.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.43.0...v1.44.0
[v1.43.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.42.0...v1.43.0
[v1.42.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.41.0...v1.42.0
[v1.41.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.40.0...v1.41.0
[v1.40.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.39.0...v1.40.0
[v1.39.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.38.0...v1.39.0
[v1.38.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.37.0...v1.38.0
[v1.37.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.36.0...v1.37.0
[v1.36.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.35.0...v1.36.0
[v1.35.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.34.0...v1.35.0
[v1.34.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.33.0...v1.34.0
[v1.33.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.32.0...v1.33.0
[v1.32.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.31.0...v1.32.0
[v1.31.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.30.0...v1.31.0
[v1.30.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.29.0...v1.30.0
[v1.29.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.28.0...v1.29.0
[v1.28.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.27.0...v1.28.0
[v1.27.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.26.0...v1.27.0
[v1.26.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.25.0...v1.26.0
[v1.25.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.24.0...v1.25.0
[v1.24.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.23.0...v1.24.0
[v1.23.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.22.0...v1.23.0
[v1.22.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.21.0...v1.22.0
[v1.21.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.20.0...v1.21.0
[v1.20.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.6.1...v1.20.0
[v1.6.1]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.19.0...v1.6.1
[v1.19.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.18.0...v1.19.0
[v1.18.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.17.0...v1.18.0
[v1.17.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.16.0...v1.17.0
[v1.16.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.15.0...v1.16.0
[v1.15.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.14.0...v1.15.0
[v1.14.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.13.0...v1.14.0
[v1.13.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.12.0...v1.13.0
[v1.12.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.11.0...v1.12.0
[v1.11.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.10.0...v1.11.0
[v1.10.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.9.0...v1.10.0
[v1.9.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.8.0...v1.9.0
[v1.8.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.7.0...v1.8.0
[v1.7.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.6.0...v1.7.0
[v1.6.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.5.0...v1.6.0
[v1.5.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.4.0...v1.5.0
[v1.4.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.3.0...v1.4.0
[v1.3.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/terraform-aws-modules/terraform-aws-lambda/compare/v0.0.1...v1.0.0
