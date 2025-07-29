#!/usr/bin/env bash
# vim:ts=4:sw=4:noet

set -eo pipefail

trap ctrl_c INT

ctrl_c() {
	echo "** Trapped CTRL-C"
	exit 1
}

failed=0

:echo() {
	local color=${2:-"33;1"}
	echo -e "\e[${color}m$1\e[0m"
}

:note() {
	:echo "$1" "35;1"
}

:case() {
	if [ $? -ne 0 ]
	then failed=1
	fi

	if [ "$failed" -eq 1 ]
	then :echo "SKIPPED: $1"; return 1
	else echo; :echo "CASE: $1"
	fi
}

:check_diff() {
    expected="$1"

    set +e
    terraform plan -detailed-exitcode
    status=$?
    set -e
    # ${status} possible values:
    # 0 - Succeeded, diff is empty (no changes)
    # 1 - Errored
    # 2 - Succeeded, there is a diff
    if [ "${status}" -ne "${expected}" ]; then
        case "${expected}" in
            0)
            :echo "Error: we don't expect any diff here!"
            return 1
            ;;
            2)
            echo "Error: we DO expect some diff here!"
            return 1
            ;;
        esac
    fi
}

terraform=$(which terraform)
terraform() {
	$terraform "$@" < <(yes yes)
}

:note "Preparing ..."
rm -rf src
mkdir -p src
cp -r "../fixtures/python-app1" src
terraform init
:echo "Destroy / Remove ZIP files"
terraform destroy
rm -rf builds 2>/dev/null || true

#############################################################
# Part 1: Check that CICD environment won't detect any diff #
#############################################################

:echo
:note "Starting Part 1: Check that CICD environment won't detect any diff"

:case "Apply / No diff" && {
	terraform apply
	:check_diff 0
}

:case "Remove 'builds' dir / No diff" && {
	rm -rf builds
	:check_diff 0
}

###############################################################################
# Part 2: Check that CICD environment will detect diff if lambda code changes #
###############################################################################

:echo
:note "Starting Part 2: Check that CICD environment will detect diff if lambda code changes"

:note "Change the source code / Remove 'builds' dir"
echo "" >> src/python-app1/index.py
rm -rf builds

:case "Plan / Expect diff" && {
	terraform plan
	:check_diff 2
}

:case "Apply / No diff" && {
	terraform apply
	:check_diff 0
}

:note "Remove 'builds' dir"
rm -rf builds

:case "Plan / No diff" && {
	terraform plan
	:check_diff 0
}

#:case "Destroy / Remove ZIP files" && {
#	terraform plan -destroy
#	terraform destroy -auto-approve
#	rm builds/*.zip
#}

:note "All tests have passed successfully."
