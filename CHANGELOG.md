# Changelog

All notable changes to this project will be documented in this file.

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
