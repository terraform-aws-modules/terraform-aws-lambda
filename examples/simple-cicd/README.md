# simple-cicd

This example is to test in a context of CICD executions, where the TF dir is empty (so it doesn't have any `builds` directory), that:

- `terraform plan` doesn't trigger a diff if the source code of the lambda function didn't change.
- `terraform plan` does trigger a diff if the source code of the lambda function has changed.
- `terraform apply` works if the code has changed.

## How to run the tests

Run:

```shell
./test.sh
```

## Teardown

Run:

```shell
terraform destroy
```
